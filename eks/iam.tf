locals {
  partition              = try(data.aws_partition.current[0].partition, "")
  iam_role_policy_prefix = "arn:${local.partition}:iam::aws:policy"
  eks_standard_iam_role_policies = { for k, v in {
    AmazonEKSClusterPolicy = "${local.iam_role_policy_prefix}/AmazonEKSClusterPolicy",
  } : k => v }
  cluster_name = format("%s-eks-cluster-%s", var.name_prefix, var.cluster_name_suffix)
}

data "aws_iam_policy_document" "assume_role_policy" {
  count = var.create_iam_role ? 1 : 0

  statement {
    sid     = "EKSClusterAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.create_iam_role ? 1 : 0

  name        = format("%s-iam-role-eks", var.name_prefix)
  path        = var.iam_role_path_cluster
  description = "IAM role for EKS cluster ${local.cluster_name}"


  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy[0].json
  force_detach_policies = true

  tags = var.tags
}

resource "aws_iam_policy" "cluster_encryption" {
  count = var.create_iam_role && var.attach_encryption_policy ? 1 : 0

  name        = format("%s-iam-policy-encryption", var.name_prefix)
  path        = var.iam_role_path_encryption
  description = "Encryption Policy for EKS cluster ${local.cluster_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ListGrants",
          "kms:DescribeKey",
        ]
        Effect   = "Allow"
        Resource = module.kms[0].key_arn
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = { for k, v in merge(
    local.eks_standard_iam_role_policies,
  ) : k => v if var.create_iam_role }

  policy_arn = each.value
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = { for k, v in var.iam_role_additional_policies : k => v if var.create_iam_role }

  policy_arn = each.value
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_role_policy_attachment" "cluster_encryption" {
  count = var.create_iam_role && var.attach_encryption_policy ? 1 : 0

  policy_arn = aws_iam_policy.cluster_encryption[0].arn
  role       = aws_iam_role.this[0].name
}
