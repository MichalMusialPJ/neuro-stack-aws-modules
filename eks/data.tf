data "aws_caller_identity" "current" {
  count = var.create_eks ? 1 : 0
}

data "aws_partition" "current" {
  count = var.create_eks ? 1 : 0
}
