variable "create_role" {
  description = "(Optional) Set to false to skip creating the IAM role and its policies"
  type        = bool
  default     = true
}

variable "name_prefix" {
  description = "(Required) Prefix for keeping naming convention"
  type        = string
}

variable "role_name" {
  description = "(Required) Name suffix for the role, e.g. karpenter, aws-lb-controller or ec2-worker"
  type        = string
}

variable "description" {
  description = "(Optional) Description of the IAM role"
  type        = string
  default     = null
}

variable "path" {
  description = "(Optional) Path of the IAM role and policies"
  type        = string
  default     = "/"
}

variable "max_session_duration" {
  description = "(Optional) Maximum session duration in seconds (3600-43200)"
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration must be between 3600 and 43200 seconds."
  }
}

variable "permissions_boundary_arn" {
  description = "(Optional) ARN of the permissions boundary policy attached to the role"
  type        = string
  default     = null
}

# ── Trust: IRSA (Kubernetes service account via EKS OIDC) ────────────────────

variable "oidc_provider_arn" {
  description = "(Optional, IRSA) ARN of the EKS cluster OIDC provider, used as the trusted principal"
  type        = string
  default     = null
}

variable "oidc_provider_url" {
  description = "(Optional, IRSA) URL of the EKS cluster OIDC provider (with or without https://)"
  type        = string
  default     = null
}

variable "namespace" {
  description = "(Optional, IRSA) Kubernetes namespace of the service account allowed to assume the role"
  type        = string
  default     = null
}

variable "service_account_name" {
  description = "(Optional, IRSA) Kubernetes service account allowed to assume the role"
  type        = string
  default     = null
}

# ── Trust: AWS services and IAM principals ───────────────────────────────────

variable "service_principals" {
  description = "(Optional) AWS service principals allowed to assume the role, e.g. [\"ec2.amazonaws.com\"]"
  type        = list(string)
  default     = []
}

variable "principal_arns" {
  description = "(Optional) IAM role/user/account ARNs allowed to assume the role, e.g. for cross-account access"
  type        = list(string)
  default     = []
}

# ── Trust: fully custom ──────────────────────────────────────────────────────

variable "assume_role_policy" {
  description = "(Optional) Complete trust policy JSON. When set, it overrides all other trust inputs (e.g. for GitHub OIDC)"
  type        = string
  default     = null
}

# ── Permissions ──────────────────────────────────────────────────────────────

variable "policy_json" {
  description = "(Optional) IAM policy JSON, created as a managed policy and attached to the role"
  type        = string
  default     = null
}

variable "additional_policies" {
  description = "(Optional) Map of extra policy name => policy JSON, each created as a managed policy and attached"
  type        = map(string)
  default     = {}
}

variable "managed_policy_arns" {
  description = "(Optional) ARNs of existing managed policies (AWS or customer) to attach to the role"
  type        = list(string)
  default     = []
}

# ── Instance profile (for EC2 roles) ─────────────────────────────────────────

variable "create_instance_profile" {
  description = "(Optional) Set to true to create an instance profile with the same name as the role (EC2 use)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "(Optional) tags for IAM resources"
  type        = map(string)
  default     = {}
}
