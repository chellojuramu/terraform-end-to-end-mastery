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
#count
resource "aws_s3_bucket" "my_bucket1" {
  #if you want to itreate the all those elements then we can use count and for each loop but here we are using only one element so we can use count and
  # for each loop both but here we are using count
  count = length(var.bucket_names)
  bucket = var.bucket_names[count.index]
  #we dont need one like 0 so use count.index and it will automatically take the value from the list and create the bucket
  #bucket = var.bucket_names_set
 #set doesnt have index so we can directly use the variable name and it will automatically take the value from the set and create the bucket
  acl    = "private"

  tags = {
    Name    = "MyBucket"
    Project = "Roboshop"
  }
}

resource "aws_s3_bucket" "my_bucker2" {
  for_each = var.bucket_names_set #for each loop is used to iterate the set and create the bucket for each element in the set

  bucket = each.value #each.value is used to get the value of the current element in the set and create the bucket
}