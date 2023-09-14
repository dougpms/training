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
}
