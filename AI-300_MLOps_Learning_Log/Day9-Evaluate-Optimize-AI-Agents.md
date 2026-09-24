# AI-300 — Day 9 Learning Log

**Date:** 2026-09-24
**Focus:** Evaluate & Optimize AI Agents
**Microsoft Learn Module:** Evaluate and optimize agents

---

```text
EVALUATE & OPTIMIZE AI AGENTS
│
├── 1. Design Evaluation Experiments
│   │
│   ├── Goal
│   │   └── Measure whether an agent change improves the system
│   │
│   ├── Three optimization dimensions
│   │   ├── Quality
│   │   │   └── How good is the response?
│   │   │
│   │   ├── Cost
│   │   │   └── How expensive is the response?
│   │   │
│   │   └── Performance
│   │       └── How fast is the response?
│   │
│   ├── Quality evaluators
│   │   ├── General-purpose
│   │   │   ├── Coherence
│   │   │   └── Fluency
│   │   │
│   │   ├── Textual similarity
│   │   │   ├── Similarity
│   │   │   ├── F1
│   │   │   ├── BLEU
│   │   │   ├── GLEU
│   │   │   ├── ROUGE
│   │   │   └── METEOR
│   │   │
│   │   ├── Agent evaluators
│   │   │   ├── Task Adherence
│   │   │   ├── Task Completion
│   │   │   ├── Intent Resolution
│   │   │   ├── Tool Call Accuracy
│   │   │   ├── Tool Selection
│   │   │   └── Tool Input Accuracy
│   │   │
│   │   └── RAG evaluators
│   │       ├── Retrieval
│   │       ├── Document Retrieval
│   │       └── Groundedness
│   │
│   ├── Safety evaluation
│   │   ├── Hate & Unfairness
│   │   ├── Sexual
│   │   ├── Violence
│   │   ├── Self-Harm
│   │   ├── Protected Materials
│   │   └── Content Safety
│   │
│   └── Custom evaluators
│       └── Organization-specific requirements
│
│
├── 2. Cost & Performance Metrics
│   │
│   ├── Cost
│   │   ├── Token usage
│   │   │   └── Input + output tokens
│   │   │
│   │   └── Model pricing
│   │       └── Converts token usage → cost
│   │
│   └── Performance
│       ├── End-to-end response time
│       │   └── Request → complete response
│       │
│       └── TTFT
│           └── Time To First Token
│
│
├── 3. Define Baseline & Variants
│   │
│   ├── Baseline
│   │   └── Current/starting agent
│   │
│   ├── Variant
│   │   └── Modified agent being tested
│   │
│   ├── Things to experiment with
│   │   ├── Prompt
│   │   ├── Model
│   │   ├── max_tokens
│   │   ├── Temperature
│   │   ├── Streaming
│   │   └── Retrieval strategy
│   │
│   └── Controlled experiment
│       └── Change ONE variable at a time
│
│
├── 4. Define Test Dataset & Success Criteria
│   │
│   ├── Test prompts
│   │   ├── Real-world scenarios
│   │   ├── Normal cases
│   │   ├── Ambiguous requests
│   │   ├── Incomplete information
│   │   └── Edge cases
│   │
│   ├── Recommended test set
│   │   └── 5–10 diverse prompts
│   │
│   ├── Success criteria
│   │   ├── Quality threshold
│   │   ├── Cost threshold
│   │   ├── Performance threshold
│   │   └── Business requirements
│   │
│   └── Important
│       └── Define criteria BEFORE testing
│
│
├── 5. Git-Based Experimentation
│   │
│   ├── Git
│   │   ├── Version control
│   │   ├── Experiment isolation
│   │   └── Reproducibility
│   │
│   ├── Branch structure
│   │   ├── main
│   │   │   └── Current/production baseline
│   │   │
│   │   └── experiment/*
│   │       └── Individual experiment
│   │
│   ├── Repository structure
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
│   │       │
│   │       └── evaluation.csv
│   │           └── Evaluation results
│   │
│   └── Experiment workflow
│       ├── Create branch
│       ├── Change agent
│       ├── Run same tests
│       ├── Capture responses
│       ├── Evaluate
│       ├── Compare
│       └── Promote validated change
│
│
├── 6. Evaluate Agent Responses
│   │
│   ├── Manual evaluation
│   │   └── Human reviews response quality
│   │
│   ├── Evaluation rubric
│   │   ├── Defines scoring criteria
│   │   ├── Defines score levels
│   │   └── Provides example responses
│   │
│   ├── Example scoring
│   │   ├── 5 → Fully meets requirement
│   │   ├── 4 → Minor gaps
│   │   ├── 3 → Partially meets requirement
│   │   ├── 2 → Major gaps
│   │   └── 1 → Misses requirement
│   │
│   └── Important
│       └── Same rubric → consistent evaluation
│
│
├── 7. Calibration
│   │
│   ├── Purpose
│   │   └── Make evaluators score consistently
│   │
│   ├── Calibration set
│   │   └── 5–8 representative responses
│   │
│   ├── Process
│   │   ├── Select responses
│   │   ├── Evaluators score independently
│   │   ├── Compare scores
│   │   ├── Discuss disagreements
│   │   ├── Clarify rubric
│   │   └── Repeat
│   │
│   └── Key idea
│       └── Same response → similar score
│
│
├── 8. Inter-Rater Reliability
│   │
│   ├── Meaning
│   │   └── Measures agreement between evaluators
│   │
│   ├── Reliability test
│   │   └── ~10–15 responses
│   │
│   ├── Agreement types
│   │   ├── Exact agreement
│   │   │   └── Same score
│   │   │
│   │   ├── Within 1 point
│   │   │   └── Score difference ≤ 1
│   │   │
│   │   └── Divergent
│   │       └── Score difference ≥ 2
│   │
│   ├── Target
│   │   └── ≥80% agreement within 1 point
│   │
│   └── If <80%
│       ├── Additional calibration
│       └── Improve/clarify rubric
│
│
├── 9. Statistical Reliability Measures
│   │
│   ├── Cohen's Kappa
│   │   └── Agreement between 2 raters
│   │
│   ├── Fleiss' Kappa
│   │   └── Agreement between multiple raters
│   │
│   ├── Krippendorff's Alpha
│   │   └── General reliability measure
│   │
│   └── ICC
│       └── Agreement/consistency of numerical ratings
│
│
├── 10. Promote or Reject Experiment
│   │
│   ├── Experiment meets criteria
│   │   ├── Merge branch → main
│   │   ├── Create version tag
│   │   └── Promote validated version
│   │
│   └── Experiment fails
│       ├── Document results
│       ├── Record why it failed
│       └── Keep/delete branch as appropriate
│
│
└── 11. Scale Evaluation
    │
    ├── Initial stage
    │   └── Manual human evaluation
    │
    ├── Mature stage
    │   ├── Automated evaluators
    │   └── Human spot-checks
    │
    └── Goal
        └── Scale evaluation while maintaining quality
```

