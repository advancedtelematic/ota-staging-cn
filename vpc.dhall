let map = https://raw.githubusercontent.com/dhall-lang/dhall-lang/0a7f596d03b3ea760a96a8e03935f4baa64274e1/Prelude/List/map

let Types = ./dhall/types.dhall

let Subnet =
{ view : Text
, range : Text
, zone : Text
}

let createSubnet =
\(vpcId : Text) -> \(region : Text) -> \(subnet : Subnet) ->
{ mapKey = "${subnet.view}-${subnet.zone}"
, mapValue =
  { vpc_id = vpcId
  , cidr_block = subnet.range
  , availability_zone = "${region}${subnet.zone}"
  , tags = None Types.Tags
  }
} : Types.AWS_Subnet

let createEip =
\(zone : Text) ->
{ mapKey = "nat-${zone}"
, mapValue =
  { vpc = True
  , instance = None Text
  }
} : Types.AWS_Eip

let createNatGateway =
\(zone : Text) ->
{ mapKey = "nat-gw-${zone}"
, mapValue =
  { allocation_id = "\${aws_eip.nat-${zone}.id}"
  , subnet_id = "\${aws_subnet.public-${zone}.id}"
  }
} : Types.AWS_Nat_Gateway

let createPublicRouteTable : Types.AWS_Route_Table =
\(vpcId : Text) -> \(region : Text) -> \(internetGatewayId : Text) ->
{ mapKey = "public-${region}"
, mapValue =
  { vpc_id = vpcId
  , route =
    { cidr_block = "0.0.0.0/0"
    , gateway_id = Some internetGatewayId
    , nat_gateway_id = None Text
    }
  }
}

let createPrivateRouteTable =
\(vpcId : Text) -> \(zone : Text) -> \(region : Text) ->
{ mapKey = "private-${region}${zone}"
, mapValue =
  { vpc_id = vpcId
  , route =
    { cidr_block = "0.0.0.0/0"
    , gateway_id = None Text
    , nat_gateway_id = Some "\${aws_nat_gateway.nat-gw-${zone}.id}"
    }
  }
} : Types.AWS_Route_Table


let zones = ["a"]
let views = ["public", "private"]

let privateSubnets =
[ { view = "private"
  , range = "10.101.1.0/24"
  , zone = "a"
  }
]

let publicSubnets =
[ { view = "public"
  , range = "10.101.0.0/24"
  , zone = "a"
  }
]

let subnets = privateSubnets # publicSubnets : List Subnet

let createVpc =
\(vpcId : Text) -> \(internetGatewayId : Text) -> \(region : Text) -> \(subnets : List Subnet) ->
{ aws_subnet = map Subnet Types.AWS_Subnet (createSubnet vpcId region) subnets
, aws_eip = map Text Types.AWS_Eip createEip zones
, aws_nat_gateway = map Text Types.AWS_Nat_Gateway createNatGateway zones
-- , aws_internet_gateway = 1
, aws_route_table = 1 -- list comprehension time
, aws_route_table_association = 1
, aws_network_acl = 1
, aws_security_group = 1
}

in createVpc "vpc-123" "ig-456" "eu-west-1" subnets
