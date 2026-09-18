# AI-300 — Day 6 Learning Log

**Topic: MLOps with GitHub Actions — Automate, Deploy, and Monitor ML Models**
**Dates: 2026-09-17 → 2026-09-18**
**Status: MLOps module completed**
**Next: GenAIOps module**

---

## 1. Mental Map — Complete MLOps Workflow

```text
                         MLOps
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
   Development          CI/CD             Operations
        │                  │                  │
        ▼                  ▼                  ▼
   Training code       GitHub Actions    Monitoring
   Job YAML            Azure ML jobs     Drift
   Data assets         Model registry    Endpoint health
        │                  │                  │
        └──────────────────┼──────────────────┘
                           │
                           ▼
                    Production Model
                           │
                    ┌──────┴──────┐
                    ▼             ▼
                 Deploy        Monitor
                    │             │
                    ▼             ▼
              Blue/Green       Azure Monitor
              Deployment       Model Monitoring
                    │             │
                    └──────┬──────┘
                           ▼
                  Investigate / Act
                     │           │
                  Rollback     Retrain
```
```
MLOps with GitHub Actions
│
│
├── 1. Automate Model Training with GitHub Actions
│   │
│   ├── Source Control
│   │   ├── Training code
│   │   ├── Job YAML
│   │   ├── Dependencies
│   │   └── GitHub Actions workflow
│   │
│   ├── GitHub Actions
│   │   ├── Workflow
│   │   ├── Jobs
│   │   ├── Steps
│   │   └── GitHub-hosted runner
│   │
│   ├── Workflow Triggers
│   │   ├── workflow_dispatch
│   │   │   └── Manual execution
│   │   ├── pull_request
│   │   │   └── Validate proposed changes
│   │   ├── push
│   │   │   └── Execute after push
│   │   ├── schedule
│   │   │   └── Time-based execution
│   │   └── repository_dispatch
│   │       └── External event trigger
│   │
│   ├── CI Validation
│   │   ├── Linting
│   │   │   └── Code quality/style
│   │   └── Unit tests
│   │       └── Code behavior
│   │
│   ├── Azure Authentication
│   │   ├── Service Principal
│   │   ├── OIDC / Federated Identity
│   │   └── Least privilege
│   │
│   ├── Azure ML CLI
│   │   └── az extension add --name ml --yes
│   │
│   ├── Azure ML Job
│   │   ├── Command job
│   │   │   └── Single training script/command
│   │   ├── Pipeline job
│   │   │   └── Multiple connected components
│   │   ├── Inputs
│   │   │   └── Data assets / parameters
│   │   ├── Outputs
│   │   │   └── Metrics / artifacts
│   │   ├── Environment
│   │   │   └── Runtime dependencies
│   │   └── Compute
│   │       └── Where training executes
│   │
│   ├── Submit Training Job
│   │   └── az ml job create -f src/job.yml
│   │
│   └── Execution Flow
│       ├── Git push / manual trigger
│       ├── GitHub Actions runner
│       ├── Azure login
│       ├── Azure ML CLI
│       ├── Submit job
│       └── Azure ML compute → Training
│
│
├── 2. Feature-Based Development
│   │
│   ├── Branching
│   │   └── feature/update-parameters
│   │
│   ├── Development
│   │   ├── Modify training code
│   │   └── Modify job configuration
│   │
│   ├── Commit
│   │   └── git commit
│   │
│   ├── Push
│   │   └── git push --set-upstream
│   │
│   ├── Pull Request
│   │   └── feature branch → main
│   │
│   ├── CI Validation
│   │   ├── Workflow executes
│   │   ├── Lint
│   │   └── Tests / validation
│   │
│   ├── Branch Protection
│   │   └── main
│   │       └── Require pull request before merging
│   │
│   └── Merge
│       └── Approved PR → main
│
│
├── 3. Register the Model
│   │
│   ├── Training
│   │   └── Azure ML job
│   │
│   ├── Model Artifact
│   │   └── Trained model
│   │
│   ├── Model Registry
│   │   ├── Model name
│   │   ├── Model version
│   │   └── Model metadata
│   │
│   └── Handoff
│       ├── Development / CI
│       │
│       ▼
│   Model Registry
│       │
│       ▼
│   Deployment / CD
│
│
├── 4. Deploy Model with GitHub Actions
│   │
│   ├── Managed Online Endpoint
│   │   └── Stable HTTPS endpoint / URL
│   │
│   ├── Deployment
│   │   ├── Specific model version
│   │   ├── Compute
│   │   ├── Environment
│   │   └── Scoring configuration
│   │
│   ├── Endpoint vs Deployment
│   │   ├── Endpoint
│   │   │   └── Stable client entry point
│   │   └── Deployment
│   │       └── Actual model serving
│   │
│   ├── Blue-Green Deployment
│   │   ├── Blue
│   │   │   └── Existing production model
│   │   └── Green
│   │       └── New model version
│   │
│   ├── Initial Traffic
│   │   ├── Blue → 100%
│   │   └── Green → 0%
│   │
│   ├── Test New Deployment
│   │   └── Directly invoke green
│   │
│   ├── Traffic Shift
│   │   ├── Blue → 90%
│   │   ├── Green → 10%
│   │   ├── Observe
│   │   └── Increase gradually
│   │
│   └── Promotion
│       └── Green → 100%
│
│
├── 5. Control Deployments with GitHub Environments
│   │
│   ├── GitHub Environment
│   │   ├── staging
│   │   └── production
│   │
│   ├── Purpose
│   │   └── Control deployment targets
│   │
│   ├── Protection Rules
│   │   ├── Required reviewers
│   │   ├── Branch restrictions
│   │   └── Wait timer
│   │
│   ├── Environment Variables
│   │   ├── Resource group
│   │   ├── Workspace
│   │   └── Endpoint name
│   │
│   ├── Environment Secrets
│   │   └── Environment-specific sensitive values
│   │
│   ├── Production Flow
│   │   ├── Deploy to staging
│   │   ├── Automated tests
│   │   ├── Review evidence
│   │   ├── Production approval
│   │   └── Deploy/promote to production
│   │
│   ├── OIDC
│   │   ├── GitHub Actions
│   │   ├── Federated identity
│   │   └── Azure
│   │
│   └── Important Distinction
│       ├── GitHub Environment
│       │   └── Deployment control
│       └── Azure ML Environment
│           └── Runtime dependencies
│
│
├── 6. Monitor the Deployed Model
│   │
│   ├── Operational Monitoring
│   │   └── Azure Monitor
│   │       ├── Request count
│   │       ├── Request latency
│   │       ├── Error rate
│   │       ├── CPU utilization
│   │       └── Memory utilization
│   │
│   ├── Model Monitoring
│   │   ├── Data drift
│   │   │   └── Input distribution changes
│   │   ├── Prediction drift
│   │   │   └── Output distribution changes
│   │   ├── Data quality
│   │   │   └── Missing / invalid / unexpected data
│   │   └── Feature attribution drift
│   │       └── Feature contribution changes
│   │
│   ├── Data Collection
│   │   ├── Production inputs
│   │   └── Production outputs
│   │
│   ├── Reference Data
│   │   └── Baseline for comparison
│   │
│   ├── Drift Detection
│   │   └── Monitoring threshold
│   │
│   └── Important Rule
│       └── Drift → Investigate first
│
│
└── 7. Production Response
    │
    ├── New Model Causes Problem
    │   │
    │   └── Rollback
    │       ├── Keep old deployment
    │       ├── Shift traffic back
    │       └── Blue → 100%
    │
    ├── Production Data / Reality Changes
    │   │
    │   └── Retrain
    │       ├── Collect new data
    │       ├── Retrain model
    │       ├── Evaluate
    │       ├── Register new version
    │       ├── Deploy
    │       ├── Test
    │       └── Promote
    │
    └── Continuous MLOps Loop
        └── Train
            ↓
        Register
            ↓
        Deploy
            ↓
        Test
            ↓
        Promote
            ↓
        Monitor
            ↓
        Investigate
            ↓
        Rollback / Retrain
            ↓
        Repeat
```
---

