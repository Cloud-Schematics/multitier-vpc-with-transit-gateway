##############################################################################
# Account Variables
##############################################################################

variable ibmcloud_api_key {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  type        = string
}

variable unique_id {
    description = "A unique identifier need to provision resources. Must begin with a letter"
    type        = string
    default     = "asset-multizone"
}

variable ibm_region {
    description = "IBM Cloud region where all resources will be deployed"
    type        = string
}

variable resource_group {
    description = "Name of resource group where all infrastructure will be provisioned"
    type        = string
    default     = "asset-development"
}

variable generation {
  description = "generation for VPC. Can be 1 or 2"
  type        = number
  default     = 2
}

##############################################################################


##############################################################################
# Production VPC Variables
##############################################################################

variable production_vpc_enable_public_gateway {
  description = "Enable public gateways for subnets, true or false"
  type        = bool
  default     = false
}


variable production_vpc_acl_rules {
  description = "Access control list rule set for all subnets"
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
    },
  ]
  
}

variable production_vpc_default_security_group_rules {
  description = "List of security group rules to be added to security group"
  default     = {
    allow_all_inbound = {
      source    = "0.0.0.0/0"
      direction = "inbound"
    }
  }
}

variable production_vpc_zones {
  description = "Create subnets and VSI across 1, 2, or 3 zones"
  type        = number
  default     = 3
}

##############################################################################


##############################################################################
# Production VPC Subnet Variables
##############################################################################

variable production_vpc_application_tier_cidr_blocks {
  description = "CIDR blocks for Production VPC Application Tier"
  type        = list(string)
  default     = [
    "10.10.10.0/28",
    "10.20.10.0/28",
    "10.30.10.0/28"
  ]
}

variable production_vpc_admin_tier_cidr_blocks {
  description = "CIDR blocks for Production VPC Admin Tier"
  type        = list(string)
  default     = [
    "10.40.10.0/28",
    "10.50.10.0/28",
    "10.60.10.0/28"
  ]
}

variable production_vpc_database_tier_cidr_blocks {
  description = "CIDR blocks for Production VPC Database Tier"
  type        = list(string)
  default     = [
    "10.70.10.0/28",
    "10.80.10.0/28",
    "10.90.10.0/28"
  ]
}

variable production_vpc_web_tier_cidr_blocks {
  description = "CIDR blocks for Production VPC Web Tier"
  type        = list(string)
  default     = [
    "10.100.10.0/28",
    "10.110.10.0/28",
    "10.120.10.0/28"
  ]
}

##############################################################################

##############################################################################
# development VPC Variables
##############################################################################

variable development_vpc_enable_public_gateway {
  description = "Enable public gateways for subnets, true or false"
  type        = bool
  default     = false
}


variable development_vpc_acl_rules {
  description = "Access control list rule set for all subnets"
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
    },
  ]
  
}

variable development_vpc_default_security_group_rules {
  description = "List of security group rules to be added to security group"
  default     = {
    allow_all_inbound = {
      source    = "0.0.0.0/0"
      direction = "inbound"
    }
  }
}

variable development_vpc_zones {
  description = "Create subnets and VSI across 1, 2, or 3 zones"
  type        = number
  default     = 3
}

##############################################################################

##############################################################################
##############################################################################
## Production Tier VSI Variables
##############################################################################
##############################################################################

##############################################################################
# Application tier VSI Variables
##############################################################################

variable production_application_tier_image {
  description = "Image name used for VSI. Run 'ibmcloud is images' to find available images in a region"
  type        = string
  default     = "ibm-centos-7-6-minimal-amd64-2"
}

variable production_application_tier_machine_type {
  description = "VSI machine type. Run 'ibmcloud is instance-profiles' to get a list of regional profiles"
  type        =  string
  default     = "cx2-2x4"
}

variable production_application_tier_security_group_rules {
  description = "List of security group rules to be added to security group"
  default     = {
    allow_all_outbound = {
      source    = "0.0.0.0/0"
      direction = "outbound"
    }
  }
}

##############################################################################


##############################################################################
# Database tier VSI Variables
##############################################################################

variable production_database_tier_image {
  description = "Image name used for VSI. Run 'ibmcloud is images' to find available images in a region"
  type        = string
  default     = "ibm-centos-7-6-minimal-amd64-2"
}

variable production_database_tier_machine_type {
  description = "VSI machine type. Run 'ibmcloud is instance-profiles' to get a list of regional profiles"
  type        =  string
  default     = "cx2-2x4"
}

variable production_database_tier_security_group_rules {
  description = "List of security group rules to be added to security group"
  default     = {
    allow_all_outbound = {
      source    = "0.0.0.0/0"
      direction = "outbound"
    }
  }
}

##############################################################################


