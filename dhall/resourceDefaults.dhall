let Types = ./types.dhall

let accessLogsDefault =
{ bucket_prefix = None Text
, interval = None Natural
, enabled = None Bool
}

let awsElbDefault =
{ name = None Text
, name_prefix = None Text
, access_logs = None Types.ElbAccessLogs
, availability_zones = None (List Text)
, security_groups = None (List Text)
, instances = None (List Text)
, internal = None Bool
, health_check = None Types.ElbHealthCheck
, cross_zone_load_balancing = None Bool
, idle_timeout = None Natural
, connection_draining = None Bool
, connection_draining_timeout = None Natural
, tags = None Types.Tags
}

in
{ accessLogsDefault = accessLogsDefault
, awsElbDefault = awsElbDefault
}
