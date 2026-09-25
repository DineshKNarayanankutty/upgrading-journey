# AI-300 — Day 10 Learning Log
Date: 2026-09-25 Microsoft Learn Module: AUTOMATED EVALUATION & OPTIMIZATION OF AI AGENTS

## GenAIOps: Automated Evaluation

**Main topic:** Evaluate GenAI applications systematically, align automated evaluators with human judgment, create evaluation datasets, run batch evaluations, and integrate evaluations into GitHub Actions.

---
## Mental Map

```
AUTOMATED EVALUATION & OPTIMIZATION
│
├── 1. WHY AUTOMATED EVALUATION?
│   │
│   ├── Goal
│   │   └── Measure GenAI quality consistently at scale
│   │
│   ├── Human Evaluation
│   │   ├── High contextual judgment
│   │   ├── Domain expertise
│   │   ├── Slow
│   │   ├── Expensive
│   │   └── Limited scalability
│   │
│   ├── Automated Evaluation
│   │   ├── Fast
│   │   ├── Consistent
│   │   ├── Repeatable
│   │   └── Scalable
│   │
│   └── Human-in-the-Loop (HITL)
│       ├── Automation → handles volume
│       └── Humans → handle judgment/edge cases
│
│
├── 2. ALIGN AUTOMATED EVALUATORS WITH HUMAN CRITERIA
│   │
│   ├── Define Human Quality Criteria
│   │   ├── Relevance
│   │   ├── Intent Resolution
│   │   ├── Groundedness
│   │   ├── Coherence
│   │   └── Domain-specific quality
│   │
│   ├── Select Appropriate Evaluators
│   │   ├── Intent Resolution
│   │   │   └── Did agent satisfy user's intent?
│   │   │
│   │   ├── Relevance
│   │   │   └── Is response on-topic?
│   │   │
│   │   └── Groundedness
│   │       └── Is response supported by context?
│   │
│   ├── Shadow Rating
│   │   ├── Same examples
│   │   ├── Human scores
│   │   ├── Automated scores
│   │   └── Compare results
│   │
│   ├── Sample Size
│   │   └── 100–200 representative examples
│   │
│   ├── Pearson Correlation
│   │   ├── Human ↔ Automated
│   │   │
│   │   ├── ≥ 0.7
│   │   │   └── Strong alignment
│   │   │
│   │   ├── 0.5–0.7
│   │   │   └── Moderate → investigate
│   │   │
│   │   └── < 0.5
│   │       └── Weak → major refinement
│   │
│   ├── Adventure Works Target
│   │   └── 0.75
│   │
│   └── Analyze Disagreements
│       ├── Human score ≠ AI score
│       ├── Find patterns
│       ├── Identify evaluator blind spots
│       └── Refine evaluator
│
│
├── 3. HUMAN CONSISTENCY / CALIBRATION
│   │
│   ├── First Question
│   │   └── Do humans agree with each other?
│   │
│   ├── Inter-Rater Reliability
│   │   └── Measures evaluator agreement
│   │
│   ├── Cohen's Kappa
│   │   └── Agreement between 2 raters
│   │
│   ├── Interpretation
│   │   ├── > 0.8
│   │   │   └── Excellent
│   │   ├── 0.6–0.8
│   │   │   └── Substantial
│   │   ├── 0.4–0.6
│   │   │   └── Moderate
│   │   └── < 0.4
│   │       └── Poor
│   │
│   └── Critical distinction
│       ├── Pearson
│       │   └── Human ↔ Automated
│       └── Cohen's Kappa
│           └── Human ↔ Human
│
│
├── 4. CUSTOM EVALUATORS
│   │
│   ├── When?
│   │   ├── Built-in evaluator insufficient
│   │   ├── Domain-specific requirements
│   │   ├── Regulatory requirements
│   │   ├── Brand requirements
│   │   └── Organization-specific quality
│   │
│   └── Lifecycle
│       ├── Create custom evaluator
│       ├── Shadow rating
│       ├── Compare with humans
│       ├── Calculate correlation
│       ├── Analyze disagreements
│       ├── Refine
│       └── Revalidate
│
│
├── 5. CREATE EVALUATION DATASETS
│   │
│   ├── Goal
│   │   └── Representative test data
│   │
│   ├── Dataset Composition
│   │   ├── Common → 60–70%
│   │   │   └── Typical production usage
│   │   │
│   │   ├── Variations → 20–30%
│   │   │   └── Same intent, different wording/context
│   │   │
│   │   ├── Edge → 5–10%
│   │   │   └── Rare/unusual situations
│   │   │
│   │   └── Adversarial → 5–10%
│   │       └── Misuse/prompt injection/safety
│   │
│   ├── Starting Example
│   │   └── 100 examples
│   │       ├── 70 common
│   │       ├── 20 variations
│   │       └── 10 edge/adversarial
│   │
│   ├── Data Sources
│   │   ├── Production
│   │   │   ├── Support tickets
│   │   │   ├── Conversations
│   │   │   ├── Search logs
│   │   │   └── Form submissions
│   │   │
│   │   └── Synthetic
│   │       ├── New systems
│   │       ├── Rare scenarios
│   │       ├── Adversarial cases
│   │       └── Controlled variations
│   │
│   ├── Preparation
│   │   ├── Clean
│   │   │   ├── Remove duplicates
│   │   │   ├── Remove empty data
│   │   │   └── Remove malformed data
│   │   │
│   │   ├── Anonymize
│   │   │   ├── Names
│   │   │   ├── Emails
│   │   │   ├── Phone numbers
│   │   │   └── Account IDs
│   │   │
│   │   ├── Structure
│   │   │   └── Categories + metadata
│   │   │
│   │   └── Validate
│   │       ├── Realistic examples
│   │       └── Correct composition
│   │
│   ├── PII Detection
│   │   └── Azure Language PII detection
│   │       └── NER
│   │
│   └── JSONL
│       └── One JSON object per line
│           ├── query
│           ├── response
│           ├── context
│           └── ground_truth
│
│
├── 6. EVALUATOR DATA REQUIREMENTS
│   │
│   ├── Intent Resolution
│   │   └── query + response
│   │
│   ├── Relevance
│   │   └── query + response
│   │
│   ├── Groundedness
│   │   └── query + response + context
│   │
│   └── Content Safety
│       └── query + response
│
│
├── 7. MICROSOFT FOUNDRY DATASETS
│   │
│   ├── Upload JSONL
│   │
│   ├── Create Dataset
│   │
│   ├── Dataset Versioning
│   │   ├── Version 1
│   │   ├── Version 2
│   │   └── Version 3
│   │
│   └── Benefits
│       ├── Track changes
│       ├── Compare results
│       └── Reuse datasets
│
│
├── 8. BATCH EVALUATIONS WITH PYTHON
│   │
│   ├── Cloud Evaluation
│   │   └── Run evaluation against dataset at scale
│   │
│   ├── Data Schema
│   │   └── Defines dataset structure
│   │
│   ├── Data Mapping
│   │   └── Dataset fields → evaluator inputs
│   │
│   ├── Testing Criteria
│   │   └── Defines evaluators to run
│   │
│   ├── Evaluation Definition
│   │   └── Reusable "what/how"
│   │
│   ├── Evaluation Run
│   │   └── Executes definition against dataset
│   │
│   ├── Cloud Execution
│   │   ├── Parallel execution
│   │   ├── Retries
│   │   └── Rate limiting
│   │
│   ├── Asynchronous
│   │   ├── Start
│   │   ├── Poll status
│   │   ├── Completed/Failed
│   │   └── Retrieve results
│   │
│   └── Results
│       ├── Label
│       ├── Score
│       ├── Threshold
│       ├── Reason
│       └── Details
│
│
├── 9. EVALUATE & OPTIMIZE AI AGENTS
│   │
│   ├── Goal
│   │   └── Determine whether an agent change improves the system
│   │
│   ├── Three Optimization Dimensions
│   │   │
│   │   ├── Quality
│   │   │   └── How good is the response?
│   │   │
│   │   ├── Cost
│   │   │   └── How expensive is the response?
│   │   │
│   │   └── Performance
│   │       └── How fast is the response?
│   │
│   └── Optimize all three
│       └── Quality + Cost + Performance
│
│
├── 10. QUALITY EVALUATORS
│   │
│   ├── General-purpose
│   │   ├── Coherence
│   │   └── Fluency
│   │
│   ├── Textual Similarity
│   │   ├── Similarity
│   │   ├── F1
│   │   ├── BLEU
│   │   ├── GLEU
│   │   ├── ROUGE
│   │   └── METEOR
│   │
│   ├── Agent Evaluators
│   │   ├── Task Adherence
│   │   ├── Task Completion
│   │   ├── Intent Resolution
│   │   ├── Tool Call Accuracy
│   │   ├── Tool Selection
│   │   └── Tool Input Accuracy
│   │
│   └── RAG Evaluators
│       ├── Retrieval
│       ├── Document Retrieval
│       └── Groundedness
│
│
├── 11. SAFETY EVALUATION
│   │
│   ├── Hate & Unfairness
│   ├── Sexual
│   ├── Violence
│   ├── Self-Harm
│   ├── Protected Materials
│   └── Content Safety
│
│
├── 12. COST & PERFORMANCE METRICS
│   │
│   ├── Cost
│   │   ├── Input tokens
│   │   ├── Output tokens
│   │   └── Model pricing → total cost
│   │
│   └── Performance
│       ├── End-to-End Response Time
│       │   └── Request → complete response
│       │
│       └── TTFT
│           └── Time To First Token
│
│
├── 13. BASELINE vs VARIANT
│   │
│   ├── Baseline
│   │   └── Current/starting agent
│   │
│   ├── Variant
│   │   └── Modified agent being tested
│   │
│   ├── Possible Changes
│   │   ├── Prompt
│   │   ├── Model
│   │   ├── max_tokens
│   │   ├── Temperature
│   │   ├── Streaming
│   │   └── Retrieval strategy
│   │
│   └── Controlled Experiment
│       └── Change ONE variable at a time
│
│
├── 14. TEST DATASET & SUCCESS CRITERIA
│   │
│   ├── Test Prompts
│   │   ├── Real-world scenarios
│   │   ├── Normal cases
│   │   ├── Ambiguous requests
│   │   ├── Incomplete information
│   │   └── Edge cases
│   │
│   ├── Recommended Small Test Set
│   │   └── 5–10 diverse prompts
│   │
│   ├── Success Criteria
│   │   ├── Quality threshold
│   │   ├── Cost threshold
│   │   ├── Performance threshold
│   │   └── Business requirements
│   │
│   └── Important
│       └── Define criteria BEFORE testing
│
│
├── 15. GIT-BASED EXPERIMENTATION
│   │
│   ├── Git Benefits
│   │   ├── Version control
│   │   ├── Experiment isolation
│   │   └── Reproducibility
│   │
│   ├── Branches
│   │   ├── main
│   │   │   └── Current/production baseline
│   │   │
│   │   └── experiment/*
│   │       └── Individual experiment
│   │
│   ├── Repository
│   │   ├── agent.py
│   │   │   └── Create/deploy agent
│   │   │
│   │   ├── run-agent.py
│   │   │   └── Run test prompts
│   │   │
│   │   ├── prompts/
│   │   │   └── Prompt versions
│   │   │
│   │   ├── test-prompts/
│   │   │   └── Standardized test scenarios
│   │   │
│   │   └── experiments/
│   │       ├── agent-responses.json
│   │       │   └── Raw responses
│   │       └── evaluation.csv
│   │           └── Evaluation results
│   │
│   └── Experiment Workflow
│       ├── Create experiment branch
│       ├── Modify agent
│       ├── Run same tests
│       ├── Capture responses
│       ├── Evaluate
│       ├── Compare baseline vs variant
│       └── Promote validated change
│
│
├── 16. MANUAL EVALUATION
│   │
│   ├── Human reviews response
│   │
│   ├── Evaluation Rubric
│   │   ├── Defines criteria
│   │   ├── Defines score levels
│   │   └── Provides example responses
│   │
│   ├── Example 1–5 Scale
│   │   ├── 5 → Fully meets requirement
│   │   ├── 4 → Minor gaps
│   │   ├── 3 → Partially meets
│   │   ├── 2 → Major gaps
│   │   └── 1 → Misses requirement
│   │
│   └── Goal
│       └── Same rubric → consistent evaluation
│
│
├── 17. CALIBRATION
│   │
│   ├── Purpose
│   │   └── Make evaluators score consistently
│   │
│   ├── Calibration Set
│   │   └── 5–8 representative responses
│   │
│   └── Process
│       ├── Select responses
│       ├── Independent scoring
│       ├── Compare scores
│       ├── Discuss disagreements
│       ├── Clarify rubric
│       └── Repeat
│
│
├── 18. INTER-RATER RELIABILITY
│   │
│   ├── Purpose
│   │   └── Measure evaluator agreement
│   │
│   ├── Reliability Sample
│   │   └── ~10–15 responses
│   │
│   ├── Agreement
│   │   ├── Exact
│   │   │   └── Same score
│   │   │
│   │   ├── Within 1 point
│   │   │   └── Difference ≤ 1
│   │   │
│   │   └── Divergent
│   │       └── Difference ≥ 2
│   │
│   └── Target
│       └── ≥80% agreement within 1 point
│
│
├── 19. STATISTICAL RELIABILITY MEASURES
│   │
│   ├── Cohen's Kappa
│   │   └── 2 raters
│   │
│   ├── Fleiss' Kappa
│   │   └── Multiple raters
│   │
│   ├── Krippendorff's Alpha
│   │   └── General reliability measure
│   │
│   └── ICC
│       └── Agreement/consistency of numerical ratings
│
│
├── 20. PROMOTE OR REJECT EXPERIMENT
│   │
│   ├── Meets success criteria
│   │   ├── Merge → main
│   │   ├── Create version tag
│   │   └── Promote validated version
│   │
│   └── Fails criteria
│       ├── Document results
│       ├── Record why it failed
│       └── Keep/delete branch as appropriate
│
│
├── 21. SCALE EVALUATION
│   │
│   ├── Early stage
│   │   └── Manual human evaluation
│   │
│   ├── Mature stage
│   │   ├── Automated evaluators
│   │   └── Human spot-checks
│   │
│   └── Goal
│       └── Scale evaluation while maintaining quality
│
│
└── 22. CI/CD QUALITY GATE
    │
    ├── Pull Request
    │
    ├── GitHub Actions
    │
    ├── Federated Azure authentication
    │
    ├── Run evaluation
    │
    ├── Generate metrics
    │
    ├── Post results to PR
    │
    ├── Compare against thresholds
    │
    └── Decision
        ├── PASS → Continue/Merge
        └── FAIL → Investigate/Fix
```
# 1. Why Automated Evaluations?

