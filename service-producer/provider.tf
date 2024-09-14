
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
}
provider "aws" {
    alias = "service_consumer"
    region = "eu-west-1"
    shared_credentials_files = ["~/.aws/credentials"]
    profile = "default"
}