resource "aws_s3_bucket" "terraform_storage" {
  bucket = "terraform-storage"

  tags = {
    Name = "terraform-storage"
  }
  lifecycle {
    prevent_destroy = true # to be remove after
  }
}

