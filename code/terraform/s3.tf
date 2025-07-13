resource "aws_s3_bucket" "terraform_storage" {
  bucket = local.terraform_storage_bucket_name

  tags = {
    Name = "tf-anaoum-lab-terraform-storage"
  }

  lifecycle {
    prevent_destroy = true # to be remove after
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_storage" {
  bucket = aws_s3_bucket.terraform_storage.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
        
      sse_algorithm = "AES256"
    }
  }
}