## AI-300 Exam Memory Map

```text
AGENT OPTIMIZATION
│
├── WHAT?
│   └── Quality + Cost + Performance
│
├── HOW?
│   └── Controlled experiments
│       └── Change one variable at a time
│
├── TEST?
│   └── Same test prompts
│       └── Representative + edge cases
│
├── MEASURE?
│   ├── Quality
│   ├── Cost
│   └── Performance
│
├── VERSION?
│   └── Git branches
│
├── HUMAN EVALUATION?
│   ├── Rubric
│   ├── Calibration
│   └── Inter-rater reliability
│
├── RELIABILITY?
│   └── ≥80% within 1 point
│
└── PROMOTE?
    ├── Meets criteria → merge → main → tag
    └── Fails → document experiment
```

### One-line recall

> **Define → Branch → Change → Test → Evaluate → Compare → Calibrate → Validate → Merge.**

### Most important numbers

```text
5–10       → Test prompts
5–8        → Calibration responses
10–15      → Reliability test responses
≥80%       → Agreement within 1 point
1 point    → Acceptable scoring difference
2+ points  → Divergent scoring
```

## 1. Design Evaluation Experiments

### Core idea

**Evaluation experiment →** A controlled way to measure whether an agent change actually improves the system.

### Three optimization dimensions

| Dimension       | Meaning                                       |
| --------------- | --------------------------------------------- |
| **Quality**     | How well the agent answers the user's request |
| **Cost**        | How expensive the agent is to operate         |
| **Performance** | How quickly the agent responds                |