##############################################################################
# Admin tier VSI Variables
##############################################################################

variable production_admin_tier_image {
  description = "Image name used for VSI. Run 'ibmcloud is images' to find available images in a region"
  type        = string
  default     = "ibm-centos-7-6-minimal-amd64-2"
}

variable production_admin_tier_machine_type {
  description = "VSI machine type. Run 'ibmcloud is instance-profiles' to get a list of regional profiles"
  type        =  string
  default     = "cx2-2x4"
}

variable production_admin_tier_security_group_rules {
  description = "List of security group rules to be added to security group"
  default     = {
    allow_all_outbound = {
      source    = "0.0.0.0/0"
      direction = "outbound"
    }
}
}

##############################################################################

##############################################################################
# Web tier VSI Variables
##############################################################################

variable production_web_tier_image {
  description = "Image name used for VSI. Run 'ibmcloud is images' to find available images in a region"
  type        = string
  default     = "ibm-centos-7-6-minimal-amd64-2"
}

variable production_web_tier_machine_type {
  description = "VSI machine type. Run 'ibmcloud is instance-profiles' to get a list of regional profiles"
  type        =  string
  default     = "cx2-2x4"
}

variable production_web_tier_security_group_rules {
  description = "List of security group rules to be added to default security group"
  default     = {
    allow_all_outbound = {
      source    = "0.0.0.0/0"
      direction = "outbound"
    }
}
}

##############################################################################


##############################################################################
##############################################################################


##############################################################################
# development VPC Subnet Variables
##############################################################################

variable development_vpc_application_tier_cidr_blocks {
  description = "CIDR blocks for development VPC Application Tier"
  type        = list(string)
  default     = [
    "172.16.0.0/24", 
    "172.16.1.0/24", 
    "172.16.2.0/24"
  ]
}

variable development_vpc_database_tier_cidr_blocks {
  description = "CIDR blocks for development VPC Database Tier"
  type        = list(string)
  default     = [
    "172.16.3.0/24", 
    "172.16.4.0/24", 
    "172.16.5.0/24"
  ]
}

variable development_vpc_web_tier_cidr_blocks {
  description = "CIDR blocks for development VPC Web Tier"
  type        = list(string)
  default     = [
    "172.16.6.0/24", 
    "172.16.7.0/24", 
    "172.16.8.0/24"
  ]
}

##############################################################################


##############################################################################
##############################################################################
## Development Tier VSI Variables
##############################################################################
##############################################################################

##############################################################################
# Application tier VSI Variables
##############################################################################

variable development_application_tier_image {
  description = "Image name used for VSI. Run 'ibmcloud is images' to find available images in a region"
  type        = string
  default     = "ibm-centos-7-6-minimal-amd64-2"
}

variable development_application_tier_machine_type {
  description = "VSI machine type. Run 'ibmcloud is instance-profiles' to get a list of regional profiles"
  type        =  string
  default     = "cx2-2x4"
}

variable development_application_tier_security_group_rules {
  description = "List of security group rules to be added to security group"
  default     = {
    allow_all_outbound = {
      source    = "0.0.0.0/0"
      direction = "outbound"
    }
  }
}

##############################################################################


##############################################################################
# Database tier VSI Variables
##############################################################################

variable development_database_tier_image {
  description = "Image name used for VSI. Run 'ibmcloud is images' to find available images in a region"
  type        = string
  default     = "ibm-centos-7-6-minimal-amd64-2"
}

variable development_database_tier_machine_type {
  description = "VSI machine type. Run 'ibmcloud is instance-profiles' to get a list of regional profiles"
  type        =  string
  default     = "cx2-2x4"
}

variable development_database_tier_security_group_rules {
  description = "List of security group rules to be added to security group"
  default     = {
    allow_all_outbound = {
      source    = "0.0.0.0/0"
      direction = "outbound"
    }
  }
}

##############################################################################

##############################################################################
# Web tier VSI Variables
##############################################################################

variable development_web_tier_image {
  description = "Image name used for VSI. Run 'ibmcloud is images' to find available images in a region"
  type        = string
  default     = "ibm-centos-7-6-minimal-amd64-2"
}

variable development_web_tier_machine_type {
  description = "VSI machine type. Run 'ibmcloud is instance-profiles' to get a list of regional profiles"
  type        =  string
  default     = "cx2-2x4"
}

variable development_web_tier_security_group_rules {
  description = "List of security group rules to be added to default security group"
  default     = {
    allow_all_outbound = {
      source    = "0.0.0.0/0"
      direction = "outbound"
    }
  }
}

##############################################################################


##############################################################################
##############################################################################


##############################################################################
# VSI Variables
##############################################################################

variable ssh_public_key {
  description = "ssh public key to use for vsi"
  type        = string
}


##############################################################################

