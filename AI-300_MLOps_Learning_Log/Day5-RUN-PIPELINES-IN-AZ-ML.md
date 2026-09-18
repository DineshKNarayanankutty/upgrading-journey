# DAY 5 — RUN PIPELINES IN AZURE MACHINE LEARNING

## Mental Map
```
RUN PIPELINES IN AZURE MACHINE LEARNING
│
├── 1. Create components
│   │
│   ├── Component
│   │   └── Reusable piece of ML code
│   │
│   ├── Component structure
│   │   ├── Metadata
│   │   │   ├── name
│   │   │   ├── display_name
│   │   │   ├── version
│   │   │   └── type
│   │   │
│   │   ├── Interface
│   │   │   ├── Inputs
│   │   │   └── Outputs
│   │   │
│   │   └── Execution
│   │       ├── Code
│   │       ├── Environment
│   │       └── Command
│   │
│   ├── Component files
│   │   ├── Python script
│   │   │   └── Contains ML workflow/code
│   │   │
│   │   └── YAML definition
│   │       ├── Metadata
│   │       ├── Inputs
│   │       ├── Outputs
│   │       ├── Code location
│   │       ├── Environment
│   │       └── Command
│   │
│   ├── Input/output binding
│   │   ├── ${{inputs.input_name}}
│   │   └── ${{outputs.output_name}}
│   │
│   ├── Component loading
│   │   └── load_component()
│   │
│   ├── Component registration
│   │   └── ml_client.components.create_or_update()
│   │
│   └── Local vs registered component
│       ├── Local
│       │   └── Reused from project files
│       │
│       └── Registered
│           └── Stored in Azure ML workspace
│
│
├── 2. Create a pipeline
│   │
│   ├── Pipeline
│   │   └── Workflow connecting ML components
│   │
│   ├── Define pipeline in Python
│   │   ├── from azure.ai.ml.dsl import pipeline
│   │   └── @pipeline()
│   │
│   ├── Pipeline inputs
│   │   └── Input(...)
│   │
│   ├── Asset types
│   │   ├── AssetTypes.URI_FILE
│   │   └── AssetTypes.URI_FOLDER
│   │
│   ├── Invoke components
│   │   └── loaded_component(...)
│   │
│   ├── Connect components
│   │   └── component_A.outputs.output
│   │       → component_B.inputs.input
│   │
│   ├── Data dependency
│   │   └── Output-to-input connection creates dependency
│   │
│   ├── Pipeline outputs
│   │   └── return { ... }
│   │
│   ├── Execution structure
│   │   ├── Sequential
│   │   │   └── A → B → C
│   │   │
│   │   └── Parallel
│   │       └── Independent components can run simultaneously
│   │
│   └── Generated pipeline YAML
│       ├── type: pipeline
│       ├── inputs
│       ├── outputs
│       └── jobs
│
│
├── 3. Run a pipeline job
│   │
│   ├── Pipeline
│   │   └── Definition of workflow
│   │
│   ├── Pipeline job
│   │   └── Execution of pipeline
│   │
│   ├── Job submission
│   │   └── ml_client.jobs.create_or_update()
│   │
│   ├── Execution
│   │   ├── Queued
│   │   ├── Running
│   │   ├── Completed
│   │   └── Failed/Cancelled
│   │
│   ├── Child jobs
│   │   └── Each component executes as a child job
│   │
│   ├── Compute
│   │   ├── Components execute on compute
│   │   ├── Different components can use different compute
│   │   ├── CPU for preprocessing/evaluation
│   │   └── GPU for training when required
│   │
│   ├── Monitoring
│   │   ├── Azure ML Studio
│   │   ├── Pipeline graph
│   │   ├── Job status
│   │   ├── Logs
│   │   ├── Metrics
│   │   ├── Inputs
│   │   └── Outputs/artifacts
│   │
│   ├── Reproducibility
│   │   ├── Same workflow
│   │   ├── Repeatable execution
│   │   └── Different inputs/configurations when required
│   │
│   └── Component reuse/caching
│       └── Avoid unnecessary repeated execution
```
---

# 1. CREATE COMPONENTS

## What is a component?

A component is a reusable piece of ML code.

