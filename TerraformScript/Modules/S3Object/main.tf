resource "aws_s3_object" "s3_bucket_object" {
  bucket = var.dest_s3_bucket
  key    = var.s3_object_key
  source = var.source_path
}