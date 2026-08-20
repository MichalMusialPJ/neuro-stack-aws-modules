resource "aws_eks_addon" "vpc_cni" {
  count = var.create_eks ? 1 : 0

  cluster_name  = aws_eks_cluster.this[0].name
  addon_name    = "vpc-cni"
  addon_version = var.vpc_cni_version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = var.tags
}

resource "aws_eks_addon" "kube_proxy" {
  count = var.create_eks ? 1 : 0

  cluster_name  = aws_eks_cluster.this[0].name
  addon_name    = "kube-proxy"
  addon_version = var.kube_proxy_version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = var.tags
}

resource "aws_eks_addon" "coredns" {
  count = var.create_eks ? 1 : 0

  cluster_name  = aws_eks_cluster.this[0].name
  addon_name    = "coredns"
  addon_version = var.coredns_version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = var.tags

  depends_on = [aws_eks_addon.vpc_cni]
}
