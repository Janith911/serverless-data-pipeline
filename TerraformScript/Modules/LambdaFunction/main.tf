resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_function_name
  role          = var.lambda_iam_role_arn
  architectures = ["arm64"]
  runtime       = var.lambda_runtime
  s3_bucket     = var.lambda_function_s3_bucket
  s3_key        = var.lambda_function_s3_key
  timeout       = 300
  handler       = "lambda_function.lambda_handler"
  tags          = var.tags
  environment {
    variables = {
      "BUCKET_NAME" = var.BUCKET_NAME
      "REGION"      = var.REGION
      "TABLE"       = var.DYNAMODB_TABLE
    }
  }
}