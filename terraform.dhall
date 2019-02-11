let map = https://raw.githubusercontent.com/dhall-lang/dhall-lang/0a7f596d03b3ea760a96a8e03935f4baa64274e1/Prelude/List/map
let Types = ./dhall/types.dhall

let region = "cn-northwest-1"
let zones = ["a", "b", "c"]
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

let internetGateway : Types.AWS_Internet_Gateway =
{ mapKey = environmentName
, mapValue = { vpc_id = "\${aws_vpc.${environmentName}.id}" }
}

let privateSubnetNames =
[ { zone = "a"
  , range = "1"
  }
, { zone = "b"
  , range = "3"
  }
, { zone = "c"
  , range = "5"
  }
]

let publicSubnetNames =
[ { zone = "a"
  , range = "0"
  }
, { zone = "b"
  , range = "2"
  }
, { zone = "c"
  , range = "4"
  }
]

let createSubnet =
\(name : Text) -> \(subnet : { zone : Text, range : Text }) ->
{ mapKey = "${name}-${region}${subnet.zone}"
, mapValue =
  { vpc_id = "\${aws_vpc.${environmentName}.id}"
  , cidr_block = "10.100.${subnet.range}.0/24"
  , availability_zone = "${region}${subnet.zone}"
  }
} : Types.AWS_Subnet

let createPrivateSubnet = createSubnet "private"
let createPublicSubnet = createSubnet "public"
let privateSubnets = map { zone : Text, range : Text } Types.AWS_Subnet createPrivateSubnet privateSubnetNames
let publicSubnets = map { zone : Text, range : Text } Types.AWS_Subnet createPublicSubnet publicSubnetNames

let createEip =
\(zone : Text) ->
{ mapKey = "nat-${zone}"
, mapValue = { vpc = True }
} : Types.AWS_Eip
let eips = map Text Types.AWS_Eip createEip zones

let createNatGateway =
\(zone : Text) ->
{ mapKey = "nat-${zone}"
, mapValue =
  { allocation_id = "\${aws_eip.nat-${zone}.id}"
  , subnet_id = "\${aws_subnet.public-${region}${zone}.id}"
  }
} : Types.AWS_Nat_Gateway
let natGateways = map Text Types.AWS_Nat_Gateway createNatGateway zones

let publicRouteTable : Types.AWS_Route_Table =
{ mapKey = "public-${region}"
, mapValue =
  { vpc_id = "\${aws_vpc.${environmentName}.id}"
  , route =
    { cidr_block = "0.0.0.0/0"
    , gateway_id = Some "\${aws_internet_gateway.${environmentName}.id}"
    , nat_gateway_id = None Text
    }
  }
}

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
  , aws_subnet = privateSubnets # publicSubnets
  , aws_eip = eips
  , aws_nat_gateway = natGateways
  , aws_internet_gateway = [internetGateway]
  , aws_route_table = [publicRouteTable]
  }
}
