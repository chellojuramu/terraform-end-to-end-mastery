variable "environment" {
  description = "Environment name (dev or prod)"
    type        = string
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "The vpc_cidr must be a valid CIDR block."
  }
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs (Multi-Az)"
  type        = list(string)
}
variable "private_subnet_cidrs" {
    description = "List of private subnet CIDRs (Multi-Az)"
    type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway  (recommended true for prod)"
    type        = bool
    default =  false
}

variable "common_tags" {
  description = "common tags to be applied to all resources"
  type        = map(string)
  default = {}
}