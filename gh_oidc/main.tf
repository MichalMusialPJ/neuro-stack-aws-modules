locals {
  tags = merge(var.tags, { ManagedBy = "terraform" })
}

resource "aws_iam_openid_connect_provider" "this" {
  count = var.create_provider ? 1 : 0

  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["cf23df2207d99a74fbe169e3eba035e633b65d94"]

  tags = var.tags
}

resource "aws_iam_role" "this" {
  count = var.create_role && var.create_provider ? 1 : 0

  name = "${var.name_prefix}-gha-oidc-role"

  # The trust policy that allows GitHub Actions to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            # This condition restricts the role to your specific GitHub repository
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  # Attach the managed policies that you pass in as a variable
  managed_policy_arns = var.create_terraform_policy ? [aws_iam_policy.terraform_policy[0].arn] : var.policy_arns

  tags = var.tags
}

resource "aws_iam_policy" "terraform_policy" {
  count       = var.create_terraform_policy ? 1 : 0
  name        = "TerraformPolicy"
  description = "Terraform permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowAllServices"
        Effect = "Allow"
        Action = [
          "iam:*",
          "s3:*",
          "dynamodb:*",
          "kms:*",
          "eks:*",
          "ec2:*",
          "autoscaling:*",
          "logs:*",
          "cloudtrail:*"
        ]
        Resource = "*"
      },
      {
        Sid    = "IAMDeny"
        Effect = "Deny"
        Action = [
          "iam:CreateUser",
          "iam:CreateAccessKey",
          "iam:UpdateAccountPasswordPolicy",
          "iam:DeactivateMFADevice",
          "iam:DeleteUser",
          "iam:DeletePermissionsBoundary",
          "iam:DeleteRolePermissionsBoundary"
        ]
        Resource = "*"
      }
    ]
  })
}
