# eks

Terraform module for an EKS cluster with managed node groups, IAM/IRSA, OIDC, addons, KMS secret encryption, and security groups.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.38 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.46.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_iam_policy.cluster_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_security_group_ids"></a> [additional\_security\_group\_ids](#input\_additional\_security\_group\_ids) | n/a | `any` | n/a | yes |
| <a name="input_attach_encryption_policy"></a> [attach\_encryption\_policy](#input\_attach\_encryption\_policy) | n/a | `any` | n/a | yes |
| <a name="input_authentication_mode"></a> [authentication\_mode](#input\_authentication\_mode) | (Optional) The authentication mode for the cluster. Valid values are `CONFIG_MAP`, `API` or `API_AND_CONFIG_MAP` | `string` | `"API_AND_CONFIG_MAP"` | no |
| <a name="input_bootstrap_cluster_creator_admin_permissions"></a> [bootstrap\_cluster\_creator\_admin\_permissions](#input\_bootstrap\_cluster\_creator\_admin\_permissions) | (Optional) Specify if u want to add admin permissions to cluster creator - it's critical operation | `bool` | `false` | no |
| <a name="input_cluster_name_suffix"></a> [cluster\_name\_suffix](#input\_cluster\_name\_suffix) | (Required) Name to be used on all the resources as identifier | `string` | `""` | no |
| <a name="input_compute_config"></a> [compute\_config](#input\_compute\_config) | n/a | `any` | n/a | yes |
| <a name="input_control_plane_scaling_config"></a> [control\_plane\_scaling\_config](#input\_control\_plane\_scaling\_config) | n/a | `any` | n/a | yes |
| <a name="input_control_plane_subnet_ids"></a> [control\_plane\_subnet\_ids](#input\_control\_plane\_subnet\_ids) | n/a | `any` | n/a | yes |
| <a name="input_create_eks"></a> [create\_eks](#input\_create\_eks) | (Optional) Defines if cluster should be created | `bool` | `true` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | n/a | `any` | n/a | yes |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | n/a | `any` | n/a | yes |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | n/a | `any` | n/a | yes |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | (Required) Whether to enable deletion protection for the cluster. When enabled, the cluster cannot be deleted unless deletion protection is first disabled | `bool` | `null` | no |
| <a name="input_enable_encryption_config"></a> [enable\_encryption\_config](#input\_enable\_encryption\_config) | n/a | `any` | n/a | yes |
| <a name="input_enabled_log_types"></a> [enabled\_log\_types](#input\_enabled\_log\_types) | (Optional) A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html) | `list(string)` | <pre>[<br/>  ""<br/>]</pre> | no |
| <a name="input_encryption_config"></a> [encryption\_config](#input\_encryption\_config) | n/a | `any` | n/a | yes |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | n/a | `any` | n/a | yes |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | n/a | `any` | n/a | yes |
| <a name="input_endpoint_public_access_cidrs"></a> [endpoint\_public\_access\_cidrs](#input\_endpoint\_public\_access\_cidrs) | n/a | `any` | n/a | yes |
| <a name="input_force_update_version"></a> [force\_update\_version](#input\_force\_update\_version) | (Optional) Force version update by overriding upgrade-blocking readiness checks when updating a cluster | `bool` | `null` | no |
| <a name="input_iam_role_additional_policies"></a> [iam\_role\_additional\_policies](#input\_iam\_role\_additional\_policies) | n/a | `any` | n/a | yes |
| <a name="input_iam_role_path_cluster"></a> [iam\_role\_path\_cluster](#input\_iam\_role\_path\_cluster) | n/a | `string` | `"/"` | no |
| <a name="input_iam_role_path_encryption"></a> [iam\_role\_path\_encryption](#input\_iam\_role\_path\_encryption) | n/a | `string` | `"/"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | (Required) Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.33`) | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | (Required) passed name prefix for my project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | (Required) aws region where to create eks cluster | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_upgrade_policy"></a> [upgrade\_policy](#input\_upgrade\_policy) | n/a | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `any` | n/a | yes |
| <a name="input_zonal_shift_config"></a> [zonal\_shift\_config](#input\_zonal\_shift\_config) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
