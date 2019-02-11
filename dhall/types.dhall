let AWS_Internet_Gateway =
{ vpc_id : Text }

let AWS_Route_Table =
{ vpc_id : Text
, route :
  { cidr_block : Text
  , gateway_id : Optional Text
  , nat_gateway_id : Optional Text
  }
}

let AWS_Subnet =
{ mapKey : Text
, mapValue :
  { vpc_id : Text
  , cidr_block : Text
  , availability_zone : Text
  }
}

let AWS_Eip =
{ mapKey : Text
, mapValue :
  { vpc : Bool }
}

let AWS_Nat_Gateway =
{ allocation_id : Text
, subnet_id : Text
}

let S3_Bucket =
{ mapKey : Text
, mapValue :
  { bucket : Text
  , acl : Text
  }
}

in
{ Provider = ./provider.dhall
, VPC = ./vpc.dhall
, AWS_Eip = AWS_Eip
, AWS_Internet_Gateway = AWS_Internet_Gateway
, AWS_Route_Table = AWS_Route_Table
, S3_Bucket = S3_Bucket
, AWS_Subnet = AWS_Subnet
}
