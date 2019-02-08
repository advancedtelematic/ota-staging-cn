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

let privateSubnets : List Types.AWS_Subnet =
[ { mapKey = "private-${region}a"
  , mapValue =
    { vpc_id = "\${aws_vpc.${environmentName}.id}"
    , cidr_block = "10.100.1.0/24"
    , availability_zone = "${region}a"
    }
  }
, { mapKey = "private-${region}b"
  , mapValue =
    { vpc_id = "\${aws_vpc.${environmentName}.id}"
    , cidr_block = "10.100.3.0/24"
    , availability_zone = "${region}b"
    }
  }
, { mapKey = "private-${region}c"
  , mapValue =
    { vpc_id = "\${aws_vpc.${environmentName}.id}"
    , cidr_block = "10.100.5.0/24"
    , availability_zone = "${region}c"
    }
  }
]

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
