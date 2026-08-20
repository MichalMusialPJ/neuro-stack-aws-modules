data "aws_iam_policy_document" "node_assume_role_policy" {
  count = var.create_node_iam_role ? 1 : 0

  statement {
    sid = "EKSAutoNodeAssumeRole"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_auto" {
  count = var.create_node_iam_role ? 1 : 0

  name                  = format("%s-iam-role-eks-node", var.name_prefix)
  path                  = var.node_iam_role_path
  description           = var.node_iam_role_description
  assume_role_policy    = data.aws_iam_policy_document.node_assume_role_policy[0].json
  force_detach_policies = true

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_auto" {
  for_each = { for k, v in {
    AmazonEKSWorkerNodePolicy          = "${local.iam_role_policy_prefix}/AmazonEKSWorkerNodePolicy",
    AmazonEC2ContainerRegistryPullOnly = "${local.iam_role_policy_prefix}/AmazonEC2ContainerRegistryPullOnly",
    AmazonEKS_CNI_Policy               = "${local.iam_role_policy_prefix}/AmazonEKS_CNI_Policy",
  } : k => v if var.create_node_iam_role }

  policy_arn = each.value
  role       = aws_iam_role.eks_auto[0].name
}

resource "aws_iam_role_policy_attachment" "eks_auto_additional" {
  for_each = { for k, v in var.node_iam_role_additional_policies : k => v if var.create_node_iam_role }

  policy_arn = each.value
  role       = aws_iam_role.eks_auto[0].name
}

resource "aws_iam_instance_profile" "node" {
  count = var.create_node_iam_role ? 1 : 0

  name_prefix = format("%s-instance-profile-eks-node-", var.name_prefix)
  path        = var.node_iam_role_path
  role        = aws_iam_role.eks_auto[0].name

  tags = var.tags
}

resource "aws_eks_access_entry" "node" {
  count = var.create_node_iam_role && var.create_eks ? 1 : 0

  cluster_name  = aws_eks_cluster.this[0].name
  principal_arn = aws_iam_role.eks_auto[0].arn
  type          = "EC2_LINUX"

  tags = var.tags
}
