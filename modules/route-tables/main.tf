resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  tags = merge(var.tags, {
    Name = "${var.name}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_ids)

  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count = max(length(var.nat_gateway_ids), 1)

  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = length(var.nat_gateway_ids) > 0 ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = var.nat_gateway_ids[var.single_nat_gateway ? 0 : count.index]
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name}-private-rt-${count.index + 1}"
  })
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_ids)

  subnet_id = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private[
    var.single_nat_gateway || length(var.nat_gateway_ids) == 0 ? 0 : count.index
  ].id
}