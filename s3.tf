resource "aws_s3_bucket" "bucket" {
  bucket = "my-bucket"
  acl    = "private"

  lifecycle_rule {
    id      = "Images"
    enabled = true
    prefix  = "Images/"

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "Logs"
    prefix  = "Logs/"
    enabled = true
    expiration {
      days = 90
    }
  }
}