## Automated Evaluation

**Automated evaluation** → Automatically measures the quality of GenAI responses using defined evaluation criteria.

### Why?

Human evaluation is:

* Accurate and contextual
* Good for domain-specific judgment
* Slow
* Expensive
* Difficult to scale

Automated evaluation is:

* Fast
* Consistent
* Repeatable
* Scalable

### Core idea

```text
Human evaluation
→ Better judgment
→ Poor scalability

Automated evaluation
→ High scalability
→ Needs human validation
```

### Human-in-the-Loop (HITL)

```text
Automation
→ Handles volume

Humans
→ Handle judgment, edge cases, and validation
```

**Exam point:** Use automated evaluation for scale, but validate automated evaluators against human judgment.

---

# 2. Align Automated Evaluators With Human Criteria

The automated evaluator should measure quality in a way that agrees with what humans consider a good response.

## Common built-in evaluators

| Evaluator         | Measures                                           |
| ----------------- | -------------------------------------------------- |
| Intent Resolution | Did the response satisfy the user's intent?        |
| Relevance         | Is the response relevant/on-topic?                 |
| Groundedness      | Is the response supported by the provided context? |
| Content Safety    | Is the content safe?                               |

---

# 3. Shadow Rating

**Shadow rating** → Humans and automated evaluators independently evaluate the same examples.

