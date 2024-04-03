data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role_for_lambda" {
  name               = "role_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy_attachment" {
  role       = aws_iam_role.role_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "lambda_ddb_policy" {
  name        = "ddb-lambda-policy"
  path        = "/"
  description = "DynamoDB access policy for lambda"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "dynamodb:PutItem",
            "Resource": "arn:aws:dynamodb:ap-south-1:*"
        }
    ]
  })
}


# resource "aws_iam_policy" "lambda_userpool_policy" {
#   name        = "userpool-lambda-policy"
#   path        = "/"
#   description = "userpool list access policy for lambda"

#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#        {
#             "Sid": "VisualEditor0",
#             "Effect": "Allow",
#             "Action": "cognito-idp:ListUsers",
#             "Resource": "arn:aws:cognito-idp:ap-south-1:*"
#        }
#     ]
#   })
# }

resource "aws_iam_role_policy_attachment" "lambda_ddb_policy_attachment" {
  role       = aws_iam_role.role_for_lambda.name
  policy_arn = aws_iam_policy.lambda_ddb_policy.arn
}

# resource "aws_iam_role_policy_attachment" "lambda_userpool_policy_attachment" {
#   role       = aws_iam_role.role_for_lambda.name
#   policy_arn = aws_iam_policy.lambda_userpool_policy.arn
# }