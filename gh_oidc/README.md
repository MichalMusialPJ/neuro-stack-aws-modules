# GitHub Actions OIDC

Terraform module for GitHub Actions OIDC provider and IAM role.

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
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.terraform_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_subjects"></a> [allowed\_subjects](#input\_allowed\_subjects) | (Optional) GitHub OIDC subject suffixes allowed to assume the role, e.g. ref:refs/heads/main, pull\_request, environment:production | `list(string)` | <pre>[<br/>  "ref:refs/heads/main"<br/>]</pre> | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | (Required) AWS account ID for arn | `string` | n/a | yes |
| <a name="input_create_provider"></a> [create\_provider](#input\_create\_provider) | Toggle if you want to create provider | `bool` | `true` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Toggle if you want to create role for provider | `bool` | `true` | no |
| <a name="input_create_terraform_policy"></a> [create\_terraform\_policy](#input\_create\_terraform\_policy) | Toggle if you wanbt to create role for provider | `bool` | `true` | no |
| <a name="input_github_org"></a> [github\_org](#input\_github\_org) | (Required) Github organisation name for trust policy | `string` | n/a | yes |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | (Required) Github repository name for trust policy | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | (Required) Prefix for keeping naming convention | `string` | n/a | yes |
| <a name="input_policy_arns"></a> [policy\_arns](#input\_policy\_arns) | (Optional) Additional policy arn for github oidc role | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) tags for backend resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_actions_role_name"></a> [github\_actions\_role\_name](#output\_github\_actions\_role\_name) | Name of github oidc role |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | ARN of oidc provider |
| <a name="output_oidc_provider_url"></a> [oidc\_provider\_url](#output\_oidc\_provider\_url) | URL of oidc provider |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN of github oidc role |
<!-- END_TF_DOCS -->
