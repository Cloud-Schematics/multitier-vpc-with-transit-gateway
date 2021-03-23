##############################################################################
# Prefixes and subnets
#
# Creates a number of address prefixes per zone equal to the subnets per 
# zone times the number of zones
##############################################################################

resource ibm_is_vpc_address_prefix subnet_prefix {
  count = length(var.cidr_blocks) > 0 ? var.subnets_per_zone * var.subnet_zones : 0
  name  = "${var.unique_id}-prefix-zone-${(count.index % var.subnet_zones) + 1}" 
  zone  = "${var.ibm_region}-${(count.index % var.subnet_zones) + 1}"
  vpc   = var.vpc_id
  cidr  = element(var.cidr_blocks, count.index)
}

##############################################################################


##############################################################################
# Create Subnets
#
# Creates a number of subnets per zone equal to the subnets per zone
# time the number of zones
##############################################################################

resource ibm_is_subnet subnet {
  count                    = (length(var.cidr_blocks) == 0 && var.total_ipv4_address_count == 0) ? 0 : var.subnets_per_zone * var.subnet_zones
  name                     = "${var.unique_id}-subnet-${count.index + 1}"
  vpc                      = var.vpc_id
  resource_group           = var.resource_group
  zone                     = "${var.ibm_region}-${(count.index % var.subnet_zones) + 1}"
  ipv4_cidr_block          = length(var.cidr_blocks) > 0 ? element(ibm_is_vpc_address_prefix.subnet_prefix.*.cidr, count.index) : null
  network_acl              = var.enable_acl_id ? var.acl_id : null
  public_gateway           = length(var.public_gateways) > 0 ? element(var.public_gateways, count.index) : null
  total_ipv4_address_count = length(var.cidr_blocks) > 0 ? null : var.total_ipv4_address_count
}

##############################################################################