##############################################################################
# Account Variables
##############################################################################

variable unique_id {
    description = "A unique identifier need to provision resources. Must begin with a letter"
    type        = string
    default     = "asset-multizone"
}

variable ibm_region {
    description = "IBM Cloud region where all resources will be deployed"
    type        = string
}

variable resource_group_id {
    description = "ID of resource group to create VPC"
    type        = string
}

##############################################################################


##############################################################################
# Network variables
##############################################################################

variable classic_access {
  description = "Enable VPC Classic Access. Note: only one VPC per region can have classic access"
  #type        = bool
  default     = false
}

variable enable_public_gateway {
  description = "Enable public gateways for subnets, true or false"
  #type        = bool
  default     = true
}

variable cidr_blocks {
  description = "A list of tier subnet CIDR blocks"
  type        = list //(string)
  default     = []
}

variable subnet_zones {
  description = "Number of zones for each subnet tier. Can be 1, 2, or 3"
  type        = number 
  default     = 3
}

variable acl_rules {
  description = "Access control list rule set"
  default = [
    {
      name        = "allow-all-inbound"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "inbound"
    },
    {
      name        = "allow-all-outbound"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "outbound"
    }
  ]
  
}

variable security_group_rules {
  description = "List of security group rules to be added to default security group"
  default     = {
    allow_all_inbound = {
      source    = "0.0.0.0/0"
      direction = "inbound"
    }
  }
}

variable application_tier_cidr_blocks {
  description = "CIDR blocks for application tier"
  type        = list(string)
  default     = []
}

variable web_tier_cidr_blocks {
  description = "CIDR blocks for Web tier"
  type        = list(string)
  default     = []
}

variable admin_tier_cidr_blocks {
  description = "CIDR blocks for Private tier"
  type        = list(string)
  default     = []
}

variable database_tier_cidr_blocks {
  description = "CIDR blocks for database tier"
  type        = list(string)
  default     = []
}

##############################################################################