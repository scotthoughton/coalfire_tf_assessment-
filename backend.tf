terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "swh-practice"

    workspaces {
      name = "main"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.72"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
  }
}