##############################################################################
# VPC GUID
##############################################################################

output vpc_id {
  description = "ID of VPC created"
  value       = ibm_is_vpc.vpc.id
}

output vpc_crn {
  description = "CRN of VPC"
  value       = ibm_is_vpc.vpc.resource_crn
}

##############################################################################


##############################################################################
# List of subnet IDs
##############################################################################

output database_tier_subnets {
  description = "List of maps containing subnet ids and zones"
  value       = module.database_tier_subnets.subnets
}

output application_tier_subnets {
  description = "List of maps containing subnet ids and zones"
  value       = module.application_tier_subnets.subnets
}

output admin_tier_subnets {
  description = "List of maps containing subnet ids and zones"
  value       = module.admin_tier_subnets.subnets
}

output web_tier_subnets {
  description = "List of maps containing subnet ids and zones"
  value       = module.web_tier_subnets.subnets
}

##############################################################################



##############################################################################
# ACL ID
##############################################################################

output acl_id {
  description = "ID of ACL created"
  value       = ibm_is_network_acl.multizone_acl.id
}

##############################################################################