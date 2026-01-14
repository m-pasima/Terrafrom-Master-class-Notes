
## a) Infrastructure as Code (IaC)

### Definition

Infrastructure as Code (IaC) is the practice of **provisioning and managing infrastructure using machine-readable configuration files**, rather than manual processes or interactive configuration.

Infrastructure includes:

* Virtual machines
* Networks
* Load balancers
* Databases
* Storage
* Security groups, firewalls, IAM roles

With IaC, infrastructure is treated the same way as application code.

---

### Core Principles of IaC

#### 1. Declarative Configuration

You define **what you want**, not how to do it.

Example:

* “I want 2 EC2 instances with this AMI and this security group.”

The tool determines the steps required to reach that state.

---

#### 2. Version Control

IaC files are stored in Git repositories.

* Track changes
* Roll back to previous states
* Review infrastructure changes via pull requests

---

#### 3. Idempotency

Running the same configuration multiple times results in the **same infrastructure state**.

* No duplicate resources
* No unintended changes

---

#### 4. Automation

Infrastructure creation, updates, and deletion are automated.

* No manual clicking
* Repeatable deployments
* Reduced human error

---

#### 5. Consistency Across Environments

The same code can be used to create:

* Development
* Testing
* Staging
* Production

Only variables change.

---

### Common IaC Tools

* Terraform
* AWS CloudFormation
* Azure ARM / Bicep
* Pulumi
* Ansible (configuration management, sometimes grouped with IaC)

---

## b) Benefits of Infrastructure as Code

### 1. Speed and Efficiency

Infrastructure can be provisioned in minutes instead of hours or days.

* Faster deployments
* Faster recovery from failures

---

### 2. Reduced Human Error

Manual setup is error-prone.
IaC ensures:

* Predictable deployments
* Fewer misconfigurations

---

### 3. Scalability

Infrastructure can scale by changing a value in code.
Example:

* Change instance count from 2 to 10

---

### 4. Cost Control

Resources are clearly defined.

* Easier to identify unused resources
* Infrastructure can be destroyed when not needed

---

### 5. Auditability and Compliance

All changes are documented in code and Git history.

* Who changed what
* When it was changed
* Why it was changed

---

### 6. Disaster Recovery

Infrastructure can be rebuilt from code.

* No dependency on manual documentation
* Faster recovery after outages

---

### 7. Collaboration

Teams can work together on infrastructure:

* Code reviews
* Shared standards
* Better handover between teams

---

### 8. Integration with CI/CD

IaC fits naturally into DevOps pipelines.

* Infrastructure changes tested and deployed automatically
* Same workflow as application code

---

## What is Terraform

### Definition

Terraform is an **open-source Infrastructure as Code tool** created by HashiCorp that allows you to **define, provision, and manage infrastructure across multiple cloud providers using a single configuration language**.

---

### Key Characteristics of Terraform

#### 1. Cloud-Agnostic

Terraform works with many providers:

* AWS
* Azure
* Google Cloud
* Kubernetes
* GitHub
* Databases and SaaS tools

---

#### 2. Declarative Language (HCL)

Terraform uses **HashiCorp Configuration Language (HCL)**.

* Human-readable
* Easy to learn
* Designed specifically for infrastructure

---

#### 3. State Management

Terraform maintains a **state file**.

* Tracks real infrastructure
* Knows what exists and what needs to change
* Enables accurate updates and deletions

State can be stored:

* Locally
* Remotely (S3, Terraform Cloud, Azure Storage)

---

#### 4. Execution Plan

Before applying changes, Terraform shows a **plan**.

* Displays what will be created, modified, or destroyed
* Prevents accidental changes

---

#### 5. Reusability with Modules

Terraform supports modules.

* Reusable infrastructure components
* Standardized architecture patterns
* Cleaner and maintainable code

---

### Basic Terraform Workflow

1. **Write**
   Define infrastructure in `.tf` files.

2. **Initialize**
   Download providers and modules.

   ```bash
   terraform init
   ```

3. **Plan**
   Preview changes.

   ```bash
   terraform plan
   ```

4. **Apply**
   Create or update infrastructure.

   ```bash
   terraform apply
   ```

5. **Destroy**
   Remove infrastructure when no longer needed.

   ```bash
   terraform destroy
   ```

---

### Why Terraform is Widely Used

* One tool for multiple clouds
* Strong community support
* Excellent documentation
* Ideal for DevOps and cloud engineers
* Easy integration with CI/CD pipelines

## Terraform Configuration Files

### Overview

Terraform configuration files define **what infrastructure Terraform should create and manage**. These files describe providers, resources, variables, outputs, and reusable modules. Terraform reads all configuration files in a directory and treats them as **one logical configuration**.
## Declarative vs Procedural: Terraform and Ansible

---

## Terraform is Declarative

### What “Declarative” Means

Declarative tools define **the desired end state** of infrastructure. You describe **what the infrastructure should look like**, and the tool determines **how to reach that state**.

You do **not** specify step-by-step instructions.

---

### How Terraform Works Declaratively

1. **You define the desired state**
   In Terraform, you declare resources and their properties.

   Example concept:

   * An EC2 instance
   * Instance type `t3.micro`
   * In region `eu-west-2`

2. **Terraform builds a dependency graph**
   Terraform automatically understands:

   * Which resources depend on others
   * The correct order of creation or deletion

3. **Terraform compares state**
   Terraform compares:

   * Desired state (configuration files)
   * Current state (state file)
   * Real infrastructure (cloud provider)

4. **Terraform decides the actions**
   Terraform calculates:

   * What to create
   * What to update
   * What to destroy

