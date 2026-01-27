# Terraform Modules

---

## Overview

A **Terraform module** is a reusable collection of Terraform configuration files that creates a specific set of infrastructure resources. Modules enable code reusability, standardization, and better organization of complex infrastructure.

Every Terraform configuration is technically a module - even a single `.tf` file in a directory is considered the **root module**.

---

## Key Terms and Definitions

### Module
A **module** is a container for multiple resources that are used together. It consists of a collection of `.tf` files kept together in a directory.

### Root Module
The **root module** is the main working directory where you run Terraform commands. It's the top-level module that calls other modules.

### Child Module
A **child module** is a module that is called by another module. Child modules are reusable components that can be used multiple times.

### Module Source
The **module source** tells Terraform where to find the module code. Sources can be:
* Local paths
* Git repositories
* Terraform Registry
* HTTP URLs

### Module Block
A **module block** is used to call a child module from within another module. It specifies the source and input variables.

### Input Variables
**Input variables** are parameters that allow customization of module behavior. They make modules flexible and reusable.

### Output Values
**Output values** are return values from a module that can be used by the calling module or displayed to users.

### Module Registry
The **Terraform Registry** is a public repository of verified modules that can be used in your configurations.

---

## Why Use Modules

### Code Reusability
* Write infrastructure code once
* Use it across multiple projects
* Reduce duplication and maintenance

### Standardization
* Enforce organizational standards
* Consistent resource configurations
* Reduce configuration drift

### Abstraction
* Hide complex implementation details
* Provide simple interfaces
* Focus on business logic

### Team Collaboration
* Share common patterns
* Centralized updates
* Version control for infrastructure components

### Testing and Validation
* Test modules independently
* Validate configurations
* Ensure reliability

---

## Module Structure

### Basic Module Structure

```
module-name/
├── main.tf          # Primary resource definitions
├── variables.tf     # Input variable declarations
├── outputs.tf       # Output value declarations
└── README.md        # Module documentation
```

### Advanced Module Structure

```
module-name/
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf      # Provider version constraints
├── locals.tf        # Local values
├── data.tf          # Data source definitions
├── examples/        # Usage examples
│   └── basic/
│       ├── main.tf
│       └── variables.tf
└── README.md
```

---

## Creating Your First Module - VPC

### Step 1: Module Directory Structure

Create a new directory for your VPC module:

```
modules/
└── vpc/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

### Step 2: Define Input Variables

**modules/vpc/variables.tf:**
```hcl
variable "vpc_name" {
  description = ""
  type        = string
}

variable "vpc_cidr" {
  description = ""
  type        = string
}

variable "availability_zones" {
  description = ""
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = ""
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = ""
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = ""
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = ""
  type        = bool
  default     = false
}

variable "tags" {
  description = ""
  type        = map(string)
  default     = {}
}
```

### Step 3: Define VPC Resources

**modules/vpc/main.tf:**
```hcl
# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    {
      Name = var.vpc_name
    },
    var.tags
  )
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "${var.vpc_name}-igw"
    },
    var.tags
  )
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "${var.vpc_name}-public-${count.index + 1}"
      Type = "Public"
    },
    var.tags
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name = "${var.vpc_name}-private-${count.index + 1}"
      Type = "Private"
    },
    var.tags
  )
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? length(var.public_subnet_cidrs) : 0

  domain = "vpc"
  depends_on = [aws_internet_gateway.this]

  tags = merge(
    {
      Name = "${var.vpc_name}-eip-${count.index + 1}"
    },
    var.tags
  )
}

# NAT Gateways
resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? length(var.public_subnet_cidrs) : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  depends_on    = [aws_internet_gateway.this]

  tags = merge(
    {
      Name = "${var.vpc_name}-nat-${count.index + 1}"
    },
    var.tags
  )
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-public-rt"
    },
    var.tags
  )
}

# Private Route Tables
resource "aws_route_table" "private" {
  count = var.enable_nat_gateway ? length(var.private_subnet_cidrs) : 1

  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this[count.index].id
    }
  }

  tags = merge(
    {
      Name = "${var.vpc_name}-private-rt-${count.index + 1}"
    },
    var.tags
  )
}

# Public Route Table Associations
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Route Table Associations
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = var.enable_nat_gateway ? aws_route_table.private[count.index].id : aws_route_table.private[0].id
}

# VPN Gateway (optional)
resource "aws_vpn_gateway" "this" {
  count = var.enable_vpn_gateway ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "${var.vpc_name}-vpn-gw"
    },
    var.tags
  )
}
```

### Step 4: Define Outputs

**modules/vpc/outputs.tf:**
```hcl
output "vpc_id" {
  description = ""
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = ""
  value       = aws_vpc.this.cidr_block
}

output "internet_gateway_id" {
  description = ""
  value       = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  description = ""
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = ""
  value       = aws_subnet.private[*].id
}

output "public_subnet_cidrs" {
  description = ""
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = ""
  value       = aws_subnet.private[*].cidr_block
}

output "nat_gateway_ids" {
  description = ""
  value       = aws_nat_gateway.this[*].id
}

output "public_route_table_id" {
  description = ""
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = ""
  value       = aws_route_table.private[*].id
}
```

---

## Using Modules

### Module Block Syntax

```hcl
module "module_name" {
  source = ""
  
  # Input variables
  variable_name = value
}
```

### Local Module Example

```hcl
module "main_vpc" {
  source = "./modules/vpc"
  
  vpc_name               = ""
  vpc_cidr              = ""
  availability_zones    = ["", "", ""]
  public_subnet_cidrs   = ["", "", ""]
  private_subnet_cidrs  = ["", "", ""]
  enable_nat_gateway    = true
  enable_vpn_gateway    = false
  
