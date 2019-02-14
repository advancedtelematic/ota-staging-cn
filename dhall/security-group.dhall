let Ingress =
  { from_port : Natural
  , to_port : Natural
  , protocol : Text
  , cidr_blocks : List Text
  }

let Egress = Ingress

let AWS_Security_Group =
{ mapKey : Text
, mapValue :
  { name : Text
  , description : Text
  , vpc_id : Text
  , ingress : Optional (List Ingress)
  , egress : Optional (List Egress)
  }
}

let Network_Acl_Ingress =
  { from_port : Natural
  , to_port : Natural
  , protocol : Text
  , cidr_block : Text
  , action : Text
  , rule_no : Natural
  }

let Network_Acl_Egress = Network_Acl_Ingress

let AWS_Network_Acl =
{ mapKey : Text
, mapValue :
  { vpc_id : Text
  , subnet_ids : List Text
  , ingress : Optional (List Network_Acl_Ingress)
  , egress : Optional (List Network_Acl_Egress)
  }
}

in
{ AWS_Security_Group = AWS_Security_Group
, AWS_Network_Acl = AWS_Network_Acl
}
