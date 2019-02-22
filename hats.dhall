let map = https://raw.githubusercontent.com/dhall-lang/dhall-lang/0a7f596d03b3ea760a96a8e03935f4baa64274e1/Prelude/List/map

let common = ./common.dhall
let Types = ./dhall/types.dhall
let defaults = ./dhall/defaults.dhall
let resourceDefaults = ./dhall/resourceDefaults.dhall

let kubeconfig = "KUBECONFIG=/etc/kubernetes/admin.conf"

let hatProvisioner =
\(keyPath : Text) ->
[ { mapKey = "remote-exec"
  , mapValue =
    { connection =
      { user = "ubuntu"
      , private_key = "\${file(\"${keyPath}\")}"
      }
    , inline =
      [ "docker pull weaveworks/weave-npc:2.5.1"
      , "docker pull weaveworks/weave-kube:2.5.1"
      , "sudo bash -c 'swapoff -a && kubeadm init --ignore-preflight-errors=all --config kubernetes-for-china/init.yml'"
      , "sleep 60"
      , "sudo bash -c 'cat /etc/kubernetes/admin.conf'"
      , "sudo bash -c '${kubeconfig} kubectl apply -f /etc/kubernetes/manifests/weave.yaml'"
      , "sleep 30"
      , "sudo bash -c '${kubeconfig} kubectl taint nodes --all node-role.kubernetes.io/master-'"
      , "sudo bash -c '${kubeconfig} kubectl apply -f /etc/kubernetes/manifests/nginx-ingress-controller.yaml'"
      , "sudo bash -c '${kubeconfig} helm init --override \"spec.template.spec.containers[0].image=registry.aliyuncs.com/google_containers/tiller:v2.12.2\" --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts'"
      ]
    }
  }
] : Types.Provisioner

let hatInstance =
\(name : Text) ->
{ mapKey = name
, mapValue =
  { ami = "ami-011faa69cfe440cf5"
  , availability_zone = "${common.region}a"
  , instance_type = "m4.2xlarge"
  , key_name = "${common.environmentName}"
  , vpc_security_group_ids = ["\${aws_security_group.private.id}"]
  , subnet_id = "\${aws_subnet.private-${common.region}a.id}"
  , disable_api_termination = False
  , root_block_device =
    { volume_type = "gp2"
    , volume_size = 80
    }
  , tags =
    Some
    [ { mapKey = "Name"
      , mapValue = name
      }
    ]
  , provisioner = Some (hatProvisioner "./keys/staging-cn.pem")
  }
} : Types.AWS_Instance

let hatElb =
\(name : Text) ->
{ mapKey = name
, mapValue =
  resourceDefaults.awsElbDefault //
  { name = Some name
  , instances =
    Some
    ["\${aws_instance.${name}.id}"]
  , subnets =
    [ "\${aws_subnet.public-cn-northwest-1a.id}"
    , "\${aws_subnet.public-cn-northwest-1b.id}"
    , "\${aws_subnet.public-cn-northwest-1c.id}"
    ]
  , cross_zone_load_balancing = Some True
  , security_groups =
    Some
    ["\${aws_security_group.public.id}"]
  , listener =
    [ { instance_port = 80
      , instance_protocol = "http"
      , lb_port = 80
      , lb_protocol = "http"
      , ssl_certificate_id = None Text
      }
    , { instance_port      = 8000
      , instance_protocol  = "tcp"
      , lb_port            = 8000
      , lb_protocol        = "tcp"
      , ssl_certificate_id = None Text
      }
    ]
  }
} : Types.AWS_ELB

let hatNames =
[ "cork" ]

let makeHats =
\(names : List Text) ->
{ aws_instance = Some (map Text Types.AWS_Instance hatInstance names)
, aws_elb = Some (map Text Types.AWS_ELB hatElb names)
}

in
(defaults // makeHats hatNames)
