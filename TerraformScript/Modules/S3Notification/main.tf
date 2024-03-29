resource "aws_lambda_permission" "allow_s3_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}

resource "aws_s3_bucket_notification" "s3_bucket_notification" {
  bucket = var.s3_bucket_name
  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.s3_notification_prefix
    filter_suffix       = var.s3_notification_suffix
    id                  = "s3-object-upload-notification"
  }

  depends_on = [aws_lambda_permission.allow_s3_bucket]
}