Typical workflow:

prepare_data
↓
train_model
↓
evaluate_model

Each step can be represented as a component.

A component contains:

* Metadata
* Inputs
* Outputs
* Code
* Environment
* Command

---

## Component structure

```text
Component
│
├── Metadata
│   ├── name
│   ├── display_name
│   ├── version
│   └── type
│
├── Interface
│   ├── Inputs
│   └── Outputs
│
└── Execution
    ├── Code
    ├── Environment
    └── Command
```

---

# 2. COMPONENT YAML

Example structure:

```yaml
$schema: https://azuremlschemas.azureedge.net/latest/commandComponent.schema.json

name: prep_data

display_name: Prepare training data

version: 1

type: command

inputs:
  input_data:
    type: uri_file

outputs:
  output_data:
    type: uri_file

code: ./src

environment: azureml:<environment-name>@latest

command: >-
  python prep.py
  --input_data ${{inputs.input_data}}
  --output_data ${{outputs.output_data}}
```

---

# 3. COMPONENT PYTHON SCRIPT

The Python script receives the values supplied by Azure ML.

Example:

```python
import argparse

parser = argparse.ArgumentParser()

parser.add_argument(
    "--input_data",
    dest="input_data",
    type=str
)

parser.add_argument(
    "--output_data",
    dest="output_data",
    type=str
)

args = parser.parse_args()

# ML/data processing logic here
```

The relationship is:

```text
YAML
 │
 ├── ${{inputs.input_data}}
 │          ↓
 │     --input_data
 │          ↓
Python
 │
 └── args.input_data
```

---

# 4. COMPONENT INPUTS AND OUTPUTS

Input:

```yaml
inputs:
  input_data:
    type: uri_file
```

Output:

```yaml
outputs:
  output_data:
    type: uri_file
```

The component therefore follows:

```text
Input
  ↓
Component
  ↓
Output
```

---

# 5. LOAD A COMPONENT

Use:

```python
from azure.ai.ml import load_component

loaded_component_prep = load_component(
    source="./prep.yml"
)
```

Important:

```text
load_component()
    ↓
Loads component definition
```

It does not execute the component.

---

# 6. REGISTER A COMPONENT

Use:

```python
prep = ml_client.components.create_or_update(
    loaded_component_prep
)
```

Flow:

```text
Local component
    ↓
load_component()
    ↓
create_or_update()
    ↓
Azure ML workspace
    ↓
Reusable registered component
```

---

# 7. LOCAL VS REGISTERED COMPONENT

## Local

Component definition remains in the project.

```text
project/
├── prep.yml
└── src/
    └── prep.py
```

## Registered

Component is stored in the Azure ML workspace and can be reused.

Useful for:

* Team collaboration
* Versioning
* Reuse
* Standardized ML workflows

---

# 8. CREATE A PIPELINE

A pipeline connects components into an ML workflow.

Example:

```text
Raw data
   ↓
prepare_data
   ↓
train_model
   ↓
evaluate_model
```

Pipeline = workflow.

Component = individual reusable task.

---

# 9. DEFINE PIPELINE USING PYTHON

Import:

```python
from azure.ai.ml.dsl import pipeline
```

Then:

```python
@pipeline()
def pipeline_function_name(pipeline_job_input):

    prep_data = loaded_component_prep(
        input_data=pipeline_job_input
    )

    train_model = loaded_component_train(
        training_data=prep_data.outputs.output_data
    )

    return {
        "pipeline_job_transformed_data":
            prep_data.outputs.output_data,

        "pipeline_job_trained_model":
            train_model.outputs.model_output,
    }
```

---

# 10. `@pipeline()`

```python
@pipeline()
```

tells Azure ML that the function defines a pipeline.

It creates the pipeline definition.

It does not itself mean that the ML workload has already executed.

---

# 11. COMPONENT INVOCATION

Inside the pipeline:

```python
prep_data = loaded_component_prep(
    input_data=pipeline_job_input
)
```

This invokes the preparation component.

Then:

```python
train_model = loaded_component_train(
    training_data=prep_data.outputs.output_data
)
```

invokes the training component.

---

# 12. DATA BINDING