# 2. Automate Model Training with GitHub Actions

This was the **starting unit** of the MLOps section.

### Core architecture

```text
Developer
   │
   ▼
GitHub Repository
   │
   ▼
GitHub Actions
   │
   ├── Lint
   ├── Tests
   ├── Azure Login
   └── Azure ML CLI
           │
           ▼
      Azure ML Job
           │
           ▼
      aml-cluster
           │
           ▼
      Model Training
```

Important distinction:

```text
GitHub-hosted runner
        ≠
Azure ML compute
```

GitHub Actions executes the workflow.

Azure ML compute executes the actual ML training job.

---

## 3. Source Control for MLOps

We covered what should and shouldn't be stored in Git.

### Git

Store:

```text
Training code
Python scripts
YAML configurations
Pipeline definitions
Dependency files
GitHub Actions workflows
Infrastructure code
```

### Azure / storage

Store:

```text
Large datasets
Model artifacts
ML artifacts
Data assets
Experiment outputs
```

### Secrets

Store securely using:

```text
GitHub Secrets
Azure Key Vault
OIDC / federated identity
```

Never hardcode:

```text
Passwords
API keys
Client secrets
Connection strings
```

---

# 4. Trunk-Based Development

We learned the Git workflow used to keep ML development controlled.

```text
                    main
                     │
              protected branch
                     │
        ┌────────────┴────────────┐
        │                         │
 feature branch              feature branch
        │                         │
        ▼                         ▼
      commit                    commit
        │                         │
        └──────────┬──────────────┘
                   ▼
                  PR
                   │
                   ▼
          Automated validation
                   │
                   ▼
                 Merge
                   │
                   ▼
                 main
```

