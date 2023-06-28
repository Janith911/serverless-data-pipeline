resource "aws_dynamodb_table" "dynamodb_table" {
  name     = var.dynamodb_table_name
  hash_key = var.dynamodb_hash_key
  attribute {
    name = var.dynamodb_hash_key
    type = var.dynamodb_hash_key_type
  }
  billing_mode   = var.dynamodb_billing_mode
  read_capacity  = var.dynamodb_read_capacity
  write_capacity = var.dynamodb_write_capacity
  tags           = var.tags
}