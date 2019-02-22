let Provisioner =
List
{ mapKey : Text
, mapValue :
  { connection :
    { user : Text
    , private_key : Text
    }
  , inline : List Text
  }
}

let Tags = ./tags.dhall

let Block_Device =
{ volume_type : Text
, volume_size : Natural
}

let AWS_Instance =
{ mapKey : Text
, mapValue :
  { ami : Text
  , availability_zone : Text
  , instance_type : Text
  , key_name : Text
  , vpc_security_group_ids : List Text
  , subnet_id : Text
  , disable_api_termination : Bool
  , root_block_device : Block_Device
  , tags : Optional Tags
  , provisioner : Optional Provisioner
  }
}

let ElbAccessLogs =
{ bucket : Text
, bucket_prefix : Optional Text
, interval : Optional Natural
, enabled : Optional Bool
}

let ElbListener =
{ instance_port : Natural
, instance_protocol : Text
, lb_port : Natural
, lb_protocol : Text
, ssl_certificate_id : Optional Text
}

let ElbHealthCheck =
{ healthy_threshold : Natural
, unhealthy_threshold : Natural
, target : Text
, interval : Natural
, timeout : Natural
}

let AWS_ELB =
{ mapKey : Text
, mapValue :
  { name : Optional Text
  , name_prefix : Optional Text
  , access_logs : Optional ElbAccessLogs
  , availability_zones : Optional (List Text)
  , security_groups : Optional (List Text)
  , subnets : List Text
  , instances : Optional (List Text)
  , internal : Optional Bool
  , listener : List ElbListener
  , health_check : Optional ElbHealthCheck
  , cross_zone_load_balancing : Optional Bool
  , idle_timeout : Optional Natural
  , connection_draining : Optional Bool
  , connection_draining_timeout : Optional Natural
  , tags : Optional Tags
  }
}

in
{ AWS_Instance = AWS_Instance
, Provisioner = Provisioner
, AWS_ELB = AWS_ELB
, ElbAccessLogs = ElbAccessLogs
, ElbHealthCheck = ElbHealthCheck
}
