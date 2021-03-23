
##############################################################################
# Create Volumes
##############################################################################

locals {
    # Total number of volumes to create
    volume_count   = length(var.volumes) * (var.vsi_per_subnet * length(var.subnet_ids))
    # Number of volumes for each VSI
    volumes_length = length(var.volumes)
    # Number of volumes per subnet
    total_volumes  = var.vsi_per_subnet * length(var.volumes)
}

resource ibm_is_volume volume {
    count          = local.volume_count

    # Name: id-vsi-<vsi number>-<volume name>-<index>
    # ex. demo-vsi-1-dev-12
    name           = "${
        var.unique_id
    }-vsi-${
        floor(count.index / var.vsi_per_subnet) % local.volumes_length
    }-vol-${
        var.volumes[count.index % local.volumes_length].name
    }-${
        count.index
    }"

    resource_group = var.resource_group_id
    profile        = var.volumes[count.index % local.volumes_length].profile

    # Calculate zone
    zone           = element(
        var.subnet_zones,
        # Get index of the ID in subnet_ids
        index(
            var.subnet_ids,
            # Get subnet ID where volume is provisioned
            element(
                var.subnet_ids, 
                floor(count.index / local.total_volumes)
            )
            
        )
    )
    # Optional Iops only works with a profile of `custom`
    iops    = contains(
        keys(var.volumes[count.index % local.volumes_length]),
        "iops"
    ) ? lookup(var.volumes[count.index % local.volumes_length], "iops") : null
    
    # Optional Capacity
    capacity = contains(
        keys(var.volumes[count.index % local.volumes_length]),
        "capacity" 
    ) ? lookup(var.volumes[count.index % local.volumes_length], "capacity") : null

    # Optional Encryption Key
    encryption_key = contains(
        keys(var.volumes[count.index % local.volumes_length]),
        "encryption_key"
    ) ? lookup(var.volumes[count.index % local.volumes_length], "encryption_key") : null

    # Optional Tags
    tags = contains(
        keys(var.volumes[count.index % local.volumes_length]),
        "tags"
    ) ? lookup(var.volumes[count.index % local.volumes_length], "tags") : null
    
}

output ids {
    description = "A list of volume ID lists, each containing storage volume IDs for a single VSI"
    value       = chunklist(ibm_is_volume.volume.*.id, local.volumes_length)
}

##############################################################################