```text
Same evaluation examples
        ↓
 ┌──────┴──────┐
Human        Automated
scores       evaluator
 └──────┬──────┘
        ↓
Compare scores
```

Typical process:

* Use **100–200 representative examples**.
* Humans score responses.
* Automated evaluator scores the same responses.
* Compare the results.

---

# 4. Pearson Correlation

**Pearson correlation** → Measures how closely human scores and automated scores align.

```text
Human scores
      ↕
Automated scores
      ↓
Pearson correlation
```

### Important thresholds

| Correlation | Meaning                                        |
| ----------- | ---------------------------------------------- |
| **≥ 0.7**   | Strong alignment                               |
| **0.5–0.7** | Moderate alignment → investigate               |
| **< 0.5**   | Weak alignment → significant refinement needed |

**Adventure Works target:** **0.75**

### Important distinction

**0.75** → Adventure Works target
**0.7+** → strong alignment threshold

---

# 5. Analyze Disagreements

Example:

```text
Human → 5
AI evaluator → 3
```

Investigate **why** they disagree.

Possible causes:

* Evaluator doesn't understand domain terminology.
* Evaluator penalizes long responses.
* Evaluator misses contextual information.
* Generic evaluator is being used for a specialized domain.

The goal is to identify **evaluator blind spots** and refine the evaluator.

