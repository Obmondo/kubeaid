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

}

provider "kops" {
  state_store = "s3://${var.kops_state_bucket_name}"
  aws {
    region = var.region
  }
}
