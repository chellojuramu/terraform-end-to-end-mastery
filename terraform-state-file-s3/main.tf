resource "aws_s3_bucket" "test_backend" {
  bucket = "test-remote-backend-${random_string.bucket_suffix.result}"
  tags = {
    Name        = "test-remote-backend"
    Environment = "dev"
  }
}
resource "aws_vpc" "sample" {
  cidr_block = "10.0.1.0/24"
  tags = {
    Environment = "Dev"
    Name        = "Dev-VPC"
  }
}

resource "random_string" "bucket_suffix" {
  length = 8
  special = false
  upper = false
}