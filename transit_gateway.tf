##############################################################################
# Transit Gateway
##############################################################################

resource ibm_tg_gateway transit_gateway {
  name           = "${var.unique_id}-transit-gateway"
  location       = var.ibm_region
  global         = false
  resource_group = data.ibm_resource_group.resource_group.id
}

##############################################################################


##############################################################################
# Transit Gateway Connections
##############################################################################

resource ibm_tg_connection production_connection {
  gateway      = ibm_tg_gateway.transit_gateway.id
  network_type = "vpc"
  name         = "${var.unique_id}-production-connection"
  network_id   = module.production_vpc.vpc_crn
}

resource ibm_tg_connection development_connection {
  gateway      = ibm_tg_gateway.transit_gateway.id
  network_type = "vpc"
  name         = "${var.unique_id}-development-connection"
  network_id   = module.development_vpc.vpc_crn
}

##############################################################################
