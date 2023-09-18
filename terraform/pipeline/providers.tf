terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
# Using always latest version for this exercise
      version = "4.67.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
    backend "s3" {
    bucket = "exercise-st-bucket"
    key = "terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}
