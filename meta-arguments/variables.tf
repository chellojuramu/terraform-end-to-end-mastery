variable "bucket_names" {
  description = "List of S3 bucket names to create"
  type        = list(string)
  default     = ["my-unique-bucket-name-metaargs-12345", "my-unique-bucket-name-metaargs-67890"]
}

variable "bucket_names_set" {
  description = "List of S3 bucket names to create"
  type        = set(string)
  default     = ["my-unique-bucket-name-metaargs-123450", "my-unique-bucket-name-metaargs-678901"]
}