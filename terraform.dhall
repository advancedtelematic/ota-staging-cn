let map = https://raw.githubusercontent.com/dhall-lang/dhall-lang/0a7f596d03b3ea760a96a8e03935f4baa64274e1/Prelude/List/map
let Types = ./dhall/types.dhall

let region = "cn-northwest-1"
let environmentName = "staging-cn"

let provider : Types.Provider =
{ mapKey = "aws"
, mapValue =
  { access_key = "\${var.aws_access_key}"
  , secret_key = "\${var.aws_secret_key}"
  , region     = region
  }
}

let vpc : Types.VPC =
{ mapKey = environmentName
, mapValue =
  { cidr_block = "10.100.0.0/16"
  , enable_dns_hostnames = True
  , enable_dns_support = True
  }
}

let bucket : Types.S3_Bucket =
{ mapKey = "ota-china-test-bucket"
, mapValue =
  { bucket = "ota-china-test-bucket"
  , acl = "private"
  }
}

let privateSubnetNames =
[ { name = "a"
  , range = "1"
  }
, { name = "b"
  , range = "3"
  }
, { name = "c"
  , range = "5"
  }
]

let createPrivateSubnet =
\(subnet: { name : Text, range : Text }) ->
{ mapKey = "private-${region}${subnet.name}"
, mapValue =
  { vpc_id = "\${aws_vpc.${environmentName}.id}"
  , cidr_block = "10.100.${subnet.range}.0/24"
  , availability_zone = "${region}${subnet.name}"
  }
}

let privateSubnets = map { name : Text, range : Text } Types.AWS_Subnet createPrivateSubnet privateSubnetNames

in
{ provider = [provider]
, terraform =
  { backend =
    { s3 =
      { bucket = "ota-china-state-store"
      , key = "terraform/"
      , region = "cn-northwest-1"
      }
    }
  }
, resource =
  { aws_vpc = [vpc]
  , aws_s3_bucket = [bucket]
  , aws_subnet = privateSubnets
  }
}
