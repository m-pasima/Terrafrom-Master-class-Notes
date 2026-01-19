````md
# Terraform Fundamentals – Notes

These notes are written for **beginners** and are suitable for **teaching, labs, and self-study**.  
Examples assume **AWS**, but the concepts apply to all providers.

---

## 1. Prerequisites

Before writing or running any Terraform code, the following must be in place.

---

### 1.1 System & Tooling Requirements

#### Operating System
- Windows
- macOS
- Linux

Terraform behaves the same across platforms.

#### Required Tools
- **Terraform CLI**
- **Cloud provider CLI** (AWS CLI if using AWS)
- **Text editor / IDE**
  - Recommended: **VS Code**

#### Recommended VS Code Extensions
- HashiCorp Terraform (syntax highlighting, validation)
- YAML (for cloud-related config files)
- GitLens (optional, for Git visibility)

---

### 1.2 Cloud Account Requirements (AWS Basics)

If you are using AWS, ensure the following exist **before** running Terraform.

#### AWS Account
- Active AWS account
- Billing enabled

#### IAM User (Best Practice)
- Programmatic access enabled
- Permissions:
  - For learning: AdministratorAccess
  - For production: least privilege policies

#### AWS Credentials Configuration
One of the following must be set:

```bash
aws configure
````

or environment variables:

```bash
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION
```

Terraform reads credentials from the same sources as the AWS CLI.

---

### 1.3 Core AWS Infrastructure Prerequisites (Beginner Level)

These are **not created by Terraform initially** but are commonly required by Terraform resources.

#### Default VPC

* Every AWS region has a **default VPC**
* Contains:

  * Default subnet(s)
  * Internet Gateway
  * Route table

For beginners:

* Using the default VPC simplifies early labs
* Terraform can reference it instead of creating networking from scratch

#### Key Pair (EC2 Access)

* Required if launching EC2 instances
* Used for SSH access

Must exist **before** Terraform runs, unless Terraform is creating it.

Example:

* Key name: `terraform-key`
* Stored in AWS EC2 → Key Pairs

Terraform will reference this key by name.

#### AMI Knowledge

* You must know:

  * AMI ID
  * Region compatibility

Example:

* Amazon Linux 2 AMI for `eu-west-2`

---

### 1.4 Knowledge Prerequisites

You should understand:

* Basic cloud concepts:

  * Virtual machines
  * Networks
  * Storage
* Basic terminal usage:

  * `cd`, `ls`, `mkdir`
* Basic Git concepts (recommended):

  * clone
  * commit
  * push

---

## 2. Terraform Workflow

Terraform follows a **structured, repeatable lifecycle**.

---

### 2.1 Write Configuration

Infrastructure is defined in `.tf` files using **HCL**.

Common files:

* `main.tf`
* `variables.tf`
* `outputs.tf`
* `providers.tf`

You describe **what you want**, not how to do it.

Terraform is **declarative**, not procedural.

---

### 2.2 Initialize

```bash
terraform init
```

What this does:

* Downloads provider plugins
* Initializes backend (local or remote)
* Prepares the working directory

This must be run:

* On first use
* After adding providers
* After changing backend configuration

---

### 2.3 Plan

```bash
terraform plan
```

Purpose:

* Compares **desired state** (code) with **current state**
* Shows a preview of changes

Output shows:

* Resources to be created
* Resources to be modified
* Resources to be destroyed

No changes are made at this stage.

---

### 2.4 Apply

```bash
terraform apply
```

Purpose:

* Executes the plan
* Calls provider APIs
* Creates or updates infrastructure
* Writes updates to the state file

Terraform will ask for confirmation unless auto-approved.

```bash
terraform apply auto-approve
```

---

### 2.5 Destroy (Cleanup)

```bash
terraform destroy
```
Terraform will ask for confirmation unless auto-approved.

```bash
terraform destroy auto-approve
```

Purpose:

* Deletes all resources managed by Terraform
* Useful for:

  * Labs
  * Cost control
  * Testing

---

## 3. Providers

---

### 3.1 What Is a Provider?

A **provider** is a plugin that allows Terraform to interact with an external service API.

Examples:

* AWS
* Azure
* Google Cloud
* Kubernetes
* GitHub

Terraform itself cannot create infrastructure without providers.

---

### 3.2 Provider Responsibilities

Providers handle:

* Authentication
* API communication
* Resource lifecycle actions

Terraform handles:

* Dependency graph
* Execution order
* State management

---

### 3.3 Example: AWS Provider

```hcl
provider "aws" {
  region = "eu-west-2"
}
```

Key points:

* Region must match your resources
* Credentials are not hardcoded
* Provider plugins are downloaded during `terraform init`

---

### 3.4 Provider Versioning (Best Practice)

You can pin provider versions to avoid breaking changes.

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

---

## 4. State File (terraform.tfstate)

---

### 4.1 What Is the State File?

The **state file** is Terraform’s memory.

It stores:

* Resource IDs
* Metadata
* Dependencies
* Real-world mappings

Terraform does **not** rely solely on the cloud provider for tracking.

---

### 4.2 Why State Is Critical

Without state:

* Terraform cannot detect changes
* Resources may be duplicated
* Infrastructure becomes inconsistent

State enables:

* Change detection
* Safe updates
* Resource linking

---

### 4.3 Local State (Default)

* Stored as `terraform.tfstate`
* Suitable for:

  * Learning
  * Solo projects
* Not safe for teams

---

### 4.4 Remote State (Recommended)

Common backends:

* AWS S3
* Terraform Cloud
* Azure Blob Storage

Benefits:

* Centralized state
* State locking
* Team collaboration
* Reduced corruption risk

---

### 4.5 State Safety Rules

* Never manually edit state
* Never commit state to Git
* Treat state as sensitive data
* Always back it up

---

## 5. Terraform Command Basics

---

### 5.1 Core Commands

#### Initialize

```bash
terraform init
```

#### Validate Syntax

```bash
terraform validate
```

#### Format Code

```bash
terraform fmt
```

#### Preview Changes

```bash
terraform plan
```

#### Apply Changes

```bash
terraform apply
```

#### Destroy Infrastructure

```bash
terraform destroy
```

---

### 5.2 State Inspection Commands

#### View State

```bash
terraform show
```

#### List Managed Resources

```bash
terraform state list
```

These commands help with debugging and learning.

---

## 6. Quick Recall Summary

* Terraform is **declarative**
* Providers connect Terraform to cloud APIs
* Workflow: **write → init → plan → apply→ destroy**
* State file is the source of truth
* Default VPC and key pair simplify beginner AWS labs
* Never lose or expose the state file
