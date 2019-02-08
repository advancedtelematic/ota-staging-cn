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
, S3_Bucket = S3_Bucket
}
