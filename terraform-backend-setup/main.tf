terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

# the vault for state file
resource "aws_s3_bucket" "state_bucket" {
  bucket = "ramu-devops-state-2026-unique" #change this to be unique across all AWS accounts
  lifecycle {
    prevent_destroy = false
  }

}
#versioning allows you to recover old state if you mess up the current state
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
# the "lock" to prevent two people from running terraform at once
resource "aws_dynamodb_table" "state_lock" {
  name = "ramu-state-lock-table"
  billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
