# This is the list of services for our Roboshop project
variable "instances" {
  type    = list(string)
  default = ["mongodb", "redis", "mysql", "rabbitmq", "catalogue", "user", "cart", "shipping", "payment", "frontend"]
}

variable "zone_id" {
  default = "Z0106832348EIO1PNV416"
}

variable "domain_name" {
  default = "servicewiz.in"
}