let common = ./common.dhall
let Types = ./dhall/types.dhall
let defaults = ./dhall/defaults.dhall

let vpnInstance =
{ mapKey = "vpn"
, mapValue =
  { ami = "ami-0b0c78f9d8233d1da"
  , availability_zone = "${common.region}a"
  , instance_type = "t2.medium"
  , key_name = "${common.environmentName}"
  , vpc_security_group_ids = ["\${aws_security_group.vpn.id}"]
  , subnet_id = "\${aws_subnet.public-${common.region}a.id}"
  , disable_api_termination = False
  , root_block_device =
    { volume_type = "gp2"
    , volume_size = 30
    }
  , tags =
    Some
    [ { mapKey = "Name"
      , mapValue = "vpn"
      }
    ]
  , provisioner = None Types.Provisioner
  }
} : Types.AWS_Instance

let vpnEip =
{ mapKey = "vpn"
, mapValue =
  { instance = Some "\${aws_instance.vpn.id}"
  , vpc = True
  }
}

in
defaults //
{ aws_instance = Some [vpnInstance]
, aws_eip = Some [vpnEip] }
