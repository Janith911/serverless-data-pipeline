

resource "aws_iam_role" "lambda_iam_role" {
  name = var.lambda_iam_role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name   = var.lambda_inline_policy
    policy = data.aws_iam_policy_document.lambda_execution_inline_policy.json
  }
}


data "aws_iam_policy_document" "lambda_execution_inline_policy" {
  statement {
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3-object-lambda:Get*",
      "s3-object-lambda:List*"
    ]

    resources = var.s3_bucket_arn
  }

  statement {
    actions = [
      "dynamodb:BatchWriteItem"
    ]

    resources = var.dynamdb_table_arn
  }

  statement {
    actions = [
      "logs:CreateLogGroup"
    ]

    resources = var.log_group_arn
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = var.log_stream_arn
  }

}