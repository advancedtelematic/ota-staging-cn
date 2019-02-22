let Types = ./types.dhall

let Resources =
{ aws_eip : Optional (List Types.AWS_Eip)
, aws_elb : Optional (List Types.AWS_ELB)
, aws_instance : Optional (List Types.AWS_Instance)
, aws_internet_gateway : Optional (List Types.AWS_Internet_Gateway)
, aws_nat_gateway : Optional (List Types.AWS_Nat_Gateway)
, aws_network_acl : Optional (List Types.AWS_Network_Acl)
, aws_route_table : Optional (List Types.AWS_Route_Table)
, aws_route_table_association : Optional (List Types.AWS_Route_Table_Association)
, aws_security_group : Optional (List Types.AWS_Security_Group)
, aws_subnet : Optional (List Types.AWS_Subnet)
, aws_s3_bucket : Optional (List Types.S3_Bucket)
, aws_vpc : Optional (List Types.VPC)
}

in Resources
