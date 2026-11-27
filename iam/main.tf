locals {
  tags     = merge(var.tags, { ManagedBy = "terraform" })
  role     = format("%s-iam-role-%s", var.name_prefix, var.role_name)
  oidc_url = try(replace(var.oidc_provider_url, "https://", ""), null)

  irsa_enabled = var.oidc_provider_arn != null && var.oidc_provider_url != null && var.namespace != null && var.service_account_name != null

  # Trust statements built from the structured inputs. Empty when none are set.
  trust_statements = concat(
    local.irsa_enabled ? [{
      Sid       = "IRSAAssumeRole"
      Effect    = "Allow"
      Principal = { Federated = var.oidc_provider_arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${local.oidc_url}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          "${local.oidc_url}:aud" = "sts.amazonaws.com"
        }
      }
    }] : [],
    length(var.service_principals) > 0 ? [{
      Sid       = "ServiceAssumeRole"
      Effect    = "Allow"
      Principal = { Service = var.service_principals }
      Action    = "sts:AssumeRole"
    }] : [],
    length(var.principal_arns) > 0 ? [{
      Sid       = "PrincipalAssumeRole"
      Effect    = "Allow"
      Principal = { AWS = var.principal_arns }
      Action    = "sts:AssumeRole"
    }] : [],
  )

  assume_role_policy = var.assume_role_policy != null ? var.assume_role_policy : jsonencode({
    Version   = "2012-10-17"
    Statement = local.trust_statements
  })

  # Customer managed policies to create: "default" (policy_json) plus additional_policies.
  policies = merge(
    var.policy_json != null ? { default = var.policy_json } : {},
    var.additional_policies,
  )
}

resource "aws_iam_role" "this" {
  count = var.create_role ? 1 : 0

  name                 = local.role
  description          = var.description
  path                 = var.path
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary_arn
  assume_role_policy   = local.assume_role_policy

  tags = local.tags

  lifecycle {
    precondition {
      condition     = var.assume_role_policy != null || length(local.trust_statements) > 0
      error_message = "Set a trust: IRSA inputs (oidc_provider_arn, oidc_provider_url, namespace, service_account_name), service_principals, principal_arns, or assume_role_policy."
    }
  }
}

resource "aws_iam_policy" "this" {
  for_each = var.create_role ? toset(keys(local.policies)) : toset([])

  name        = each.key == "default" ? format("%s-iam-policy-%s", var.name_prefix, var.role_name) : format("%s-iam-policy-%s-%s", var.name_prefix, var.role_name, each.key)
  description = "Policy for role ${local.role}"
  path        = var.path
  policy      = local.policies[each.key]

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.create_role ? toset(keys(local.policies)) : toset([])

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[each.key].arn
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = var.create_role ? toset(var.managed_policy_arns) : toset([])

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_role && var.create_instance_profile ? 1 : 0

  name = local.role
  path = var.path
  role = aws_iam_role.this[0].name

  tags = local.tags
}
