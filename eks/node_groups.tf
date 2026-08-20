locals {
  node_security_group_id = var.create_node_sg ? aws_security_group.node[0].id : var.node_security_group_id
}

data "aws_ssm_parameter" "eks_ami" {
  count = var.create_node_group ? 1 : 0
  name  = "/aws/service/eks/optimized-ami/${var.kubernetes_version}/amazon-linux-2023/x86_64/standard/recommended/image_id"
}

resource "aws_launch_template" "node" {
  count = var.create_node_group ? 1 : 0

  name_prefix = format("%s-lt-eks-node-", var.name_prefix)
  description = "Launch template for EKS system nodes in ${local.cluster_name}"

  image_id      = data.aws_ssm_parameter.eks_ami[0].value
  instance_type = var.node_group_instance_type

  vpc_security_group_ids = [local.node_security_group_id]

  iam_instance_profile {
    name = aws_iam_instance_profile.node[0].name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.node_group_disk_size_gb
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  user_data = base64encode(<<-EOF
    ---
    apiVersion: node.eks.aws/v1alpha1
    kind: NodeConfig
    spec:
      cluster:
        name: ${local.cluster_name}
        apiServerEndpoint: ${aws_eks_cluster.this[0].endpoint}
        certificateAuthority: ${aws_eks_cluster.this[0].certificate_authority[0].data}
        cidr: ${aws_eks_cluster.this[0].kubernetes_network_config[0].service_ipv4_cidr}
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
      "kubernetes.io/cluster/${local.cluster_name}" = "owned"
      Name                                          = format("%s-eks-node", var.name_prefix)
    })
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(var.tags, {
      "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    })
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_autoscaling_group" "node" {
  count = var.create_node_group ? 1 : 0

  name_prefix         = format("%s-asg-eks-node-", var.name_prefix)
  vpc_zone_identifier = var.subnet_ids

  min_size         = var.node_group_min_size
  max_size         = var.node_group_max_size
  desired_capacity = var.node_group_desired_capacity

  launch_template {
    id      = aws_launch_template.node[0].id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  dynamic "tag" {
    for_each = merge(var.tags, {
      "kubernetes.io/cluster/${local.cluster_name}"     = "owned"
      "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned"
      "k8s.io/cluster-autoscaler/enabled"               = "true"
      Name                                              = format("%s-eks-node", var.name_prefix)
    })
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}
