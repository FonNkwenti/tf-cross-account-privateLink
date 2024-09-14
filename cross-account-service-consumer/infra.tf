#######################################################
##  Cross Account Service Consumer Infrastructure 
#######################################################

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = local.vpc_name
  }
}


resource "aws_subnet" "pri_sn1_az1" {
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, 0)
  availability_zone       = local.az1
  tags = {
    Name = "pri-sn1-az1"
  }
    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "pri_rt1_az1" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name    = "pri-rt1-az1"
  }
}

resource "aws_route_table_association" "pri_rta1_az2" {
  subnet_id      = aws_subnet.pri_sn1_az1.id
  route_table_id = aws_route_table.pri_rt1_az1.id
}



resource "aws_vpc_endpoint" "ssm_ep" {
  for_each = local.ssm_services
  vpc_id   = aws_vpc.this.id
  ip_address_type     = "ipv4"
  vpc_endpoint_type   = "Interface"

  service_name        = each.value.name
  security_group_ids  = [aws_security_group.ssm.id]
  private_dns_enabled = true
  subnet_ids          = [aws_subnet.pri_sn1_az1.id]
}



resource "aws_security_group" "ssm" {
  name        = "allow-ssm"
  description = "Allow traffic to SSM endpoint"
  vpc_id      = aws_vpc.this.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.pri_sn1_az1.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group" "ssm_client" {
  name        = "ssm-client"
  description = "allow traffic from SSM Session maanger"
  vpc_id      = aws_vpc.this.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = [aws_subnet.pri_sn1_az1.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    lifecycle {
    create_before_destroy = true
  }

}

# resource "aws_vpc_endpoint" "privateLink_service" {
#   vpc_endpoint_type   = "Interface"
#   private_dns_enabled = false
#   vpc_id              = aws_vpc.this.id
#   service_name        = var.privateLink_service_name
#   security_group_ids  = [aws_security_group.privateLink_service.id]
#   subnet_ids          = [aws_subnet.pri_sn1_az1.id]

#   tags = {
#     Name = "privateLink-service"
#   }
# }

resource "aws_security_group" "privateLink_service" {
  name        = "privateLink-service"
  description = "Security group for privateLink Interface Endpoint"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}