---

# 6. Human Consistency — Cohen's Kappa

If automated and human scores disagree, don't immediately assume the automated evaluator is wrong.

First check whether **humans agree with each other**.

**Cohen's Kappa** → Measures agreement between human evaluators.

```text
Human A
   +
Human B
   ↓
Cohen's Kappa
```

### Interpretation

| Kappa       | Human agreement |
| ----------- | --------------- |
| **> 0.8**   | Excellent       |
| **0.6–0.8** | Substantial     |
| **0.4–0.6** | Moderate        |
| **< 0.4**   | Poor            |

### Critical exam distinction

```text
Pearson correlation
→ Human vs Automated

Cohen's Kappa
→ Human vs Human
```

If humans disagree:

> Fix/clarify the human evaluation criteria before trying to improve the automated evaluator.

---

# 7. Custom Evaluators

Use a **custom evaluator** when built-in evaluators don't capture your application's specific requirements.

Examples:

* Domain-specific terminology
* Regulatory requirements
* Brand voice
* Industry-specific quality
* Custom business rules

### Custom evaluator lifecycle

```text
Create evaluator
      ↓
Shadow rating
      ↓
Compare with humans
      ↓
Calculate correlation
      ↓
Analyze disagreements
      ↓
Refine
      ↓
Revalidate
```

