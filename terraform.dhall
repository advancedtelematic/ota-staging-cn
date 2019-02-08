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
  , aws_s3_bucket = [bucket] }
}
