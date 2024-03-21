provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "chirag-ptel-bucket-for-tf-state"
    key            = "Serverless-WebApp-AWS/cognito/terraform.tfstate"
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

// Resources
resource "aws_cognito_user_pool" "user_pool" {
  name = "WIld-Rydes-user-pool"

  username_attributes = ["email"]
  auto_verified_attributes = ["email"]

  deletion_protection = "INACTIVE"

  password_policy {
    minimum_length = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
    temporary_password_validity_days = 10
  }

  account_recovery_setting {
    recovery_mechanism {
      name = "verified_email"
      priority = 1
  } 
     recovery_mechanism {
      name = "verified_phone_number"
      priority = 2
  }
  #   recovery_mechanism {
  #     name = "admin_only"
  #     priority = 2
  # }
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject = "Account Confirmation"
    email_message = "Greetings From WIld-Rydes !!! It shows that cognito setup is successfull. Your confirmation code is {####}"
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "cognito-client"

  user_pool_id = aws_cognito_user_pool.user_pool.id
  generate_secret = false
  refresh_token_validity = 90
  prevent_user_existence_errors = "ENABLED"
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
    # "ADMIN_NO_SRP_AUTH"
  ]
  
}