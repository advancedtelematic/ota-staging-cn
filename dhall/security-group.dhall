let Ingress =
  { from_port : Natural
  , to_port : Natural
  , protocol : Text
  , cidr_blocks : List Text
  }

let Egress = Ingress

in
{ mapKey : Text
, mapValue :
  { name : Text
  , description : Text
  , vpc_id : Text
  , ingress : Optional (List Ingress)
  , egress : Optional (List Egress)
  }
}
