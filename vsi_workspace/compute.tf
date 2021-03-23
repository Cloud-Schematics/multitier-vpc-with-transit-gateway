##############################################################################
# Image Data Block
##############################################################################

data ibm_is_image image {
  name = var.image
}

##############################################################################


##############################################################################
# Create Volumes
##############################################################################

# module volumes {
#   source            = "./volume_module"
#   unique_id         = var.unique_id
#   volumes           = var.volumes
#   vsi_per_subnet    = var.vsi_per_subnet
#   subnet_ids        = var.subnet_ids
#   subnet_zones      = var.subnet_zones
#   resource_group_id = var.resource_group_id
# }

##############################################################################


##############################################################################
# Provision VSI
##############################################################################

resource ibm_is_instance vsi {
  count   = var.vsi_per_subnet * length(var.subnet_ids)

  name           = "${var.unique_id}-vsi-${count.index + 1}"
  image          = data.ibm_is_image.image.id
  profile        = var.machine_type
  resource_group = var.resource_group_id
  primary_network_interface {
    subnet   = element(var.subnet_ids, (count.index / var.vsi_per_subnet))
    security_groups = [
      ibm_is_security_group.security_group.id
    ]
  }  

  user_data  = <<BASH
#!/bin/bash
sudo yum -y install epel-release
sudo yum -y install nginx
sudo systemctl start nginx  
  BASH
                 
  vpc        = var.vpc_id
  zone       = element(
      var.subnet_zones,
      index(
        var.subnet_ids, 
        element(var.subnet_ids, (count.index / var.vsi_per_subnet))
      )
  )

  
  keys       = [ var.ssh_public_key ]
  # volumes    = length(var.volumes) > 0 ? module.volumes.ids[count.index] : null
}

##############################################################################


##############################################################################
# Provision Floating IPs for Subnets
##############################################################################

resource ibm_is_floating_ip vsi_fip {
  count  = var.enable_fip ? var.vsi_per_subnet * length(var.subnet_ids) : 0
  name   = "${var.unique_id}-fip-${count.index + 1}"
  target = element(ibm_is_instance.vsi.*.primary_network_interface.0.id, count.index)
}

##############################################################################