5. **Idempotent execution**
   Re-running Terraform does not repeat work if the desired state is already achieved.

---

### Key Declarative Characteristics of Terraform

* You do not write commands like “create”, “update”, or “delete”
* You describe resources and attributes
* Terraform figures out execution order
* Terraform shows a plan before applying changes
* The same configuration always converges to the same state

---

### Example (Conceptual)

You declare:

* 2 EC2 instances
* A security group allowing HTTP

Terraform ensures:

* Exactly 2 instances exist
* The security group rules match the definition

If one instance is deleted manually, Terraform recreates it.

---

## Ansible is Procedural

### What “Procedural” Means

Procedural tools define **how tasks should be executed step by step**. You specify **the exact sequence of operations** to perform.

You control **the process**, not just the outcome.

---

### How Ansible Works Procedurally

1. **You write tasks in order**
   Ansible playbooks execute tasks **top to bottom**.

2. **Each task performs an action**
   Examples:

   * Install a package
   * Start a service
   * Copy a file
   * Edit a configuration

3. **Execution order matters**
   If tasks are in the wrong order:

   * Playbook fails
   * Configuration breaks

4. **No global state awareness**
   Ansible does not maintain a full infrastructure state file.

   * It runs tasks
   * It checks success or failure per task

---

### Key Procedural Characteristics of Ansible

* You explicitly define task order
* You control how configuration is applied
* Execution is linear
* Focused on configuration and orchestration
* Better suited for OS-level changes

---

### Example (Conceptual)

You write steps like:

1. Install NGINX
2. Copy NGINX config file
3. Restart NGINX service

If step 2 is skipped or fails, step 3 may break.

---

## Declarative vs Procedural Comparison

| Aspect           | Terraform (Declarative)     | Ansible (Procedural)     |
| ---------------- | --------------------------- | ------------------------ |
| Focus            | Desired end state           | Step-by-step actions     |
| Execution        | Automatic planning          | Sequential tasks         |
| State management | Uses state file             | No global state          |
| Order handling   | Auto-resolved               | Manually controlled      |
| Best use case    | Infrastructure provisioning | Configuration management |
| Idempotency      | Built-in                    | Module-dependent         |

---

## Why They Are Often Used Together

Terraform and Ansible are **complementary**, not competitors.

Typical workflow:

1. Terraform provisions infrastructure
2. Ansible configures servers and applications

Terraform answers:

* “What infrastructure should exist?”

Ansible answers:

* “How should this system be configured?”



---

### File Extension

Terraform configuration files use the extension:

```text
.tf
```

Terraform loads **all `.tf` files** in a directory automatically.

---

## Common Terraform Configuration Files and Their Purpose

### 1. `main.tf`

#### Purpose

Contains the **primary infrastructure definitions**.

Typical contents:

* Provider configuration
* Resource definitions
* Module usage

Example responsibilities:

* EC2 instances
* VPCs
* Load balancers
* Databases

`main.tf` does not have a special meaning to Terraform. It is a **naming convention** for readability.

---

### 2. `providers.tf`

#### Purpose

Defines the **cloud or service providers** Terraform will use.

Includes:

* Provider name
* Region
* Authentication method
* Provider version constraints

Example concept:

* AWS provider
* Azure provider
* Google Cloud provider

Separating providers improves clarity and maintainability.

---

### 3. `variables.tf`

#### Purpose

Declares **input variables** used in the configuration.

Benefits:

* Reusability
* Environment-specific values
* Cleaner code

Variables can define:

* Instance type
* Region
* Environment name
* Resource sizes

Variables allow the same code to be reused across environments without modification.

---

### 4. `terraform.tfvars` or `*.tfvars`

#### Purpose

Stores **actual values for variables**.

Key points:

* Overrides default variable values
* Environment-specific
* Not hardcoded into configuration

Common practice:

* `dev.tfvars`
* `staging.tfvars`
* `prod.tfvars`

Sensitive values should be protected and excluded from public repositories.

---

### 5. `outputs.tf`

#### Purpose

Defines **output values** returned after Terraform runs.

Outputs are useful for:

* Displaying important information
* Passing values to other modules
* Integration with CI/CD pipelines

Examples of outputs:

* Public IP addresses
* Load balancer DNS names
* Resource IDs

---

### 6. `backend.tf`

#### Purpose

Configures **where Terraform state is stored**.

State storage options:

* Local file
* Amazon S3
* Azure Blob Storage
* Google Cloud Storage
* Terraform Cloud

Remote backends enable:

* Team collaboration
* State locking
* Improved security

---

### 7. `locals.tf`

#### Purpose

Defines **local values** used to simplify expressions.

Locals:

* Reduce repetition
* Improve readability
* Centralize commonly used values

Used for:

* Naming conventions
* Common tags
* Calculated values

---

### 8. `modules/` Directory

#### Purpose

Holds **reusable Terraform modules**.

Modules are:

* Self-contained Terraform configurations
* Reusable across projects
* Version-controlled

Typical module structure:

* `main.tf`
* `variables.tf`
* `outputs.tf`

Modules improve consistency and reduce duplication.

---

## How Terraform Reads Configuration Files

* All `.tf` files in a directory are loaded together
* File order does not matter
* Logical grouping is for **human readability**
* Terraform builds a dependency graph internally

---

## Best Practices for Terraform Configuration Files

1. Separate concerns

   * Providers, variables, outputs in different files

2. Use meaningful file names

   * Improve readability and onboarding

3. Avoid hardcoding values

   * Use variables and tfvars files

4. Protect state and secrets

   * Use remote backends
   * Do not commit sensitive files

5. Keep configurations modular

   * Use modules for reusable components

