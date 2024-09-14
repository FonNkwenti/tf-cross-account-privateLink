
#####################################################
## Public NLB
#####################################################


# resource "aws_lb" "nlb" {
#   name               = "service-provider-nlb"
#   internal           = false
#   load_balancer_type = "network"
#   subnets            = module.service_provider_vpc.public_subnets

#   enable_deletion_protection = false
#   enable_cross_zone_load_balancing = true 

#   provider = aws.service_provider
# }


# resource "aws_lb_target_group" "nlb_tg" {
#   name        = "nlb-tg"
#   port        = 80
#   protocol    = "TCP"
#   vpc_id      = module.service_provider_vpc.vpc_id
#   target_type = "instance"

#   health_check {
#     path                = "/"
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 5
#     interval            = 10
#     port                = 80
#     protocol            = "HTTP"
#   }
# }

# resource "aws_lb_listener" "nlb_listener" {
#   load_balancer_arn = aws_lb.nlb.arn
#   port              = 80
#   protocol          = "TCP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.nlb_tg.arn
#   }
# }

# resource "aws_lb_target_group_attachment" "nlb_tg_attachment" {
#   target_group_arn = aws_lb_target_group.nlb_tg.arn
#   target_id        = aws_instance.public.id
#   port             = 80
# }

# resource "aws_vpc_endpoint_service" "this" {
#     acceptance_required = false 
#     network_load_balancer_arns = [aws_lb.nlb.arn]
#     allowed_principals = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
#     tags = {
#         Environment = "dev"
#     }
# }



#######################################################
##  EC2
#######################################################

# resource "aws_instance" "public" {
#   ami                    = data.aws_ami.amazon_linux_2.id
#   instance_type          = "t2.micro"
#   subnet_id              = element(module.service_provider_vpc.public_subnets, 0)
#   associate_public_ip_address = true
#   key_name = "default-eu1"
#   vpc_security_group_ids = [aws_security_group.www_sg.id]
#   user_data_replace_on_change = true
#   user_data_base64 = filebase64("${path.module}/webserver.sh")

#   tags = {
#     Name = "public_instance"
#   }
# }
