##############################################################################
# VSI Outputs
##############################################################################

output vsi {
    description = "Provisioned VSIs IDs, subnets and zones."
    value       = [
        for i in ibm_is_instance.vsi:
        {
            id           = i.id,
            zone         = i.zone
            ipv4_address = i.primary_network_interface.0.primary_ipv4_address
        }
    ]
}

output security_group_id {
    description = "Security group ID"
    value       = ibm_is_security_group.security_group.id
}

output vsi_subnet {
    description = "List of subnets where vsi are provisioned"
    value       = [
        for i in ibm_is_instance.vsi:
        lookup(i.primary_network_interface[0], "id")
    ]
}


##############################################################################
