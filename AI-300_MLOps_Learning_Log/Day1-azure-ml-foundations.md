# AI-300 — Day 1 Log - 09/09/2026
## AI-300 Overview + Azure Machine Learning Foundations

**Day:** 1  
**Focus:** Azure Machine Learning foundations  
**Status:** ✅ Completed  
**Goal:** Understand the Azure ML object model and how the pieces fit into an MLOps workflow.

---

# 1. AI-300 Exam Context

AI-300 focuses on operationalizing:

1. Machine Learning
2. Generative AI

Major exam areas:

- Design and implement an MLOps infrastructure
- Implement the ML lifecycle and operationalize ML solutions
- Design and implement GenAIOps infrastructure
- Implement generative AI quality assurance and observability
- Optimize generative AI and ML solutions

For Day 1, the main focus is understanding the Azure ML platform and its core objects.

---

# 2. Azure ML — Big Picture

Azure Machine Learning is an Azure platform for managing the ML lifecycle.

Typical lifecycle:

```text
Data
  ↓
Experiment
  ↓
Training
  ↓
Evaluation
  ↓
Model
  ↓
Registry
  ↓
Deployment
  ↓
Monitoring
````

Azure ML provides the infrastructure and operational objects around this lifecycle.

---

# 3. Main Azure ML Objects

## Workspace

### Simple meaning

Central place for an ML project/workload.

### Mental model

```text
Azure ML Workspace
│
├── Data
├── Compute
├── Environments
├── Components
├── Jobs
├── Models
├── Endpoints
└── Experiments
```

### Remember

> Workspace = ML project/operational boundary.

Do NOT confuse it with an Azure Resource Group.

---

# 4. Azure Resource Group vs Azure ML Workspace

```text
Subscription
    ↓
Resource Group
    ↓
Azure ML Workspace
```

### Resource Group

Logical management container for Azure resources.

### Workspace

Logical/operational boundary for Azure ML work.

### Important

```text
Resource Group ≠ Workspace
```

A Resource Group is an Azure resource-management concept.

A Workspace is an ML platform/project concept.

---

# 5. Datastore

## Simple meaning

A registered connection/reference to storage.

Example:

```text
Azure ML
   ↓
Datastore
   ↓
ADLS Gen2 / Blob Storage
```

### Remember

> Datastore = WHERE/HOW to access storage.

It is NOT the actual dataset.

---

# 6. Data Asset

## Simple meaning

A reusable/versioned representation of ML data.

Example:

```text
customer-training-data:v1
customer-training-data:v2
customer-training-data:v3
```

### Why use it?

For reproducibility.

Instead of:

```text
latest.csv
```

use a versioned data asset.

That allows us to determine exactly which version was used to train a model.

### Remember

> Data asset = WHAT ML data we are using.

---

# 7. Datastore vs Data Asset

| Concept    | Meaning                                        |
| ---------- | ---------------------------------------------- |
| Datastore  | Connection/reference to storage                |
| Data asset | ML data resource, typically versioned/reusable |

Mental model:

```text
Datastore → WHERE/HOW
Data Asset → WHAT
```

---

# 8. Compute

Compute provides the execution resources for ML workloads.

## Compute Instance

Mental model:

```text
Developer ML VM
```

Useful for interactive development.

## Compute Cluster

Mental model:

```text
Pool of scalable VMs
```

Useful for training workloads.

Example:

```text
Training workload
      ↓
Compute Cluster
      ↓
VMs
```

### Remember

> Compute = WHERE the ML workload runs.

---

# 9. Environment

An environment defines the software/runtime required to execute ML code.

Example:

```text
Python 3.11
pandas
numpy
scikit-learn
mlflow
```

Mental model:

```text
Training code
      +
Dependencies
      ↓
Environment
```

### Connection to Docker

Similar mental model:

```text
Docker image
      ≈
Azure ML environment/runtime
```

The goal is reproducibility:

```text
"It works on my laptop"
          ❌

Same defined environment everywhere
          ✅
```

### Remember

> Environment = SOFTWARE + DEPENDENCIES + RUNTIME.

---

# 10. Environment vs Compute

Very important exam distinction.

```text
Environment
    ↓
Software / dependencies

Compute
    ↓
Execution resources / machines
```

Example:

```text
Python 3.11 + sklearn
        → Environment

GPU VM pool
        → Compute
```

---

# 11. Job

A job represents the actual execution of an ML workload.

Conceptually:

```text
Data Asset
    +
Environment
    +
Compute
    +
Code
    ↓
   JOB
    ↓
 Model / Metrics / Logs
```

### Remember

> Job = actual execution.

Do NOT confuse:

```text
Compute ≠ Job
```

Compute provides resources.

The job uses those resources to execute the workload.

---

# 12. Component

A component is a reusable ML workflow building block.

Example:

```text
preprocess_data
train_model
evaluate_model
```

Then:

```text
Pipeline
   │
   ├── preprocess component
   ├── train component
   └── evaluate component
