provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "chirag-ptel-bucket-for-tf-state"
    key            = "Serverless-WebApp-AWS/dynamodb/terraform.tfstate"
    dynamodb_table = "dynamodb-statelock-for-tfstate-bucket"
    region         = "ap-south-1"
  }

  required_version = ">=0.13.0"
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}