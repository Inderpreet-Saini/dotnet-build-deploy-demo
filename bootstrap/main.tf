terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" 
      version = "5.60.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.2.0"
    }
  }
  
  backend "s3" {
    bucket         = "terraform-demos-bootstrap" 
    key            = "my-favourite-places.tfstate" 
    region         = "ap-south-1" 
    dynamodb_table = "terraform-lock-bootstrap" 
  } 
}

provider "aws" {
  region = "ap-south-1"
}

provider "github" {
  owner = "Inderpreet-Saini"
  app_auth {
    
  }
}


locals {
  common_tags = {
    purpose = "Bootstrap resources needed for .NET Demos"
  }
}