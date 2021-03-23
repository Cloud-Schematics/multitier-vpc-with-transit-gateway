##############################################################################
# VSI Variables
##############################################################################

variable unique_id {
  description = "A unique ID for the workspace"
  type        = string
}

variable resource_group_id {
  description = "ID of resource group where volumes will be provisioned"
  type        = string
}

variable volumes {
  description = "A list of volumes to create"
  /*
  type         = list(object({
      name           = string
      profile        = string
      iops           = number
      capacity       = number
      encryption_key = string
      tags           = list(string)
  }))
  */
  default     = []
}

variable vsi_per_subnet {
  description = "Number of VSI the volumes will be created for on each subnet"
  type        = number
  default     = 0
}

variable subnet_ids {
  description = "A list of subnet for the volumes to be created"
  type        = list(string)
  default     = []
}

variable subnet_zones {
  description = "A list of zones for the subnets"
  type        = list(string)
  default     = []
}

##############################################################################