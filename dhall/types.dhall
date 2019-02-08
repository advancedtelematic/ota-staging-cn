let S3_Bucket =
{ mapKey : Text
, mapValue :
  { bucket : Text
  , acl : Text
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

in
{ Provider = ./provider.dhall
, VPC = ./vpc.dhall
, S3_Bucket = S3_Bucket
, AWS_Subnet = AWS_Subnet
}
