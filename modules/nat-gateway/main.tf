resource "aws_eip" "this" {
  count = var.enabled ? (var.single_nat_gateway ? 1 : length(var.public_subnet_ids)) : 0

  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name}-nat-eip-${count.index + 1}"
  })
}

resource "aws_nat_gateway" "this" {
  count = var.enabled ? (var.single_nat_gateway ? 1 : length(var.public_subnet_ids)) : 0

  allocation_id = aws_eip.this[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]

  tags = merge(var.tags, {
    Name = "${var.name}-nat-${count.index + 1}"
  })
}