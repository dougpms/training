terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
# Using always latest version for this exercise
#      version = "~> 5.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
#  backend "s3" {
#    bucket = "exercise-st-bucket"
#    key = "terraform.tfstate"
#    region = "eu-west-1"
#  }
}
