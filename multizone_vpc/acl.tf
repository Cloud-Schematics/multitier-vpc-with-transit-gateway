
##############################################################################
# Create an  ACL for ingress/egress used by  all subnets in VPC
##############################################################################

resource ibm_is_network_acl multizone_acl {
      name           = "${var.unique_id}-acl"
      vpc            = ibm_is_vpc.vpc.id
      resource_group = var.resource_group_id

      # Create ACL rules
      dynamic rules {
            for_each = var.acl_rules
            content {
                  name        = rules.value.name
                  action      = rules.value.action
                  source      = rules.value.source
                  destination = rules.value.destination
                  direction   = rules.value.direction

                  ##############################################################################
                  # Dynamically create TCP rules
                  ##############################################################################

                  dynamic tcp {

                        # Runs a for each loop, if the rule block contains tcp, it looks through the block
                        # Otherwise the list will be empty     

                        for_each = (
                              contains(keys(rules.value), "tcp")
                              ? [rules.value]
                              : []
                        )

                        # Conditionally adds content if sg has tcp
                        content {

                              port_min = ( 
                                    contains(
                                          keys(
                                                lookup(rules.value, "tcp")
                                          ), "port_min"
                                    )
                                    ? lookup(
                                          lookup(
                                                rules.value, 
                                                "tcp"
                                          ), 
                                          "port_min"
                                    )
                                    : null 
                              )

                              port_max = (
                                    contains(
                                          keys(
                                                lookup(rules.value, "tcp")
                                          ), "port_max"
                                    )
                                    ? lookup(
                                          lookup(
                                                rules.value, 
                                                "tcp"
                                          ), 
                                          "port_max"
                                    )
                                    : null
                              )

                              source_port_min = (
                                    contains(
                                          keys(
                                                lookup(rules.value, "tcp")
                                          ), "source_port_min"
                                    )
                                    ? lookup(
                                          lookup(
                                                rules.value, 
                                                "tcp"
                                          ), 
                                          "source_port_min"
                                    )
                                    : null
                              )

                              source_port_max = (
                                    contains(
                                          keys(
                                                lookup(rules.value, "tcp")
                                          ), "source_port_max"
                                    )
                                    ? lookup(
                                          lookup(
                                                rules.value, 
                                                "tcp"
                                          ), 
                                          "source_port_max"
                                    )
                                    : null
                              )
                        }
                  } 

                  ##############################################################################

                  ##############################################################################
                  # Dynamically create UDP rules
                  ##############################################################################
      
                  dynamic udp {

                        # Runs a for each loop, if the rule block contains udp, it looks through the block
                        # Otherwise the list will be empty     

                        for_each = (
                              contains(keys(rules.value), "udp")
                              ? [rules.value]
                              : []
                        )

                        # Conditionally adds content if sg has udp
                        content {

                              port_min = ( 
                                    contains(
                                          keys(
                                                lookup(rules.value, "udp")
                                          ), "port_min"
                                    )
                                    ? lookup(
                                          lookup(
                                                rules.value, 
                                                "udp"
                                          ), 
                                          "port_min"
                                    )
                                    : null 
                              )

                              port_max = (
                                    contains(
                                          keys(
                                                lookup(rules.value, "udp")
                                          ), "port_max"
                                    )
                                    ? lookup(
                                          lookup(
                                                rules.value, 
                                                "udp"
                                          ), 
                                          "port_max"
                                    )
                                    : null
                              )

                              source_port_min = (
                                    contains(
                                          keys(
                                                lookup(rules.value, "udp")
                                          ), "source_port_min"
                                    )
                                    ? lookup(
                                          lookup(
                                                rules.value, 
                                                "udp"
                                          ), 
                                          "source_port_min"
                                    )
                                    : null
                              )

                              source_port_max = (
                                    contains(
                                          keys(
                                                lookup(rules.value, "udp")
                                          ), "source_port_max"
                                    )
                                    ? lookup(
                                          lookup(
                                                rules.value, 
                                                "udp"
                                          ), 
                                          "source_port_max"
                                    )
                                    : null
                              )
                        } 
                  }
                  ##############################################################################

                  ##############################################################################
                  # Dynamically create ICMP rules
                  ##############################################################################

                  dynamic icmp {

                        # Runs a for each loop, if the rule block contains icmp, it looks through the block
                        # Otherwise the list will be empty     

                        for_each = (
                              contains(keys(rules.value), "icmp")
                              ? [rules.value]
                              : []
                        )

                        # Conditionally adds content if sg has icmp
                        content {

                              type = lookup(
                                    lookup(
                                          rules.value, 
                                          "icmp"
                                    ), 
                                    "type"
                              )

                              code = lookup(
                                    lookup(
                                          rules.value, 
                                          "icmp"
                                    ), 
                                    "code"
                              )
                        }
                  } 

                  ##############################################################################

            }
      }
}

##############################################################################