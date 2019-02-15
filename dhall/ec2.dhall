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
  }
}

in
{ AWS_Instance = AWS_Instance }
