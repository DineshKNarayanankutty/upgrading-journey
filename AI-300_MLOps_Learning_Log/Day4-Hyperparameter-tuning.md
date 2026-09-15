# AI-300 — Day 4 Learning Log

## Topic

**Perform Hyperparameter Tuning with Azure Machine Learning**

Microsoft Learn module:

[https://learn.microsoft.com/en-us/training/modules/perform-hyperparameter-tuning-azure-machine-learning-pipelines/](https://learn.microsoft.com/en-us/training/modules/perform-hyperparameter-tuning-azure-machine-learning-pipelines/)

---

# 1. Complete Mental Map

```text
HYPERPARAMETER TUNING
│
├── 1. Introduction
│   │
│   ├── Parameters
│   │   └── Values learned from training data
│   │
│   ├── Hyperparameters
│   │   └── Values used to configure training
│   │
│   ├── Examples
│   │   ├── Regularization rate
│   │   ├── Learning rate
│   │   └── Batch size
│   │
│   └── Hyperparameter tuning
│       ├── Same algorithm
│       ├── Same training data
│       ├── Different hyperparameter values
│       ├── Train multiple models
│       ├── Evaluate performance
│       └── Select best-performing model
│
│
├── 2. Define a search space
│   │
│   ├── Search space
│   │   └── Set/range of hyperparameter values to try
│   │
│   ├── Discrete hyperparameters
│   │   ├── Choice
│   │   │   ├── List
│   │   │   ├── range()
│   │   │   └── Explicit values
│   │   │
│   │   ├── QUniform
│   │   ├── QLogUniform
│   │   ├── QNormal
│   │   └── QLogNormal
│   │
│   ├── Continuous hyperparameters
│   │   ├── Uniform
│   │   ├── LogUniform
│   │   ├── Normal
│   │   └── LogNormal
│   │
│   └── Search-space definition
│       └── Dictionary of hyperparameter → distribution
│
│
├── 3. Configure a sampling method
│   │
│   ├── Grid
│   │   └── Try EVERY possible combination
│   │       └── Only discrete hyperparameters
│   │
│   ├── Random
│   │   └── Randomly choose values
│   │
│   ├── Sobol
│   │   ├── Variation of random sampling
│   │   ├── Uses seed
│   │   └── Reproducible + more evenly spread
│   │
│   └── Bayesian
│       ├── Uses previous trial results
│       ├── Selects promising combinations
│       └── Supports Choice / Uniform / QUniform
│
│
├── 4. Configure early termination
│   │
│   ├── Purpose
│   │   └── Stop poorly performing trials early
│   │
│   ├── evaluation_interval
│   │   └── How often policy is evaluated
│   │
│   ├── delay_evaluation
│   │   └── Number of metric-reporting intervals
│   │       before first evaluation
│   │
│   ├── Bandit
│   │   ├── slack_factor OR slack_amount
│   │   └── Compare against best-performing trial
│   │
│   ├── Median stopping
│   │   └── Compare against median running average
│   │
│   └── Truncation selection
│       └── Cancel lowest-performing X%
│
│
├── 5. Use a sweep job for hyperparameter tuning
│   │
│   ├── Start with parameterized command job
│   │
│   ├── Convert command job → sweep job
│   │
│   ├── Configure
│   │   ├── Search space
│   │   ├── Sampling algorithm
│   │   ├── Primary metric
│   │   ├── Goal
│   │   │   ├── Maximize
│   │   │   └── Minimize
│   │   ├── max_total_trials
│   │   ├── max_concurrent_trials
│   │   └── Early termination policy
│   │
│   ├── Trial
│   │   └── One training run with one
│   │       hyperparameter combination
│   │
│   └── Submit sweep job
│       └── Azure ML runs trials
│
│
├── 6. Exercise — Run a sweep job
    │
    ├── Create/prepare training script
    ├── Parameterize hyperparameters
    ├── Define search space
    ├── Configure sampling
    ├── Configure early termination
    ├── Configure objective
    ├── Submit sweep job
    └── Inspect results
```

---

# 2. What is Hyperparameter Tuning?

Hyperparameters are values that configure how a machine learning model is trained.

Examples:

* `learning_rate`
* `batch_size`
* `regularization_rate`
* `number_of_estimators`

The model learns its parameters from the training data, while hyperparameters are supplied as part of the training configuration.

Hyperparameter tuning automates the process of trying different hyperparameter combinations and selecting the configuration that produces the best model according to a target metric.

```text
Same algorithm
      +
Same training data
      +
Different hyperparameters
      ↓
Multiple training trials
      ↓
Evaluate target metric
      ↓
Select best configuration
      ↓
Best model
```

---

# 3. Azure ML Sweep Job

Azure Machine Learning uses a **sweep job** to perform hyperparameter tuning.

A sweep job creates multiple trials, where each trial represents one training run using a particular combination of hyperparameter values.

Example:

```text
Sweep Job
│
├── Trial 1
│   ├── learning_rate = 0.01
│   └── batch_size = 32
│
├── Trial 2
│   ├── learning_rate = 0.01
│   └── batch_size = 64
│
├── Trial 3
│   ├── learning_rate = 0.05
│   └── batch_size = 32
│
└── Trial 4
    ├── learning_rate = 0.05
    └── batch_size = 64
```

The sweep job evaluates the trials and identifies the best-performing configuration.

---

# 4. Search Space

The **search space** defines which hyperparameter values Azure ML is allowed to try.

```text
Search Space
│
├── Discrete
│   └── Choice
│
└── Continuous
    ├── Uniform
    ├── LogUniform
    ├── Normal
    └── LogNormal
```

## Choice

Used when the parameter must be one of a predefined set of values.

Example:

```python
Choice(values=[16, 32, 64])
```

Possible values:

```text
16
32
64
```

The sweep cannot select values such as `40` or `51`.

---

## Uniform

Used for continuous values in a range where values are sampled evenly.

Example:

```python
Uniform(
    min_value=0.001,
    max_value=0.1
)
```

---

## LogUniform

Useful when the parameter spans several orders of magnitude.

Example:

```text
0.0001
0.001
0.01
0.1
```

Learning rates are a common example where logarithmic sampling can be useful.

---

## Normal

Samples values around a central mean according to a normal distribution.

---

## LogNormal

A logarithmic version of a normal distribution, useful for positive values that span different scales.

---

# 5. Quantized Distributions

Azure ML also supports quantized versions of distributions:

```text
QUniform
QLogUniform
QNormal
QLogNormal
```

The important concept is that these produce values at discrete/quantized intervals.

These are lower priority than understanding:

```text
Choice
Uniform
LogUniform
```

for certification preparation.

---

# 6. Sampling Methods

After defining the search space, we need to determine **how Azure ML selects values from that search space**.

```text
Sampling
│
├── Grid
│
├── Random
│
├── Sobol
│
└── Bayesian
```

---

## Grid Sampling

Grid sampling systematically evaluates **every possible combination** of discrete hyperparameter values.

Example:

```text
learning_rate = [0.01, 0.05]
batch_size    = [32, 64]

Combinations:

0.01 + 32
0.01 + 64
0.05 + 32
0.05 + 64
```

Important:

**Grid sampling requires discrete hyperparameters.**

---

## Random Sampling

Random sampling randomly selects combinations from the search space.

It can explore a large search space without evaluating every possible combination.

---

## Sobol Sampling

Sobol is a variation of random sampling.

Important characteristics:

* Uses a seed
* Provides reproducibility
* Produces a more evenly distributed search than basic random sampling

---

## Bayesian Sampling

Bayesian sampling uses results from previous trials to help determine promising hyperparameter combinations for subsequent trials.

Conceptually:

```text
Trial 1
   ↓
Result
   ↓
Learn from result
   ↓
Choose promising values
   ↓
Trial 2
   ↓
Result
   ↓
Learn again
   ↓
...
```

Important Azure ML detail:

Bayesian sampling supports specific parameter expressions including:

* `Choice`
* `Uniform`
* `QUniform`

---

# 7. Early Termination

A sweep can contain many trials.

Some trials may clearly perform worse than others while training is still in progress.

An **early termination policy** can stop these poorly performing trials before they finish.

Benefits:

```text
Poor trial
    ↓
Stop early
    ↓
Less compute
    ↓
Less training time
    ↓
Lower cost
```

---

# 8. Early Termination Policies

Azure ML provides several early termination policies.

```text
Early Termination
│
├── Bandit
│
├── Median stopping
│
└── Truncation selection
```

---

## Bandit

Stops a trial when its performance falls sufficiently below the current best-performing trial according to the configured tolerance.

Important concepts include:

```text
slack_factor
slack_amount
```

---

## Median Stopping

Compares the current trial's performance with the median performance of previous trials at the same point.

```text
Current trial
      ↓
Compare with median
      ↓
Underperforming?
      ↓
Terminate
```

---

## Truncation Selection

Periodically terminates the lowest-performing percentage of trials.

Example concept:

```text
100 trials
   ↓
Bottom 20%
   ↓
Terminate
```

---

# 9. Evaluation Interval

An early termination policy needs to determine how frequently it should evaluate a running trial.

`evaluation_interval` specifies how often the policy is evaluated based on reported metrics.

---

# 10. Delay Evaluation

`delay_evaluation` specifies how many metric-reporting intervals should pass before early termination is evaluated.

This prevents a trial from being terminated too early before enough performance information is available.

Conceptually:

```text
Training starts
     ↓
Wait for configured intervals
     ↓
Begin early-termination evaluation
```

---

# 11. Sweep Job Objective

The sweep job needs to know:

1. Which metric to optimize
2. Whether to maximize or minimize it

```text
              Objective
                  │
          ┌───────┴───────┐
          │               │
       Metric            Goal
                          │
                    ┌─────┴─────┐
                    │           │
                 Maximize     Minimize
```

Examples:

```text
Accuracy  → Maximize
F1 score  → Maximize
Precision → Maximize

RMSE      → Minimize
MAE       → Minimize
Loss      → Minimize
```

---

# 12. Trial Limits

Two important sweep-job settings are:

```text
max_total_trials
```

and

```text
max_concurrent_trials
```

## max_total_trials

Defines the maximum number of trials that can be run by the sweep.

```text
max_total_trials = 20

→ Maximum of 20 trials
```

## max_concurrent_trials

Defines the maximum number of trials that can run simultaneously.

```text
max_concurrent_trials = 4

→ At most 4 trials run at once
```

These settings are particularly important when managing compute capacity and cost.

---

# 13. Complete Sweep Job Flow

```text
Parameterized training script
            │
            ▼
      Command Job
            │
            ▼
       Sweep Job
            │
     ┌──────┴──────┐
     │             │
Search Space    Sampling
     │             │
     └──────┬──────┘
            ▼
       Generate trials
            │
            ▼
    ┌───────────────┐
    │ Trial 1       │
    │ Trial 2       │
    │ Trial 3       │
    │ Trial ...     │
    └───────┬───────┘
            │
            ▼
     Target metric
            │
            ▼
   Early termination
            │
            ▼
    Compare completed
       / running trials
            │
            ▼
    Best configuration
            │
            ▼
       Best model
```

---

# 14. Important AI-300 Exam Comparisons

## Search Space vs Sampling

```text
Search Space
    ↓
"What values can be tried?"

Sampling
    ↓
"How should values be selected?"
```

---

## Grid vs Random vs Bayesian

```text
Grid
→ Every combination

Random
→ Random combinations

Bayesian
→ Uses previous results to guide the next trials
```

---

## Parameter vs Hyperparameter

```text
Parameter
→ Learned during training

Hyperparameter
→ Configured before/during training
```

---

## Environment vs Compute

```text
Environment
→ Software/runtime/dependencies

Compute
→ Where the job executes
```

---

## Command Job vs Sweep Job

```text
Command Job
→ One configured training execution

Sweep Job
→ Multiple training executions
   using different hyperparameter combinations
```

---

# 15. AI-300 Exam Traps

### Trap 1

**"Try every combination"**

→ **Grid**

### Trap 2

**"Use previous trial results to select promising values"**

→ **Bayesian**

### Trap 3

**"Random but reproducible using a seed"**

→ **Sobol**

### Trap 4

**"Stop trials that are performing poorly"**

→ **Early termination**

### Trap 5

**"Specific values such as 16, 32, 64"**

→ **Choice**

### Trap 6

**"Continuous range such as 0.001–0.1"**

→ **Uniform**

### Trap 7

**"Values spanning multiple orders of magnitude"**

→ **LogUniform**

### Trap 8

**"Best model has lowest RMSE"**

→ Primary metric = `rmse`, goal = **minimize**

### Trap 9

**"Best model has highest accuracy"**

→ Primary metric = `accuracy`, goal = **maximize**

### Trap 10

**"Maximum trials running simultaneously"**

→ `max_concurrent_trials`

### Trap 11

**"Maximum number of trials for the sweep"**

→ `max_total_trials`

---

# 16. Microsoft Learn Exercise — Practical Flow

The hands-on exercise follows the same overall workflow:

```text
Training script
      ↓
Parameterize training
      ↓
Create command job
      ↓
Define hyperparameter search space
      ↓
Choose sampling method
      ↓
Configure early termination
      ↓
Set primary metric
      ↓
Set maximize/minimize goal
      ↓
Set trial limits
      ↓
Submit sweep job
      ↓
Monitor trials
      ↓
Inspect results
      ↓
Identify best trial
```

---

# 17. What I Need to Remember for AI-300

The most important decision tree:

```text
Need hyperparameter tuning?
        │
        ▼
Use Sweep Job
        │
        ▼
Define Search Space
        │
        ├── Specific values?
        │       → Choice
        │
        ├── Continuous range?
        │       → Uniform
        │
        └── Orders of magnitude?
                → LogUniform

        ↓

Choose Sampling
        │
        ├── Every combination?
        │       → Grid
        │
        ├── Random exploration?
        │       → Random
        │
        ├── Random + reproducible?
        │       → Sobol
        │
        └── Learn from previous trials?
                → Bayesian

        ↓

Need to save compute?
        │
        └── Yes
             → Early termination

                 ↓

Choose objective
        │
        ├── Higher is better
        │       → Maximize
        │
        └── Lower is better
                → Minimize

                 ↓

Set limits
        │
        ├── max_total_trials
        └── max_concurrent_trials

                 ↓

              Run sweep

                 ↓

          Find best trial

                 ↓

           Best configuration
```

---

# 18. Key Takeaways

1. **Hyperparameter tuning** searches for the best training configuration.
2. Azure ML uses a **sweep job** for hyperparameter tuning.
3. A **trial** is one training run with a particular hyperparameter combination.
4. A **search space** defines the possible values.
5. `Choice` is used for predefined discrete values.
6. `Uniform` is used for continuous values.
7. `LogUniform` is useful for values spanning multiple orders of magnitude.
8. **Grid** evaluates all discrete combinations.
9. **Random** samples combinations randomly.
10. **Sobol** provides reproducible, more evenly distributed random sampling.
11. **Bayesian** uses previous trial results to guide subsequent trials.
12. **Early termination** stops poor-performing trials to save resources.
13. **Bandit**, **Median stopping**, and **Truncation selection** are early termination policies.
14. `primary_metric` identifies what the sweep optimizes.
15. `maximize` is used when higher metric values are better.
16. `minimize` is used when lower metric values are better.
17. `max_total_trials` limits the total number of trials.
18. `max_concurrent_trials` limits simultaneously running trials.
19. The final objective is to identify the **best hyperparameter configuration and corresponding model**.

---

# 19. AI-300 Preparation Status

### Completed today

* [x] Understand hyperparameter tuning
* [x] Understand sweep jobs
* [x] Understand trials
* [x] Define search spaces
* [x] Discrete vs continuous distributions
* [x] `Choice`
* [x] `Uniform`
* [x] `LogUniform`
* [x] Normal / LogNormal concepts
* [x] Quantized distributions
* [x] Grid sampling
* [x] Random sampling
* [x] Sobol sampling
* [x] Bayesian sampling
* [x] Early termination
* [x] Bandit
* [x] Median stopping
* [x] Truncation selection
* [x] `evaluation_interval`
* [x] `delay_evaluation`
* [x] Primary metric
* [x] Maximize vs minimize
* [x] `max_total_trials`
* [x] `max_concurrent_trials`
* [x] Sweep-job mental model
* [x] Microsoft Learn assessment-style questions

## Exam Preparation Approach

Questions will be based on **Microsoft/Azure certification-style scenarios**, rather than simple definition questions.

Focus will be on recognizing:

```text
Requirement
    ↓
Azure ML feature
    ↓
Correct configuration
```

Examples:

```text
Every combination
→ Grid

Previous results guide search
→ Bayesian

Stop poor trials
→ Early termination

Specific discrete values
→ Choice

Continuous range
→ Uniform

Orders of magnitude
→ LogUniform

Highest metric
→ Maximize

Lowest metric
→ Minimize
```