Custom evaluators also need continuous maintenance because models, domains, and requirements can change.

---

# 8. Evaluator Drift

**Evaluator drift** → The automated evaluator becomes less aligned with human judgment over time.

Possible causes:

* Model updates
* Prompt changes
* New user scenarios
* Changed evaluation criteria
* Evaluator updates

### Monitoring

Example:

```text
Production responses
        ↓
Random sample
        ↓
Human + automated evaluation
        ↓
Correlation
        ↓
Detect drift
```

Example monthly sample: **50 production responses**

### Example thresholds

```text
0.75 → Target

0.65 → Warning
       Review / increase sampling

0.55 → Critical
       Consider pausing automated gates

0.45 → Severe
       Return to stronger human evaluation
```

---

# 9. Create Evaluation Datasets

**Evaluation dataset** → Representative test data used to measure GenAI application quality.

The dataset should represent realistic production scenarios.

## Dataset composition

```text
Evaluation Dataset
│
├── Common → 60–70%
├── Variations → 20–30%
├── Edge cases → 5–10%
└── Adversarial → 5–10%
```

### Common scenarios

Normal production usage.

**Purpose:** Establish the quality baseline.

### Variations

Same intent but different wording/context.

**Purpose:** Test robustness and avoid overfitting to specific wording.

