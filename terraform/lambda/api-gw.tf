data "aws_caller_identity" "current" {}

data "aws_cognito_user_pools" "user_pool" {
  name = "WIld-Rydes-user-pool"
}

resource "aws_api_gateway_rest_api" "lambda_backend_api" {
  name = "${var.name}-api-gw"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "api_gw_resource" {
  rest_api_id = aws_api_gateway_rest_api.lambda_backend_api.id
  parent_id   = aws_api_gateway_rest_api.lambda_backend_api.root_resource_id
  path_part   = var.endpoint_path
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.lambda_backend_api.id
  resource_id   = aws_api_gateway_resource.api_gw_resource.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_authorizer" "cognito_auth" {
  name                             = "${var.name}-cupool-auth"
  type                             = "COGNITO_USER_POOLS"
  rest_api_id                      = aws_api_gateway_rest_api.lambda_backend_api.id
  provider_arns                    = data.aws_cognito_user_pools.user_pool.arns
  authorizer_result_ttl_in_seconds = 300
}

resource "aws_api_gateway_integration" "lambda_api_gw_integration" {
  rest_api_id             = aws_api_gateway_rest_api.lambda_backend_api.id
  resource_id             = aws_api_gateway_resource.api_gw_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  connection_type         = "INTERNET"
  uri                     = aws_lambda_function.backend_lambda.invoke_arn
}

resource "aws_lambda_permission" "lambda_invoke_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.backend_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.lambda_backend_api.id}/*/${aws_api_gateway_method.post_method.http_method}${aws_api_gateway_resource.api_gw_resource.path}"
  # source_arn    = "${aws_api_gateway_rest_api.lambda_backend_api.execution_arn}/*" 
}

resource "aws_api_gateway_deployment" "test_deplyment" {
  rest_api_id = aws_api_gateway_rest_api.lambda_backend_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.lambda_backend_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_api_gateway_method.post_method, aws_api_gateway_integration.lambda_api_gw_integration]
}

resource "aws_api_gateway_stage" "test_stage" {
  deployment_id = aws_api_gateway_deployment.test_deplyment.id
  rest_api_id   = aws_api_gateway_rest_api.lambda_backend_api.id
  stage_name    = "test"
}

output "execute_url" {
  value = aws_api_gateway_rest_api.lambda_backend_api.execution_arn
  }