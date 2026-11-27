output "role_arn" {
  description = "ARN of the IAM role"
  value       = try(aws_iam_role.this[0].arn, null)
}

output "role_name" {
  description = "Name of the IAM role"
  value       = try(aws_iam_role.this[0].name, null)
}

output "role_id" {
  description = "Unique ID of the IAM role"
  value       = try(aws_iam_role.this[0].unique_id, null)
}

output "policy_arns" {
  description = "Map of policy key (default or additional_policies key) to ARN of the managed policies created by this module"
  value       = { for k, p in aws_iam_policy.this : k => p.arn }
}

output "instance_profile_name" {
  description = "Name of the instance profile, when create_instance_profile is true"
  value       = try(aws_iam_instance_profile.this[0].name, null)
}

output "instance_profile_arn" {
  description = "ARN of the instance profile, when create_instance_profile is true"
  value       = try(aws_iam_instance_profile.this[0].arn, null)
}
