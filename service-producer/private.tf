
#####################################################
## PrivateLink Setup
#####################################################


#######################################################
##  EC2 SAAS
#######################################################


# resource "aws_instance" "private" {
#   ami                    = data.aws_ami.amazon_linux_2.id
#   instance_type          = "t2.micro"
#   subnet_id              = element(module.service_provider_vpc.private_subnets, 0)
#   associate_public_ip_address = false
#   key_name = "default-eu1"
#   vpc_security_group_ids = [aws_security_group.www_sg.id]
#    user_data_replace_on_change = true
#   user_data_base64 = filebase64("${path.module}/webserver.sh")

#   tags = {
#     Name = "private_instance"
#   }
# }

resource "aws_lb" "private_nlb" {
  name               = "private-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = module.service_provider_vpc.private_subnets

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true 

  # provider = aws.service_provider
}

resource "aws_lb_target_group" "private_nlb_tg" {
  name        = "private-nlb-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = module.service_provider_vpc.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    port                = 80
    protocol            = "HTTP"
  }
}

resource "aws_lb_listener" "private_nlb_listener" {
  load_balancer_arn = aws_lb.private_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_nlb_tg.arn
  }
}
# resource "aws_lb_target_group_attachment" "private_nlb_tg_attachment" {
#   target_group_arn = aws_lb_target_group.private_nlb_tg.arn
#   target_id        = aws_instance.private.id
#   port             = 80
# }

resource "aws_vpc_endpoint_service" "this" {
    acceptance_required = false 
    network_load_balancer_arns = [aws_lb.private_nlb.arn]
    # allowed_principals = ["arn:aws:iam::${var.account_id}:root"]
    allowed_principals = ["arn:aws:iam::${var.account_id}:root", "arn:aws:iam::${var.cross_account_id}:root"]
    tags = {
        Environment = "dev"
    }
}

resource "aws_launch_template" "saas_product" {
  name_prefix   = "saas_product"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  user_data = filebase64("${path.module}/webserver.sh")
  network_interfaces {
    associate_public_ip_address = false 
    subnet_id = element(module.service_provider_vpc.private_subnets, 0)
    security_groups             = [aws_security_group.www_sg.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "sass-instance" 
    }
  }

  lifecycle {
    create_before_destroy = true
  }

}
resource "aws_autoscaling_group" "saas_product" {
  # availability_zones = local.azs
  desired_capacity   = 2
  max_size           = 3
  min_size           = 2
  vpc_zone_identifier = module.service_provider_vpc.private_subnets
  launch_template {
    id      = aws_launch_template.saas_product.id
    version = "$Latest"
  }
  # target_group_arns = aws_lb_target_group.private_nlb_tg.arn
}

## create autoscaling attachment to the NLB
resource "aws_autoscaling_attachment" "private_nlb" {
  autoscaling_group_name = aws_autoscaling_group.saas_product.id
  lb_target_group_arn   = aws_lb_target_group.private_nlb_tg.arn
}

