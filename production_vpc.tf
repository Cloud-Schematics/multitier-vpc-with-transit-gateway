##############################################################################
# Create Multizone VPC
##############################################################################

module production_vpc {
    source                = "./multizone_vpc"

    # Account Variables
    unique_id                    = "${var.unique_id}-production"
    ibm_region                   = var.ibm_region
    resource_group_id            = data.ibm_resource_group.resource_group.id

    # Network Variables
    enable_public_gateway        = var.production_vpc_enable_public_gateway
    acl_rules                    = var.production_vpc_acl_rules
    security_group_rules         = var.production_vpc_default_security_group_rules
    subnet_zones                 = var.production_vpc_zones

    # Subnet Variables
    application_tier_cidr_blocks = var.production_vpc_application_tier_cidr_blocks
    admin_tier_cidr_blocks       = var.production_vpc_admin_tier_cidr_blocks
    database_tier_cidr_blocks    = var.production_vpc_database_tier_cidr_blocks
    web_tier_cidr_blocks         = var.production_vpc_web_tier_cidr_blocks
}

##############################################################################


##############################################################################
# Web tier Instances
##############################################################################

module production_web_tier_compute {
    source               = "./vsi_workspace"

    # Account Variables
    unique_id            = "${var.unique_id}-production-web"
    resource_group_id    = data.ibm_resource_group.resource_group.id
  
    # VPC Variables
    vpc_id               = module.production_vpc.vpc_id
    subnet_ids           = module.production_vpc.web_tier_subnets.*.id
    subnet_zones         = module.production_vpc.web_tier_subnets.*.zone
    ssh_public_key       = ibm_is_ssh_key.ssh_key.id

    # VSI Variables
    image                = var.production_web_tier_image
    machine_type         = var.production_web_tier_machine_type
    security_group_rules = merge(
        var.production_admin_tier_security_group_rules,
        # Allow Access from Admin and App Tiers
        {
            "allow-in-application-sg" = {
                source    = module.production_application_tier_compute.security_group_id
                direction = "inbound"
            },
            "allow-in-admin-sg" = {
                source    = module.production_admin_tier_compute.security_group_id
                direction = "inbound"
            }
        }
    )
}

##############################################################################


##############################################################################
# application tier Instances
# add lb
##############################################################################

module production_application_tier_compute {
    source               = "./vsi_workspace"

    # Account Variables
    unique_id            = "${var.unique_id}-production-application"
    resource_group_id    = data.ibm_resource_group.resource_group.id
  
    # VPC Variables
    vpc_id               = module.production_vpc.vpc_id
    subnet_ids           = module.production_vpc.application_tier_subnets.*.id
    subnet_zones         = module.production_vpc.application_tier_subnets.*.zone
    ssh_public_key       = ibm_is_ssh_key.ssh_key.id

    # VSI Variables
    image                = var.production_application_tier_image
    machine_type         = var.production_application_tier_machine_type
    
    # Create a single object containing all security group rules
    security_group_rules = merge(
        # Add Custom Security Group Rules
        var.production_admin_tier_security_group_rules,
        # Allow inbound traffic from Admin, Web, and DB Tiers
        {
            "allow-in-admin-sg" = {
                source    = module.production_admin_tier_compute.security_group_id
                direction = "inbound"
            },
            "allow-in-web-sg" = {
                source    = module.production_web_tier_compute.security_group_id
                direction = "inbound"
            },
            "allow-in-database-sg" = {
                source    = module.production_database_tier_compute.security_group_id
                direction = "inbound"
            }
        }
    )
}

##############################################################################


##############################################################################
# database tier Instances
# add lb
##############################################################################

module production_database_tier_compute {
    source               = "./vsi_workspace"

    # Account Variables
    unique_id            = "${var.unique_id}-production-database"
    resource_group_id    = data.ibm_resource_group.resource_group.id
  
    # VPC Variables
    vpc_id               = module.production_vpc.vpc_id
    subnet_ids           = module.production_vpc.database_tier_subnets.*.id
    subnet_zones         = module.production_vpc.database_tier_subnets.*.zone
    ssh_public_key       = ibm_is_ssh_key.ssh_key.id

    # VSI Variables
    image                = var.production_database_tier_image
    machine_type         = var.production_database_tier_machine_type

    # Create a single object containing all security group rules
    security_group_rules = merge(
        # Add custom security group rules
        var.production_admin_tier_security_group_rules,
        # Allow Access to Application and Admin Security Groups
        {
            "allow-in-application-sg" = {
                source    = module.production_application_tier_compute.security_group_id
                direction = "inbound"
            },
            "allow-in-admin-sg" = {
                source    = module.production_admin_tier_compute.security_group_id
                direction = "inbound"
            }
        }
    )
}

##############################################################################


##############################################################################
# Private tier Instances
##############################################################################

module production_admin_tier_compute {
    source               = "./vsi_workspace"

    # Account Variables
    unique_id            = "${var.unique_id}-production-admin"
    resource_group_id    = data.ibm_resource_group.resource_group.id
  
    # VPC Variables
    vpc_id               = module.production_vpc.vpc_id
    subnet_ids           = module.production_vpc.admin_tier_subnets.*.id
    subnet_zones         = module.production_vpc.admin_tier_subnets.*.zone
    ssh_public_key       = ibm_is_ssh_key.ssh_key.id

    # VSI Variables
    image                = var.production_admin_tier_image
    machine_type         = var.production_admin_tier_machine_type

    # Create a single object containing all security group rules
    security_group_rules = merge(
        # Add custom security group rules
        var.production_admin_tier_security_group_rules,
        # Allow Access to App, Web, and DB Tier Security Groups
        {
            "allow-in-application-sg" = {
                source    = module.production_application_tier_compute.security_group_id
                direction = "inbound"
            },
            "allow-in-web-sg" = {
                source    = module.production_web_tier_compute.security_group_id
                direction = "inbound"
            },
            "allow-in-database-sg" = {
                source    = module.production_database_tier_compute.security_group_id
                direction = "inbound"
            }
        },
        # Allow Access to Development VPC tiers
        {
            for i in module.development_vpc.web_tier_subnets :
            "allow-inbound-traffic-subnet-${i.name}" => {
                  source    = i.ipv4_cidr_block
                  direction = "inbound"
            }
        },
        {
            for i in module.development_vpc.web_tier_subnets :
            "allow-outbound-traffic-subnet-${i.name}" => {
                  source    = i.ipv4_cidr_block
                  direction = "outbound"
            }
        },
        {
            for i in module.development_vpc.application_tier_subnets :
            "allow-inbound-traffic-subnet-${i.name}" => {
                  source    = i.ipv4_cidr_block
                  direction = "inbound"
            }
        },
        {
            for i in module.development_vpc.application_tier_subnets :
            "allow-outbound-traffic-subnet-${i.name}" => {
                  source    = i.ipv4_cidr_block
                  direction = "outbound"
            }
        },
        {
            for i in module.development_vpc.database_tier_subnets :
            "allow-inbound-traffic-subnet-${i.name}" => {
                  source    = i.ipv4_cidr_block
                  direction = "inbound"
            }
        },
        {
            for i in module.development_vpc.database_tier_subnets :
            "allow-outbound-traffic-subnet-${i.name}" => {
                  source    = i.ipv4_cidr_block
                  direction = "outbound"
            }
        }
    )

}

##############################################################################