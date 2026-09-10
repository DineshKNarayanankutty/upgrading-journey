# AI-300 — Day 2 Log - 10/09/2026
## Azure ML Experimentation + MLflow

**Day:** 2  
**Focus:** Azure ML Experimentation + MLflow  
**Status:** ✅ Completed  
**Goal:** Understand experiment tracking with MLflow, run training jobs in Azure ML, track parameters/metrics/artifacts, compare runs, and manage model versions.

---

# 1. Day 2 Objective

Understand how Azure ML and MLflow work together:

```text
Training Code
     ↓
Azure ML Job
     ↓
Experiment / Run
     ↓
MLflow Tracking
 ┌────┼─────────────┐
 ↓    ↓             ↓
Params Metrics   Artifacts
                  ↓
                Model
````

Core idea:

> Azure ML executes the workload; MLflow tracks what happened during the workload.

---

# 2. Experiment

An experiment groups related ML training runs.

Example:

```text
Experiment: iris-random-forest
│
├── Run 1
├── Run 2
└── Run 3
```

Why?

To organize and compare different training executions.

---

# 3. Run

A run represents **one execution** of ML code.

Example:

```text
Run 1
├── n_estimators = 100
├── max_depth = 5
└── accuracy = 1.0
```

Another execution:

```text
Run 2
├── n_estimators = 200
├── max_depth = 10
└── accuracy = 1.0
```

---

# 4. Parameters

Parameters are configuration/hyperparameter values used during training.

Examples:

```text
learning_rate
batch_size
epochs
max_depth
n_estimators
```

MLflow:

```python
mlflow.log_param("n_estimators", n_estimators)
mlflow.log_param("max_depth", max_depth)
```

Example:

```text
n_estimators = 100
max_depth = 5
```

### Memory trick

> Parameter = What settings did I USE?

---

# 5. Metrics

Metrics represent model performance/results.

Examples:

```text
accuracy
precision
recall
f1_score
RMSE
MAE
```

MLflow:

```python
mlflow.log_metric("accuracy", accuracy)
```

Example:

```text
accuracy = 1.0
```

### Memory trick

> Metric = What result did I GET?

---

# 6. Artifacts

Artifacts are files associated with an ML run.

Examples:

```text
model.pkl
metrics.txt
confusion_matrix.png
predictions.csv
training_report.json
```

MLflow:

```python
mlflow.log_artifact("metrics.txt")
```

### Memory trick

> Artifact = FILE associated with the run.

---

# 7. Parameter vs Metric vs Artifact

| Type      | Meaning                | Example        |
| --------- | ---------------------- | -------------- |
| Parameter | Training configuration | `max_depth=5`  |
| Metric    | Performance/result     | `accuracy=1.0` |
| Artifact  | File                   | `metrics.txt`  |
| Model     | Trained ML model       | `model.pkl`    |

Memory:

```text
Parameter → What did I USE?
Metric    → What did I GET?
Artifact  → What FILE did I produce/use?
Model     → What did I TRAIN?
```

---

# 8. Why Experiment Tracking?

Without experiment tracking:

```text
python train.py
       ↓
accuracy = 0.91

Change something

python train.py
       ↓
accuracy = 0.94
```

Later:

```text
"What exactly changed?"
```

May not be known.

With MLflow:

```text
Run 1
├── Parameters
├── Metrics
└── Artifacts

Run 2
├── Parameters
├── Metrics
└── Artifacts
```

Now the runs can be compared systematically.

---

# 9. MLflow

MLflow is used for ML lifecycle tracking and management.

For today's workflow, the important areas are:

```text
MLflow
│
├── Parameters
├── Metrics
├── Artifacts
└── Models
```

MLflow allows us to record what happened during training.

---

# 10. MLflow Run Lifecycle

Conceptually:

```text
START RUN
   ↓
Log parameters
   ↓
Train model
   ↓
Calculate metrics
   ↓
Log metrics
   ↓
Save artifacts
   ↓
Log model/artifact
   ↓
END RUN
```

---

# 11. Local MLflow Setup

Local architecture:

```text
Your PC
  │
  ▼
train.py
  │
  ▼
MLflow Server
localhost:5000
  │
  ▼
MLflow UI
```

The local tracking URI was:

```python
mlflow.set_tracking_uri("http://127.0.0.1:5000")
```

This tells the MLflow client where the tracking server is.

---

# 12. Local Training Code

The training code used:

```python
import mlflow
import mlflow.sklearn

