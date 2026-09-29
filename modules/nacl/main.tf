locals {
  # NACLs are stateless: allow ephemeral return traffic as well as request traffic.
  public_ingress_rules = var.public_ingress_rules == null ? [
    { rule_number = 100, protocol = "6", rule_action = "allow", from_port = 80, to_port = 80, cidr_block = "0.0.0.0/0" },
    { rule_number = 110, protocol = "6", rule_action = "allow", from_port = 443, to_port = 443, cidr_block = "0.0.0.0/0" },
    { rule_number = 120, protocol = "6", rule_action = "allow", from_port = 1024, to_port = 65535, cidr_block = "0.0.0.0/0" },
  ] : var.public_ingress_rules
  public_egress_rules = var.public_egress_rules == null ? [
    { rule_number = 100, protocol = "-1", rule_action = "allow", from_port = 0, to_port = 0, cidr_block = "0.0.0.0/0" },
  ] : var.public_egress_rules
  private_ingress_rules = var.private_ingress_rules == null ? [
    { rule_number = 100, protocol = "-1", rule_action = "allow", from_port = 0, to_port = 0, cidr_block = var.vpc_cidr },
    { rule_number = 110, protocol = "6", rule_action = "allow", from_port = 1024, to_port = 65535, cidr_block = "0.0.0.0/0" },
  ] : var.private_ingress_rules
  private_egress_rules = var.private_egress_rules == null ? [
    { rule_number = 100, protocol = "-1", rule_action = "allow", from_port = 0, to_port = 0, cidr_block = var.vpc_cidr },
    { rule_number = 110, protocol = "-1", rule_action = "allow", from_port = 0, to_port = 0, cidr_block = "0.0.0.0/0" },
  ] : var.private_egress_rules
}

resource "aws_network_acl" "public" {
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-public-nacl"
  })
}

resource "aws_network_acl_rule" "public_ingress" {
  for_each = { for rule in local.public_ingress_rules : tostring(rule.rule_number) => rule }

  network_acl_id = aws_network_acl.public.id
  rule_number    = each.value.rule_number
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  egress         = false
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_network_acl_rule" "public_egress" {
  for_each = { for rule in local.public_egress_rules : tostring(rule.rule_number) => rule }

  network_acl_id = aws_network_acl.public.id
  rule_number    = each.value.rule_number
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  egress         = true
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_network_acl" "private" {
  vpc_id = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-private-nacl"
  })
}

resource "aws_network_acl_rule" "private_ingress" {
  for_each = { for rule in local.private_ingress_rules : tostring(rule.rule_number) => rule }

  network_acl_id = aws_network_acl.private.id
  rule_number    = each.value.rule_number
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  egress         = false
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_network_acl_rule" "private_egress" {
  for_each = { for rule in local.private_egress_rules : tostring(rule.rule_number) => rule }

  network_acl_id = aws_network_acl.private.id
  rule_number    = each.value.rule_number
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  egress         = true
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_network_acl_association" "public" {
  count = length(var.public_subnet_ids)

  network_acl_id = aws_network_acl.public.id
  subnet_id      = var.public_subnet_ids[count.index]
}

resource "aws_network_acl_association" "private" {
  count = length(var.private_subnet_ids)

  network_acl_id = aws_network_acl.private.id
  subnet_id      = var.private_subnet_ids[count.index]
}