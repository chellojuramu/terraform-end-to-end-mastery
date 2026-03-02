# 🚀 Terraform AWS VPC Module - Multi-AZ 3-Tier Architecture

This project provisions a production-ready AWS VPC architecture using a reusable Terraform module.

It demonstrates:

- Terraform Module Structure
- Multi-AZ 3-Tier Networking
- NAT Gateway with Elastic IP
- Route Tables and Associations
- Optional VPC Peering with Default VPC
- Centralized Tagging Strategy
- Dynamic Resource Creation using `count`

---

# 📁 Project Structure
project-root/
│
├── terraform-aws-vpc/ # Reusable VPC module
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│
└── vpc-module-test/ # Root module (calls VPC module)
├── provider.tf
├── variables.tf
├── outputs.tf
├── vpc.tf

---

# 🧠 Architecture Overview

This project creates a standard AWS 3-tier networking architecture:

Internet
↓
Internet Gateway
↓
Public Subnets (Load Balancer / NAT)
↓
Private Subnets (App / EKS Nodes)
↓
Database Subnets (RDS)

Optional:
Custom VPC <——> Default VPC (via VPC Peering)

---

# 🔹 Module Usage

Inside `vpc.tf`:

```hcl
module "vpc" {
  source = "../terraform-aws-vpc"

  project             = var.project
  environment         = var.environment
  is_peering_required = true
}
```
Explanation

source → Path to reusable VPC module

project → Used for tagging and naming

environment → dev / qa / prod

is_peering_required → Controls VPC peering creation