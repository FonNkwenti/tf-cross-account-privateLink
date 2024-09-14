# output "public_instance_public_ip" {
#     value = aws_instance.public.public_ip
# }
output "private_nlb_dns" {
    value = aws_lb.private_nlb.dns_name
}

output "privateLink_service_name" {
    value = aws_vpc_endpoint_service.this.service_name
}
