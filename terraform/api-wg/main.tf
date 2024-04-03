module "lambda_data_source" {
  source = "../lib/"
  func_name = ""
  # name = var.name
}

resource "aws_apigatewayv2_api" "lambda_api_gw" {
  name          = "serverless_lambda_gw"
  protocol_type = "REST"
}

resource "aws_apigatewayv2_stage" "test" {
  api_id = aws_apigatewayv2_api.lambda_api_gw.id

  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.lambda_api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "lambda_gw_intigration" {
  api_id = aws_apigatewayv2_api.lambda_api_gw.id

  integration_uri    = aws_lambda_function.backend_lambda.qualified_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "hello_world" {
  api_id = aws_apigatewayv2_api.lambda_api_gw.id

  route_key = "POST /ride"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_gw_intigration.id}"
}

resource "aws_cloudwatch_log_group" "lambda_api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda_api_gw.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  # function_name = aws_lambda_function.hello_world.function_name
  function_name = module.lambda_data_source.func_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda_api_gw.execution_arn}/*/*"
}
