# Terraform State Management - Interview Notes

> Last Updated: Terraform 1.10+ (Current Best Practices)

---

# Table of Contents

1. What is a Terraform State File?
2. Why is State Important?
3. Local vs Remote State
4. AWS Remote Backend
5. Azure Remote Backend
6. State Locking
7. Terraform 1.10+ Changes
8. State Corruption
9. Recovery Methods
10. Interview Questions & Answers
11. Best Practices
12. Common Commands

---

# 1. What is a Terraform State File?

Terraform keeps track of all infrastructure resources in a **state file (`terraform.tfstate`)**.

It stores:

- Resource IDs
- Current infrastructure state
- Resource dependencies
- Metadata
- Outputs

Without the state file, Terraform doesn't know what infrastructure already exists.

---

# 2. Why is State Important?

Terraform compares:

```
Terraform Code (.tf)
        ↓
Current State (tfstate)
        ↓
Actual Infrastructure
```

This comparison allows Terraform to determine:

- What to create
- What to update
- What to delete

---

# 3. Local vs Remote State

## Local State

```
terraform.tfstate
```

Pros

- Easy to use
- Good for learning

Cons

- No collaboration
- No locking
- Easy to lose
- Not suitable for teams

---

## Remote State

State is stored in cloud storage.

Examples

AWS

- S3 Bucket

Azure

- Azure Blob Storage

Benefits

- Shared by teams
- Secure
- Version history
- State locking
- Backup
- High availability

---

# 4. AWS Remote Backend

Example

```hcl
terraform {
  backend "s3" {
    bucket       = "terraform-state"
    key          = "dev/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}
```

### Mapping

| Property | Meaning |
|-----------|----------|
| bucket | S3 bucket |
| key | State file path |
| region | AWS Region |
| encrypt | Encrypt state |
| use_lockfile | Enable locking |

---

# 5. Azure Remote Backend

Example

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstateaccount"
    container_name       = "tfstate"
    key                  = "dev/terraform.tfstate"
  }
}
```

Azure automatically encrypts storage.

---

# AWS vs Azure Backend

| AWS | Azure |
|------|--------|
| S3 Bucket | Storage Account |
| Folder | Container |
| State File | Blob |
| use_lockfile | Blob Lease |
| Versioning | Blob Versioning |

---

# 6. State Locking

## Why?

Imagine:

Developer A

```
terraform apply
```

Developer B

```
terraform apply
```

Both modify the same state simultaneously.

Result:

❌ State corruption

---

## Locking Prevents This

Only one user can update the state.

Others receive:

```
Error acquiring the state lock
```

---

# AWS Locking

## Terraform < 1.10

Used DynamoDB

```
S3
 +
DynamoDB
```

---

## Terraform 1.10+

DynamoDB locking is deprecated.

Now use:

```hcl
use_lockfile = true
```

Terraform creates a lock file inside S3.

---

# Azure Locking

Azure Blob Storage automatically uses:

**Blob Lease**

No extra configuration needed.

---

# 7. Terraform 1.10+ Changes

Old

```
S3
 +
DynamoDB
```

New

```
S3
 +
use_lockfile=true
```

Interview Point

> DynamoDB locking is deprecated starting with Terraform 1.10. AWS S3 now supports native lock files using `use_lockfile = true`.

---

# 8. State Corruption

Possible causes

- Two users running apply simultaneously
- Manual editing of tfstate
- Interrupted terraform apply
- Network failure
- Backend storage issue
- Accidental deletion
- Partial write

---

# 9. Recovering a Corrupted State

## Step 1

Run

```bash
terraform plan
```

Identify the issue.

---

## Step 2

If infrastructure exists but state is outdated

```bash
terraform refresh
```

or

```bash
terraform plan -refresh-only
```

---

## Step 3

Missing resources?

Import them.

```bash
terraform import aws_instance.web i-123456789
```

---

## Step 4

If versioning is enabled

Restore previous version.

AWS

Restore previous S3 object version.

Azure

Restore previous Blob version.

---

## Step 5

Run

```bash
terraform plan
```

Verify state and infrastructure match.

---

# 10. Interview Question

## Q. How do you manage a corrupted Terraform state file?

### Best Answer

> I always store Terraform state remotely instead of locally. On AWS I use an S3 backend with versioning enabled and `use_lockfile = true` for state locking. On Azure I use Azure Blob Storage, which automatically uses blob leases for locking. If the state becomes corrupted, I first inspect it using `terraform plan`. If needed, I synchronize it with `terraform refresh` or re-import missing resources using `terraform import`. If corruption is severe, I restore the last healthy version from S3 or Azure Blob Storage version history and validate it using `terraform plan`.

---

# Follow-up

## How do you prevent state corruption?

Answer

- Remote backend
- State locking
- Versioning
- Least privilege IAM/RBAC
- Never edit tfstate manually
- CI/CD instead of local apply
- Regular backups

---

# Follow-up

## What if versioning isn't enabled?

Answer

- Use terraform refresh
- Import resources
- Rebuild state manually if necessary

Versioning should always be enabled.

---

# Follow-up

## Why is state locking needed?

Answer

To prevent multiple users from updating the state simultaneously, avoiding race conditions and state corruption.

---

# Follow-up

## What if state lock is stuck?

Check if another Terraform process is running.

If it's a stale lock:

```bash
terraform force-unlock LOCK_ID
```

Use this only after confirming no active Terraform operation is holding the lock.

---

# 11. Best Practices

✔ Store state remotely

✔ Enable encryption

✔ Enable versioning

✔ Enable state locking

✔ Use IAM/RBAC

✔ Never edit tfstate manually

✔ Run Terraform through CI/CD

✔ Backup state

✔ Review `terraform plan`

✔ Keep secrets out of state whenever possible

---

# 12. Common Commands

Initialize backend

```bash
terraform init
```

Show state

```bash
terraform show
```

List resources

```bash
terraform state list
```

Show one resource

```bash
terraform state show RESOURCE
```

Import resource

```bash
terraform import RESOURCE_NAME RESOURCE_ID
```

Move state

```bash
terraform state mv
```

Remove resource from state

```bash
terraform state rm
```

Replace provider

```bash
terraform state replace-provider
```

Unlock state

```bash
terraform force-unlock LOCK_ID
```

Refresh state (older workflow)

```bash
terraform refresh
```

Refresh-only plan (recommended)

```bash
terraform plan -refresh-only
```

---

# AWS Backend

```hcl
terraform {
  backend "s3" {
    bucket       = "terraform-state"
    key          = "dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

---

# Azure Backend

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "tfstateaccount"
    container_name       = "tfstate"
    key                  = "dev/terraform.tfstate"
  }
}
```

---

# 30-Second Interview Answer

> "I store Terraform state in a remote backend—S3 on AWS or Azure Blob Storage on Azure. I enable versioning and state locking (`use_lockfile` for S3 or blob leases in Azure) to prevent concurrent updates. If the state becomes corrupted, I first inspect it with `terraform plan`, use `terraform refresh` or `terraform import` if possible, and if necessary restore the last known good version from the backend before validating the infrastructure with another `terraform plan`."

---

# Key Takeaways

- Never use local state for teams.
- Enable versioning on remote storage.
- Terraform 1.10+ uses `use_lockfile` instead of DynamoDB for S3 locking.
- Azure Blob Storage uses blob leases for locking automatically.
- Recover with `terraform refresh`, `terraform import`, or restore a previous version.
- Always verify recovery with `terraform plan`.
