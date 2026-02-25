terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" # The official AWS plugin
      version = "6.33.0"        # Fixed version to prevent breaking changes
    }
  }
}

provider "aws" {
  region = "us-east-1" # N. Virginia: The standard region for Roboshop
}