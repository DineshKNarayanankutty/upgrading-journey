# AI-300 — Day 3: Experiment, Evaluate & Track Models

## Microsoft Learn

* [Experiment and evaluate models — Azure Machine Learning](https://learn.microsoft.com/en-us/training/modules/experiment-azure-machine-learning/)
* [Preprocess data and configure featurization](https://learn.microsoft.com/en-us/training/modules/experiment-azure-machine-learning/2-preprocess-data-configure-featurization)
* [Run an AutoML job](https://learn.microsoft.com/en-us/training/modules/experiment-azure-machine-learning/3-run-job)
* [Evaluate and compare models](https://learn.microsoft.com/en-us/training/modules/experiment-azure-machine-learning/4-evaluate-compare-models)
* [Model tracking](https://learn.microsoft.com/en-us/training/modules/experiment-azure-machine-learning/5-model-tracking)
* [Train and track models in notebooks](https://learn.microsoft.com/en-us/training/modules/experiment-azure-machine-learning/6-train-models-notebooks)
* [Responsible AI dashboard](https://learn.microsoft.com/en-us/training/modules/experiment-azure-machine-learning/7-responsible-ai-dashboard)

---

# 1. Data Preprocessing & Featurization

## MLTable

**MLTable = instructions that tell Azure ML how to read/interpret the data.**

Flow:

```text
Raw Data
   ↓
MLTable
   ↓
AutoML
```

## AutoML Featurization

AutoML can automatically preprocess and transform data.

| Problem                             | What AutoML can do      |
| ----------------------------------- | ----------------------- |
| Missing values                      | Imputation              |
| Categorical values                  | Encoding                |
| Date/time                           | Extract useful features |
| Different numerical scales          | Scaling/normalization   |
| Unhelpful high-cardinality features | May be dropped          |

### Important

**Feature engineering** = creating useful ML features from existing data.

Example:

```text
DateTime
   ↓
Year
Month
Day
Hour
DayOfWeek
```

---

# 2. Configure an AutoML Job

AutoML can try multiple ML algorithms and compare their performance.

Example:

```python
classification_job = automl.classification(
    compute="aml-cluster",
    training_data=training_data,
    target_column_name="Diabetic",
    primary_metric="accuracy",
)
```

### Important parameters

| Parameter             | Meaning                          |
| --------------------- | -------------------------------- |
| `compute`             | Where the job runs               |
| `training_data`       | Data used for training           |
| `target_column_name`  | Column we want to predict        |
| `primary_metric`      | Main metric used to rank models  |
| `n_cross_validations` | Number of cross-validation folds |

### Easy memory

```text
compute → Where?
training_data → Which data?
target → What to predict?
primary_metric → How to compare?
```

---

# 3. Control AutoML Limits

Example:

```python
classification_job.set_limits(
    timeout_minutes=60,
    trial_timeout_minutes=20,
    max_trials=5,
    enable_early_termination=True,
)
```

### Meaning

* `timeout_minutes` → maximum time for the complete AutoML job
* `trial_timeout_minutes` → maximum time for one trial
* `max_trials` → maximum number of trials/models
* `enable_early_termination` → stop poorly performing trials early

### Why use limits?

To control:

```text
Compute usage
     +
Execution time
     +
Cost
```

---

# 4. Submit the Job

Configuration and execution are different.

```python
returned_job = ml_client.jobs.create_or_update(
    classification_job
)
```

### Remember

```text
automl.classification()
        ↓
Configure

create_or_update()
        ↓
Submit / Run
```

---

# 5. Evaluate & Compare Models

AutoML runs multiple trials.

```text
Trial 1 → Model A → Accuracy 82%
Trial 2 → Model B → Accuracy 89%
Trial 3 → Model C → Accuracy 94%
```

## Trial

**Trial = one model/configuration attempt by AutoML.**

## Metrics

**Metric = measurement of model performance.**

Common classification metrics:

* Accuracy → how many predictions were correct overall
* Precision → of predicted positives, how many were actually positive
* Recall → of actual positives, how many were found
* F1 score → balance between precision and recall
* AUC → how well the model separates classes

### Primary Metric

```python
primary_metric="accuracy"
```

The primary metric is the main metric AutoML uses to rank models.

### Important

The highest metric does not automatically mean the best production model.

Also consider:

* Validation performance
* Overfitting
* Model complexity
* Prediction speed
* Compute/resource requirements
* Business requirements

---

# 6. Model Explainability

**Model explainability = understanding why the model made a prediction.**

Example:

```text
Prediction → Loan rejected

Important features:
- Income
- Credit score
- Debt
```

Can be enabled with:

```python
enable_model_explainability=True
```

### Easy distinction

```text
Evaluation       → How well does it perform?

Explainability   → Why did it make this prediction?
```

---

# 7. MLflow Model Tracking

**MLflow = open-source platform/library used for tracking ML experiments.**

MLflow Tracking records information about training runs.

```text
Experiment
    ↓
   Runs
    ↓
Parameters
Metrics
Artifacts
```

## Experiment vs Run

**Experiment** → groups related runs.

**Run** → one execution/training attempt.

Example:

```text
Experiment: Diabetes Prediction

Run 1
Run 2
Run 3
```

---

# 8. Parameters, Metrics & Artifacts

### Parameter

Something configured for training.

```text
learning_rate = 0.01
max_depth = 5
```

> **Parameter = What I configured**

### Metric

A measured result.

```text
accuracy = 0.94
F1 = 0.89
```

> **Metric = What I measured**

### Artifact

A file produced by the run.

```text
model.pkl
confusion_matrix.png
```

> **Artifact = What the run produced**

---

# 9. MLflow Tracking URI

For a local development environment, MLflow needs to know where tracking information should be sent.

```python
mlflow.set_tracking_uri("MLFLOW-TRACKING-URI")
```

### Remember

**Tracking URI = tells MLflow where to send/store tracking information.**

In an Azure ML managed compute notebook, MLflow is already configured for the Azure ML environment.

---

# 10. Train & Track Models in Notebooks

## Set an experiment

```python
mlflow.set_experiment(
    experiment_name="heart-condition-classifier"
)
```

> Selects/groups the related runs under an experiment.

## Start a run

```python
with mlflow.start_run():
    # training code
```

> Starts an MLflow-tracked run.

---

# 11. Autologging

```python
mlflow.autolog()
```

Automatically records relevant information such as:

* Parameters
* Metrics
* Artifacts
* Model

### Framework-specific example

```python
mlflow.xgboost.autolog()
```

### Autologging vs Custom Logging

| Autologging                               | Custom logging        |
| ----------------------------------------- | --------------------- |
| Automatic                                 | Manual                |
| Less code                                 | More control          |
| Framework determines relevant information | We choose what to log |

They can also be used together.

---

# 12. Custom Logging

### Parameter

```python
mlflow.log_param("learning_rate", 0.01)
```

### Metric

```python
mlflow.log_metric("accuracy", 0.94)
```

### Artifact

```python
mlflow.log_artifact("confusion_matrix.png")
```

### Model

```python
mlflow.log_model(...)
```

### Easy memory

```text
log_param()   → Parameter
log_metric()  → Metric
log_artifact() → Artifact
log_model()   → Model
```

---

# 13. Responsible AI Dashboard

The Responsible AI dashboard helps investigate model behavior beyond overall performance.

### Error Analysis

> **Where is the model making mistakes?**

### Interpretability

> **Why did the model make this prediction?**

### Fairness

> **Does the model behave differently across groups?**

### Counterfactual Analysis

> **What change could result in a different prediction?**

### Easy memory

```text
Error analysis    → Where is it wrong?
Interpretability  → Why this prediction?
Fairness          → Different across groups?
Counterfactual    → What change could alter it?
```

---

# 14. Practical Lab

## Microsoft MLOps Lab

Lab:

https://microsoftlearning.github.io/mslearn-mlops/docs/01-experiment-evaluate-models.html

The lab covered:

```text
Azure ML Workspace
       ↓
Compute
       ↓
Experiment
       ↓
AutoML
       ↓
Multiple trials
       ↓
Evaluate & compare models
       ↓
MLflow tracking
```

## Provisioning Issue

The Microsoft setup script initially failed because the subscription had:

```text
Standard DSv2 Family Dedicated vCPUs
Maximum allowed: 0
Current in use: 0
Additional requested: 2
```

### Reason

The lab attempted to provision a DSv2-based compute resource, but the subscription had **0 quota** for that VM family in the selected region.

### Resolution

Instead of using the lab's provisioned compute instance, I created my own Azure ML compute instance:

```text
aml-instance
```

Then I ran the notebooks/cells from the lab successfully using the custom compute instance.

### Important MLOps lesson

A lab may specify a particular compute SKU, but in a real Azure environment we must also consider:

* Subscription quota
* Region availability
* VM SKU availability
* Compute cost
* Resource requirements

---

# 15. Key Revision Sheet

```text
MLTable
→ Instructions for reading/understanding data

Featurization
→ Transform raw data into useful ML features

AutoML
→ Tries multiple models and configurations

Target
→ What we want to predict

Feature
→ Input used for prediction

Trial
→ One AutoML model attempt

Primary metric
→ Main metric used to rank models

Cross-validation
→ Evaluate using multiple train/validation splits

MLflow
→ Track ML experiments

Experiment
→ Group of related runs

Run
→ One execution

Parameter
→ What we configured

Metric
→ What we measured

Artifact
→ File/output produced

Autologging
→ Automatically track relevant information

Custom logging
→ Manually choose what to track

Tracking URI
→ Where MLflow sends tracking information

Explainability
→ Why did the model make this prediction?

Error analysis
→ Where is the model making mistakes?

Fairness
→ Does behavior differ across groups?

Counterfactual
→ What change could alter the prediction?
```

# 16. Overall AI-300 Mental Model

```text
DATA
 ↓
MLTable
 ↓
Preprocessing / Featurization
 ↓
Configure AutoML
 ↓
Set Limits
 ↓
Submit Job
 ↓
Multiple Trials
 ↓
Evaluate Metrics
 ↓
Compare Models
 ↓
Explain Model
 ↓
Track with MLflow
 ↓
Responsible AI Analysis
 ↓
Select Appropriate Model
```

## Today's Outcome

* Understood Azure ML data preprocessing and featurization.
* Configured and understood AutoML jobs.
* Learned how AutoML trials are evaluated and compared.
* Learned classification metrics and primary metrics.
* Learned model explainability.
* Understood MLflow experiment/run tracking.
* Practiced autologging and custom logging concepts.
* Learned Responsible AI dashboard capabilities.
* Completed the Microsoft MLOps experiment/evaluate-models lab.
* Resolved an Azure compute quota issue by creating and using a custom compute instance named `aml-instance`.
* Successfully executed the lab notebooks/cells.
