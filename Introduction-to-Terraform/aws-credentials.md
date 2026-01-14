
# AWS Credentials

---

## Overview

AWS credentials are used to **authenticate and authorize access** to AWS services.
When using Terraform with AWS, credentials allow Terraform to:

* Create resources
* Modify infrastructure
* Delete resources

Without valid AWS credentials, Terraform **cannot interact with AWS**.

---

## What Are AWS Credentials

AWS credentials consist of:

* **Access Key ID**
* **Secret Access Key**

These credentials represent an **IAM identity** (user or role) and determine:

* What actions are allowed
* Which AWS resources can be accessed

---

## AWS Credential Types

---

### 1. IAM User Credentials

Used mainly for:

* Local development
* Learning environments
* Terraform execution from laptops

Components:

* Access Key ID
* Secret Access Key

---

### 2. IAM Role Credentials

Used mainly for:

* EC2 instances
* CI/CD pipelines
* Production environments

Key characteristics:

* Temporary credentials
* Automatically rotated
* More secure than long-term keys

---

## Creating AWS Credentials (IAM User)

### Step 1: Create an IAM User

In the AWS Console:

* Navigate to **IAM**
* Create a new user
* Enable **Programmatic access**

---

### Step 2: Attach Permissions

Recommended for learning:

* `AdministratorAccess` (temporary for labs)

Recommended for best practice:

* Least-privilege policies tailored to resources used

---

### Step 3: Download Credentials

You will receive:

* Access Key ID
* Secret Access Key

⚠️ **Important**

* Secret Access Key is shown only once
* Store it securely
* Never share or commit it to Git

---

## Configuring AWS Credentials on Windows

### Using AWS CLI (Recommended)

Configure credentials:

```bash
aws configure
```

You will be prompted for:

```text
AWS Access Key ID:
AWS Secret Access Key:
Default region name:
Default output format:
```

Example region:

```text
eu-west-2
```

---

### Where Credentials Are Stored

On Windows, credentials are stored in:

```text
C:\Users\<username>\.aws\credentials
C:\Users\<username>\.aws\config
```

---

## AWS Credential File Structure

### `credentials` File Example

```ini
[default]
aws_access_key_id = AKIAxxxxxxxxxxxx
aws_secret_access_key = xxxxxxxxxxxxxxxxxxxxx
```

---

### `config` File Example

```ini
[default]
region = eu-west-2
output = json
```

---

## AWS Profiles

AWS profiles allow **multiple credential sets**.

Example:

* `default`
* `dev`
* `staging`
* `prod`

---

### Creating a Named Profile

```bash
aws configure --profile dev
```

---

### Using a Profile with Terraform

```bash
export AWS_PROFILE=dev
```

On Windows (PowerShell):

```powershell
$env:AWS_PROFILE="dev"
```

---

## How Terraform Uses AWS Credentials

Terraform automatically checks credentials in the following order:

1. Environment variables
2. AWS CLI credentials file
3. EC2 Instance Role (if running on AWS)

No credentials should be hardcoded in Terraform files.

---

## Environment Variables (Alternative Method)

Useful for:

* CI/CD pipelines
* Temporary sessions

### Windows (PowerShell)

```powershell
$env:AWS_ACCESS_KEY_ID="AKIA..."
$env:AWS_SECRET_ACCESS_KEY="xxxx..."
$env:AWS_DEFAULT_REGION="eu-west-2"
```

---

## Verifying AWS Credentials

Run:

```bash
aws sts get-caller-identity
```

Successful output confirms:

* Credentials are valid
* AWS access is working

---

## Security Best Practices

* Never commit credentials to Git
* Use IAM roles where possible
* Rotate access keys regularly
* Use least-privilege policies
* Use `.gitignore` to exclude:

  ```text
  .aws/
  *.tfvars
  ```

---

## Common Mistakes

| Mistake                        | Impact                 |
| ------------------------------ | ---------------------- |
| Hardcoding keys in `.tf` files | Credential leakage     |
| Using root account keys        | Severe security risk   |
| Missing region configuration   | Terraform errors       |
| Expired or deleted keys        | Authentication failure |

---

## Recommended Approach for Learning

1. Create an IAM user
2. Configure AWS CLI
3. Verify credentials
4. Run Terraform using default profile
5. Transition to IAM roles for production


