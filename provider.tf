terraform {
    backend "s3" {
    bucket = "infra-statefile-primuslearning"
    key    = "terraform.tfvars"
    region = "REGION"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.0.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

provider "aws" {
  region = "REGION"
}

