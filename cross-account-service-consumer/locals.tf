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
  azs            = slice(data.aws_availability_zones.available.names, 0, 1)
  az1            = data.aws_availability_zones.available.names[0]
  az2            = data.aws_availability_zones.available.names[1]
  ami            = data.aws_ami.amazon_linux_2.id
  instance_name  = "${local.name}-instance"
  vpc_name       = "${local.name}-vpc"

}

//////////////////////////
locals {
  ssm_services = {
    "ec2messages" : {
      "name" : "com.amazonaws.${var.region}.ec2messages"
    },
    "ssm" : {
      "name" : "com.amazonaws.${var.region}.ssm"
    },
    "ssmmessages" : {
      "name" : "com.amazonaws.${var.region}.ssmmessages"
    }
  }
}