This is one of the most important concepts.

```python
training_data=prep_data.outputs.output_data
```

means:

```text
prepare_data
     │
     │ output_data
     ↓
train_model
     │
     │ training_data
     ↓
training
```

The output of one component becomes the input of another.

This also establishes the dependency.

Therefore:

```text
prepare_data
     ↓
train_model
```

Azure ML knows that `train_model` depends on `prepare_data`.

---

# 13. PIPELINE INPUT

Pipeline inputs can use Azure ML data assets.

Example:

```python
from azure.ai.ml import Input
from azure.ai.ml.constants import AssetTypes

pipeline_job = pipeline_function_name(
    Input(
        type=AssetTypes.URI_FILE,
        path="azureml:data:1"
    )
)
```

Important:

```text
AssetTypes.URI_FILE
    ↓
File URI

AssetTypes.URI_FOLDER
    ↓
Folder URI
```

---

# 14. PIPELINE OUTPUTS

Pipeline outputs can be defined by returning component outputs:

```python
return {
    "pipeline_job_transformed_data":
        prep_data.outputs.output_data,

    "pipeline_job_trained_model":
        train_model.outputs.model_output,
}
```

Conceptually:

```text
prepare_data
    ↓
output_data
    ↓
pipeline_job_transformed_data


train_model
    ↓
model_output
    ↓
pipeline_job_trained_model
```

---

# 15. SEQUENTIAL EXECUTION

If:

```python
component_B(
    input=component_A.outputs.output
)
```

then:

```text
A
↓
B
```

B depends on A.

Example:

```text
prepare_data
      ↓
train_model
      ↓
evaluate_model
```

---

# 16. PARALLEL EXECUTION

If two components don't depend on each other:

```text
             ┌──→ component_B
component_A ─┤
             └──→ component_C
```

B and C can potentially execute independently/parallel.

Exam clue:

> Components have no dependency on each other and should execute simultaneously.

Think:

**Parallel execution.**

---

# 17. GENERATED PIPELINE YAML

A Python pipeline can be represented as pipeline YAML.

Simplified structure:

```yaml
display_name: pipeline_function_name

type: pipeline

inputs:
  pipeline_job_input:
    type: uri_file
    path: azureml:data:1

outputs:
  pipeline_job_transformed_data: null
  pipeline_job_trained_model: null

jobs:
  prep_data:
    type: command

  train_model:
    type: command
```

Important pipeline-level sections:

```text
type
inputs
outputs
jobs
```

---

# 18. `$ {{parent...}}`

Pipeline YAML can use expressions such as:

```yaml
${{parent.inputs.pipeline_job_input}}
```

and:

```yaml
${{parent.outputs.pipeline_job_transformed_data}}
```

`parent` refers to the parent pipeline job.

Think:

```text
${{parent.inputs...}}
    ↓
Pipeline input

${{parent.outputs...}}
    ↓
Pipeline output
```

---

# 19. RUN A PIPELINE JOB

A pipeline definition is not the same thing as its execution.

```text
Pipeline
   ↓
Definition
```

while:

```text
Pipeline Job
   ↓
Execution
```

The same pipeline can be executed multiple times.

```text
Pipeline
│
├── Pipeline Job #1
├── Pipeline Job #2
└── Pipeline Job #3
```

---

# 20. SUBMIT THE PIPELINE JOB

Use:

```python
returned_job = ml_client.jobs.create_or_update(
    pipeline_job
)
```

Flow:

```text
pipeline_job
     ↓
ml_client.jobs.create_or_update()
     ↓
Azure ML
     ↓
Pipeline execution
```

This is the key SDK operation for submitting the job.

---

# 21. PIPELINE JOB AND CHILD JOBS

A pipeline job contains individual component executions.

Example:

```text
Pipeline Job
│
├── Child Job
│   └── prepare_data
│
└── Child Job
    └── train_model
```

Remember:

```text
Pipeline
    ↓
Pipeline Job
    ↓
Child Jobs
```

---

# 22. JOB LIFECYCLE

Conceptually:

```text
Not submitted
      ↓
Queued
      ↓
Running
      ↓
Completed
```

A job can also end in states such as:

