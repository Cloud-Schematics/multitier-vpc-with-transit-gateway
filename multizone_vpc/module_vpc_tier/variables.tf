##############################################################################
# Account Variables
##############################################################################

variable ibm_region {
    description = "Region for resources to be created"
    type        = string
}

variable unique_id {
    description = "Unique ID for subnets created"
    type        = string
}

variable resource_group {
    description = "Name of resource group to create VPC"
    type        = string
    default     = "asset-development"
}

##############################################################################

##############################################################################
# VPC Variables
##############################################################################

variable enable_acl_id {
    description = "Enables acl id if true"
    type        = bool
    default     = true
  
}


variable acl_id {
    description = "ID of ACL for subnets to use"
    type        = string
}


variable vpc_id {
    description = "ID of VPC where subnet needs to be created"
    type        = string
}

##############################################################################


##############################################################################
# Network variables
##############################################################################

variable cidr_blocks {
    description = "CIDR blocks for subnets to be created. If no CIDR blocks are provided, it will create subnets with 256 total ipv4 addresses"
    type        = list(string)
    default     = []
}

variable total_ipv4_address_count {
    description = "Number of IPV4 Addresses to add to subnet. Conflicts with `cidr_blocks`"
    type        = number
    default     = 0
}

##############################################################################


##############################################################################
# Subnet variables
##############################################################################

variable subnets_per_zone {
    description = "Number of subnets per zone"
    type        = number
    default     = 1
}

variable subnet_zones {
    description = "Number of zones to deploy subnets in"
    type        = number
    default     = 3
}

variable public_gateways {
    description = "List of public gateway ids"
    type        = list(string)
    default     = []
}


##############################################################################
