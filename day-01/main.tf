terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.32.0" #provider version if we dont specify it will take the latest version which may cause issues in future when there are breaking changes in provider
      #u have terraform version and provider version both in terraform block but they are different, provider version is for the provider and terraform version is for the terraform itself, they are independent of each other
      #aws provider version is maintained by aws so there are high chances of breaking changes in future when there are new features added or old features removed, so its always good to specify the provider version to avoid any issues in future when there are breaking changes in provider
      #that is why we have to lock the version and the version for whcih u have developed and tested your tf configurations in non prod environment, so that when u run the same tf configurations in prod environment it will work without any issues, if u dont specify the provider version and there are breaking changes in provider then u may face issues in prod environment when u run the same tf configurations which were working fine in non prod environment, so its always good to specify the provider version to avoid any issues in future when there are breaking changes in provider
    # version = "~> 6.32.0" #this will allow any version from 6.32.0 to 6.33.0 but not 6.34.0, this is also a good practice to specify the provider version with a range to allow for minor updates and bug fixes without breaking changes, but it may cause issues if there are breaking changes in minor updates, so its always good to specify the provider version with a range to allow for minor updates and bug fixes without breaking changes, but it may cause issues if there are breaking changes in minor updates, so its always good to specify the provider version with a range to allow for minor updates and bug fixes without breaking changes, but it may cause issues if there are breaking changes in minor updates, so its always good to specify the provider version with a range to allow for minor updates and bug fixes without breaking changes, but it may cause issues if there are breaking changes in minor updates, so its always good to specify the provider version with a range to allow for minor updates and bug fixes without breaking changes, but it may cause issues if there are breaking changes in minor updates, so its always good to specify the provider version with a range to allow for minor updates and bug fixes without breaking changes, but it may cause issues if there are breaking changes in minor updates, so its always good to specify the provider version with a range to allow for minor updates and bug fixes without breaking changes, but it may cause issues if there are breaking changes in minor updates, so its always good to specify the provider version with a range to allow for minor updates and bug fixes without breaking changes, but it may cause issues if there are breaking changes in minor updates, so its always good to specify the provider version with a range to allow for minor updates and bug fixes without breaking changes, but it may cause issues if there are breaking changes in minor updates, so its always good to specify the provider version with a range to allow for minor updates and bug fixes without breaking changes, but it may cause issues if there are breaking changes in minor updates, so its always good to specify the provider version with a range to allow for minor updates and bug fixes without breaking changes, but it may cause issues if there are breaking changes in minor updates, so its always good to specify the provider version with a range to allow for minor updates and bug fixes without breaking changes, but it may cause issues if there are breaking changes in minor updates, so
      # = exact version, ~> minor version, >= minimum version, <= maximum version
    }
    random = {
      source  = "hashicorp/random" #other provider generate random values for different user cases
      version = "3.7.2"
    }
  }
  required_version = ">= 1.0" # Specify the required Terraform version
}
provider "aws" {
  region = "us-east-1" #simple hardcoded region for demo
}
resource "aws_s3_bucket" "ramu-day01" {
  bucket = "ramu-devops-project-2026-xyz"

  tags = {
    Name        = "ramu bucket"
    Environment = "Dev"
  }
}