Important concept:

**`main` should be protected rather than allowing uncontrolled direct changes.**

---

# 5. GitHub Actions Fundamentals

We covered the hierarchy:

```text
Workflow
   │
   ├── Job
   │    ├── Step
   │    ├── Step
   │    └── Step
   │
   └── Job
```

### Important triggers

| Trigger               | Purpose                          |
| --------------------- | -------------------------------- |
| `pull_request`        | Validate proposed changes        |
| `push`                | Run after code is pushed         |
| `workflow_dispatch`   | Manual execution                 |
| `schedule`            | Time-based execution             |
| `repository_dispatch` | External event triggers workflow |

### Important distinction

```text
pull_request
    ↓
Validate change

workflow_dispatch
    ↓
Run manually

schedule
    ↓
Run at defined time

repository_dispatch
    ↓
External system triggers GitHub
```

---

# 6. Linting vs Unit Testing

We covered why both can be included in CI.

### Linting

Checks code quality/style problems.

```text
Syntax/style
       ↓
    Linter
       ↓
Pass / Fail
```

### Unit testing

Checks whether code behaves correctly.

```text
Function
   ↓
Test
   ↓
Expected vs actual
   ↓
Pass / Fail
```

So:

> **Linting checks how code is written; testing checks whether code works as expected.**

---

# 7. Azure Authentication and Authorization

We covered the difference between:

### Authentication

```text
"Who are you?"
```

### Authorization

```text
"What are you allowed to do?"
```

For GitHub Actions → Azure, we initially worked with a service principal and:

```bash
az ad sp create-for-rbac \
  --name "<service-principal-name>" \
  --role contributor \
  --scopes /subscriptions/<subscription-id>/resourceGroups/<resource-group-name> \
  --json-auth
```

The resulting credentials were stored as a GitHub secret:

```text
AZURE_CREDENTIALS
```

Workflow:

```yaml
- name: Azure login
  uses: azure/login@v2
  with:
    creds: ${{ secrets.AZURE_CREDENTIALS }}
```

We also covered the more modern approach:

```text
GitHub Actions
      │
      │ OIDC
      ▼
Microsoft Entra ID
      │
      ▼
Azure resources
```

This avoids storing long-lived Azure client secrets.

---

# 8. Azure ML Command Job

We learned that an Azure ML **command job** is appropriate when running a single training command/script.

Example structure:

```yaml
$schema: https://azuremlschemas.azureedge.net/latest/commandJob.schema.json

code: .

command: >-
  python train-model-parameters.py
  --training_data ${{inputs.training_data}}
  --reg_rate ${{inputs.reg_rate}}
  --metrics_output ${{outputs.metrics_output}}

inputs:
  training_data:
    type: uri_file
    path: azureml:diabetes-data@latest

  reg_rate: 0.01

outputs:
  metrics_output:
    type: uri_folder

environment: azureml:AzureML-sklearn-1.0-ubuntu20.04-py38-cpu@latest

compute: azureml:aml-cluster

experiment_name: diabetes-training

display_name: diabetes-train-command

description: diabetes training job
```