### Quality evaluators

**General-purpose**

* **Coherence** → Is the response logically organized?
* **Fluency** → Is the response natural and readable?

**Textual similarity**

* **Similarity** → How similar is output to a reference answer?
* **F1** → Balances precision and recall.
* **BLEU** → Compares generated text with reference text.
* **GLEU** → Measures language similarity.
* **ROUGE** → Measures overlap with reference text.
* **METEOR** → Measures linguistic similarity.

**Agent evaluators**

* **Task Adherence** → Did the agent follow instructions?
* **Task Completion** → Did it complete the task?
* **Intent Resolution** → Did it understand the user's intent?
* **Tool Call Accuracy** → Was the tool call correct?
* **Tool Selection** → Did it select the right tool?
* **Tool Input Accuracy** → Were correct inputs supplied?

**RAG evaluators**

* **Retrieval** → How well information is retrieved.
* **Document Retrieval** → Whether appropriate documents were retrieved.
* **Groundedness** → Whether the answer is supported by retrieved information.
* **Groundedness Pro** → Advanced groundedness evaluation.

**Safety evaluators**

* Hate and Unfairness
* Sexual
* Violence
* Self-Harm
* Protected Materials
* Content Safety

**Custom evaluators →** Used for organization-specific requirements such as brand voice or regulatory compliance.

---

## 2. Cost Evaluation

### Token usage

**Token usage →** Number of input and output tokens processed.

### Model pricing

**Model pricing →** Converts token usage into actual operating cost.

### Key principle

A cheaper model isn't automatically better.

You must verify:

**Cost ↓ + Quality acceptable + Performance acceptable**

---

## 3. Performance Evaluation

### End-to-end response time

**Total time →** Time from user request until complete response.

### TTFT

**Time-to-first-token (TTFT) →** Time until the first generated token reaches the user.

### Important distinction

**Streaming →** Can improve perceived responsiveness but doesn't necessarily reduce total response time.

---

# 4. Baseline vs Variant

### Baseline

**Baseline →** Current/starting agent configuration.

### Variant

**Variant →** Modified version being tested against the baseline.

Examples:

* New prompt
* Different model
* Different retrieval strategy
* Different token limit
* Different temperature

---

# 5. Agent Configuration Experiments

### `max_tokens`

**`max_tokens` →** Limits maximum generated output.

Lower limit can:

* Reduce potential cost
* Reduce latency
* Risk truncating responses

### `stream: true`

**Streaming →** Returns generated output progressively.

### Temperature

**Temperature →** Controls response variability.

* Lower → more consistent
* Higher → more variable/creative

### Retrieval strategy

**Retrieval strategy →** Controls how relevant information is found for the agent.

---

# 6. Controlled Experimentation

### Most important principle

> **Change one variable at a time.**

Example:

Bad experiment:

```text
Model changed
+
Prompt changed
+
Temperature changed
```

You cannot determine which change caused the result.

Better:

```text
Change model
→ evaluate

Change prompt
→ evaluate

Change temperature
→ evaluate
```

### AI-300 memory

**Controlled experiment = isolate the effect of each change.**

---

# 7. Test Prompts

Use **representative real-world scenarios**.

Include:

* Normal scenarios
* Ambiguous requests
* Incomplete information
* Last-minute changes
* Edge cases

### Practical test set

**5–10 diverse prompts** can provide useful manual/smoke-test coverage.

Each test should define:

* User query
* Expected information needs
* Ideal response characteristics

---

# 8. Success Criteria

Define thresholds **before** running the experiment.

Example:

```text
Quality           ≥ 4.2 / 5
Individual score  ≥ 3.5 / 5
Cost reduction    ≥ 60%
Resolution rate   ≥ 85%
Response time     < 30 sec
TTFT              < 2 sec
```

### Why?

You compare the experiment against **predefined business requirements**, rather than changing expectations after seeing results.

---

# 9. Git-Based Experimentation Workflow

Git provides:

* Version control
* Experiment isolation
* Reproducibility
* Collaboration
* Ability to compare variants

### Basic workflow

```text
Create branch
      ↓
Change agent
      ↓
Run same test prompts
      ↓
Capture responses
      ↓
Evaluate
      ↓
Compare against criteria
      ↓
Merge successful experiment
```

---