from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score


# Load data
data = load_iris()

X = data.data
y = data.target


# Train/test split
X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42
)


# Hyperparameters
n_estimators = 100
max_depth = 5


# Train model
model = RandomForestClassifier(
    n_estimators=n_estimators,
    max_depth=max_depth,
    random_state=42
)

model.fit(X_train, y_train)


# Evaluate
predictions = model.predict(X_test)
accuracy = accuracy_score(y_test, predictions)


# MLflow
mlflow.set_tracking_uri("http://127.0.0.1:5000")

mlflow.set_experiment("iris-random-forest")

with mlflow.start_run():

    mlflow.log_param("n_estimators", n_estimators)
    mlflow.log_param("max_depth", max_depth)

    mlflow.log_metric("accuracy", accuracy)

    mlflow.sklearn.log_model(
        model,
        name="model"
    )

    # Save metrics as an artifact
    with open("metrics.txt", "w") as f:
        f.write(f"accuracy={accuracy}\n")

    mlflow.log_artifact("metrics.txt")


print(f"Accuracy: {accuracy}")
```

---

# 13. Important MLflow API Update

Initially, the older model logging syntax produced a warning:

```text
`artifact_path` is deprecated.
Please use `name` instead.
```

Old style:

```python
mlflow.sklearn.log_model(
    model,
    artifact_path="model"
)
```

Current MLflow 3.x style:

```python
mlflow.sklearn.log_model(
    model,
    name="model"
)
```

Our local MLflow version:

```text
MLflow 3.16.0
```

Therefore:

```text
name="model"
```

was used.

### Important lesson

Always check the current MLflow/Azure ML documentation before using older tutorials or API examples.

---

# 14. Local MLflow Verification

The local MLflow UI showed the training runs.

Verified:

```text
Experiment
    ↓
iris-random-forest
    ↓
Runs
```

Each run contained:

```text
Parameters
├── n_estimators
└── max_depth

Metrics
└── accuracy

Model
└── model

Artifacts
└── metrics.txt
```

### Result

✅ Local MLflow tracking worked successfully.

---

# 15. Azure ML + MLflow

Azure ML is MLflow-compatible.

Instead of:

```text
Local Python
    ↓
localhost:5000
    ↓
Local MLflow Server
```

Azure ML provides an MLflow tracking endpoint associated with the workspace.

Conceptually:

```text
Azure ML Workspace
       ↓
Azure ML Job
       ↓
Training Code
       ↓
MLflow
       ↓
Parameters
Metrics
Artifacts
```

---

# 16. Azure ML Tracking URI

The workspace tracking URI can be obtained with:

```bash
az ml workspace show \
  --name <WORKSPACE_NAME> \
  --resource-group <RESOURCE_GROUP> \
  --query mlflow_tracking_uri \
  -o tsv
```

Example output:

```text
azureml://...
```

### Important

The Azure ML tracking URI is **not a browser/UI URL**.

It is an endpoint used by the MLflow client.

Therefore:

```text
MLflow Tracking URI
        ≠
Browser URL
```

To inspect Azure ML jobs, use:

```text
Azure ML Studio
```

---

# 17. Azure-Ready `train.py`

For Azure ML, the local tracking URI was removed:

```python
# Removed
mlflow.set_tracking_uri("http://127.0.0.1:5000")
```

Azure-ready version:

```python
import mlflow
import mlflow.sklearn
import joblib

from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score


# Load data
data = load_iris()

X = data.data
y = data.target


# Train/test split
X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42
)


# Hyperparameters
n_estimators = 100
max_depth = 5


# Train model
model = RandomForestClassifier(
    n_estimators=n_estimators,
    max_depth=max_depth,
    random_state=42
)

model.fit(X_train, y_train)


# Evaluate
predictions = model.predict(X_test)
accuracy = accuracy_score(y_test, predictions)


# MLflow
mlflow.set_experiment("iris-random-forest")

with mlflow.start_run():

    mlflow.log_param("n_estimators", n_estimators)
    mlflow.log_param("max_depth", max_depth)

    mlflow.log_metric("accuracy", accuracy)

    # Save model as file
    joblib.dump(model, "model.pkl")

    # Log model file as artifact
    mlflow.log_artifact("model.pkl")

    # Save metrics as artifact
    with open("metrics.txt", "w") as f:
        f.write(f"accuracy={accuracy}\n")

    mlflow.log_artifact("metrics.txt")


