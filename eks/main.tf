locals {
  role_arn          = try(aws_iam_role.this[0].arn, "")
  account_id        = try(data.aws_caller_identity.current[0].account_id, "")
  security_group_id = try(aws_security_group.cluster[0].id, "")
}

resource "aws_eks_cluster" "this" {
  count = var.create_eks ? 1 : 0

  name                          = local.cluster_name
  role_arn                      = local.role_arn
  version                       = var.kubernetes_version
  enabled_cluster_log_types     = var.enabled_log_types
  deletion_protection           = var.deletion_protection
  bootstrap_self_managed_addons = true
  force_update_version          = var.force_update_version

  access_config {
    authentication_mode                         = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

  dynamic "control_plane_scaling_config" {
    for_each = var.control_plane_scaling_config != null ? [var.control_plane_scaling_config] : []

    content {
      tier = control_plane_scaling_config.value.tier
    }
  }

  dynamic "compute_config" {
    for_each = var.compute_config != null ? [var.compute_config] : []

    content {
      enabled       = compute_config.value.enabled
      node_pools    = compute_config.value.node_pools
      node_role_arn = compute_config.value.node_pools != null ? try(aws_iam_role.eks_auto[0].arn, compute_config.value.node_role_arn) : null
    }
  }

  vpc_config {
    security_group_ids      = compact(distinct(concat(var.additional_security_group_ids, [local.security_group_id])))
    subnet_ids              = length(var.control_plane_subnet_ids) > 0 ? var.control_plane_subnet_ids : var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.endpoint_public_access_cidrs
  }

  dynamic "encryption_config" {
    for_each = var.enable_encryption_config ? [var.encryption_config] : []

    content {
      provider {
        key_arn = var.create_kms_key ? module.kms[0].key_arn : encryption_config.value.provider_key_arn
      }
      resources = encryption_config.value.resources
    }
  }

  dynamic "storage_config" {
    for_each = var.compute_config != null ? [var.compute_config] : []

    content {
      block_storage {
        enabled = storage_config.value.enabled
      }
    }
  }

  dynamic "upgrade_policy" {
    for_each = var.upgrade_policy != null ? [var.upgrade_policy] : []

    content {
      support_type = upgrade_policy.value.support_type
    }
  }

  dynamic "zonal_shift_config" {
    for_each = var.zonal_shift_config != null ? [var.zonal_shift_config] : []

    content {
      enabled = zonal_shift_config.value.enabled
    }
  }

  lifecycle {
    ignore_changes = [
      access_config[0].bootstrap_cluster_creator_admin_permissions,
      bootstrap_self_managed_addons,
    ]
  }

  tags = var.tags
}