# 10. Experiment Branches

Each experiment should have its own branch.

Example:

```text
main
├── experiment/prompt-v2
├── experiment/model-change
└── experiment/token-optimization
```

### Main

**`main` →** Production/current baseline.

### Experiment branch

**Experiment branch →** Isolated version of one specific change.

### Key principle

> **One experiment/variant → one isolated branch.**

---

# 11. Recommended Repository Structure

```text
adventure-works-agent/
│
├── agent.py
├── run-agent.py
│
├── prompts/
│   ├── system-prompt-v1.txt
│   └── system-prompt-v2.txt
│
├── test-prompts/
│   ├── scenario-1.txt
│   ├── scenario-2.txt
│   └── scenario-3.txt
│
└── experiments/
    ├── prompt-v2/
    │   ├── agent-responses.json
    │   └── evaluation.csv
    │
    └── model-change/
        ├── agent-responses.json
        └── evaluation.csv
```

### Important files

**`agent.py` →** Creates/deploys the agent.

**`run-agent.py` →** Runs test prompts against the agent.

**`prompts/` →** Stores prompt versions.

**`test-prompts/` →** Stores standardized test scenarios.

**`agent-responses.json` →** Stores raw agent outputs.

**`evaluation.csv` →** Stores evaluation results.

---

# 12. Manual Evaluation

Humans review agent responses using predefined criteria.

Typical scoring:

**1 → Poor**

**5 → Excellent**

Example criteria:

* Intent Resolution
* Relevance
* Groundedness

### Important

Use the **same criteria across experiments** so results can be compared fairly.

---

# 13. Comparing Experiments

For each experiment:

```text
Run same prompts
      ↓
Evaluate responses
      ↓
Record scores
      ↓
Compare with baseline
      ↓
Check success criteria
```

### Important

Don't simply ask:

> "Which experiment has the highest score?"

Ask:

> "Does this experiment satisfy the predefined requirements?"

---

# 14. Promoting an Experiment

If an experiment meets requirements:

```bash
git checkout main
git merge experiment/prompt-v2
git tag promoted-version
git push origin main --tags
```

### Commands

**`git checkout main` →** Switch to main.

**`git merge` →** Merge validated changes.

**`git tag` →** Mark a specific release/version.

**`git push` →** Push changes to remote repository.

### AI-300 scenario

**Validated experiment → merge into `main` and version/tag the release.**

---

# 15. Failed Experiments

Failed experiments are still useful.

Record:

* What changed
* What was tested
* Results
* Why it failed
* Which requirement wasn't met

### Principle

> **Document failed experiments so the team doesn't repeat them.**

---

# 16. Evaluation Rubrics

### Rubric

**Rubric →** A standardized guide defining what each score means.

Bad:

```text
5 = Good
3 = Average
1 = Bad
```

Better:

```text
5 → Fully addresses user's need
4 → Addresses core need with minor gaps
3 → Partially addresses need
2 → Related but misses core need
1 → Completely misses user's intent
```

### Why?

Different evaluators can interpret "good" differently.

A detailed rubric reduces this subjectivity.

---

# 17. Use Examples in Rubrics

Each score should have **concrete example responses**.

Example:

**Score 5 →** Completely answers the user's request.

**Score 3 →** Answers part of the request but misses important information.

**Score 1 →** Doesn't address the user's actual intent.

### AI-300

**Rubric + examples → more consistent human evaluation.**

---

# 18. Calibration

### Calibration

**Calibration →** Evaluators independently score the same responses and then compare their reasoning.

Workflow:

```text
Select sample responses
        ↓
Evaluators score independently
        ↓
Compare scores
        ↓
Discuss disagreements
        ↓
Clarify rubric
        ↓
Repeat
```

### Calibration set

Use approximately:

**5–8 representative responses**

Include:

* High-quality responses
* Medium-quality responses
* Poor responses
* Ambiguous responses

---

# 19. Handling Evaluator Disagreement

Example:

```text
Evaluator A → 5
Evaluator B → 3
```

Difference = **2 points**

This is a significant disagreement.

Discuss:

* Why did each evaluator choose the score?
* Was the rubric ambiguous?
* Does the rubric need better examples?

Then update the rubric if needed.

---

# 20. Inter-Rater Reliability

### Inter-rater reliability

