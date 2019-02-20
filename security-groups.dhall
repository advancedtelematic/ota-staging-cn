let Types = ./dhall/types.dhall
let common = ./common.dhall
let defaults = ./dhall/defaults.dhall

let vpn =
{ mapKey = "vpn"
, mapValue =
  { name = "vpn"
  , description = "[TF] allow inbound internet traffic to openvpn, ssh"
  , vpc_id = "\${aws_vpc.${common.environmentName}.id}"
  , ingress =
    Some
    [ { from_port   = 22
      , to_port     = 22
      , protocol    = "tcp"
      , cidr_blocks = ["\${var.office_ip}"]
      }
    , { from_port   = 22
      , to_port     = 22
      , protocol    = "tcp"
      , cidr_blocks = ["\${var.here_office_ip}"]
      }
    , { from_port   = 1194
      , to_port     = 1194
      , protocol    = "udp"
      , cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  , egress =
    Some
    [ { from_port   = 22
      , to_port     = 22
      , protocol    = "tcp"
      , cidr_blocks = ["0.0.0.0/0"]
      }
    , { from_port   = 80
      , to_port     = 80
      , protocol    = "tcp"
      , cidr_blocks = ["0.0.0.0/0"]
      }
    , { from_port   = 443
      , to_port     = 443
      , protocol    = "tcp"
      , cidr_blocks = ["0.0.0.0/0"]
      }
    , { from_port = 0
      , to_port = 0
      , protocol = "-1"
      , cidr_blocks = ["\${aws_vpc.${common.environmentName}.cidr_block}"]
      }
    ]
  }
}

let privateSecurityGroup =
{ mapKey = "private"
, mapValue =
  { name = "private"
  , description = "[TF] only access from the vpc to instances in the private subnet"
  , vpc_id = "\${aws_vpc.${common.environmentName}.id}"
  , ingress =
    Some
    [ { from_port = 0
      , to_port = 0
      , protocol = "-1"
      , cidr_blocks = ["\${aws_vpc.${common.environmentName}.cidr_block}"]
      }
    ]
  , egress =
    Some
    [ { from_port = 0
      , to_port = 0
      , protocol = "-1"
      , cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}

let publicSecurityGroup =
{ mapKey = "public"
, mapValue =
  { name = "public"
  , description = "[TF] Allow http traffic"
  , vpc_id = "\${aws_vpc.${common.environmentName}.id}"
  , ingress =
    Some
    [ { from_port = 80
      , to_port = 80
      , protocol = "tcp"
      , cidr_blocks = ["0.0.0.0/0"]
      }
    , { from_port = 443
      , to_port = 443
      , protocol = "tcp"
      , cidr_blocks = ["0.0.0.0/0"]
      }
    , { from_port = 8000
      , to_port = 8000
      , protocol = "tcp"
      , cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  , egress =
    Some
    [ { from_port = 0
      , to_port = 0
      , protocol = "-1"
      , cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}

in
defaults //
{ aws_security_group = Some [ vpn, privateSecurityGroup, publicSecurityGroup ] }
