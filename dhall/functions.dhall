let fold = https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Optional/fold
let isZero = https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Natural/isZero
let length = https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/List/length

let Types = ./types.dhall
let Resources = ./resources.dhall

let isEmpty =
\(t : Type) -> \(l : List t) ->
isZero (length t l)

let toOptional =
\(t : Type) -> \(l : List t) ->
if (isEmpty t l) then (None (List t)) else Some l

let unwrapList =
\(t : Type) -> \(x : Optional (List t)) ->
fold (List t) x (List t) (λ(x : (List t)) →  x) ([] : List t)

let mergeOptionalLists =
\(t : Type) -> \(x : Optional (List t)) -> \(y : Optional (List t)) ->
(toOptional t ((unwrapList t x) # (unwrapList t y))) : Optional (List t)

let concatResources =
\(x : Resources) -> \(y : Resources) ->
{ aws_eip = (mergeOptionalLists Types.AWS_Eip x.aws_eip y.aws_eip)
, aws_instance = (mergeOptionalLists Types.AWS_Instance x.aws_instance y.aws_instance)
, aws_internet_gateway = (mergeOptionalLists Types.AWS_Internet_Gateway x.aws_internet_gateway y.aws_internet_gateway)
, aws_nat_gateway = (mergeOptionalLists Types.AWS_Nat_Gateway x.aws_nat_gateway y.aws_nat_gateway)
, aws_network_acl = (mergeOptionalLists Types.AWS_Network_Acl x.aws_network_acl y.aws_network_acl)
, aws_route_table = (mergeOptionalLists Types.AWS_Route_Table x.aws_route_table y.aws_route_table)
, aws_route_table_association = (mergeOptionalLists Types.AWS_Route_Table_Association x.aws_route_table_association y.aws_route_table_association)
, aws_security_group = (mergeOptionalLists Types.AWS_Security_Group x.aws_security_group y.aws_security_group)
, aws_subnet = (mergeOptionalLists Types.AWS_Subnet x.aws_subnet y.aws_subnet)
, aws_s3_bucket = (mergeOptionalLists Types.S3_Bucket x.aws_s3_bucket y.aws_s3_bucket)
, aws_vpc = (mergeOptionalLists Types.VPC x.aws_vpc y.aws_vpc)
} : Resources

in
{ concatResources = concatResources
, mergeOptionalLists = mergeOptionalLists
, unwrapList = unwrapList
, toOptional = toOptional
, isEmpty = isEmpty
}
