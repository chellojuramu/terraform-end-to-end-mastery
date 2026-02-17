resource "aws_s3_bucket" "example" {
  bucket = "ramu-test-remote-state-check"  #msut be unique across all AWS accounts
}