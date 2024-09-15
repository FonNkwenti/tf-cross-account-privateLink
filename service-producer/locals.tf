data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners     = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


locals {
  dir_name       = "${basename(path.cwd)}"
  name           = "${var.project_name}-${var.environment}"
  azs            = slice(data.aws_availability_zones.available.names, 0, 2)
  az1            = data.aws_availability_zones.available.names[0]
  az2            = data.aws_availability_zones.available.names[1]
  ami            = data.aws_ami.amazon_linux_2.id
  instance_name  = "${local.name}-saas"
  vpc_name       = "${local.name}-vpc"
  common_tags = {
        Environment = var.environment
        Project     = var.project_name
        ManagedBy   = "terraform"
        Service     = var.service_name
        CostCenter  = var.cost_center
      }

}
