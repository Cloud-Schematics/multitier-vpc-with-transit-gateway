##############################################################################
# Outputs
##############################################################################

output subnets {
  description = "ID and zones of subnets created for this tier"
  value       = [
    for i in ibm_is_subnet.subnet:
    {
      id              = i.id
      zone            = i.zone
      ipv4_cidr_block = i.ipv4_cidr_block
      name            = i.name
    }
  ]
}  

output cidr_blocks {
  value       = ibm_is_subnet.subnet.*.ipv4_cidr_block
}

##############################################################################