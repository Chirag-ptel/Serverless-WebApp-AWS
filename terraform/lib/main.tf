provider "aws" {
  region = var.region
}

data "aws_lambda_function" "backend_lambda" {
  function_name = var.func_name
}

output "lambda_arn" {
    value = data.aws_lambda_function.backend_lambda.arn
}

output "lambda_qualified_invoke_arn" {
    value = data.aws_lambda_function.backend_lambda.qualified_invoke_arn
}