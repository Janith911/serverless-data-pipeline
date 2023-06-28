data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "dynamodb_table" {
  source                  = "./Modules/DynamoDBTable"
  dynamodb_table_name     = var.dynamodb_table_name
  dynamodb_hash_key       = var.dynamodb_hash_key
  dynamodb_hash_key_type  = var.dynamodb_hash_key_type
  dynamodb_billing_mode   = var.dynamodb_billing_mode
  dynamodb_read_capacity  = var.dynamodb_read_capacity
  dynamodb_write_capacity = var.dynamodb_write_capacity
  tags                    = var.tags
}

module "source_s3_bucket" {
  source                    = "./Modules/S3"
  bucket_name               = var.source_bucket_name
  tags                      = var.tags
  s3_versioning             = var.source_s3_versioning
  lambda_execution_role_arn = module.lambda_execution_role.lambda_execution_role_arn
  depends_on                = [module.code_s3_bucket, module.dynamodb_table]

}

module "code_s3_bucket" {
  source                    = "./Modules/S3"
  bucket_name               = var.code_bucket_name
  tags                      = var.tags
  s3_versioning             = var.code_s3_versioning
  lambda_execution_role_arn = module.lambda_execution_role.lambda_execution_role_arn
  depends_on                = [module.dynamodb_table]

}

module "lambda_function_code" {
  source         = "./Modules/S3Object"
  dest_s3_bucket = var.code_bucket_name
  s3_object_key  = var.lambda_function_s3_key
  source_path    = var.source_path

  depends_on = [module.code_s3_bucket]
}

module "lambda_execution_role" {
  source               = "./Modules/ExecutionRole"
  lambda_iam_role      = var.lambda_iam_role
  lambda_inline_policy = var.lambda_inline_policy

  s3_bucket_arn = [
    "arn:aws:s3:::${var.source_bucket_name}",
    "arn:aws:s3:::${var.source_bucket_name}/*",
    "arn:aws:s3:::${var.code_bucket_name}",
    "arn:aws:s3:::${var.code_bucket_name}/*"
  ]

  dynamdb_table_arn = [module.dynamodb_table.dynamdb_table_arn]

  log_group_arn = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.lambda_function_name}:*"]

  log_stream_arn = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.lambda_function_name}:log-stream:*"]

  depends_on = [module.dynamodb_table]

}

module "s3_notification" {
  source                 = "./Modules/S3Notification"
  s3_bucket_name         = var.source_bucket_name
  lambda_function_arn    = module.lambda_function.lambda_function_arn
  s3_notification_prefix = var.s3_notification_prefix
  s3_notification_suffix = var.s3_notification_suffix
  s3_bucket_arn          = module.source_s3_bucket.s3_arn

  depends_on = [module.source_s3_bucket]

}

module "lambda_function" {
  source                    = "./Modules/LambdaFunction"
  lambda_function_name      = var.lambda_function_name
  lambda_runtime            = var.lambda_runtime
  lambda_function_s3_bucket = var.code_bucket_name
  lambda_function_s3_key    = var.lambda_function_s3_key
  BUCKET_NAME               = var.source_bucket_name
  REGION                    = var.REGION
  DYNAMODB_TABLE            = var.dynamodb_table_name
  lambda_iam_role_arn       = module.lambda_execution_role.lambda_execution_role_arn
  tags                      = var.tags

  depends_on = [module.code_s3_bucket, module.source_s3_bucket, module.lambda_function_code]

}