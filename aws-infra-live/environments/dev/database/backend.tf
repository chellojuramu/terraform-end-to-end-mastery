terraform {
  backend "s3" {
    bucket = "terraform-state-file-s3-23022026"
    key = "dev/database/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
    encrypt = true
  }
}