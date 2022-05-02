terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "devops-case-study-s3"
    key    = "pclinic/api-deploy.tfstate"
    region = "us-east-1"
  }
}