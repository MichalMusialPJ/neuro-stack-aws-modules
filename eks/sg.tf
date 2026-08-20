resource "aws_security_group" "cluster" {
  count = var.create_security_group ? 1 : 0

  name        = format("%s-security-group-eks-cluster", var.name_prefix)
  description = "Cluster security group for ${local.cluster_name}"
  vpc_id      = var.vpc_id

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "cluster_from_nodes" {
  count = var.create_security_group && var.create_node_sg ? 1 : 0

  security_group_id        = aws_security_group.cluster[0].id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.node[0].id
  description              = "Allow nodes to reach cluster API server"
}

resource "aws_security_group_rule" "cluster" {
  for_each = { for k, v in merge(
    var.cluster_security_group_rules,
    var.security_group_additional_rules
  ) : k => v if var.create_security_group }

  security_group_id        = aws_security_group.cluster[0].id
  protocol                 = each.value.protocol
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  type                     = each.value.type
  description              = try(each.value.description, null)
  cidr_blocks              = try(each.value.cidr_blocks, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, null)
  self                     = try(each.value.self, null)
  source_security_group_id = try(each.value.source_node_security_group, false) ? local.node_security_group_id : try(each.value.source_security_group_id, null)
}