  tags = {
    Environment = ""
    Project     = ""
  }
}
```

### Accessing Module Outputs

```hcl
output "vpc_id" {
  value = module.main_vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.main_vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.main_vpc.private_subnet_ids
}
```

---

## Module Sources

### Local Paths

```hcl
module "example" {
  source = "./modules/example"
}
```

### Git Repositories

```hcl
module "example" {
  source = "git::https://github.com/user/repo.git"
}

# Specific branch or tag
module "example" {
  source = "git::https://github.com/user/repo.git?ref=v1.0.0"
}
```

### Terraform Registry

```hcl
module "example" {
  source  = "namespace/module-name/provider"
  version = ""
}
```

### HTTP URLs

```hcl
module "example" {
  source = "https://example.com/modules/example.zip"
}
```

---

## Variable Types and Validation

### Basic Types

```hcl
variable "string_var" {
  type = string
}

variable "number_var" {
  type = number
}

variable "bool_var" {
  type = bool
}
```

### Collection Types

```hcl
variable "list_var" {
  type = list(string)
}

variable "map_var" {
  type = map(string)
}

variable "set_var" {
  type = set(string)
}
```

### Complex Types

```hcl
variable "object_var" {
  type = object({
    name = string
    age  = number
  })
}

variable "tuple_var" {
  type = tuple([string, number, bool])
}
```

### Variable Validation

```hcl
variable "instance_type" {
  type        = string
  description = ""
  
  validation {
    condition     = contains(["t2.micro", "t2.small", "t2.medium"], var.instance_type)
    error_message = ""
  }
}
```

---

## Module Best Practices

### 1. Single Responsibility

Each module should have a single, well-defined purpose:
* EC2 instance module
* VPC module
* Security group module

### 2. Clear Interface

Define clear input variables and outputs:
* Descriptive variable names
* Comprehensive descriptions
* Appropriate default values

### 3. Documentation

Always include:
* README.md with usage examples
* Variable descriptions
* Output descriptions

### 4. Versioning

Use semantic versioning for modules:
* v1.0.0 for initial release
* v1.1.0 for new features
* v1.0.1 for bug fixes

### 5. Testing

Test modules with different configurations:
* Unit tests for individual resources
* Integration tests for complete scenarios

---

## Module Composition Patterns

### Layered Architecture

```
├── modules/
│   ├── networking/     # VPC, subnets, gateways
│   ├── security/       # Security groups, NACLs
│   ├── compute/        # EC2, Auto Scaling
│   └── database/       # RDS, DynamoDB
```

### Environment-Specific Modules

```
├── modules/
│   ├── environments/
│   │   ├── dev/
│   │   ├── staging/
│   │   └── prod/
│   └── components/
│       ├── web-tier/
│       ├── app-tier/
│       └── db-tier/
```

---

## Working with Module Registry

### Finding Modules

1. Visit [registry.terraform.io](https://registry.terraform.io)
2. Search for modules by provider and use case
3. Review module documentation and examples

### Using Registry Modules

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ""
  
  name = ""
  cidr = ""
  
  azs             = ["", "", ""]
  private_subnets = ["", "", ""]
  public_subnets  = ["", "", ""]
  
  enable_nat_gateway = true
  enable_vpn_gateway = true
  
  tags = {
    Environment = ""
  }
}
```

---

## Module Development Workflow

### 1. Plan and Design

* Define module purpose
* Identify required resources
* Plan input/output interface

### 2. Create Module Structure

* Set up directory structure
* Create basic files (main.tf, variables.tf, outputs.tf)

### 3. Implement Resources

* Define resources in main.tf
* Configure variables and outputs

### 4. Test Module

* Create test configurations
* Validate with different inputs

### 5. Document Module

* Write comprehensive README
* Include usage examples

### 6. Version and Publish

* Tag releases with semantic versioning
* Publish to registry if public

---

## Common Module Patterns

### Conditional Resources

```hcl
resource "aws_instance" "this" {
  count = var.create_instance ? 1 : 0
  
  ami           = var.ami_id
  instance_type = var.instance_type
}
```

### Dynamic Blocks

```hcl
resource "aws_security_group" "this" {
  name = var.name
  
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
```

### Local Values

```hcl
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_instance" "this" {
  tags = merge(var.tags, local.common_tags)
}
```

---

## Module Security Considerations

### Input Validation

* Validate all input variables
* Use appropriate types and constraints
* Provide clear error messages

### Sensitive Data

```hcl
variable "database_password" {
  type      = string
  sensitive = true
}

output "database_endpoint" {
  value     = aws_db_instance.this.endpoint
  sensitive = false
}
```

### Least Privilege

* Create minimal IAM policies
* Use specific resource ARNs
* Avoid wildcard permissions

---

## Troubleshooting Modules

### Common Issues

**Module not found:**
* Check source path
* Verify module exists
* Run `terraform init`

**Variable errors:**
* Check variable names and types
* Verify required variables are provided
* Review variable validation rules

**Output errors:**
* Ensure outputs are defined in child module
* Check output references in calling module

### Debugging Commands

```bash
# Initialize and download modules
terraform init

# Validate module configuration
terraform validate

# Show module dependency graph
terraform graph

# Plan with detailed logging
TF_LOG=DEBUG terraform plan
```

---

## Summary

Terraform modules provide:
* **Code reusability** across projects
* **Standardization** of infrastructure patterns
* **Abstraction** of complex configurations
* **Team collaboration** through shared components

Key concepts:
* **Root module** - main working directory
* **Child modules** - reusable components
* **Input variables** - module parameters
* **Output values** - module return values
* **Module sources** - where modules are stored

**Next step:** Convert your existing project infrastructure into reusable modules to improve organization and enable code sharing.