```

### Remember

> Component = reusable workflow building block.

Do NOT confuse:

```text
Component ≠ Job
```

Component = reusable definition.

Job = execution.

---

# 13. Model

A trained model is the output/artifact of training.

Example:

```text
model.pkl
```

Operationally, we want the model to have:

* version
* metadata
* lineage
* relationship to training data
* relationship to training run

Example:

```text
fraud-model:v1
fraud-model:v2
fraud-model:v3
```

---

# 14. Registry

A registry allows reusable ML assets to be shared across workspaces.

Example:

```text
Dev Workspace
      │
      ├───────────────┐
      │               │
      ▼               ▼
   Registry       Registry
      │
      ↓
Prod Workspace
```

More generally:

```text
Registry
│
├── Models
├── Components
└── Environments
```

### Remember

> Workspace = where I work
> Registry = where I publish/share reusable ML assets

This is particularly useful when multiple workspaces such as Dev/Test/Prod need common reusable assets.

---

# 15. Core Azure ML Mental Model

Memorize this relationship:

```text
Data Asset
     +
Environment
     +
Compute
     +
Code
     ↓
   JOB
     ↓
  MODEL
```

Expanded version:

```text
                    Azure ML Workspace
                           │
          ┌────────────────┼─────────────────┐
          │                │                 │
          ▼                ▼                 ▼
      Data Asset      Environment         Compute
          │                │                 │
          └────────────────┼─────────────────┘
                           ↓
                          Job
                           ↓
                         Model
                           ↓
                       Registry
```

---

# 16. Correct Architecture

Important: Data, environment and compute do NOT form a sequential data-flow.

Incorrect:

```text
ADLS
 ↓
Datastore
 ↓
Compute
 ↓
Job
 ↓
Model
```

Better mental model:

```text
                    ADLS Gen2
                        │
                        ▼
                    Datastore
                        │
                        ▼
                    Data Asset
                        │
                        │
           ┌────────────┼────────────┐
           │            │            │
           ▼            ▼            ▼
       Data Asset   Environment   Compute
           │            │            │
           └────────────┼────────────┘
                        ▼
                       Job
                        ↓
                      Model
                        ↓
                     Registry
```

Even more accurately:

```text
Data Asset ─────┐
                │
Environment ────┼──→ Training Job ──→ Model
                │
Compute ────────┘
```

---

# 17. Azure ML Workspace Supporting Resources

Conceptually:

```text
Azure ML Workspace
       │
       ├── Storage
       ├── Key Vault
       ├── Container Registry
       └── Monitoring-related resources
```

These are Azure services/resources that support ML workloads.

Important:

> Do not think that the workspace is literally the same thing as these resources.

The workspace is an Azure ML resource that works with supporting Azure resources.

---

# 18. Identity + RBAC

Training workloads need identities to access Azure resources.

Example:

```text
Training Job
     ↓
Managed Identity
     ↓
Microsoft Entra ID authentication
     ↓
RBAC authorization
     ↓
ADLS Gen2
```

Avoid:

```text
Storage account key hardcoded in train.py
```

Prefer identity-based access.

Example conceptual permission:

```text
ML workload identity
       ↓
Storage Blob Data Reader
       ↓
Storage / ADLS Gen2
```

### Important

Authentication:

> Who are you?

Authorization:

> What are you allowed to do?

Managed Identity helps with identity/authentication.

RBAC determines permissions.

---

# 19. Azure CLI — Basic Workspace Setup

## Login

```bash
az login
```

### Purpose

Authenticate to Azure.

---

## Check current subscription

```bash
az account show
```

---

## List subscriptions

```bash
az account list -o table
```

---

## Select subscription

```bash
az account set --subscription "<subscription-id>"
```

---

## Create Resource Group

```bash
az group create \
  --name rg-ai300-mlops \
  --location eastus
```

### Important arguments

```text
--name
    Resource group name

--location
    Azure region
```

---

## Create Azure ML Workspace

```bash
az ml workspace create \
  --name aml-ai300-mlops \
  --resource-group rg-ai300-mlops \
  --location eastus
```

### Important arguments

```text
--name
    Workspace name

--resource-group
    Resource group containing the workspace

--location
    Azure region
```

---

## Verify Workspace

```bash
az ml workspace show \
  --name aml-ai300-mlops \
  --resource-group rg-ai300-mlops
```

---

# 20. CLI Mental Model

```text
az
 ↓
Azure CLI
 ↓
ml
 ↓
