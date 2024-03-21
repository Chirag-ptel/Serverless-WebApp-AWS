provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "chirag-ptel-bucket-for-tf-state"
    key            = "Serverless-WebApp-AWS/amplify/terraform.tfstate"
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

resource "aws_amplify_app" "amplify_app" {
  name       = "Wild-rydes-frontend"
  repository = "https://github.com/Chirag-ptel/Serverless-WebApp-AWS"

  # The default build_spec added by the Amplify Console for React.
  build_spec = <<-EOT
  version: 1
  applications:
    - frontend:
        phases:
          build:
            commands: []
        artifacts:
          baseDirectory: /
          files:
            - '**/*'
        cache:
          paths: []
      appRoot: 1_StaticWebHosting/website
    # version: 0.1
    # frontend:
    #   phases:
    #     preBuild:
    #       commands:
    #         - cd 1_StaticWebHosting/website
    #         - yarn install
    #     build:
    #       commands:
    #         - yarn run build
    #   artifacts:
    #     baseDirectory: build
    #     files:
    #       - '**/*'
    #   cache:
    #     paths:
    #       - node_modules/**/*
  EOT

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  # environment_variables = {
  #   ENV = "test"
  # }

 # GitHub personal access token
  access_token = var.access_token

  enable_auto_branch_creation = true

  # The default patterns added by the Amplify Console.
  auto_branch_creation_patterns = [
    "*",
    "*/**",
  ]

  auto_branch_creation_config {
  # Enable auto build for the created branch.
  enable_auto_build = true
  }


}


# resource "aws_amplify_branch" "master" {
#   app_id      = aws_amplify_app.Wild_rydes_app.id
#   branch_name = "master"

#   # framework = "React"
#   stage     = "PRODUCTION"

#   # environment_variables = {
#   #   REACT_APP_API_SERVER = "https://api.example.com"
#   # }
# }

# resource "aws_amplify_webhook" "master" {
#   app_id      = aws_amplify_app.Wild_rydes_app.id
#   branch_name = aws_amplify_branch.master.branch_name
#   description = "triggermaster"
# }

# resource "aws_amplify_app" "amplify_app" {
#   name       = var.app_name
#   repository = var.repository
#   # oauth_token = var.token  
#   access_token = var.token  
# }
resource "aws_amplify_branch" "amplify_branch" {
  app_id      = aws_amplify_app.amplify_app.id
  branch_name = var.branch_name
}
# resource "aws_amplify_domain_association" "domain_association" {
#   app_id      = aws_amplify_app.amplify_app.id
#   domain_name = var.domain_name
#   wait_for_verification = false

#   sub_domain {
#     branch_name = aws_amplify_branch.amplify_branch.branch_name
#     prefix      = var.branch_name
#   }

# }
