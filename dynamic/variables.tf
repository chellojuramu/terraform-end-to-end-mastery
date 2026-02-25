variable "ingress_rules" {
  type = list(object({
    port         = number
    cidr_blocks  = list(string)
    description  = string
  }))

  default = [
    {
      port        = 22
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow SSH"
    },
    {
      port        = 443
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS"
    },
    {
      port        = 3306
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow MySQL"
    }
  ]
}

variable "egress_rules" {
  type = list(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      port        = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}