### Edge cases

Rare or unusual scenarios.

**Purpose:** Test graceful handling.

### Adversarial cases

Deliberately difficult/malicious inputs.

**Purpose:** Test safety, misuse resistance, and prompt-injection handling.

---

# 10. Evaluation Data Sources

## Production Data

Real user-generated data.

Examples:

* Customer support tickets
* Conversation logs
* Search query logs
* Form submissions

**Advantage:** Highly realistic.

**Limitation:** Usually doesn't contain enough rare or adversarial cases.

---

## Synthetic Data

Artificially generated evaluation examples.

Useful for:

* New systems with no production history
* Rare edge cases
* Adversarial testing
* Controlled variations

### Generation methods

**LLMs** → Generate realistic queries and variations.

**Rule-based templates** → Generate controlled/repeatable examples.

**Domain experts** → Create realistic edge cases.

**Security experts** → Create adversarial scenarios.

**Exam point:** Edge and adversarial cases are often better created manually because domain expertise is important.

---

# 11. Prepare Evaluation Data

```text
Raw Data
   ↓
Clean
   ↓
Anonymize
   ↓
Structure
   ↓
Validate
   ↓
JSONL
```

## Clean

* Remove duplicates.
* Remove empty entries.
* Remove malformed entries.
* Normalize formatting.

## Anonymize

Remove sensitive information such as:

* Names
* Email addresses
* Phone numbers
* Account IDs
* Other PII

**Azure Language PII detection** can identify sensitive information using **Named Entity Recognition (NER)**.

## Structure

* Organize examples by category.
* Add metadata.
* Make filtering and analysis easier.

## Validate

Check:

* Examples are realistic.
* Dataset composition is correct.
* Examples represent the intended scenarios.

---

# 12. JSONL

**JSONL = JSON Lines**

> One JSON object per line.

Typical fields:

```text
query
response
context
ground_truth
```

### Meaning

* `query` → User's input.
* `response` → AI-generated response.
* `context` → Information available to the AI.
* `ground_truth` → Expected/reference answer.

---

# 13. Required Fields for Evaluators

| Evaluator         | Required                         |
| ----------------- | -------------------------------- |
| Intent Resolution | `query` + `response`             |
| Relevance         | `query` + `response`             |
| Groundedness      | `query` + `response` + `context` |
| Content Safety    | `query` + `response`             |

### Important

**Groundedness needs `context`** because it checks whether the response is supported by provided information.

---

# 14. Microsoft Foundry Datasets

Upload the JSONL file to the Foundry project.

```text
JSONL
 ↓
Foundry
 ↓
Dataset
 ↓
Versioned
 ↓
Reusable
```

### Dataset versioning

Uploading another file with the same dataset name creates a **new version**.

```text
Evaluation Dataset
├── Version 1
├── Version 2
└── Version 3
```

Benefits:

* Track dataset changes.
* Compare evaluation results.
* Reuse datasets.
* Maintain consistent evaluation history.

---

# 15. Batch Evaluations With Python

**Batch evaluation** → Run evaluators against an entire evaluation dataset in the cloud.

```text
Dataset
   ↓
Cloud Evaluation
   ↓
Multiple Evaluators
   ↓
Parallel execution
   ↓
Results
```

The evaluation can run at scale without managing local compute.

---

# 16. Data Schema

**Data schema** → Defines the structure and required fields of the evaluation data.

Example:

```text
query
response
context
ground_truth
```

Purpose:

* Validate the dataset.
* Define available fields.
* Act as a contract between the dataset and evaluation service.

---

# 17. Data Mapping

**Data mapping** → Maps dataset fields to evaluator inputs.

Example:

```text
query    → evaluator query
response → evaluator response
context  → evaluator context
```

### Important

Field names are **case-sensitive** and must match the dataset fields correctly.

---

# 18. Testing Criteria

