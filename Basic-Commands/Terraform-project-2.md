# Beginner Terraform Project 2 (Task-Only)

## Project Title
**Secure EC2 Web Server with Remote State and Variables**

---

## Project Goal
Extend the previous project by improving security, automation, and configuration flexibility.

---

## Tasks

### Task 1: Add a Security Group
- Identify the Terraform Registry documentation for `aws_security_group`
- Create a security group that:
  - Allows inbound HTTP (port 80)
  - Allows inbound SSH (port 22) from your IP
  - Allows all outbound traffic
- Attach the security group to the EC2 instance

---

### Task 2: Install a Web Server Using User Data
- Locate examples of EC2 `user_data` in the Terraform Registry
- Write a user data script to:
  - Update the instance
  - Install a web server (Apache or Nginx)
  - Start and enable the service
- Attach the user data script to the EC2 instance
- Verify the web page loads using the instance public IP

---

### Task 3: Move Terraform State to an S3 Backend
- Identify Terraform backend documentation for `s3`
- Create an S3 bucket manually (outside Terraform)
- Configure Terraform to:
  - Store state in the S3 bucket
  - Use a unique state file key
  - Enable state locking (via DynamoDB if required)
- Re-initialise Terraform to migrate state

---

### Task 4: Introduce Variables
- Identify variable syntax in Terraform documentation
- Replace hardcoded values with variables for:
  - AWS region
  - Instance type
  - Key pair name
  - Allowed SSH CIDR block
- Define variables in `variables.tf`
- Assign values using:
  - Default values
  - `terraform.tfvars` or CLI flags

---

## Completion Criteria
- EC2 instance is accessible via HTTP
- SSH access is restricted
- Terraform state is stored remotely
- Configuration values are reusable and configurable

