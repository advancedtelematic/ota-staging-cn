let listFold = https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/List/fold

let Types = ./dhall/types.dhall
let Resources = ./dhall/resources.dhall

let defaults = ./dhall/defaults.dhall
let functions = ./dhall/functions.dhall

let common = ./common.dhall

let resourceFiles =
[ ./hats.dhall
, ./vpn.dhall
, ./security-groups.dhall
, ./terraform.dhall
]

let resources = listFold Resources resourceFiles Resources functions.concatResources defaults

let provider : Types.Provider =
{ mapKey = "aws"
, mapValue =
  { access_key = "\${var.aws_access_key}"
  , secret_key = "\${var.aws_secret_key}"
  , region     = common.region
  }
}

in
{ provider = [provider]
, terraform =
  { backend =
    { s3 =
      { bucket = "ota-china-state-store"
      , key = "terraform/"
      , region = common.region
      }
    }
  }
, resource = resources
}
