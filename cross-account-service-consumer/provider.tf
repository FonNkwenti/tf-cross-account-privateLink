terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        # version = "5.14.0"
    }
  }
}

provider "aws" {
  region                   = var.region
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "aai-admin"
  default_tags {
    tags = {
      use_case = "tutorial"
    }
  }

}