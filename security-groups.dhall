let Types = ./dhall/types.dhall

let privateSecurityGroup =
{ mapKey = "private"
, mapValue =
  { name = "private"
  , description = "[TF] only access from the vpc to instances in the private subnet"
  , ingress =
    Some
    [ { from_port = 0
      , to_port = 0
      , protocol = "-1"
      , cidr_blocks = ["\${aws_vpc.staging-cn.cidr_block}"]
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
{ aws_security_group = [ privateSecurityGroup, publicSecurityGroup ] : List Types.AWS_Security_Group }
