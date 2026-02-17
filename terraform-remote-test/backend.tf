terraform {
  backend "s3" {
    bucket = "ramu-devops-state-2026-unique" #your s3 vault name
    key = "test-project/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "ramu-state-lock-table" #your lock table name
    encrypt = true
  }
}