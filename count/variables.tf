variable "instances" {
  type        = list(string)
  description = "List of Roboshop microservices to be deployed"
  default     = ["mongodb", "redis", "mysql", "rabbitmq", "catalogue", "user", "cart", "shipping", "payment", "frontend"]
}

variable "zone_id" {
  type        = string
  description = "The Hosted Zone ID from AWS Route53"
  default     = "Z0106832348EIO1PNV416"
}

variable "domain_name" {
  type        = string
  description = "The registered domain name for the project"
  default     = "servicewiz.in"
}

# Used to demonstrate the difference between ordered and unique collections
variable "fruits" {
  type    = list(string)
  default = ["apple", "banana", "apple", "orange"]
}

variable "fruits_set" {
  type    = set(string)
  default = ["apple", "banana", "apple", "orange"]
}