```text
Failed
Cancelled
```

---

# 23. COMPUTE

The actual component code executes on compute.

Example:

```text
Pipeline
│
├── prepare_data → CPU compute
│
├── train_model  → GPU compute
│
└── evaluate     → CPU compute
```

Different components can use different compute targets when configured accordingly.

The pipeline is the **orchestration layer**.

The compute is where the actual component workload runs.

---

# 24. MONITORING

After submitting a pipeline job, Azure ML Studio can be used to inspect the execution.

You can inspect:

* Pipeline status
* Individual child jobs
* Pipeline graph
* Inputs
* Outputs
* Logs
* Metrics
* Artifacts
* Execution details

Example:

```text
Pipeline Job
│
├── prepare_data
│   ├── logs
│   └── outputs
│
└── train_model
    ├── logs
    ├── metrics
    └── model output
```

---

# 25. TROUBLESHOOTING

If the pipeline fails:

```text
Pipeline Job
     ↓
Find failed child job
     ↓
Inspect logs
     ↓
Identify component failure
     ↓
Fix code/configuration/environment
     ↓
Run again
```

Breaking the workflow into components makes troubleshooting easier because each task has its own execution context.

---

# 26. REPRODUCIBILITY

Pipelines allow you to define a repeatable workflow.

Instead of manually:

```text
1. Prepare data
2. Train model
3. Evaluate model
4. Save model
```

you define:

```text
prepare_data
     ↓
train_model
     ↓
evaluate_model
```

and execute the pipeline whenever required.

Benefits:

* Repeatability
* Automation
* Consistency
* Traceability
* Reusable workflows

---

# 27. COMPONENT REUSE / CACHING

Azure ML can reuse previous component results when the relevant inputs and configuration have not changed.

Conceptually:

```text
Previous component execution
          ↓
Same relevant inputs/configuration?
          │
       ┌──┴──┐
      YES    NO
       │      │
       ↓      ↓
Reuse      Execute again
result
```

This can reduce unnecessary computation.

---

# 28. MLflow VS AZURE ML JOB

These should not be confused.

## MLflow

Primarily used for experiment/model tracking:

```text
MLflow
├── Parameters
├── Metrics
├── Artifacts
└── Models
```

## Azure ML Job

Represents workload execution:

```text
Azure ML Job
├── Components
├── Pipeline
├── Compute
├── Logs
└── Outputs
```

They can work together:

```text
Azure ML Pipeline
      ↓
Training Component
      ↓
MLflow Tracking
      ├── Parameters
      ├── Metrics
      └── Artifacts
```

---

# 29. COMPLETE END-TO-END FLOW

```text
                    AZURE ML MLOps WORKFLOW

                         Python Code
                              │
                              ▼
                       Component YAML
                              │
                  ┌───────────┴───────────┐
                  │                       │
                  ▼                       ▼
              Inputs                  Outputs
                  │                       │
                  └───────────┬───────────┘
                              ▼
                        Component
                              │
                       load_component()
                              │
                              ▼
                         @pipeline()
                              │
              ┌───────────────┴───────────────┐
              │                               │
              ▼                               ▼
        prepare_data                     train_model
              │                               │
              │ output_data                   │
              └───────────────→ training_data │
                                              │
                                              ▼
                                         model_output
                                              │
                                              ▼
                                       Pipeline Outputs
                                              │
                                              ▼
                                         pipeline_job
                                              │
                                              ▼
                              ml_client.jobs.create_or_update()
                                              │
                                              ▼
                                      Azure ML Pipeline Job
                                              │
                              ┌───────────────┴───────────────┐
                              ▼                               ▼
                         Child Job 1                     Child Job 2
                         prepare_data                    train_model
                              │                               │
                              └───────────────┬───────────────┘
                                              ▼
                                      Logs / Metrics /
                                      Outputs / Artifacts
```

---

# 30. AI-300 EXAM CHEAT SHEET

