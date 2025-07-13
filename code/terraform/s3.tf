resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_storage" {
  bucket = local.terraform_storage_bucket_name

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"
    }
  }
}
