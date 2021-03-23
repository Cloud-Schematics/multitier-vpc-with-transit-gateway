##############################################################################
# Account Variables
##############################################################################

variable vpc_id {
  description = "ID of VPC"
  type        = string
}

variable resource_group_id {
  description = "Name of resource group to create VPC"
  type        = string
  default     = "asset-development"
}

variable unique_id {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  type        = string
  default     = "asset-module-vsi"
}

##############################################################################


##############################################################################
# VPC Variables
##############################################################################

variable enable_fip {
  description = "Enable floating IP. Can be true or false"
  type        = bool
  default     = false
}

variable subnet_ids {
  description = "A list of subnet IDs where VSI will be deployed"
  type        = list
}


##############################################################################


##############################################################################
# VSI Variables
##############################################################################

variable image {
  description = "Image name used for VSI. Run 'ibmcloud is images' to find available images in a region"
  type        = string
  default     = "ibm-centos-7-6-minimal-amd64-2"
}

variable ssh_public_key {
  description = "ssh public key to use for vsi"
  type        = string
}

variable machine_type {
  description = "VSI machine type. Run 'ibmcloud is instance-profiles' to get a list of regional profiles"
  type        =  string
  default     = "bx2-8x32"
}

variable vsi_per_subnet {
    description = "Number of VSI instances for each subnet"
    type        = number
    default     = 1
}

variable security_group_rules {
  description = "List of security group rules to be added to security group"
  default     = {
    allow_all_inbound = {
      source    = "0.0.0.0/0"
      direction = "inbound"
    }
  }
}

##############################################################################

##############################################################################
# Volume Variables
##############################################################################

variable subnet_zones {
  description = "A list of the zones where subnets are created"
  type        = list(string)
}

# variable volumes {
#   description = "A list of maps describng the volumes for each of the VSI"
#   type        = list
# }

##############################################################################