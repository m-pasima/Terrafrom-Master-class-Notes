# Beginner Terraform Project (Task-Based, With Guidance on Where Things Come From)

## Project Title
**Deploy a Basic EC2 Instance Using Terraform (AWS Default VPC)**

This beginner project focuses on **learning how to find Terraform resources**, **where code comes from**, and **how to work efficiently in VS Code**, not just writing code blindly.

---

## Project Goal

By the end of this project, you will be able to:

- Understand where Terraform code comes from (Registry, docs)
- Use VS Code effectively for Terraform
- Configure an AWS provider correctly
- Deploy an EC2 instance in the default VPC
- Understand Terraform state
- Safely clean up infrastructure

---

## Assumptions

You already have:

- An AWS account
- An IAM user with programmatic access
- AWS CLI installed and configured
- A key pair created in AWS
- Terraform installed
- VS Code installed

---

## Task 1: Prepare VS Code for Terraform

### Objective
Set up your editor so Terraform is easy to write and understand.

### Tasks
- Open **VS Code**
- Install the following extensions:
  - **HashiCorp Terraform**  
    (syntax highlighting, validation, IntelliSense)
  - **YAML** (useful for cloud configs)
  - **GitLens** (optional, for Git visibility)
- Restart VS Code after installing extensions

---

## Task 2: Create the Project Structure

### Objective
Create a clean Terraform workspace.

### Tasks
- Create a new folder called:
```

terraform-ec2-beginner

```
- Open the folder in VS Code
- Create the following empty files:
- `main.tf`
- `providers.tf`
- `variables.tf`
- `outputs.tf`

---

## Task 3: Learn Where Terraform Code Comes From

### Objective
Understand how Terraform resources are discovered.

### Tasks
- Open a browser and go to:
```

[https://registry.terraform.io](https://registry.terraform.io)

````
- Search for **AWS Provider**
- Open the documentation for:
- `hashicorp/aws`
- Observe:
- Provider examples
- Resource documentation
- Data sources

Important understanding:
> You do not memorise Terraform code.  
> You look it up in the Terraform Registry.

---

## Task 4: Configure the AWS Provider

### Objective
Tell Terraform which cloud to talk to.

### Tasks
- In the Terraform Registry:
- Open **AWS Provider** documentation
- Find the **Basic Provider Configuration** example
- In `providers.tf`:
- Add the AWS provider block
- Set a region (e.g. `eu-west-2`)
- Do NOT hardcode credentials

Terraform will automatically use:
- AWS CLI credentials
- Environment variables

---

## Task 5: Initialise Terraform

### Objective
Prepare Terraform to run in this project.

### Tasks
- Open a terminal in VS Code
- Run:
```bash
terraform init
````

* Confirm:

  * Provider plugins download successfully
  * `.terraform/` directory is created
  * No errors appear

---

## Task 6: Discover EC2 Resource Syntax

### Objective

Learn how to define an EC2 instance.

### Tasks

* Go back to **Terraform Registry**
* Search for:

  ```
  aws_instance
  ```
* Open the resource documentation
* Review:

  * Required arguments
  * Optional arguments
  * Example usage

Key learning:

> Terraform resources are documented, not guessed.

---

## Task 7: Use the Default VPC via Data Sources

### Objective

Reuse existing AWS infrastructure instead of creating new networking.

### Tasks

* In Terraform Registry:

  * Search for:

    * `aws_vpc`
    * `aws_subnet`
* Find examples that reference **default VPC**
* In `main.tf`:

  * Add data sources to read:

    * The default VPC
    * One default subnet

Understanding:

* **Resources** create things
* **Data sources** read existing things

---

## Task 8: Define an EC2 Instance Resource

### Objective

Describe the virtual machine you want Terraform to create.

### Tasks

* In `main.tf`, define an `aws_instance` resource
* Use information from:

  * Terraform Registry examples
* Configure:

  * AMI (Amazon Linux 2 for your region)
  * Instance type (e.g. `t2.micro`)
  * Key pair name (already created in AWS)
  * Subnet ID from the data source
* Add tags:

  * `Name = "terraform-beginner-ec2"`

---

## Task 9: Validate and Format Your Code

### Objective

Catch mistakes early.

### Tasks

* Run:

  ```bash
  terraform validate
  ```
* Fix any syntax errors
* Run:

  ```bash
  terraform fmt
  ```
* Confirm formatting is consistent

---

## Task 10: Plan the Deployment

### Objective

Preview what Terraform will do.

### Tasks

* Run:

  ```bash
  terraform plan
  ```
* Review the plan output:

  * One EC2 instance should be created
* Confirm:

  * No unexpected resources appear

---

## Task 11: Apply the Configuration

### Objective

Create the infrastructure.

### Tasks

* Run:

  ```bash
  terraform apply
  ```
* Review the plan
* Type `yes` to confirm
* Wait for Terraform to complete

---

## Task 12: Verify in AWS Console

### Objective

Confirm the resource exists.

### Tasks

* Log into AWS Console
* Navigate to **EC2**
* Confirm:

  * Instance is running
  * Name tag is correct
  * Instance is in the default VPC

---

## Task 13: Explore the State File

### Objective

Understand how Terraform tracks resources.

### Tasks

* Locate `terraform.tfstate`
* Open it (read-only)
* Run:

  ```bash
  terraform state list
  ```
* Run:

  ```bash
  terraform show
  ```

Important:

* Never edit the state file manually
* Never commit it to Git

---

## Task 14: Add Outputs

### Objective

Expose useful information.

### Tasks

* In `outputs.tf`, define outputs for:

  * EC2 instance ID
  * Public IP address
* Run:

  ```bash
  terraform apply
  ```
* Confirm outputs appear in terminal

---

## Task 15: Destroy the Infrastructure

### Objective

Clean up and avoid costs.

### Tasks

* Run:

  ```bash
  terraform destroy
  ```
* Confirm destruction
* Verify in AWS Console that the instance is removed

---

## Key Learning Outcomes

* Terraform code comes from the **Terraform Registry**
* Providers connect Terraform to cloud APIs
* Data sources read existing infrastructure
* Resources create infrastructure
* State tracks everything Terraform manages
* Workflow: **init → plan → apply → destroy**

---


