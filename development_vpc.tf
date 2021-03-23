##############################################################################
# Create Multizone VPC
##############################################################################

module development_vpc {
    source                = "./multizone_vpc"

    # Account Variables
    unique_id                    = "${var.unique_id}-development"
    ibm_region                   = var.ibm_region
    resource_group_id            = data.ibm_resource_group.resource_group.id

    # Network Variables
    enable_public_gateway        = var.development_vpc_enable_public_gateway
    acl_rules                    = var.development_vpc_acl_rules
    security_group_rules         = var.development_vpc_default_security_group_rules
    subnet_zones                 = var.development_vpc_zones

    # Subnet Variables
    application_tier_cidr_blocks = var.development_vpc_application_tier_cidr_blocks
    database_tier_cidr_blocks    = var.development_vpc_database_tier_cidr_blocks
    web_tier_cidr_blocks         = var.development_vpc_web_tier_cidr_blocks
}

##############################################################################


##############################################################################
# Web tier Instances
##############################################################################

module development_web_tier_compute {
    source               = "./vsi_workspace"

    # Account Variables
    unique_id            = "${var.unique_id}-development-web"
    resource_group_id    = data.ibm_resource_group.resource_group.id
  
    # VPC Variables
    vpc_id               = module.development_vpc.vpc_id
    subnet_ids           = module.development_vpc.web_tier_subnets.*.id
    subnet_zones         = module.development_vpc.web_tier_subnets.*.zone
    ssh_public_key       = ibm_is_ssh_key.ssh_key.id

    # VSI Variables
    image                = var.development_web_tier_image
    machine_type         = var.development_web_tier_machine_type

    # Create a single object containing all security group rules
    security_group_rules = merge(
        var.development_application_tier_security_group_rules,
        # Allow Application Tier to Access Web Tier
        {
            "allow-in-application-sg" = {
                source    = module.development_application_tier_compute.security_group_id
                direction = "inbound"
            }
        },
        # Allow Production Access via Transit Gateway
        {
            for i in module.production_vpc.admin_tier_subnets :
            "allow-inbound-traffic-subnet-${i.name}" => {
                  source    = i.ipv4_cidr_block
                  direction = "inbound"
            }
        },
        {
            for i in module.production_vpc.admin_tier_subnets :
            "allow-outbound-traffic-subnet-${i.name}" => {
                  source    = i.ipv4_cidr_block
                  direction = "outbound"
            }
        }
    )
}

##############################################################################


##############################################################################
# application tier Instances
##############################################################################

module development_application_tier_compute {
    source               = "./vsi_workspace"

    # Account Variables
    unique_id            = "${var.unique_id}-development-application"
    resource_group_id    = data.ibm_resource_group.resource_group.id
  
    # VPC Variables
    vpc_id               = module.development_vpc.vpc_id
    subnet_ids           = module.development_vpc.application_tier_subnets.*.id
    subnet_zones         = module.development_vpc.application_tier_subnets.*.zone
    ssh_public_key       = ibm_is_ssh_key.ssh_key.id

    # VSI Variables
    image                = var.development_application_tier_image
    machine_type         = var.development_application_tier_machine_type

    # Create a single object containing all security group rules
    security_group_rules = merge(
        var.development_application_tier_security_group_rules,
        # Allow Web and DB Tier Access
        {
            "allow-in-web-sg" = {
                source    = module.development_web_tier_compute.security_group_id
                direction = "inbound"
            },
            "allow-in-database-sg" = {
                source    = module.development_database_tier_compute.security_group_id
                direction = "inbound"
            },
        },
        # Allow Production Access via Transit Gateway
        {
            for i in module.production_vpc.admin_tier_subnets :
            "allow-inbound-traffic-subnet-${i.name}" => {
                  source    = i.ipv4_cidr_block
                  direction = "inbound"
            }
        },
        {
            for i in module.production_vpc.admin_tier_subnets :
            "allow-outbound-traffic-subnet-${i.name}" => {
                  source    = i.ipv4_cidr_block
                  direction = "outbound"
            }
        }
    )
}

##############################################################################


##############################################################################
# database tier Instances
##############################################################################

module development_database_tier_compute {
    source               = "./vsi_workspace"

    # Account Variables
    unique_id            = "${var.unique_id}-development-database"
    resource_group_id    = data.ibm_resource_group.resource_group.id
  
    # VPC Variables
    vpc_id               = module.development_vpc.vpc_id
    subnet_ids           = module.development_vpc.database_tier_subnets.*.id
    subnet_zones         = module.development_vpc.database_tier_subnets.*.zone
    ssh_public_key       = ibm_is_ssh_key.ssh_key.id

    # VSI Variables
    image                = var.development_database_tier_image
    machine_type         = var.development_database_tier_machine_type

    # Create a single object containing all security group rules
    security_group_rules = merge(
        # Add Custom Security Group Rules
        var.development_database_tier_security_group_rules,
        # Allow App Tier Access
        {
            "allow-in-application-sg" = {
                source    = module.development_application_tier_compute.security_group_id
                direction = "inbound"
            }
        },
        
        # Allow Production Access via Transit Gateway
        {
            for i in module.production_vpc.admin_tier_subnets :
            "allow-inbound-traffic-subnet-${i.name}" => {
                  source    = i.ipv4_cidr_block
                  direction = "inbound"
            }
        },
        {
            for i in module.production_vpc.admin_tier_subnets :
            "allow-outbound-traffic-subnet-${i.name}" => {
                  source    = i.ipv4_cidr_block
                  direction = "outbound"
            }
        }
    )
}

##############################################################################