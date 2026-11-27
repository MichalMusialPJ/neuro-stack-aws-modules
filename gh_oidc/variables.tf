variable "tags" {
  description = "(Optional) tags for backend resources"
  type        = map(string)
  default     = {}
}

variable "name_prefix" {
  description = "(Required) Prefix for keeping naming convention"
  type        = string
}

variable "aws_account_id" {
  description = "(Required) AWS account ID for arn"
  type        = string
}

variable "github_org" {
  description = "(Required) Github organisation name for trust policy"
  type        = string
}

variable "github_repo" {
  description = "(Required) Github repository name for trust policy"
  type        = string
}

variable "allowed_subjects" {
  description = "(Optional) GitHub OIDC subject suffixes allowed to assume the role, e.g. ref:refs/heads/main, pull_request, environment:production"
  type        = list(string)
  default     = ["ref:refs/heads/main"]
}

variable "policy_arns" {
  description = "(Optional) Additional policy arn for github oidc role"
  type        = list(string)
  default     = []
}

variable "create_role" {
  description = "Toggle if you want to create role for provider"
  type        = bool
  default     = true
}

variable "create_provider" {
  description = "Toggle if you want to create provider"
  type        = bool
  default     = true
}
variable "create_terraform_policy" {
  description = "Toggle if you wanbt to create role for provider"
  type        = bool
  default     = true
}
