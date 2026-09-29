resource "aws_launch_template" "workers" {
  name_prefix            = "${var.cluster_name}-${var.node_group_name}-"
  description            = "Launch template attaching the project-managed worker security group to EKS nodes."
  vpc_security_group_ids = var.ssh_enabled ? [var.node_security_group_id, var.admin_security_group_id] : [var.node_security_group_id]
  key_name               = var.ssh_enabled ? var.ssh_key_pair_name : null

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
      Name = "${var.cluster_name}-${var.node_group_name}-worker"
    })
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(var.tags, {
      Name = "${var.cluster_name}-${var.node_group_name}-worker-volume"
    })
  }
}

resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  ami_type       = var.ami_type
  disk_size      = var.disk_size
  instance_types = [var.instance_type]

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  update_config {
    max_unavailable_percentage = 33
  }

  launch_template {
    id      = aws_launch_template.workers.id
    version = aws_launch_template.workers.latest_version
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-${var.node_group_name}"
  })

  lifecycle {
    precondition {
      condition     = var.min_size <= var.desired_size && var.desired_size <= var.max_size
      error_message = "Node group sizes must satisfy min_size <= desired_size <= max_size."
    }
  }
}