terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    kops = {
      source = "eddycharly/kops"
      version = "1.23.5"
    }
  }

  required_version = ">= 1.2.2"

  backend "s3" {
    encrypt = true
    bucket  = "hobbii-terraform-statefiles"
    key     = "terraform.tfstate"
    region  = "eu-west-1"
  }
}

module "helm" {
  source = "../helm"
}