`testing_criteria` defines **which evaluators should run**.

Example:

```text
testing_criteria
│
├── Intent Resolution
│   └── query + response
│
└── Groundedness
    └── query + response + context
```

Each evaluator can specify:

* Evaluator name
* Initialization parameters
* Data mapping

---

# 19. Evaluation Definition vs Evaluation Run

This is an important exam distinction.

### Evaluation Definition

Defines **what and how to evaluate**.

It is reusable.

### Evaluation Run

Actually executes the evaluation against a **specific dataset**.

```text
Evaluation Definition
        ↓
Reusable configuration
        ↓
Evaluation Run
        ↓
Specific dataset
```

### Remember

> **Definition = what/how**
> **Run = execute**

---

# 20. Cloud Evaluation Process

```text
Dataset
   ↓
Load
   ↓
Validate schema
   ↓
Run evaluators
   ↓
Parallel execution
   ↓
Store results
   ↓
Foundry report
```

The service handles:

* Parallel execution
* Retries
* Rate limiting

---

# 21. Asynchronous Evaluation

Evaluation runs are **asynchronous**.

```text
Start evaluation
      ↓
Poll status
      ↓
Completed / Failed
      ↓
Retrieve results
```

Possible failures:

* Insufficient model quota
* Invalid data mapping
* Dataset access problems

---

# 22. Evaluation Results

Each evaluated example can produce:

| Result        | Meaning                           |
| ------------- | --------------------------------- |
| **Label**     | Pass/fail                         |
| **Score**     | Evaluator-specific score          |
| **Threshold** | Pass/fail boundary                |
| **Reason**    | Explanation from evaluator        |
| **Details**   | Additional evaluation information |

Example score ranges:

* Quality → **1–5**
* Safety → **0–7**
* Similarity → **0–1**

---

# 23. Aggregate Results

Two important result views:

```text
run.result_counts
→ Overall pass/fail counts

run.per_testing_criteria_results
→ Results for each evaluator
```

`report_url` → Opens the evaluation results in Microsoft Foundry for filtering, sorting, and visualization.

---

# 24. GitHub Actions Integration

The final step is integrating automated evaluation into CI/CD.

**Goal:** Catch GenAI quality regressions before deployment.

```text
Developer
   ↓
Pull Request
   ↓
GitHub Actions
   ↓
Run evaluation
   ↓
Generate metrics
   ↓
Post results to PR
   ↓
Threshold check
   ↓
PASS / FAIL
```

---

# 25. GitHub Actions Workflow

Workflow file:

```text
.github/workflows/evaluate-on-pr.yml
```

Typical flow:

```text
Trigger
 ↓
Setup Python
 ↓
Install dependencies
 ↓
Azure authentication
 ↓
Run evaluation
 ↓
Generate results
 ↓
Post results to PR
```

The workflow can trigger when relevant prompt/configuration files change.

---

# 26. Azure Authentication in GitHub Actions

Use **federated identity credentials** for keyless authentication.

```text
GitHub Actions
      ↓
Federated Identity
      ↓
Azure
      ↓
Foundry
```

### Why?

Avoid storing long-lived Azure credentials/secrets in GitHub.

Important values include:

```text
AZURE_CLIENT_ID
AZURE_TENANT_ID
AZURE_SUBSCRIPTION_ID
AZURE_RESOURCE_GROUP
FOUNDRY_PROJECT_NAME
```

### Exam point

> **GitHub Actions + Azure → federated credentials = secure keyless authentication.**

---

# 27. GitHub Workflow Permissions

Important permissions:

```yaml
permissions:
  id-token: write
  contents: read
  pull-requests: write
```

### Meaning

**`id-token: write`**

→ Enables federated authentication.

**`contents: read`**

→ Allows repository checkout/read access.

**`pull-requests: write`**

→ Allows posting evaluation results/comments to PRs.

---

# 28. Evaluation Script

GitHub Actions runs the evaluation Python script.

```text
Test dataset
     ↓
Python evaluation
     ↓
results.json
```

