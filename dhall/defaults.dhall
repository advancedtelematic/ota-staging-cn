let Resources = ./resources.dhall
let Types = ./types.dhall

let defaults =
{ aws_eip = None (List Types.AWS_Eip)
, aws_elb = None (List Types.AWS_ELB)
, aws_instance = None (List Types.AWS_Instance)
, aws_internet_gateway = None (List Types.AWS_Internet_Gateway)
, aws_nat_gateway = None (List Types.AWS_Nat_Gateway)
, aws_network_acl = None (List Types.AWS_Network_Acl)
, aws_route_table = None (List Types.AWS_Route_Table)
, aws_route_table_association = None (List Types.AWS_Route_Table_Association)
, aws_security_group = None (List Types.AWS_Security_Group)
, aws_subnet = None (List Types.AWS_Subnet)
, aws_s3_bucket = None (List Types.S3_Bucket)
, aws_vpc = None (List Types.VPC)
} : Resources

in defaults