Important pieces:

```text
code
  ↓
Source code location

command
  ↓
Training command

inputs
  ↓
Training data / parameters

outputs
  ↓
Training artifacts

environment
  ↓
Runtime dependencies

compute
  ↓
Where job executes

experiment_name
  ↓
Groups related runs
```

---

# 9. Command Job vs Pipeline Job

```text
Command Job
    │
    └── Single command/script


Pipeline Job
    │
    ├── Data preparation
    ├── Training
    ├── Evaluation
    └── Registration
```

### Exam shortcut

**One training script → command job**

**Multiple connected ML steps → pipeline job**

---

# 10. GitHub Actions — Azure ML Training

The important workflow step was:

```yaml
- name: Install Azure ML CLI extension
  run: |
    az extension add --name ml --yes
```

Then submit the training job:

```yaml
- name: Run Azure Machine Learning training job
  run: az ml job create -f src/job.yml --stream \
    --resource-group ${{ vars.AZURE_RESOURCE_GROUP }} \
    --workspace-name ${{ vars.AZURE_ML_WORKSPACE }}
```

The GitHub repository configuration used:

```text
AZURE_CREDENTIALS
        → Secret

AZURE_RESOURCE_GROUP
        → Variable

AZURE_ML_WORKSPACE
        → Variable
```

Important:

**GitHub variable names are case-sensitive.**

For example:

```yaml
${{ vars.AZURE_RESOURCE_GROUP }}
```

must exactly match the repository variable name.

---

# 11. Hands-On GitHub Lab

We worked through the Microsoft Learn MLOps lab:

**Automate model training with a manually triggered workflow**

Main flow:

```text
Clone MicrosoftLearning/mslearn-mlops
              ↓
Provision Azure ML infrastructure
              ↓
Create GitHub repository
              ↓
Configure GitHub secrets/variables
              ↓
Create job.yml
              ↓
Create GitHub Actions workflow
              ↓
workflow_dispatch
              ↓
Azure login
              ↓
Azure ML CLI
              ↓
Submit training job
              ↓
Azure ML compute
              ↓
Training
```

---

# 12. GitHub SSH Configuration

We also fixed GitHub authentication for the repository.

Initially:

```text
git push
    ↓
Username/password
```

We checked:

```bash
git remote -v
```

Then tested SSH:

```bash
ssh -T git@github.com
```

Initially there was no SSH key:

```text
~/.ssh/
└── known_hosts
```

We generated an Ed25519 key:

```bash
ssh-keygen -t ed25519 -C "your-github-email@example.com"
```

Started the agent:

```bash
eval "$(ssh-agent -s)"
```

Added the key:

```bash
ssh-add ~/.ssh/id_ed25519
```

Displayed the public key:

```bash
cat ~/.ssh/id_ed25519.pub
```

Added it to GitHub → **Settings → SSH and GPG keys**.

Then configured the repository remote:

```bash
git remote set-url origin git@github.com:YOUR_USERNAME/mslearn-mlops.git
```

This allowed Git operations over SSH.

---

# 13. Troubleshooting Azure ML GitHub Actions

We encountered an authorization error:

```text
Code: AuthorizationFailed
```

This reinforced:

```text
Authentication
      ≠
Authorization
```

Later the workflow successfully reached:

```text
Uploading src
      ↓
RunId generated
      ↓
Web View
      ↓
Incorrect padding
```

The important observation was that a `RunId` had already been generated and source had uploaded.

So the failure appeared during the later command/streaming stage rather than meaning that the entire Azure ML submission had failed.

We considered removing:

```bash
--stream
```

temporarily and checking the job directly in Azure ML Studio.

---

# 14. Feature-Based Development

We then implemented the feature-development workflow.

Updated workflow trigger:

```yaml
on:
  workflow_dispatch:

  pull_request:
    branches:
      - main
```

This means:

```text
Manual execution
       ↓
workflow_dispatch


PR → main
       ↓
GitHub Actions validation
```

---

# 15. Protecting `main`

GitHub:

```text
Settings
   ↓
Branches
   ↓
Add branch protection rule
   ↓
Branch pattern:
main
```

The required protection was:

```text
Require a pull request before merging
```

This prevents direct uncontrolled changes to `main`.

---

# 16. Feature Branch Workflow

Created:

```bash
git checkout -b feature/update-parameters
```

Made a small change to:

```text
src/train-model-parameters.py
```

or:

```text
src/job.yml
```

Then:

```bash
git add .
```

```bash
git commit -m "Adjust training parameters"
```

```bash
git push --set-upstream origin feature/update-parameters
```

Then:

```text
Feature branch
      ↓
Pull Request
      ↓
GitHub Actions
      ↓
Validation
      ↓
Review
      ↓
Merge → main
```

---

# 17. Model Deployment with GitHub Actions

After completing model training automation, we moved to:

**Deploy a model with GitHub Actions**

The key lifecycle:

```text
Train
  ↓
Evaluate
  ↓
Register model
  ↓
Deploy
  ↓
Test
  ↓
Promote
  ↓
Monitor
```

---

# 18. Model Registration

Model registration creates a versioned model asset.

```text
Training
   ↓
Model artifact
   ↓
Model Registry
   ↓
Model v1
Model v2
Model v3
```

This creates a controlled handoff:

```text
Development / CI
       ↓
 Model Registry
       ↓
Deployment / CD
```

### Exam shortcut

**Model registration = handoff between model development/CI and deployment/CD.**

---

# 19. Managed Online Endpoint

We learned the difference between an endpoint and a deployment.

```text
Managed Online Endpoint
        │
        │ stable URL
        ▼
   Deployments
      /    \
     /      \
  blue      green
```

### Endpoint

Provides:

```text
Stable HTTPS endpoint
```

### Deployment

Contains:

```text
Specific model
Compute configuration
Scoring configuration
Environment
```

So:

> **Endpoint = stable entry point**

> **Deployment = actual model serving instance**

---

# 20. Blue-Green Deployment

New model should not immediately replace the production model.

Example:

```text
Endpoint
   │
   ├── blue  → Model v1 → 100%
   │
   └── green → Model v2 →   0%
```

Test green first.

Then:

```text
blue  → 90%
green → 10%
```

Later:

```text
blue  → 50%
green → 50%
```

Finally:

```text
blue  → 0%
green → 100%
```

Mental model:

```text
Deploy
   ↓
Test
   ↓
Small traffic
   ↓
Observe
   ↓
Increase traffic
   ↓
Full production
```

---

# 21. Direct Deployment Testing

We learned that a deployment can be tested without immediately sending production traffic to it.

Example:

```bash
az ml online-endpoint invoke \
  --name $ENDPOINT_NAME \
  --deployment-name green \
  --request-file sample-request.json \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $WORKSPACE_NAME
```

Therefore:

```text
green deployment
      ↓
Direct invocation
      ↓
Prediction test
      ↓
Pass?
```

Only after validation should production traffic be shifted.

---

# 22. Traffic Management and Rollback

Traffic can be controlled between deployments.

Example:

```bash
az ml online-endpoint update \
  --name $ENDPOINT_NAME \
  --traffic "blue=90 green=10" \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $WORKSPACE_NAME
```

If the new model causes problems:

```text
green → problematic
blue  → healthy
```

Rollback:

```bash
az ml online-endpoint update \
  --name $ENDPOINT_NAME \
  --traffic "blue=100 green=0" \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $WORKSPACE_NAME
```

Important:

**Rollback can be achieved by changing traffic; you don't necessarily need to recreate the endpoint.**

---

# 23. GitHub Environments

We then learned how to control deployments with GitHub Environments.

Example:

```text
GitHub
  │
  ├── staging
  │
  └── production
```

A GitHub environment is a **deployment target/control mechanism**.

It is **not an Azure resource**.

---

## GitHub Environment vs Azure ML Environment

Very important AI-300 distinction:

