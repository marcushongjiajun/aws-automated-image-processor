# Global settings

terraform {
  # Run code on HCP Terraform
  cloud {
    organization = "mh-terraform-learn"
    workspaces {
      project = "Automated Image Processor"
      name    = "automated-image-processor"
    }
  }
  required_providers {
    aws = {
      # version constraints, to avoid major version upgrades during normal operations
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }
  # Terraform version
  required_version = "~> 1.2"
}

# Provider
provider "aws" {
  region = "ap-southeast-1"
}