**Inter-rater reliability →** Measures how consistently multiple evaluators score the same responses.

Example:

```text
Same responses
      ↓
Multiple evaluators
      ↓
Independent scoring
      ↓
Measure agreement
```

### Reliability categories

**Exact agreement →** Same score.

**Within 1 point →** Scores differ by no more than 1.

**Divergent →** Scores differ by 2 or more.

---

# 21. 80% Agreement Target

Important number:

> **Target ≥80% agreement within one point.**

If agreement is below 80%:

**→ Perform additional calibration.**

Then:

**→ Clarify/improve the rubric.**

### Example

30 total scoring opportunities:

```text
18 exact agreements
10 within 1 point
2 divergent
```

Within-one-point agreement:

```text
18 + 10 = 28

28 / 30 = 93%
```

Therefore:

**93% agreement within one point → exceeds 80% target.**

---

# 22. Statistical Reliability Measures

### Cohen's Kappa

**Cohen's Kappa →** Agreement measure for **two raters**, accounting for chance agreement.

### Fleiss' Kappa

**Fleiss' Kappa →** Agreement measure for **multiple raters**.

### Krippendorff's Alpha

**Krippendorff's Alpha →** General reliability measure that accounts for chance agreement.

### ICC

**Intraclass Correlation Coefficient →** Measures consistency/agreement for numerical ratings.

### Practical approach

For small teams:

**Percent agreement within one point → simple and easy to interpret.**

---

# 23. Maintain Evaluation Reliability

Calibration should not happen only once.

Recheck reliability:

* At the beginning of major optimization work
* When adding new evaluators
* Periodically during long evaluation projects

### Reason

**Evaluator drift →** Evaluators may gradually interpret scoring criteria differently over time.

---

# 24. Human + Automated Evaluation

### Starting point

**Manual human evaluation →** Helps understand response quality deeply.

### Scaling

**Automated evaluation + human spot-checks →** Allows evaluation of large numbers of responses.

### AI-300 scenario

If thousands of responses must be evaluated:

> Use automated evaluators for scale + human spot-checks for quality control.

---

# AI-300 MASTER CHEAT SHEET — DAY 9

```text
EVALUATION
│
├── Quality
│   ├── Coherence
│   ├── Fluency
│   ├── Intent Resolution
│   ├── Task Adherence
│   └── Task Completion
│
├── RAG
│   ├── Retrieval
│   ├── Document Retrieval
│   └── Groundedness
│
├── Cost
│   └── Token usage
│
└── Performance
    ├── Response time
    └── TTFT
```

```text
EXPERIMENT
│
├── Baseline
├── Variant
├── Test prompts
├── Success criteria
├── Controlled change
└── Compare results
```

```text
GIT WORKFLOW
│
├── Experiment branch
├── Change agent
├── Run tests
├── agent-responses.json
├── evaluation.csv
├── Compare
└── Successful → merge → main → tag
```

```text
HUMAN EVALUATION
│
├── Rubric
├── Examples
├── Calibration
├── Inter-rater reliability
│
├── ≥80% within 1 point → good
│
└── <80%
    └── recalibrate + improve rubric
```

---

# Day 9 — 10 Things to Remember

1. **Quality + Cost + Performance** are the core optimization dimensions.
2. **Baseline** = current version; **Variant** = version being tested.
3. Use **controlled experiments** and isolate changes.
4. Use the **same test prompts** when comparing variants.
5. Define **success criteria before testing**.
6. Use **Git branches** to isolate experiments.
7. `agent-responses.json` stores responses; `evaluation.csv` stores evaluation results.
8. **Rubrics** make human scoring consistent.
9. **≥80% agreement within one point** is the important reliability target.
10. For scale, use **automated evaluation + human spot-checks**.

---

## One-minute Day 9 revision

> **Design → Experiment → Evaluate → Compare → Optimize**

**Design:** Define quality, cost, performance and success criteria.

**Experiment:** Create an isolated Git branch and change one variable.

**Evaluate:** Run the same test prompts and score responses using consistent rubrics.

**Compare:** Compare results against the baseline and predefined thresholds.

**Optimize:** Promote validated changes to `main`, while documenting failed experiments.

**Human evaluation:** Use rubrics → calibration → inter-rater reliability → target ≥80% within one point.
