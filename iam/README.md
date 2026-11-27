# IAM

Terraform module for an IAM role with flexible trust and permissions. Supports:

- **IRSA**: a Kubernetes service account on EKS (set `oidc_provider_arn`, `oidc_provider_url`, `namespace`, `service_account_name`)
- **AWS services**: e.g. EC2, Lambda (`service_principals`)
- **IAM principals**: cross-account or other roles (`principal_arns`)
- **Custom**: a complete trust policy, e.g. for GitHub OIDC (`assume_role_policy`, which overrides the other trust inputs)

Permissions can come from one or more customer managed policies (`policy_json`, `additional_policies`) and existing managed policies (`managed_policy_arns`). Set `create_instance_profile` for EC2 roles.

Naming: role `<name_prefix>-iam-role-<role_name>`, default policy `<name_prefix>-iam-policy-<role_name>`, additional policies `<name_prefix>-iam-policy-<role_name>-<key>`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.38 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.38 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_policies"></a> [additional\_policies](#input\_additional\_policies) | (Optional) Map of extra policy name => policy JSON, each created as a managed policy and attached | `map(string)` | `{}` | no |
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | (Optional) Complete trust policy JSON. When set, it overrides all other trust inputs (e.g. for GitHub OIDC) | `string` | `null` | no |
| <a name="input_create_instance_profile"></a> [create\_instance\_profile](#input\_create\_instance\_profile) | (Optional) Set to true to create an instance profile with the same name as the role (EC2 use) | `bool` | `false` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | (Optional) Set to false to skip creating the IAM role and its policies | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) Description of the IAM role | `string` | `null` | no |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | (Optional) ARNs of existing managed policies (AWS or customer) to attach to the role | `list(string)` | `[]` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | (Optional) Maximum session duration in seconds (3600-43200) | `number` | `3600` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | (Required) Prefix for keeping naming convention | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (Optional, IRSA) Kubernetes namespace of the service account allowed to assume the role | `string` | `null` | no |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | (Optional, IRSA) ARN of the EKS cluster OIDC provider, used as the trusted principal | `string` | `null` | no |
| <a name="input_oidc_provider_url"></a> [oidc\_provider\_url](#input\_oidc\_provider\_url) | (Optional, IRSA) URL of the EKS cluster OIDC provider (with or without https://) | `string` | `null` | no |
| <a name="input_path"></a> [path](#input\_path) | (Optional) Path of the IAM role and policies | `string` | `"/"` | no |
| <a name="input_permissions_boundary_arn"></a> [permissions\_boundary\_arn](#input\_permissions\_boundary\_arn) | (Optional) ARN of the permissions boundary policy attached to the role | `string` | `null` | no |
| <a name="input_policy_json"></a> [policy\_json](#input\_policy\_json) | (Optional) IAM policy JSON, created as a managed policy and attached to the role | `string` | `null` | no |
| <a name="input_principal_arns"></a> [principal\_arns](#input\_principal\_arns) | (Optional) IAM role/user/account ARNs allowed to assume the role, e.g. for cross-account access | `list(string)` | `[]` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | (Required) Name suffix for the role, e.g. karpenter, aws-lb-controller or ec2-worker | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | (Optional, IRSA) Kubernetes service account allowed to assume the role | `string` | `null` | no |
| <a name="input_service_principals"></a> [service\_principals](#input\_service\_principals) | (Optional) AWS service principals allowed to assume the role, e.g. ["ec2.amazonaws.com"] | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) tags for IAM resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_profile_arn"></a> [instance\_profile\_arn](#output\_instance\_profile\_arn) | ARN of the instance profile, when create\_instance\_profile is true |
| <a name="output_instance_profile_name"></a> [instance\_profile\_name](#output\_instance\_profile\_name) | Name of the instance profile, when create\_instance\_profile is true |
| <a name="output_policy_arns"></a> [policy\_arns](#output\_policy\_arns) | Map of policy key (default or additional\_policies key) to ARN of the managed policies created by this module |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of the IAM role |
| <a name="output_role_id"></a> [role\_id](#output\_role\_id) | Unique ID of the IAM role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Name of the IAM role |
<!-- END_TF_DOCS -->