Azure Machine Learning commands
```

Examples:

```bash
az ml workspace ...
az ml job ...
```

Do not waste time memorizing every CLI option.

Understand:

* what resource you're creating
* where it belongs
* what the resource does

---

# 21. DevOps Knowledge → Azure ML

Use the following mapping to connect existing knowledge.

| Existing knowledge                   | Azure ML connection                               |
| ------------------------------------ | ------------------------------------------------- |
| Azure Resource Group                 | Azure resource-management boundary                |
| Managed Identity                     | Workload/service identity                         |
| RBAC                                 | Access authorization                              |
| Storage                              | ML data/artifacts                                 |
| Docker                               | Runtime/dependency reproducibility                |
| Git                                  | Source/version control                            |
| GitHub Actions                       | CI/CD                                             |
| MLflow                               | Experiment tracking                               |
| Application Insights / Log Analytics | Monitoring/observability                          |
| Terraform/Bicep                      | Infrastructure as Code                            |
| Kubernetes                           | Useful background for compute/deployment concepts |

---

# 22. Exam Traps

## Trap 1

Datastore = Dataset

❌ Wrong

```text
Datastore → storage connection/reference
Data asset → ML data
```

---

## Trap 2

Environment = Compute

❌ Wrong

```text
Environment → software/runtime
Compute → machines/resources
```

---

## Trap 3

Compute = Job

❌ Wrong

```text
Compute → resources
Job → execution
```

---

## Trap 4

Component = Job

❌ Wrong

```text
Component → reusable workflow building block
Job → execution of workload
```

---

## Trap 5

Workspace = Resource Group

❌ Wrong

```text
Resource Group → Azure resource-management boundary
Workspace → ML operational/project boundary
```

---

## Trap 6

Registry = Workspace

❌ Wrong

```text
Workspace → ML project/workspace
Registry → shared/reusable ML assets
```

---

# 23. Day 1 Exam Practice Results

## Understanding Questions

1. Datastore vs Data Asset
   ✅ Correct

2. Environment vs Compute
   ✅ Correct

3. Component vs Job
   ✅ Correct

4. Registry purpose
   ✅ Correct

5. Requirements: data + software + execution resources
   ✅ Correct after correction

---

## Scenario Questions

6. Reusable preprocessing logic
   ✅ B — Component

7. Reproducible training data version
   ✅ B — Versioned Data Asset

8. Scalable 8–20 VM workload
   ✅ B — Compute Cluster

9. Share assets across workspaces
   ✅ B — Registry

10. Secure storage access
    ✅ C — Managed Identity + RBAC

### Score

```text
Understanding: 5/5
Scenario:       5/5
Overall:        Excellent
```

---

# 24. Day 1 Important Corrections

These were the concepts that initially caused confusion:

### Correction 1

A compute cluster is not the job.

```text
Compute cluster = execution resources
Job = actual execution
```

### Correction 2

Data asset, environment and compute are not components.

```text
Data Asset → data
Environment → software
Compute → infrastructure
Component → reusable workflow step
```

### Correction 3

Datastore does not equal data asset.

```text
Datastore → storage connection/reference
Data asset → ML data resource
```

---

# 25. Day 1 Final Cheat Sheet

```text
WORKSPACE
Central ML project/operational boundary

RESOURCE GROUP
Azure resource-management container

DATASTORE
Connection/reference to storage

DATA ASSET
Versioned/reusable ML data

ENVIRONMENT
Software + dependencies + runtime

COMPUTE
Execution resources

JOB
Actual execution

COMPONENT
Reusable workflow building block

MODEL
Trained ML artifact

REGISTRY
Share/reuse ML assets across workspaces
```

---

# 26. One-Line Memory Trick

```text
Datastore = WHERE
Data Asset = WHAT
Environment = SOFTWARE
Compute = WHERE IT RUNS
Job = EXECUTION
Component = REUSABLE STEP
Model = RESULT
Registry = SHARE
Workspace = PROJECT
```

---

# 27. Day 1 Redo Checklist

When revisiting this day, redo the following without looking at the answers:

```text
[ ] Explain Workspace
[ ] Explain Resource Group
[ ] Explain Datastore
[ ] Explain Data Asset
[ ] Explain Compute Instance
[ ] Explain Compute Cluster
[ ] Explain Environment
[ ] Explain Component
[ ] Explain Job
[ ] Explain Model
[ ] Explain Registry

[ ] Explain Datastore vs Data Asset
[ ] Explain Environment vs Compute
[ ] Explain Component vs Job
[ ] Explain Workspace vs Registry
[ ] Explain Workspace vs Resource Group

[ ] Draw Azure ML architecture from memory
[ ] Explain Managed Identity + RBAC flow
[ ] Create Resource Group using Azure CLI
[ ] Create Azure ML Workspace using Azure CLI
[ ] Verify Workspace

[ ] Answer Day 1 scenario questions again
```

---

# 28. Day 1 Architecture From Memory

Try to recreate this without looking:

```text
GitHub
   ↓
GitHub Actions
   ↓
Azure / Bicep
   ↓
Resource Group
   ↓
Azure ML Workspace
   ↓
Data + Environment + Compute
   ↓
Training Job
   ↓
MLflow / Experiment Tracking
   ↓
Model
   ↓
Registry
   ↓
Deployment
   ↓
Monitoring
```

This architecture will be continuously extended throughout the remaining 13 days.

---

# 29. Next — Day 2

## Azure ML Experimentation + MLflow

We will add:

```text
Training Job
      ↓
Experiment
      ↓
MLflow
 ┌────┼────────────┐
 ↓    ↓            ↓
Params Metrics   Artifacts
             ↓
            Model
```

Topics:

* Azure ML jobs and experiments
* MLflow tracking in Azure ML
* Parameters
* Metrics
* Artifacts
* Model logging
* Model registration
* Reproducibility
* Run comparison
* Practical MLflow workflow
* AI-300 scenario questions