| GitHub Environment            | Azure ML Environment        |
| ----------------------------- | --------------------------- |
| Controls deployments          | Defines ML runtime          |
| `staging`, `production`       | OS/packages/dependencies    |
| Can require approval          | Used by training/inference  |
| Can contain secrets/variables | Used by ML jobs/deployments |
| GitHub feature                | Azure ML feature            |

They are completely different concepts.

---

# 24. Production Approval

A typical workflow:

```text
Build
  ↓
Deploy to staging
  ↓
Automated tests
  ↓
Evidence
  ↓
Production environment
  ↓
Required reviewer
  ↓
Approval
  ↓
Production deployment
```

This allows automation without allowing every successful workflow to immediately affect production.

GitHub environment protection rules can include:

```text
Required reviewers
Branch/tag restrictions
Wait timer
```

---

# 25. Environment-Scoped Configuration

Environment variables can hold values such as:

```text
Azure ML workspace
Endpoint name
Deployment configuration
```

Sensitive information can be stored as:

```text
Environment secrets
```

Only jobs referencing that environment can access its environment-specific secrets, subject to protection rules.

---

# 26. OIDC + GitHub Environments

The stronger production architecture is:

```text
GitHub staging
      ↓
Staging federated identity
      ↓
Azure staging resources


GitHub production
      ↓
Production federated identity
      ↓
Azure production resources
```

This follows the principle of:

> **Least privilege**

A production deployment shouldn't automatically receive unnecessary permissions to unrelated Azure resources.

---

# 27. Model Monitoring

After deployment, we moved into monitoring.

Two major monitoring layers:

```text
                 Production
                     │
          ┌──────────┴──────────┐
          │                     │
          ▼                     ▼
   Endpoint Health        Model Behavior
          │                     │
          ▼                     ▼
   Azure Monitor         Model Monitoring
```

---

# 28. Azure Monitor

Azure Monitor can be used for operational health such as:

```text
Request count
Request latency
Error rate
CPU utilization
Memory utilization
```

Example:

```text
Latency ↑
Errors ↑
CPU ↑
Memory ↑
```

This points toward an **operational/infrastructure problem** that needs investigation.

---

# 29. Model Monitoring

A healthy endpoint does not necessarily mean a healthy model.

Model monitoring can look for:

```text
Data drift
Prediction drift
Data quality
Feature attribution drift
```

---

## Data Drift

Training distribution:

```text
Age:
20–40 → common
```

Production:

```text
Age:
60–80 → common
```

Input distribution changed.

```text
→ Data drift
```

---

## Prediction Drift

Previous predictions:

```text
Low risk  = 80%
High risk = 20%
```

Production:

```text
Low risk  = 40%
High risk = 60%
```

Output distribution changed.

```text
→ Prediction drift
```

---

## Data Quality

Production data:

```text
age = NULL
age = -5
age = "unknown"
```

```text
→ Data quality issue
```

---

## Feature Attribution Drift

The relative contribution/importance of features changes significantly.

```text
Before:
Feature A → major
Feature B → minor

Later:
Feature A → minor
Feature B → major
```

```text
→ Feature attribution drift
```

---

# 30. Monitoring Requires Production Data

The monitoring flow is:

```text
Online Endpoint
       ↓
Data Collection
       ↓
Production data
       ↓
Model Monitoring
       ↓
Compare against reference data
       ↓
Detect changes
```

The key idea:

> **Deploying a model does not automatically mean you have complete model-behavior monitoring configured.**

Production data needs to be collected for monitoring.

---

# 31. Drift Does Not Automatically Mean Retraining

This is a major exam point.

Incorrect mental model:

```text
Drift
  ↓
Retrain immediately
```

Correct:

```text
Drift detected
      ↓
Investigate
      ↓
Understand cause
      ↓
Determine appropriate action
      │
      ├── No retraining
      │
      └── Retraining
```

A drift threshold should be treated as a signal to investigate.

---

# 32. Rollback vs Retraining

Another important exam distinction:

### New deployment is causing the problem

```text
Model v1 → healthy
Model v2 → problematic
```

Action:

```text
ROLLBACK
```

Return traffic to v1.

---

### Production environment/data has fundamentally changed

```text
Old model
    ↓
Production distribution changes
    ↓
Model no longer suitable
```

Action:

```text
RETRAIN
```

Then:

```text
New data
   ↓
Retrain
   ↓
Evaluate
   ↓
Register
   ↓
Deploy
   ↓
Test
   ↓
Promote
```

---

# 33. Complete Day 6 MLOps Mental Map

```text
                         MLOps
                           │
                           ▼
                    SOURCE CONTROL
                           │
                           ▼
                    GitHub Repository
                           │
                           ▼
                    GitHub Actions
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
          Validation                Training
          Lint/Test                 Azure ML
              │                         │
              └────────────┬────────────┘
                           ▼
                     Model Registry
                           │
                           ▼
                     Model Version
                           │
                           ▼
                  Managed Endpoint
                           │
                    ┌──────┴──────┐
                    ▼             ▼
                  blue          green
                Model v1       Model v2
                    │             │
                    │        Direct test
                    │             │
                    │             ▼
                    │        Acceptance
                    │             │
                    └──────┬──────┘
                           ▼
                    Traffic Shift
                           │
                           ▼
                      Production
                           │
                ┌──────────┴──────────┐
                ▼                     ▼
          Azure Monitor         Model Monitor
                │                     │
        errors/latency          drift/quality
        CPU/memory              predictions
                │                     │
                └──────────┬──────────┘
                           ▼
                       INVESTIGATE
                       /          \
                      /            \
                Rollback          Retrain
                  │                 │
                  └────────┬────────┘
                           ▼
                       Production
```

---

# 34. AI-300 Exam Cheat Sheet

| Situation                                | Remember                          |
| ---------------------------------------- | --------------------------------- |
| Automate ML training                     | **GitHub Actions + Azure ML job** |
| Single training script                   | **Command job**                   |
| Multiple ML steps                        | **Pipeline job**                  |
| Manual workflow execution                | `workflow_dispatch`               |
| Validate PR                              | `pull_request`                    |
| External event                           | `repository_dispatch`             |
| Protect `main`                           | **Pull request requirement**      |
| Stable model API URL                     | **Managed online endpoint**       |
| Specific model serving                   | **Deployment**                    |
| Test model without users                 | **Directly invoke deployment**    |
| New model without immediate traffic      | **0% traffic**                    |
| Gradual rollout                          | **Traffic splitting**             |
| Keep old/new models                      | **Blue-green deployments**        |
| New model causes production issue        | **Rollback**                      |
| Production data fundamentally changes    | **Retrain**                       |
| Endpoint latency/errors                  | **Azure Monitor**                 |
| Data drift                               | **Model monitoring**              |
| Prediction distribution changes          | **Prediction drift**              |
| Bad/missing production data              | **Data quality**                  |
| Feature importance changes               | **Feature attribution drift**     |
| Drift detected                           | **Investigate first**             |
| GitHub → Azure without long-lived secret | **OIDC**                          |
| Production deployment approval           | **GitHub Environment**            |
| ML dependencies/runtime                  | **Azure ML Environment**          |
| GitHub deployment target                 | **GitHub Environment**            |
| Versioned model handoff                  | **Model Registry**                |

---

# Day 6 Final Status

```text
AI-300
  │
  └── MLOps
       │
       ├── Automate model training with GitHub Actions     ✓
       ├── GitHub Actions CI/CD                           ✓
       ├── Azure authentication                           ✓
       ├── Azure ML command jobs                          ✓
       ├── Feature-based development                      ✓
       ├── Pull requests                                  ✓
       ├── Branch protection                              ✓
       ├── Model registration                             ✓
       ├── Model deployment                               ✓
       ├── Managed online endpoints                       ✓
       ├── Blue-green deployment                          ✓
       ├── Traffic management                             ✓
       ├── Rollback                                       ✓
       ├── GitHub Environments                             ✓
       ├── Production approval                             ✓
       ├── OIDC                                           ✓
       ├── Endpoint monitoring                            ✓
       ├── Model monitoring                               ✓
       ├── Data drift                                     ✓
       ├── Prediction drift                               ✓
       ├── Data quality                                   ✓
       ├── Feature attribution drift                      ✓
       └── Retraining / rollback decisions                 ✓
       
       MLOps MODULE: COMPLETED
       
       NEXT → GenAIOps
```


