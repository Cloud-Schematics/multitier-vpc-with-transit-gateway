##############################################################################
# Terraform Providers
# This block is required for every module in Terraform 0.13.x
##############################################################################

terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "1.21.2"
    }
  }
}

##############################################################################