Structured output makes it easy for GitHub Actions to parse metrics and determine pass/fail.

Example results:

```text
Groundedness → 4.25
Relevance    → 4.10
Coherence    → 3.85
Status       → PASS/FAIL
```

---

# 29. Evaluation as a Quality Gate

```text
Evaluation
    ↓
Compare metrics with thresholds
    ↓
 ┌──────────────┐
 │              │
PASS          FAIL
 │              │
 ↓              ↓
Continue       Investigate
deployment     / change
```

**PASS** → Metrics meet required thresholds.

**FAIL** → Quality regression needs investigation before merging/deployment.

---

# 30. Complete Day 10 Mental Map

```text
                    GENAI AUTOMATED EVALUATION
                              │
                              ▼
                    Why Automated Evaluation?
                              │
                 ┌────────────┴────────────┐
                 ▼                         ▼
             Automation                  Humans
             Scale/Fast              Judgment/Context
                 │                         │
                 └────────────┬────────────┘
                              ▼
                             HITL
                              │
                              ▼
                    Define Human Criteria
                              │
                              ▼
                     Select Evaluators
                              │
                              ▼
                        Shadow Rating
                        100–200 examples
                              │
                              ▼
                    Pearson Correlation
                              │
                   ┌──────────┼──────────┐
                   ▼          ▼          ▼
                 ≥0.7      0.5–0.7      <0.5
                   │          │          │
                 Good      Investigate  Refine
                   │
                   ▼
              Human Consistency
                   │
                   ▼
             Cohen's Kappa
                   │
                   ▼
          Analyze Disagreements
                   │
                   ▼
          Custom Evaluator if needed
                   │
                   ▼
          Create Evaluation Dataset
                   │
       ┌───────────┼────────────┐
       ▼           ▼            ▼
   Production   Synthetic    Representative
       │           │             │
       └───────────┴─────────────┘
                   ▼
       Common / Variation / Edge / Adversarial
                   │
                   ▼
       Clean → Anonymize → Structure → Validate
                   │
                   ▼
                  JSONL
                   │
                   ▼
          Microsoft Foundry Dataset
                   │
                   ▼
            Batch Evaluation
                   │
       ┌───────────┼────────────┐
       ▼           ▼            ▼
      Schema     Mapping    Testing Criteria
       │           │            │
       └───────────┴────────────┘
                   ▼
          Evaluation Definition
                   │
                   ▼
             Evaluation Run
                   │
                   ▼
          Async Cloud Evaluation
                   │
                   ▼
                Results
                   │
                   ▼
            GitHub Actions
                   │
                   ▼
                 PR
                   │
                   ▼
          Automated Quality Gate
             ┌─────┴─────┐
             ▼           ▼
           PASS         FAIL
             │           │
             ▼           ▼
          Continue    Investigate
          deployment
```

# Final AI-300 Recall Sheet

```text
Pearson
→ Human vs Automated

Cohen's Kappa
→ Human vs Human

Shadow rating
→ Same examples evaluated by humans + AI

Evaluation dataset
→ Common + Variations + Edge + Adversarial

60–70%
→ Common

20–30%
→ Variations

5–10%
→ Edge

5–10%
→ Adversarial

Groundedness
→ Requires context

JSONL
→ One JSON object per line

Data schema
→ Defines dataset structure

Data mapping
→ Connects dataset fields to evaluator inputs

Testing criteria
→ Defines evaluators to run

Evaluation Definition
→ What/how to evaluate

Evaluation Run
→ Actually executes evaluation

Asynchronous evaluation
→ Start → Poll → Complete/Fail → Retrieve results

Federated identity
→ Keyless GitHub → Azure authentication

id-token: write
→ Federated authentication

pull-requests: write
→ Post evaluation results to PR

GitHub Actions
→ Automated evaluation quality gate
```

## Day 10 — One-Sentence Summary

> **GenAIOps evaluation = define human quality criteria → align automated evaluators → build representative evaluation data → run batch evaluations → monitor results → integrate evaluation into GitHub Actions as a continuous quality gate.**