print(f"Accuracy: {accuracy}")
```

---

# 18. Why `model.pkl` Instead of `mlflow.sklearn.log_model()`?

We initially used:

```python
mlflow.sklearn.log_model(
    model,
    name="model"
)
```

Locally, this worked with MLflow 3.16.0.

However, the Azure ML job failed at:

```text
/api/2.0/mlflow/logged-models
```

with:

```text
404
```

Error:

```text
mlflow.exceptions.MlflowException:
API request to endpoint
/api/2.0/mlflow/logged-models
failed with error code 404
```

The training itself was successful.

The failure occurred specifically while attempting to create the MLflow Logged Model.

---

# 19. Troubleshooting the MLflow 3.x / Azure ML Issue

Architecture during the failure:

```text
Azure ML Job
    ↓
train.py
    ↓
model.fit()
    ↓
SUCCESS
    ↓
log_param()
    ↓
SUCCESS
    ↓
log_metric()
    ↓
SUCCESS
    ↓
mlflow.sklearn.log_model()
    ↓
/api/2.0/mlflow/logged-models
    ↓
404 ❌
```

Therefore the problem was not:

```text
Python
RandomForest
Dataset
Training
Accuracy
```

It was the MLflow model-logging API compatibility with the Azure ML tracking backend.

---

# 20. Workaround

Instead of using:

```python
mlflow.sklearn.log_model(
    model,
    name="model"
)
```

we saved the model using Joblib:

```python
joblib.dump(model, "model.pkl")
```

Then logged it as an artifact:

```python
mlflow.log_artifact("model.pkl")
```

This successfully allowed the Azure ML job to complete.

---

# 21. Final Azure ML Job Architecture

```text
                Azure ML Workspace
                       │
                       ▼
                 Command Job
                       │
              ┌────────┼────────┐
              ▼        ▼        ▼
           Compute Environment Code
                                │
                                ▼
                            train.py
                                │
                                ▼
                              MLflow
                        ┌───────┼────────┐
                        ▼       ▼        ▼
                    Params   Metrics  Artifacts
                                      │
                              ┌───────┴───────┐
                              ▼               ▼
                          model.pkl      metrics.txt
```

---

# 22. Azure ML Job YAML

Created:

```text
job.yml
```

Code:

```yaml
$schema: https://azuremlschemas.azureedge.net/latest/commandJob.schema.json

code: .

command: python train.py

environment: azureml://registries/azureml/environments/sklearn-1.5/labels/latest

compute: azureml:<YOUR_COMPUTE_NAME>

display_name: iris-mlflow-training

experiment_name: iris-random-forest

description: Train Random Forest on Iris dataset and track with MLflow.
```

Replace:

```text
<YOUR_COMPUTE_NAME>
```

with the Azure ML compute created during Day 1.

Example:

```yaml
compute: azureml:cpu-cluster
```

---

# 23. Check Azure ML Compute

Command:

```bash
az ml compute list \
  --resource-group <RESOURCE_GROUP> \
  --workspace-name <WORKSPACE_NAME> \
  -o table
```

Example:

```text
Name          Type
------------  -------
cpu-cluster   amlcompute
```

---

# 24. Submit Azure ML Job

Command:

```bash
az ml job create \
  --file job.yml \
  --resource-group <RESOURCE_GROUP> \
  --workspace-name <WORKSPACE_NAME> \
  --web
```

This submits the Command Job to Azure ML and opens the job in Azure ML Studio.

---

# 25. Azure ML Job Result

The job completed successfully after changing model logging to an artifact.

Verified in Azure ML Studio:

```text
Experiment:
iris-random-forest
```

The Azure run produced the same result as the local run.

Verified:

```text
Parameters
├── n_estimators
└── max_depth

Metrics
└── accuracy

Artifacts
├── model.pkl
└── metrics.txt
```

### Result

✅ Azure ML execution
✅ MLflow experiment tracking
✅ Parameters
✅ Metrics
✅ Artifacts
✅ Model artifact

---

# 26. Model Registration

The trained model was registered in Azure ML.

Model:

```text
iris-random-forest
```

Version:

```text
1
```

Conceptually:

```text
Training Run 1
      ↓
model.pkl
      ↓
Azure ML Model
      ↓
