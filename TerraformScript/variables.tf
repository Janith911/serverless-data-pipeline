### Source S3 Bucket ###
variable "source_bucket_name" {
  default = "data-pipeline-demo-s3-bucket-source-csv"
}

variable "tags" {
  default = {
    "Project" : "Data-Pipeline-Demo"
  }
}

variable "source_s3_versioning" {
  default = "Disabled"
}

### Lambda Function ###
variable "lambda_function_name" {
  default = "data-pipeline-demo-lambda-function"
}

variable "lambda_runtime" {
  default = "python3.8"
}

variable "lambda_function_s3_key" {
  default = "lambda_function.zip"
}

variable "REGION" {
  default = "us-east-1"
}

variable "lambda_iam_role" {
  default = "data-pipeline-demo-lambda-function-execution-role"
}

variable "lambda_inline_policy" {
  default = "data-pipeline-demo-lambda-function-execution-role-inline-policy"
}

### Source S3 Bucket ###
variable "code_bucket_name" {
  default = "data-pipeline-demo-lambda-function-code"
}

variable "code_s3_versioning" {
  default = "Disabled"
}

### S3 Bucket Notification ###

variable "s3_notification_prefix" {
  default = "csv_files/"
}

variable "s3_notification_suffix" {
  default = ".csv"
}


### Lambda Function Code

variable "source_path" {
  default = "./lambda_function.zip"
}

### DynamoDB Table Name

variable "dynamodb_table_name" {
  default = "sample_ec2_instance_data"
}

variable "dynamodb_hash_key" {
  default = "ID"
}

variable "dynamodb_hash_key_type" {
  default = "N"
}

variable "dynamodb_billing_mode" {
  default = "PROVISIONED"
}

variable "dynamodb_read_capacity" {
  default = 5
}

variable "dynamodb_write_capacity" {
  default = 5
}