```text
Reusable ML task
    → Component

Workflow of components
    → Pipeline

Execute the pipeline
    → Pipeline Job

Individual component execution
    → Child Job

Define pipeline in Python
    → @pipeline()

Load YAML component
    → load_component()

Register component
    → ml_client.components.create_or_update()

Submit pipeline job
    → ml_client.jobs.create_or_update()

Access component output
    → component.outputs.output_name

Connect components
    → output → input

File input
    → AssetTypes.URI_FILE

Folder input
    → AssetTypes.URI_FOLDER

Monitor execution
    → Azure ML Studio

Independent components
    → Can execute in parallel

Dependent components
    → Execute according to dependency graph

Pipeline
    → Orchestration/workflow

Compute
    → Executes component workload
```

---

# 31. IMPORTANT EXAM TRAPS

### Trap 1

**Question:** What provides reusable ML functionality?

**Answer:** Component

---

### Trap 2

**Question:** What combines multiple components into a workflow?

**Answer:** Pipeline

---

### Trap 3

**Question:** What actually executes the workflow?

**Answer:** Pipeline Job

---

### Trap 4

**Question:** How do you establish a dependency between two components?

**Answer:**

```python
component_B(
    input=component_A.outputs.output
)
```

---

### Trap 5

**Question:** Which SDK method submits a pipeline job?

**Answer:**

```python
ml_client.jobs.create_or_update()
```

---

### Trap 6

**Question:** Which function loads a YAML component definition?

**Answer:**

```python
load_component()
```

---

### Trap 7

**Question:** You want to expose a component's output as a pipeline output.

Use:

```python
return {
    "output_name": component.outputs.output_name
}
```

---

### Trap 8

**Question:** Two components don't depend on each other.

They can potentially run:

**In parallel.**

---

# 32. HANDS-ON EXECUTION PATTERN

The practical sequence for reproducing this workflow is:

```text
1. Create component Python script
        ↓
2. Create component YAML
        ↓
3. Load component
        ↓
4. Register component if required
        ↓
5. Create pipeline with @pipeline()
        ↓
6. Pass pipeline inputs
        ↓
7. Connect component outputs to inputs
        ↓
8. Define pipeline outputs
        ↓
9. Create pipeline job
        ↓
10. Submit with ml_client.jobs.create_or_update()
        ↓
11. Open Azure ML Studio
        ↓
12. Monitor pipeline graph
        ↓
13. Inspect child jobs
        ↓
14. Check logs / metrics / outputs
```

---

# 33. KEY COMMANDS / CODE TO REMEMBER

### Load component

```python
from azure.ai.ml import load_component

component = load_component(
    source="./component.yml"
)
```

### Register component

```python
ml_client.components.create_or_update(
    component
)
```

### Define pipeline

```python
from azure.ai.ml.dsl import pipeline

@pipeline()
def my_pipeline(input_data):

    prep = prep_component(
        input_data=input_data
    )

    train = train_component(
        training_data=prep.outputs.output_data
    )

    return {
        "model": train.outputs.model_output
    }
```

### Define pipeline input

```python
from azure.ai.ml import Input
from azure.ai.ml.constants import AssetTypes

pipeline_job = my_pipeline(
    Input(
        type=AssetTypes.URI_FILE,
        path="azureml:data:1"
    )
)
```

### Submit pipeline

```python
returned_job = ml_client.jobs.create_or_update(
    pipeline_job
)
```

---

# 34. FINAL DAY 5 SUMMARY

The complete concept can be reduced to:

```text
COMPONENT
│
│ Reusable ML task
│
▼
PIPELINE
│
│ Connect components
│
│ output → input
│
▼
PIPELINE JOB
│
│ Execute workflow
│
▼
CHILD JOBS
│
├── Component 1 execution
├── Component 2 execution
└── Component 3 execution
│
▼
COMPUTE
│
▼
LOGS / METRICS / OUTPUTS / ARTIFACTS
```

The most important AI-300 distinction is:

```text
Component = WHAT task
Pipeline  = HOW tasks are connected
Job       = EXECUTION of the workflow
Compute   = WHERE the workload runs
```

Day 5 covered the complete Azure ML pipeline lifecycle:

```text
Create Component
      ↓
Create Pipeline
      ↓
Connect Components
      ↓
Create Pipeline Job
      ↓
Submit Job
      ↓
Run Child Jobs
      ↓
Monitor
      ↓
Inspect Outputs
```