iris-random-forest:1
```

---

# 27. Run 2 — Hyperparameter Experiment

Changed:

```python
n_estimators = 100
max_depth = 5
```

to:

```python
n_estimators = 200
max_depth = 10
```

Everything else remained the same.

Submitted the second Azure ML Job.

---

# 28. Run Comparison

Compared the two Azure ML jobs.

Results:

| Parameter / Metric | Run 1 | Run 2 |
| ------------------ | ----: | ----: |
| `n_estimators`     |   100 |   200 |
| `max_depth`        |     5 |    10 |
| `accuracy`         |   1.0 |   1.0 |

Therefore:

```text
Run 1 accuracy = 1.0
Run 2 accuracy = 1.0
```

The hyperparameter change did **not improve accuracy** on this particular Iris dataset/test split.

This is still a successful experiment because the objective was to demonstrate controlled experimentation and comparison.

---

# 29. Model Versioning

Registered models:

```text
iris-random-forest
│
├── Version 1 → Run 1 model
└── Version 2 → Run 2 model
```

Concept:

> Each trained model can be stored as a versioned model asset so that different model versions can be managed and used later.

---

# 30. MLflow 3.x Logged Models — Important Modern Concept

MLflow 3 introduced **Logged Models as first-class entities**.

Conceptually:

```text
Experiment
│
├── Runs
│   ├── Parameters
│   ├── Metrics
│   └── Artifacts
│
└── Logged Models
```

For this Day 2 exercise, the Azure ML backend did not accept the newer Logged Models API used by the MLflow 3.x client, so we used:

```text
model.pkl
    ↓
mlflow.log_artifact()
```

instead.

Don't confuse:

```text
MLflow Logged Model
```

with:

```text
Azure ML Registered Model
```

They are related but are not identical concepts.

---

# 31. Important Distinctions

## Azure ML Job vs MLflow

```text
Azure ML Job
    ↓
EXECUTES workload
```

```text
MLflow
    ↓
TRACKS workload
```

---

## Experiment vs Run

```text
Experiment
    ↓
Groups related runs
```

```text
Run
    ↓
One execution
```

---

## Parameter vs Metric

```text
Parameter
    ↓
Configuration

Metric
    ↓
Performance
```

---

## Artifact vs Model

```text
Artifact
    ↓
File associated with run

Model
    ↓
Trained ML model
```

---

## Tracking URI vs UI

```text
MLflow Tracking URI
    ↓
Connection endpoint used by MLflow
```

```text
Azure ML Studio
    ↓
Web interface for inspecting jobs/runs
```

---

# 32. AI-300 Scenario Patterns

### Scenario 1

> Record the learning rate used for training.

Answer:

```text
Parameter
```

---

### Scenario 2

> Record the F1 score produced by the model.

Answer:

```text
Metric
```

---

### Scenario 3

> Preserve a confusion matrix PNG.

Answer:

```text
Artifact
```

---

### Scenario 4

> Represent one execution of training code.

Answer:

```text
Run
```

---

### Scenario 5

> Group multiple related training executions.

Answer:

```text
Experiment
```

---

### Scenario 6

> Compare 20 training runs with different hyperparameters and identify the highest F1 score.

Answer:

```text
Use MLflow/Azure ML experiment tracking
to compare runs by their metrics and parameters.
```

---

### Scenario 7

> Execute the training workload on Azure compute.

Answer:

```text
Azure ML Job
```

---

# 33. Day 2 Exam Cheat Sheet

```text
Experiment
= Group of related runs

Run
= One execution

Parameter
= Training configuration

Metric
= Performance/result

Artifact
= File

Model
= Trained ML model

MLflow
= Experiment/lifecycle tracking

Azure ML Job
= Workload execution

Azure ML Model
= Managed/versioned model asset

Tracking URI
= MLflow connection endpoint

Azure ML Studio
= Web UI for inspecting ML workloads
```

---

# 34. One-Line Memory Trick

```text
EXPERIMENT = GROUP
RUN        = EXECUTION
PARAMETER  = INPUT/CONFIGURATION
METRIC     = RESULT
ARTIFACT   = FILE
MODEL      = TRAINED RESULT
MLFLOW     = TRACK
JOB        = EXECUTE
REGISTRY   = MANAGE/SHARE/VERSION
```

---

# 35. Day 2 End-to-End Architecture

```text
                    Azure ML Workspace
                           │
                           ▼
                     Experiment
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
            Run 1                     Run 2
              │                         │
       ┌──────┼──────┐          ┌──────┼──────┐
       ▼      ▼      ▼          ▼      ▼      ▼
    Params Metrics Artifacts Params Metrics Artifacts
       │      │      │          │      │      │
       └──────┴──────┘          └──────┴──────┘
              │                         │
              ▼                         ▼
          Model v1                  Model v2
              │                         │
              └────────────┬────────────┘
                           ▼
                   Azure ML Model
                       Registry
