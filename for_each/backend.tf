terraform {
  backend "s3" {
    bucket = "terraform-state-file-s3-23022026" #your s3 vault name
    key    = "dev/terraform.tfstate" #path to the state file in the vault
    region = "us-east-1"
    use_lockfile = true
    encrypt = true
  }
}