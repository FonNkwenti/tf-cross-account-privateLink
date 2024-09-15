
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        # version = "5.14.0"
    }
  }
}

provider "aws" {
    alias = "service_provider"
    region = "eu-west-1"
    shared_credentials_files = ["~/.aws/credentials"]
    profile = "default"
    default_tags {
      tags = {
        Environment = var.environment
        Project     = var.project_name
        ManagedBy   = "terraform"
        Service     = var.service_name
        CostCenter  = var.cost_center
      }
    }
}