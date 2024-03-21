resource "aws_lambda_function" "backend_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/../../3_ServerlessBackend/3_ServerlessBackend.zip"
  package_type  = "Zip"
  function_name = "wild-ryde-backend-func"
  role          = aws_iam_role.role_for_lambda.arn
  handler       = "index.handler"
  architectures = ["x86_64"]
  memory_size   = 128
  timeout       = 10

#   source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs20.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name = "/aws/lambda/${aws_lambda_function.backend_lambda.function_name}"

  retention_in_days = 30
}