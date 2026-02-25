# 🏗️ AWS 3-Tier Infrastructure with Terraform

[![Terraform](https://img.shields.io/badge/Terraform-v1.0+-623CE4?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=flat&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Infrastructure](https://img.shields.io/badge/IaC-Modular-blue)](https://github.com/yourusername/aws-infra-live)

> **Production-style modular AWS infrastructure implementing a secure, scalable 3-tier architecture with Terraform**

A real-world Infrastructure as Code project demonstrating AWS best practices, modular design patterns, and enterprise-grade architecture principles.

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Features](#-features)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Layer-by-Layer Deployment](#%EF%B8%8F-layer-by-layer-deployment)
- [Remote State Management](#-remote-state-management)
- [Security](#-security)
- [Debugging Journey](#-debugging-journey)
- [Future Enhancements](#-future-enhancements)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Overview

This project implements a **production-ready 3-tier architecture** on AWS using Terraform with:

- ✅ **Modular Design** - Reusable infrastructure components
- ✅ **Environment Separation** - Dev/Staging/Prod isolation
- ✅ **Remote State** - S3 backend with built-in locking
- ✅ **Security First** - Private database, SG isolation, least privilege
- ✅ **High Availability** - Multi-AZ subnet design
- ✅ **Scalability** - Ready for production enhancements

### 🎓 What You'll Learn

- AWS VPC networking and routing
- Terraform module architecture
- Remote state management patterns
- Security group design
- Infrastructure debugging techniques
- Production-ready cloud infrastructure

---

## 🏛️ Architecture

### High-Level Diagram

```
┌──────────────────────────────────────────────────────────────┐
│                         Internet                             │
└────────────────────────┬─────────────────────────────────────┘
                         │
                    ┌────▼────┐
                    │   IGW   │
                    └────┬────┘
                         │
        ┌────────────────┴────────────────┐
        │                                  │
   ┌────▼──────────┐              ┌──────▼────────┐
   │ Public Subnet │              │ Public Subnet │
   │ 10.10.1.0/24  │              │ 10.10.2.0/24  │
   │               │              │               │
   │  ┌─────────┐  │              │  ┌─────────┐  │
   │  │ App EC2 │  │              │  │   NAT   │  │
   │  │  :80    │  │              │  │ Gateway │  │
   │  └────┬────┘  │              │  └────┬────┘  │
   └───────┼───────┘              └───────┼───────┘
           │ :3306                        │
           │ (App SG → DB SG)             │
   ┌───────▼───────┐              ┌───────▼───────┐
   │Private Subnet │              │Private Subnet │
   │ 10.10.11.0/24 │              │ 10.10.12.0/24 │
   │               │              │               │
   │  ┌─────────┐  │              │               │
   │  │  DB EC2 │  │              │  (Reserved)   │
   │  │ MariaDB │  │              │               │
   │  └─────────┘  │              │               │
   └───────────────┘              └───────────────┘
        us-east-1a                     us-east-1b
```

### 🧩 Component Architecture

| Layer | Purpose | Resources |
|-------|---------|-----------|
| **Network** | VPC foundation | VPC, Subnets, IGW, NAT, Route Tables |
| **Security** | Access control | Security Groups with SG-to-SG rules |
| **Database** | Data tier | MariaDB on EC2 (Private Subnet) |
| **Compute** | Application tier | Apache + PHP on EC2 (Public Subnet) |

---

## ✨ Features

### 🌐 Network Layer
- **Custom VPC** with CIDR `10.10.0.0/16`
- **2 Public Subnets** across multiple AZs
- **2 Private Subnets** for database isolation
- **Internet Gateway** for public subnet internet access
- **NAT Gateway** for private subnet outbound traffic
- **Route Tables** with proper associations

### 🔐 Security Layer
- **App Security Group**
  - Inbound: HTTP (80) from `0.0.0.0/0`
  - Inbound: SSH (22) from specific IP only
  - Outbound: All traffic allowed
  
- **DB Security Group**
  - Inbound: MySQL (3306) **ONLY from App SG** (SG-to-SG reference)
  - Outbound: All traffic allowed
  - ❌ NO public access

### 🗄️ Database Layer
- **MariaDB 10.5** on Amazon Linux 2023
- Deployed in **private subnet**
- **No public IP** assigned
- Accessible only from application tier
- Dedicated database user with limited privileges
- Automated database provisioning via user-data

### 💻 Compute Layer
- **Apache + PHP** web server
- `mysqli` extension for database connectivity
- **Dynamic DB connection** using Terraform remote state
- Public IP for internet access
- Automated deployment via user-data script

### 📦 Infrastructure as Code
- **Modular Terraform** architecture
- **S3 backend** for state storage with built-in locking
- **Remote state** data sources for layer communication
- **Environment separation** (dev/staging/prod ready)

---

## 📁 Project Structure

```
aws-infra-live/
│
├── modules/                           # Reusable infrastructure modules
│   ├── network/
│   │   ├── main.tf                   # VPC, subnets, IGW, NAT, routes
│   │   ├── variables.tf              # Input variables
│   │   ├── outputs.tf                # Exported values
│   │   └── versions.tf               # Provider requirements
│   │
│   ├── security/
│   │   ├── main.tf                   # Security groups
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   │
│   ├── database/
│   │   ├── main.tf                   # DB EC2 instance
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   │
│   └── compute/
│       ├── main.tf                   # App EC2 instance
│       ├── user-data.sh              # Bootstrap script
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
│
└── environments/                      # Environment-specific configurations
    └── dev/
        ├── network/
        │   ├── main.tf               # Module instantiation
        │   ├── backend.tf            # S3 backend config
        │   ├── outputs.tf            # Re-exported outputs
        │   └── terraform.tfvars      # Environment values
        │
        ├── security/
        │   ├── main.tf
        │   ├── backend.tf
        │   ├── outputs.tf
        │   └── terraform.tfvars
        │
        ├── database/
        │   ├── main.tf
        │   ├── backend.tf
        │   ├── outputs.tf
        │   └── terraform.tfvars
        │
        └── compute/
            ├── main.tf
            ├── backend.tf
            ├── outputs.tf
            └── terraform.tfvars
```

---

## 🔧 Prerequisites

### Required Tools

```bash
# Terraform
terraform >= 1.0

# AWS CLI
aws-cli >= 2.0

# AWS Account with appropriate permissions
```

### AWS Resources to Create First

1. **S3 Bucket** for Terraform state
   ```bash
   aws s3 mb s3://terraform-state-file-s3-YOUR-UNIQUE-ID
   ```

2. **EC2 Key Pair** for SSH access
   ```bash
   aws ec2 create-key-pair --key-name your-key-name \
     --query 'KeyMaterial' --output text > your-key-name.pem
   chmod 400 your-key-name.pem
   ```

---

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/aws-infra-live.git
cd aws-infra-live
```

### 2. Configure AWS Credentials

```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter your default region (e.g., us-east-1)
```

### 3. Update Backend Configuration

Edit `environments/dev/*/backend.tf` with your S3 bucket name:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"  # Change this
    key            = "dev/network/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true  # S3-native locking (no DynamoDB needed)
  }
}
```

### 4. Deploy Infrastructure

```bash
# Deploy in order (respects dependencies)
cd environments/dev

# 1. Network layer
cd network
terraform init
terraform plan
terraform apply -auto-approve

# 2. Security layer
cd ../security
terraform init
terraform plan
terraform apply -auto-approve

# 3. Database layer
cd ../database
terraform init
terraform plan
terraform apply -auto-approve

# 4. Compute layer
cd ../compute
terraform init
terraform plan
terraform apply -auto-approve
```

### 5. Get Application URL

```bash
cd environments/dev/compute
terraform output app_public_ip

# Visit: http://<APP_PUBLIC_IP>
```

---

## 🏗️ Layer-by-Layer Deployment

### 1️⃣ Network Layer

**Purpose**: Create VPC foundation with public and private subnets

```bash
cd environments/dev/network
terraform init
terraform apply
```

**Resources Created**:
- VPC (10.10.0.0/16)
- 2 Public Subnets (10.10.1.0/24, 10.10.2.0/24)
- 2 Private Subnets (10.10.11.0/24, 10.10.12.0/24)
- Internet Gateway
- NAT Gateway with Elastic IP
- Public and Private Route Tables
- Route Table Associations

**Outputs**:
- `vpc_id`
- `public_subnet_ids`
- `private_subnet_ids`

---

### 2️⃣ Security Layer

**Purpose**: Create security groups with proper isolation

```bash
cd environments/dev/security
terraform init
terraform apply
```

**Dependencies**: Network layer outputs via remote state

**Resources Created**:
- App Security Group (allow HTTP, SSH)
- DB Security Group (allow MySQL from App SG only)

**Outputs**:
- `app_sg_id`
- `db_sg_id`

---

### 3️⃣ Database Layer

**Purpose**: Deploy MariaDB in private subnet

```bash
cd environments/dev/database
terraform init
terraform apply
```

**Dependencies**: Network + Security layer outputs

**Resources Created**:
- EC2 instance in private subnet
- MariaDB 10.5 installation
- Database and user provisioning

**Outputs**:
- `db_private_ip`

---

### 4️⃣ Compute Layer

**Purpose**: Deploy application server in public subnet

```bash
cd environments/dev/compute
terraform init
terraform apply
```

**Dependencies**: Network + Security + Database layer outputs

**Resources Created**:
- EC2 instance in public subnet
- Apache + PHP installation
- Dynamic DB connection configuration

**Outputs**:
- `app_public_ip`

---

## 🔄 Remote State Management

### State Architecture

Each layer maintains **independent state** in S3 with built-in locking:

```
S3 Bucket: terraform-state-file-s3-YOUR-ID
│
├── dev/
│   ├── network/terraform.tfstate
│   ├── network/.terraform.tfstate.lock.info  # S3 lockfile
│   ├── security/terraform.tfstate
│   ├── security/.terraform.tfstate.lock.info
│   ├── database/terraform.tfstate
│   ├── database/.terraform.tfstate.lock.info
│   └── compute/terraform.tfstate
│       └── compute/.terraform.tfstate.lock.info
│
└── [Future: staging/, prod/]
```

### State Locking

Using **S3 native locking** with `use_lockfile = true`:

```hcl
terraform {
  backend "s3" {
    bucket       = "terraform-state-file-s3-YOUR-ID"
    key          = "dev/network/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true  # Creates .terraform.tfstate.lock.info in S3
  }
}
```

**How it works**:
- When `terraform apply` runs, it creates a lock file in S3
- Lock file: `.terraform.tfstate.lock.info` in the same directory
- Prevents concurrent modifications without DynamoDB
- Automatically cleaned up after operation completes
- ✅ **Simpler setup** - No separate DynamoDB table needed
- ✅ **Cost-effective** - Only S3 costs, no DynamoDB charges

### Cross-Layer Communication

Higher layers consume lower layer outputs using `terraform_remote_state`:

```hcl
# Example: Security layer reads Network layer outputs
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "terraform-state-file-s3-YOUR-ID"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}

# Use outputs
vpc_id = data.terraform_remote_state.network.outputs.vpc_id
```

### Why S3 Lockfile Instead of DynamoDB?

**Traditional approach**: Separate DynamoDB table for locking  
**Our approach**: S3 native locking with `use_lockfile = true`

**Benefits**:
- ✅ **Simpler setup** - One less AWS service to manage
- ✅ **Lower cost** - No DynamoDB charges
- ✅ **Same functionality** - Prevents concurrent modifications
- ✅ **Automatic cleanup** - Lock removed after operation
- ✅ **No extra infrastructure** - Works out of the box with S3

**How it works**:
```
When terraform apply starts:
1. Creates .terraform.tfstate.lock.info in S3
2. Other operations see the lock and wait
3. Lock automatically removed when done
4. Next operation can proceed
```

### Benefits

✅ **Independent Deployments** - Deploy layers separately  
✅ **Loose Coupling** - Layers depend only on outputs  
✅ **Team Collaboration** - Multiple teams can work in parallel  
✅ **State Safety** - Versioned, encrypted, locked  
✅ **Rollback Capability** - Roll back individual layers

---

## 🔐 Security

### Network Security

```
✓ Database in private subnet
✓ No public IP on database
✓ NAT Gateway for outbound only
✓ Internet Gateway only for public subnet
```

### Security Group Design

```
✓ App SG: Minimal inbound (80, 22)
✓ DB SG: Only from App SG (3306)
✓ SG-to-SG references (not CIDR-based)
✓ No 0.0.0.0/0 on database
```

### Access Control

```
✓ SSH restricted to specific IP
✓ Database user with limited privileges
✓ No root user for application
✓ Host-based restrictions (10.10.1.%)
```

### Best Practices Implemented

- ✅ **Principle of Least Privilege** - Minimal required permissions
- ✅ **Defense in Depth** - Multiple security layers
- ✅ **Network Segmentation** - Public/private isolation
- ✅ **State Encryption** - S3 encryption enabled
- ✅ **State Locking** - S3 lockfile prevents concurrent modifications

### 🚨 Production Enhancements Needed

For production use, add:

- [ ] AWS Secrets Manager for credentials
- [ ] IAM roles instead of access keys
- [ ] VPC Flow Logs for monitoring
- [ ] AWS WAF on load balancer
- [ ] SSL/TLS certificates via ACM
- [ ] Multi-factor authentication
- [ ] Regular security audits

---

## 🐛 Debugging Journey

### Issues Resolved During Development

| Issue | Root Cause | Solution |
|-------|------------|----------|
| **Expression not evaluated** | Quoted Terraform expressions | Removed quotes from `each.value` |
| **Invalid CIDR block** | `0.0.0/0` instead of `0.0.0.0/0` | Added missing octet |
| **Provider not found** | Hyphen instead of underscore | Changed `aws-availability` to `aws_availability_zones` |
| **Validation failed** | Wrong function signature | Used `cidrnetmask()` instead of `cidrsubnet()` |
| **Duplicate terraform block** | Two provider configs | Kept only one `terraform {}` block |
| **Remote state attribute missing** | No environment-level output | Re-exposed module outputs at environment level |
| **NAT repo timeout** | No NAT Gateway | Added NAT Gateway for private subnet |
| **DB connection refused** | MariaDB not running | Started and enabled MariaDB service |
| **Host not allowed** | MySQL host permissions | Created user with correct host pattern |

### Key Learnings

🧠 **Module Scope vs State Scope**  
Module outputs must be re-exposed at environment level to be accessible via remote state.

🧠 **Expressions vs Strings**  
Never quote Terraform expressions - quotes make them literal strings.

🧠 **EC2 Network Attachment**  
EC2 attaches to ONE subnet; subnet determines VPC, AZ, and routing.

🧠 **Security Group Relationships**  
SG-to-SG references are dynamic and more secure than CIDR-based rules.

---

## 📈 Future Enhancements

### Short-term (Production Readiness)

- [ ] **Replace EC2 DB with RDS Multi-AZ**
  - Managed service
  - Automated backups
  - High availability
  
- [ ] **Add Application Load Balancer**
  - SSL/TLS termination
  - Health checks
  - Multi-AZ distribution

- [ ] **Implement Auto Scaling Group**
  - Automatic scaling
  - Self-healing
  - Cost optimization

- [ ] **Use AWS Secrets Manager**
  - Secure credential storage
  - Automatic rotation
  - Audit logging

### Medium-term (Enterprise Features)

- [ ] Add CloudWatch monitoring and alarms
- [ ] Implement backup and disaster recovery
- [ ] Add VPC Flow Logs
- [ ] Create staging environment
- [ ] Add AWS WAF for security
- [ ] Implement blue-green deployment

### Long-term (Advanced Architecture)

- [ ] Multi-region deployment
- [ ] CI/CD pipeline integration
- [ ] Infrastructure testing (Terratest)
- [ ] Cost optimization and tagging strategy
- [ ] Compliance and governance (Policy as Code)

---

## 🎯 Use Cases

This architecture pattern is suitable for:

- 🌐 **Web Applications** - SaaS platforms, APIs
- 🏢 **Enterprise Applications** - Internal tools, dashboards
- 📱 **Mobile Backends** - App servers with database
- 🛒 **E-commerce Sites** - Product catalogs, shopping carts
- 📊 **Data Processing** - ETL pipelines, analytics platforms

---

## 📚 Documentation

- [AWS VPC Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)
- [Terraform Module Documentation](https://developer.hashicorp.com/terraform/language/modules)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform Backend Configuration](https://developer.hashicorp.com/terraform/language/settings/backends/s3)

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Terraform best practices
- Use consistent naming conventions
- Add comments for complex logic
- Update documentation
- Test in dev environment first

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Your Name**

- GitHub: [@chellojuramu](https://github.com/chellojuramu)
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/ramuchelloju)


---

## 🙏 Acknowledgments

- AWS for comprehensive documentation
- Terraform community for best practices
- HashiCorp for excellent tooling

---

## 📊 Project Stats

![GitHub stars](https://img.shields.io/github/stars/yourusername/aws-infra-live?style=social)
![GitHub forks](https://img.shields.io/github/forks/yourusername/aws-infra-live?style=social)
![GitHub issues](https://img.shields.io/github/issues/yourusername/aws-infra-live)
![GitHub pull requests](https://img.shields.io/github/issues-pr/yourusername/aws-infra-live)

---

## 💡 Tips for Interview Presentation

**30-Second Elevator Pitch**:
> "I built a production-ready 3-tier AWS architecture using Terraform with modular design and remote state management. The infrastructure includes a VPC with public and private subnets, security group isolation, and automated provisioning. The database runs in a private subnet with no public access, while the application tier serves HTTP traffic through an Internet Gateway. I debugged several real-world issues and implemented AWS best practices for security and scalability."

**Key Points to Emphasize**:
- ✅ Modular, reusable infrastructure
- ✅ Security-first design (private DB, SG isolation)
- ✅ Real debugging experience
- ✅ Remote state management
- ✅ Production-ready architecture
- ✅ Scalability considerations

---

<div align="center">

### ⭐ If you find this project helpful, please give it a star!

**Built with ❤️ using Terraform and AWS**

</div>
