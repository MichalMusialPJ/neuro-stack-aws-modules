output "role_arn" {
  description = "ARN of github oidc role"
  value       = try(aws_iam_role.this[0].arn, null)
}

output "github_actions_role_name" {
  description = "Name of github oidc role"
  value       = try(aws_iam_role.this[0].name, null)
}

output "oidc_provider_arn" {
  description = "ARN of oidc provider"
  value       = try(aws_iam_openid_connect_provider.this[0].arn, null)
}

output "oidc_provider_url" {
  description = "URL of oidc provider"
  value       = try(aws_iam_openid_connect_provider.this[0].url, null)
}
