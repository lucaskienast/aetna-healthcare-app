# Terraform block
terraform {
  required_version = "~> 1.3.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.36.1"
    }
  }
  cloud {
    organization = "hcta-demo-3094"

    workspaces {
      name = "terraform-aws-devops-caltech"
    }
  }
}

# Provider block
provider "aws" {
  region = var.aws_region
}
