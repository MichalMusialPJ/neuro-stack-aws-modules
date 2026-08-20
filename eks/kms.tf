module "kms" {
  source = "../kms"
  count  = var.create_kms_key ? 1 : 0

  create_kms  = var.create_kms_key
  region      = var.region
  description = "EKS cluster ${local.cluster_name} secrets encryption"
  key_users   = [local.role_arn]
  tags        = var.tags
}
