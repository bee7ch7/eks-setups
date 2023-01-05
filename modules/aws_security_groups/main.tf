resource "aws_security_group" "this" {

  count = var.create ? 1 : 0

  name   = "${var.name}-${var.environment}"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ports_in
    content {
      protocol         = ingress.value.protocol
      from_port        = ingress.value.from_port
      to_port          = length(ingress.value.to_port) > 0 ? ingress.value.to_port : ingress.value.from_port
      cidr_blocks      = length(ingress.value.cidr_blocks) == 0 && length(ingress.value.security_groups) == 0 ? ["0.0.0.0/0"] : ingress.value.cidr_blocks
      ipv6_cidr_blocks = length(ingress.value.ipv6_cidr_blocks) == 0 && length(ingress.value.security_groups) == 0 ? null : ingress.value.cidr_blocks
      security_groups  = length(ingress.value.security_groups) == 0 ? [] : ingress.value.security_groups
    }
  }

  dynamic "egress" {
    for_each = length(var.ports_out.cidr_blocks) == 0 ? ["0"] : var.ports_out.cidr_blocks
    content {
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = length(var.ports_out.cidr_blocks) == 0 ? ["0.0.0.0/0"] : var.ports_out.cidr_blocks
      ipv6_cidr_blocks = length(var.ports_out.ipv6_cidr_blocks) == 0 ? ["::/0"] : var.ports_out.cidr_blocks

    }
  }

  tags = {
    Name = "${var.name}-${var.environment}"
  }
}