```

---

# 36. Day 2 Redo Checklist

When revisiting Day 2, redo everything without looking at the answers.

## Concepts

```text
[ ] Explain Experiment
[ ] Explain Run
[ ] Explain Parameter
[ ] Explain Metric
[ ] Explain Artifact
[ ] Explain Model
[ ] Explain MLflow
[ ] Explain Azure ML Job
[ ] Explain Tracking URI
[ ] Explain Model Version
```

## Distinctions

```text
[ ] Experiment vs Run
[ ] Parameter vs Metric
[ ] Metric vs Artifact
[ ] Artifact vs Model
[ ] Azure ML Job vs MLflow
[ ] Tracking URI vs UI
[ ] MLflow Model vs Azure ML Model
```

## Hands-on

```text
[ ] Start local MLflow server
[ ] Run train.py locally
[ ] Create iris-random-forest experiment
[ ] Create MLflow run
[ ] Log parameters
[ ] Log metrics
[ ] Log artifacts
[ ] Inspect run in MLflow UI

[ ] Remove localhost tracking URI
[ ] Create Azure ML-ready train.py
[ ] Create job.yml
[ ] Identify Azure ML compute
[ ] Submit Command Job
[ ] Inspect Azure ML Job
[ ] Verify parameters
[ ] Verify metrics
[ ] Verify artifacts

[ ] Register model
[ ] Create model version 1
[ ] Change hyperparameters
[ ] Submit second job
[ ] Compare Run 1 and Run 2
[ ] Register model version 2
```

## Troubleshooting

```text
[ ] Understand localhost tracking URI
[ ] Understand Azure ML tracking URI
[ ] Understand why Azure tracking URI is not a browser URL
[ ] Recognize MLflow API compatibility problems
[ ] Understand MLflow 3.x Logged Models
[ ] Know artifact-based model logging workaround
```

---

# 37. Day 2 Final Assessment

Score:

```text
Concept Questions: 10/10
Scenario Understanding: 10/10
Hands-on Local MLflow: PASS
Hands-on Azure ML Job: PASS
Azure ML Tracking: PASS
Run Comparison: PASS
Model Registration: PASS
```

### Day 2 Status

```text
████████████████████ 100%
```

---

# 38. Key Lessons From Day 2

### Lesson 1

Azure ML executes ML workloads.

### Lesson 2

MLflow tracks experiments and their results.

### Lesson 3

Parameters describe training configuration.

### Lesson 4

Metrics describe model performance.

### Lesson 5

Artifacts are files associated with runs.

### Lesson 6

Experiments group related runs.

### Lesson 7

Runs represent individual executions.

### Lesson 8

Multiple runs allow controlled experimentation and comparison.

### Lesson 9

Model registration provides centralized model management/versioning.

### Lesson 10

Always verify client/server compatibility when using rapidly evolving ML tooling.

---

# 39. Day 3 Preview

## Azure ML Components + Pipelines

Day 2:

```text
Data
 ↓
Training Job
 ↓
Model
```

Day 3:

```text
                 Pipeline
                    │
          ┌─────────┼─────────┐
          ▼         ▼         ▼
     Preprocess   Train    Evaluate
          │         │         │
          └─────────┼─────────┘
                    ▼
                  Model
```

Topics:

```text
Components
Pipeline Jobs
Inputs
Outputs
Pipeline reuse
Component reuse
Data flow
Command components
Pipeline orchestration
```

The main Day 1 concept we will put into practice:

```text
Component ≠ Job

Component
    = reusable definition

Job
    = execution
```

---

# END OF DAY 2

````

### Day 2 is officially complete.

The most important thing to retain before Day 3 is this:

```text
Azure ML Job → EXECUTE
MLflow       → TRACK
Experiment   → GROUP RUNS
Run          → ONE EXECUTION
Parameter    → CONFIGURATION
Metric       → PERFORMANCE
Artifact     → FILE
Model        → TRAINED MODEL
Registry     → MANAGE / VERSION / SHARE
````

**Day 3 will build directly on this and turn our single training job into a reusable Azure ML pipeline.**
