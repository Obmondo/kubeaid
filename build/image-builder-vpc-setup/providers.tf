terraform {
  required_version = ">= 1.4.6"

  backend "local" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.66.1"
    }
  }
}

provider "aws" {
  access_key = var.args.credentials.access_key
  secret_key = var.args.credentials.secret_key

  region = var.args.region

  default_tags {
    tags = {
      project = "kubeaid-demo"
    }
  }
}
