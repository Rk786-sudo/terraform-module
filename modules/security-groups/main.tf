resource "aws_security_group" "cluster" {
  name_prefix = "${var.name}-control-plane-"
  description = "Additional EKS control-plane security group; API ingress is restricted to workers and trusted CIDRs."
  vpc_id      = var.vpc_id
  egress      = []

  tags = merge(var.tags, {
    Name = "${var.name}-control-plane-sg"
  })
}

resource "aws_security_group" "workers" {
  name_prefix = "${var.name}-workers-"
  description = "Managed worker node security group for Kubernetes and intra-node traffic."
  vpc_id      = var.vpc_id
  egress      = []

  tags = merge(var.tags, {
    Name = "${var.name}-workers-sg"
  })
}

resource "aws_security_group" "admin" {
  name_prefix = "${var.name}-admin-"
  description = "Optional source security group for explicitly enabled managed-node SSH access."
  vpc_id      = var.vpc_id
  egress      = []

  tags = merge(var.tags, {
    Name = "${var.name}-admin-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "cluster_from_workers" {
  security_group_id            = aws_security_group.cluster.id
  referenced_security_group_id  = aws_security_group.workers.id
  description                   = "Allow worker nodes to reach the Kubernetes API over HTTPS."
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
}

resource "aws_vpc_security_group_ingress_rule" "cluster_from_trusted_cidrs" {
  for_each = { for cidr in toset(concat(var.eks_public_access_cidrs, var.eks_admin_access_cidrs)) : cidr => cidr }

  security_group_id = aws_security_group.cluster.id
  cidr_ipv4         = each.value
  description       = "Allow HTTPS from a configured trusted EKS API client CIDR."
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "workers_from_cluster_control_plane" {
  for_each = {
    "https"         = { from = 443, to = 443, description = "Control-plane HTTPS callbacks to nodes." }
    "kubelet"       = { from = 10250, to = 10250, description = "Control-plane access to the kubelet." }
    "ephemeral"     = { from = 1025, to = 65535, description = "Control-plane to node ephemeral and webhook ports." }
  }

  security_group_id            = aws_security_group.workers.id
  referenced_security_group_id = aws_security_group.cluster.id
  description                  = each.value.description
  ip_protocol                  = "tcp"
  from_port                    = each.value.from
  to_port                      = each.value.to
}

resource "aws_vpc_security_group_ingress_rule" "workers_self" {
  security_group_id            = aws_security_group.workers.id
  referenced_security_group_id = aws_security_group.workers.id
  description                  = "Allow worker-to-worker pod and node traffic within the node security group."
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "admin_ssh_from_trusted_cidrs" {
  for_each = var.ssh_enabled ? { for cidr in var.ssh_trusted_cidrs : cidr => cidr } : {}

  security_group_id = aws_security_group.admin.id
  cidr_ipv4         = each.value
  description       = "Optional SSH source restricted to a configured trusted CIDR."
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "cluster_all" {
  security_group_id = aws_security_group.cluster.id
  description       = "Allow control-plane ENIs to reach worker and AWS service endpoints as required by EKS."
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "workers_all" {
  security_group_id = aws_security_group.workers.id
  description       = "Allow nodes to reach in-VPC services and required AWS endpoints through private routes."
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "admin_all" {
  security_group_id = aws_security_group.admin.id
  description       = "Allow return traffic for optional administrator SSH sessions."
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}