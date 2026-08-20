variable "create_eks" {
  description = "(Optional) Defines if cluster should be created"
  type        = bool
  default     = true
}

variable "region" {
  description = "(Required) AWS region where to create EKS cluster"
  type        = string
}

variable "name_prefix" {
  description = "(Required) Name prefix used across all resources"
  type        = string
}

variable "cluster_name_suffix" {
  description = "(Optional) Suffix appended to the cluster name"
  type        = string
  default     = ""
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "kubernetes_version" {
  description = "(Required) Kubernetes <major>.<minor> version (e.g. 1.33)"
  type        = string
  default     = null
}

variable "enabled_log_types" {
  description = "(Optional) Control plane log types to enable. See https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html"
  type        = list(string)
  default     = []
}

variable "deletion_protection" {
  description = "(Optional) Whether to enable deletion protection for the cluster"
  type        = bool
  default     = false
}

variable "force_update_version" {
  description = "(Optional) Force version update by overriding upgrade-blocking readiness checks"
  type        = bool
  default     = null
}

variable "authentication_mode" {
  description = "(Optional) Authentication mode for the cluster. Valid values: CONFIG_MAP, API, API_AND_CONFIG_MAP"
  type        = string
  default     = "API_AND_CONFIG_MAP"
}

variable "bootstrap_cluster_creator_admin_permissions" {
  description = "(Optional) Whether to grant admin permissions to the cluster creator"
  type        = bool
  default     = false
}

# --- Encryption ---

variable "enable_encryption_config" {
  description = "(Optional) Whether to enable encryption config for secrets"
  type        = bool
  default     = false
}

variable "encryption_config" {
  description = "(Optional) Encryption config for the cluster. provider_key_arn is used when create_kms_key = false"
  type = object({
    provider_key_arn = optional(string)
    resources        = optional(list(string), ["secrets"])
  })
  default = {
    provider_key_arn = null
    resources        = ["secrets"]
  }
}

variable "create_kms_key" {
  description = "(Optional) Whether to create a KMS key for cluster secret encryption"
  type        = bool
  default     = false
}

# --- IAM (cluster role) ---

variable "create_iam_role" {
  description = "(Optional) Whether to create the IAM role for the EKS cluster"
  type        = bool
  default     = true
}

variable "iam_role_additional_policies" {
  description = "(Optional) Additional IAM policies to attach to the cluster role (map of name => ARN)"
  type        = map(string)
  default     = {}
}

variable "attach_encryption_policy" {
  description = "(Optional) Whether to attach an inline KMS encryption policy to the cluster role"
  type        = bool
  default     = false
}

variable "iam_role_path_encryption" {
  description = "(Optional) IAM path for the encryption policy"
  type        = string
  default     = "/"
}

variable "iam_role_path_cluster" {
  description = "(Optional) IAM path for the cluster role"
  type        = string
  default     = "/"
}

# --- Control plane scaling / compute / upgrade ---

variable "control_plane_scaling_config" {
  description = "(Optional) Control plane scaling config. Set tier to STANDARD or AUTO"
  type = object({
    tier = string
  })
  default = null
}

variable "compute_config" {
  description = "(Optional) EKS Auto Mode compute config"
  type = object({
    enabled       = optional(bool)
    node_pools    = optional(list(string))
    node_role_arn = optional(string)
  })
  default = null
}

variable "upgrade_policy" {
  description = "(Optional) Cluster upgrade policy. support_type: STANDARD or EXTENDED"
  type = object({
    support_type = string
  })
  default = null
}

variable "zonal_shift_config" {
  description = "(Optional) Zonal shift config for the cluster"
  type = object({
    enabled = bool
  })
  default = null
}

# --- Networking ---

variable "endpoint_private_access" {
  description = "(Optional) Whether to enable private access to the cluster API endpoint"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "(Optional) Whether to enable public access to the cluster API endpoint"
  type        = bool
  default     = true
}

variable "endpoint_public_access_cidrs" {
  description = "(Optional) CIDRs allowed to access the public API endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "control_plane_subnet_ids" {
  description = "(Optional) Subnet IDs for the control plane. Falls back to subnet_ids if empty"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "(Required) Subnet IDs for cluster nodes"
  type        = list(string)
  default     = []
}

variable "additional_security_group_ids" {
  description = "(Optional) Additional security group IDs to attach to the cluster"
  type        = list(string)
  default     = []
}

# --- Cluster security group ---

variable "create_security_group" {
  description = "(Optional) Whether to create a dedicated security group for the cluster"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "(Required) VPC ID where the cluster will be created"
  type        = string
  default     = null
}

variable "cluster_security_group_rules" {
  description = "(Optional) Security group rules for the cluster SG"
  type        = any
  default     = {}
}

variable "security_group_additional_rules" {
  description = "(Optional) Additional security group rules to add to the cluster SG"
  type        = any
  default     = {}
}

# --- Node security group ---

variable "create_node_sg" {
  description = "(Optional) Whether to create a dedicated security group for nodes"
  type        = bool
  default     = true
}

variable "node_security_group_id" {
  description = "(Optional) Existing security group ID for nodes. Used when create_node_sg = false"
  type        = string
  default     = null
}

variable "node_security_group_enable_recommended_rules" {
  description = "(Optional) Whether to add recommended ingress/egress rules to the node SG"
  type        = bool
  default     = true
}

variable "node_security_group_additional_rules" {
  description = "(Optional) Additional security group rules to add to the node SG"
  type        = any
  default     = {}
}

# --- Node IAM role ---

variable "create_node_iam_role" {
  description = "(Optional) Whether to create an IAM role for EKS nodes"
  type        = bool
  default     = true
}

variable "node_iam_role_path" {
  description = "(Optional) IAM path for the node role"
  type        = string
  default     = "/"
}

variable "node_iam_role_description" {
  description = "(Optional) Description for the node IAM role"
  type        = string
  default     = null
}

variable "node_iam_role_additional_policies" {
  description = "(Optional) Additional IAM policies to attach to the node role (map of name => ARN)"
  type        = map(string)
  default     = {}
}

# --- Self-managed node group ---

# --- Addons ---

variable "vpc_cni_version" {
  description = "(Optional) Version of the VPC CNI addon"
  type        = string
  default     = null
}

variable "kube_proxy_version" {
  description = "(Optional) Version of the kube-proxy addon"
  type        = string
  default     = null
}

variable "coredns_version" {
  description = "(Optional) Version of the CoreDNS addon"
  type        = string
  default     = null
}

variable "create_node_group" {
  description = "(Optional) Whether to create a self-managed node group (Launch Template + ASG)"
  type        = bool
  default     = true
}

variable "node_group_instance_type" {
  description = "(Optional) EC2 instance type for the system node group"
  type        = string
  default     = "t3.medium"
}

variable "node_group_min_size" {
  description = "(Optional) Minimum number of nodes in the system node group"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "(Optional) Maximum number of nodes in the system node group"
  type        = number
  default     = 3
}

variable "node_group_desired_capacity" {
  description = "(Optional) Desired number of nodes in the system node group"
  type        = number
  default     = 2
}

variable "node_group_disk_size_gb" {
  description = "(Optional) Root EBS disk size in GB for system nodes"
  type        = number
  default     = 20
}
