output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.backend_lambda.function_name
}

output "function_arn" {
  value = aws_lambda_function.backend_lambda.arn
}

output "qualified_invoke_arn" {
  value = aws_lambda_function.backend_lambda.qualified_invoke_arn
}
