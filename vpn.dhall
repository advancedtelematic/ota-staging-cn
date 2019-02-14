let common = ./common.dhall
let Types = ./dhall/types.dhall

let testInstance =
{ mapKey = "test"
, mapValue =
  { ami = "ami-0b0c78f9d8233d1da"
  , availability_zone = "${common.region}a"
  , instance_type = "t2.medium"
  , key_name = "${common.environmentName}"
  , vpc_security_group_ids = ["\${aws_security_group.private.id}"]
  , subnet_id = "\${aws_subnet.private-${common.region}a.id}"
  , disable_api_termination = False
  , root_block_device =
    { volume_type = "gp2"
    , volume_size = 15
    }
  , tags =
    Some
    [ { mapKey = "Name"
      , mapValue = "test"
      }
    ]
  }
} : Types.AWS_Instance
let testInstance2 =
{ mapKey = "test2"
, mapValue =
  { ami = "ami-0b0c78f9d8233d1da"
  , availability_zone = "${common.region}b"
  , instance_type = "t2.small"
  , key_name = "${common.environmentName}"
  , vpc_security_group_ids = ["\${aws_security_group.private.id}"]
  , subnet_id = "\${aws_subnet.private-${common.region}b.id}"
  , disable_api_termination = False
  , root_block_device =
    { volume_type = "gp2"
    , volume_size = 15
    }
  , tags =
    Some
    [ { mapKey = "Name"
      , mapValue = "test2"
      }
    ]
  }
} : Types.AWS_Instance
let testInstance3 =
{ mapKey = "test3"
, mapValue =
  { ami = "ami-0b0c78f9d8233d1da"
  , availability_zone = "${common.region}b"
  , instance_type = "t2.small"
  , key_name = "${common.environmentName}"
  , vpc_security_group_ids = ["\${aws_security_group.private.id}"]
  , subnet_id = "\${aws_subnet.public-${common.region}b.id}"
  , disable_api_termination = False
  , root_block_device =
    { volume_type = "gp2"
    , volume_size = 15
    }
  , tags =
    Some
    [ { mapKey = "Name"
      , mapValue = "test3"
      }
    ]
  }
} : Types.AWS_Instance

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
{ aws_instance = [vpnInstance]
, aws_eip = [vpnEip] }
