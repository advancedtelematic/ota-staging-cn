let AWS_Internet_Gateway =
{ mapKey : Text
, mapValue : { vpc_id : Text }
}

let AWS_Route_Table =
{ mapKey : Text
, mapValue :
  { vpc_id : Text
  , route :
    { cidr_block : Text
    , gateway_id : Optional Text
    , nat_gateway_id : Optional Text
    }
  }
}

let AWS_Route_Table_Association =
{ mapKey : Text
, mapValue :
  { subnet_id : Text
  , route_table_id : Text
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
{ mapKey : Text
, mapValue :
  { allocation_id : Text
  , subnet_id : Text
  }
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
, AWS_Route_Table_Association = AWS_Route_Table_Association
, AWS_Nat_Gateway = AWS_Nat_Gateway
, AWS_Security_Group = ./security-group.dhall
, S3_Bucket = S3_Bucket
, AWS_Subnet = AWS_Subnet
}
