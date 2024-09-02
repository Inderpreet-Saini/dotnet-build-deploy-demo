terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" 
      version = "5.60.0"
    }
  }
  
  backend "s3" {
    # bucket         = "terraform-backend-dotnet-demo" 
    # key            = "terraform/myfavouriteplaces.tf" 
    # region         = "ap-south-1" 
    # dynamodb_table = "terraform-lock-dotnet-demo" 
  } 
}

provider "aws" {
  region = "ap-south-1"
}

locals {
  common_tags = {
    purpose = "Dotnet application CI/CD Demo"
  }
}

# data "aws_ecr_repository" "ecr" {
#   name  = "${lower(var.ecr_namespace)}/${var.ecr_service_name}"
#   }