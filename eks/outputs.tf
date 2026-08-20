output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = try(aws_eks_cluster.this[0].id, null)
}

output "cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = try(aws_eks_cluster.this[0].arn, null)
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster API server"
  value       = try(aws_eks_cluster.this[0].endpoint, null)
}

output "cluster_version" {
  description = "The Kubernetes version of the EKS cluster"
  value       = try(aws_eks_cluster.this[0].version, null)
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for the cluster"
  value       = try(aws_eks_cluster.this[0].certificate_authority[0].data, null)
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster control plane"
  value       = local.security_group_id
}

output "node_security_group_id" {
  description = "Security group ID for EKS nodes"
  value       = local.node_security_group_id
}

output "cluster_iam_role_arn" {
  description = "ARN of the IAM role used by the EKS cluster"
  value       = try(aws_iam_role.this[0].arn, null)
}

output "node_iam_role_arn" {
  description = "ARN of the IAM role used by EKS nodes"
  value       = try(aws_iam_role.eks_auto[0].arn, null)
}

output "node_iam_role_name" {
  description = "Name of the IAM role used by EKS nodes (used for IRSA trust policies)"
  value       = try(aws_iam_role.eks_auto[0].name, null)
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider for IRSA"
  value       = try(aws_iam_openid_connect_provider.this[0].arn, null)
}

output "oidc_provider_url" {
  description = "URL of the OIDC provider (without https:// prefix)"
  value       = try(replace(aws_iam_openid_connect_provider.this[0].url, "https://", ""), null)
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for secrets encryption (null if not created)"
  value       = try(module.kms[0].key_arn, null)
}
