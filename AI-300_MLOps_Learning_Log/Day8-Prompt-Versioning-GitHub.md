# AI-300 Learning Log - Day8

Date: 2026-09-23 Topic: GenAIOps — Manage prompts for agents in Microsoft Foundry with GitHub

**AI-300 — Machine Learning Operations Engineer Associate**

## Mental Map

```text
                         GenAIOps
                            │
                            ▼
                    Prompt Management
                            │
          ┌─────────────────┴─────────────────┐
          │                                   │
          ▼                                   ▼
   Prompt Versioning                    Foundry Agents
          │                                   │
          ▼                                   ├── Agent Definition
        GitHub                                ├── System Instructions
          │                                   ├── Model
    ┌─────┼─────┐                             └── Tools
    │     │     │
    ▼     ▼     ▼
 Branch  PR   Git Tags
    │     │     │
    └─────┼─────┘
          ▼
       Testing
          │
          ▼
      Validation
          │
          ▼
        Review
          │
          ▼
        Merge
          │
          ▼
       Deployment
          │
          ▼
   Microsoft Foundry
          │
          ▼
       Monitoring
          │
     ┌────┴────┐
     ▼         ▼
   Healthy   Problem
               │
               ▼
            Rollback
```

## 1. Prompt Version Control

Prompts should be treated like production code.

Version control provides:

* Change history
* Collaboration
* Traceability
* Code/prompt review
* Rollback capability
* Consistency across environments

### Core principle

```text
Prompt
  ↓
Git
  ↓
Version
  ↓
Review
  ↓
Test
  ↓
Deploy
```

A prompt change can change the behavior of an AI agent, so production prompts shouldn't be modified manually without a controlled workflow.

---

## 2. Microsoft Foundry Agents

A Foundry agent combines:

```text
Agent
├── Agent definition / metadata
├── System instructions
├── Model
└── Tools
```

### Simple recall

```text
Agent = Identity + Prompt + Model + Tools
```

### System instructions

System instructions define the agent's behavior, role, constraints, and capabilities.

Changing the instructions can change the behavior of the agent.

Therefore:

```text
Prompt change
     ↓
Agent behavior change
```

---

## 3. Agent Versioning

When an agent is modified, a new agent version can be created.

```text
Agent v1
   ↓
Prompt improvement
   ↓
Agent v2
   ↓
Another change
   ↓
Agent v3
```

Different versions can be tested using the same scenarios to determine whether a new prompt improves or degrades performance.

### Regression

A regression occurs when a newer version performs worse than an earlier version.

```text
v1 → Good
v2 → Better
v3 → Worse
         ↓
     Regression
```

Never assume that a newer prompt is automatically better.

---

## 4. Managing Prompts Separately

Prompts can be stored separately from deployment code.

Example:

```text
project/
├── trail_guide_agent.py
└── prompts/
    ├── v1_instructions.txt
    ├── v2_instructions.txt
    └── v3_instructions.txt
```

Python can read the prompt:

```python
with open("prompts/v1_instructions.txt", "r") as f:
    instructions = f.read().strip()
```

Then use it when creating the Foundry agent.

Example:

```python
agent = project_client.agents.create_agent(
    model=os.environ["MODEL_NAME"],
    name=os.environ["AGENT_NAME"],
    instructions=instructions
)
```

Authentication can use:

```python
from azure.identity import DefaultAzureCredential
```

This avoids hardcoding credentials.

---

# 5. Prompt File Formats

Different formats can be used depending on the requirement.

| Format    | Use                                  |
| --------- | ------------------------------------ |
| `.txt`    | Simple system instructions           |
| `.md`     | Prompt + documentation               |
| `.json`   | Structured data/API integration      |
| `.yaml`   | Configuration + metadata             |
| `.py`     | Dynamic/programmatic prompts         |
| `.jinja2` | Template-based variable substitution |

### Examples

Simple prompt:

```text
v1_instructions.txt
```

Documentation:

```text
prompt-guidelines.md
```

Configuration:

```text
agent.yaml
```

Dynamic template:

```text
customer_prompt.jinja2
```

---

# 6. GitHub Repository Structure

A well-organized GenAIOps repository separates responsibilities.

```text
project-root/
│
├── README.md
├── .env
├── .gitignore
├── requirements.txt
│
├── src/
│   └── agents/
│       ├── trail_guide_agent/
│       │   ├── trail_guide_agent.py
│       │   └── prompts/
│       │       ├── v1_instructions.txt
│       │       ├── v2_instructions.txt
│       │       └── v3_instructions.txt
│       │
│       ├── customer_support_agent/
│       │   ├── support_agent.py
│       │   └── prompts/
│       │       ├── v1_greeting.txt
│       │       └── v2_greeting.txt
│       │
│       └── content_generator/
│           ├── content_agent.py
│           └── prompts/
│               └── blog_post.txt
│
├── tests/
│   ├── test_trail_guide.py
│   └── test_support_agent.py
│
├── docs/
│   ├── deployment-guide.md
│   ├── testing-standards.md
│   └── prompt-guidelines.md
│
├── infra/
│   └── main.bicep
│
└── .github/
    └── workflows/
        ├── test-agents.yml
        └── deploy-agents.yml
```

### Directory responsibilities

```text
src/                  → Application/agent source code
tests/                → Automated tests
docs/                 → Documentation
infra/                → Infrastructure as Code
.github/workflows/    → CI/CD
prompts/              → Prompt files
README.md             → Project overview
requirements.txt      → Python dependencies
.env                  → Environment configuration
```

**Never commit secrets stored in `.env`.**

---

# 7. Naming Conventions

Use clear and descriptive names.

Good:

```text
customer_support_agent.py
trail_guide_agent.py
v1_instructions.txt
v2_instructions.txt
```

Avoid unclear names such as:

```text
agent2.py
final_prompt_new.txt
test123.txt
```

Use consistent versioning:

```text
v1
v2
v3
```

Prompt versions can be aligned with Foundry agent versions.

```text
v1_instructions.txt → Agent v1
v2_instructions.txt → Agent v2
v3_instructions.txt → Agent v3
```

---

# 8. Git Tags

Git tags can identify a specific deployment state.

Example:

```bash
git tag v1
git tag v2
git tag v3
```

A tag can map:

```text
Git tag
   ↓
Repository state
   ↓
Prompt version
   ↓
Deployment
   ↓
Foundry agent version
```

### Why use tags?

* Traceability
* Debugging
* Release identification
* Rollback

Example:

```text
Production
   ↓
Agent v3
   ↓
Git tag v3
   ↓
Exact repository state
```

---

# 9. Safe Prompt Development Workflow

Prompt changes should not go directly into production.

The safe workflow is:

```text
Create branch
     ↓
Modify prompt
     ↓
Test
     ↓
Commit
     ↓
Pull Request
     ↓
Validation
     ↓
Review
     ↓
Merge
     ↓
Git Tag
     ↓
Deploy
     ↓
Monitor
```

---

# 10. Git Branch Types

### Feature branch

Used for new functionality or improvements.

```bash
git checkout -b feature/improve-customer-greeting
```

### Experiment branch

Used to test alternative approaches.

```text
experiment/tone-variations
```

### Hotfix branch

Used for urgent production fixes.

```text
hotfix/fix-greeting-error
```

### Quick recall

```text
feature/     → New capability
experiment/  → Try alternatives
hotfix/      → Urgent production fix
```

---

# 11. Create a Development Branch

Start from the latest `main`:

```bash
git checkout main
git pull origin main
git checkout -b feature/improve-customer-greeting
```

### Why?

To ensure the new work starts from the latest approved state.

```text
Remote main
    ↓
git pull
    ↓
Latest local main
    ↓
Feature branch
```

---

# 12. Develop and Test

On the development branch:

```text
Modify prompt
     ↓
Test sample inputs
     ↓
Review outputs
     ↓
Refine prompt
     ↓
Test again
```

Prompt development is iterative.

Example:

```text
v1
 ↓
Test
 ↓
Poor response
 ↓
Improve prompt
 ↓
v2
 ↓
Test again
```

Document:

* What changed
* Why it changed
* Expected improvement
* Test results

---

# 13. Commit Changes

Use meaningful commit messages.

Example:

```bash
git add prompts/customer-support/greeting.md
```

```bash
git commit -m "Improve customer greeting clarity"
```

A detailed commit can include:

```text
Improve customer greeting clarity

- Simplified technical language
- Added personalization elements
- Updated test cases
- Version bump to 1.3.0
```

Good commits provide useful historical information.

---

# 14. Pull Request Workflow

After development and testing:

```text
Feature branch
      ↓
Pull Request
      ↓
Review
```

A good PR should contain:

* Description of changes
* Reason for the change
* Testing results
* Performance comparison
* Potential impact
* Relevant reviewers

Example:

```text
Prompt:
v1.2 → v1.3

Changes:
- Simplified technical language
- Added personalization

Testing:
- Tested representative scenarios

Results:
- Improved response clarity
- No observed regression
```

---

# 15. Prompt Lifecycle

The five major stages are:

```text
Development
     ↓
Validation
     ↓
Review
     ↓
Production
     ↓
Monitoring
```

### Development

Goal:

> Create and refine functionality.

Activities:

* Drafting
* Initial testing
* Iteration

Success:

> Meets functional requirements.

### Validation

Goal:

> Verify quality and performance.

Activities:

* Comprehensive testing
* A/B comparison
* Documentation review

Success:

> Meets or exceeds benchmarks.

### Review

Goal:

> Obtain team/stakeholder approval.

Activities:

* Prompt/code review
* Stakeholder approval

Success:

> Consensus and formal approval.

### Production

Goal:

> Provide reliable service to real users.

Activities:

* Deployment
* Monitoring
* Performance tracking

Success:

> Stable performance and user satisfaction.

### Monitoring

Goal:

> Continuously validate production performance.

Activities:

* Metrics
* User feedback
* Alerts

Success:

> Maintain or improve performance.

---

# 16. Complete Prompt Lifecycle

```text
             DEVELOPMENT
                  │
                  ▼
              VALIDATION
                  │
                  ▼
                REVIEW
                  │
                  ▼
              PRODUCTION
                  │
                  ▼
              MONITORING
                  │
                  ▼
              FEEDBACK
                  │
                  ▼
             DEVELOPMENT
```

This is a continuous lifecycle, not a one-time process.

---

# 17. Automation Opportunities

GenAIOps workflows can automate:

```text
Automated Testing
        │
        ▼
Performance Monitoring
        │
        ▼
Deployment Pipelines
        │
        ▼
Rollback Procedures
```

### Automated testing

```text
Prompt change
     ↓
Test suite
     ↓
Pass / Fail
```

### Performance monitoring

```text
Production
     ↓
Metrics
     ↓
Performance degradation
     ↓
Alert
```

### Deployment pipeline

```text
GitHub
  ↓
Validation
  ↓
Approval
  ↓
Deployment
```

### Rollback

```text
New version
    ↓
Problem
    ↓
Rollback
    ↓
Previous known-good version
```

---

# 18. Full GenAIOps Prompt Workflow

```text
Developer
    │
    ▼
Create feature/experiment branch
    │
    ▼
Modify prompt
    │
    ▼
Local testing
    │
    ▼
Commit changes
    │
    ▼
Pull Request
    │
    ▼
Validation
    │
    ├── Automated testing
    ├── Performance testing
    └── A/B comparison
    │
    ▼
Team Review
    │
    ├── Reject → Modify → Test again
    │
    └── Approve
           │
           ▼
         Merge
           │
           ▼
        Git Tag
           │
           ▼
      Production
           │
           ▼
       Monitoring
           │
      ┌────┴────┐
      ▼         ▼
   Healthy    Problem
      │         │
      │         ▼
      │      Rollback
      │         │
      └─────────┘
```

---

# 19. AI-300 Exam Quick Recall

| Scenario                        | Think                                     |
| ------------------------------- | ----------------------------------------- |
| Track prompt changes            | Git/version control                       |
| Try an alternative prompt       | Experiment branch                         |
| Add new functionality           | Feature branch                            |
| Urgent production correction    | Hotfix branch                             |
| Review before production        | Pull Request                              |
| Compare prompt quality          | Validation / A-B testing                  |
| New version performs worse      | Regression                                |
| Identify exact deployed state   | Git tag                                   |
| Restore previous prompt         | Rollback                                  |
| Continuously observe production | Monitoring                                |
| Simple system instructions      | `.txt`                                    |
| Documentation                   | `.md`                                     |
| Structured configuration        | YAML / JSON                               |
| Dynamic prompt                  | `.py`                                     |
| Variable template               | `.jinja2`                                 |
| Agent behavior                  | System instructions                       |
| Agent components                | Definition + Instructions + Model + Tools |

---

# 20. Day 8 Final Cheat Sheet

```text
PROMPT AS CODE
      ↓
Git Version Control
      ↓
Branch
      ↓
Develop
      ↓
Test
      ↓
Commit
      ↓
Pull Request
      ↓
Validate
      ↓
Review
      ↓
Merge
      ↓
Git Tag
      ↓
Microsoft Foundry
      ↓
Agent Version
      ↓
Production
      ↓
Monitor
      ↓
Regression?
   /       \
 No         Yes
 │           │
 │        Rollback
 │           │
 └───────────┘
```

### Key definitions

```text
Prompt Versioning
→ Managing prompt changes using source control.

Foundry Agent
→ AI agent combining model, instructions, and tools.

Regression
→ New version performs worse than an earlier version.

Feature Branch
→ Branch for developing a new capability.

Experiment Branch
→ Branch for testing alternative approaches.

Hotfix Branch
→ Branch for urgent production fixes.

Pull Request
→ Review and approval gate before merging.

Validation
→ Comprehensive testing against quality/performance benchmarks.

Git Tag
→ Marker identifying a specific repository/release state.

Monitoring
→ Continuous observation of production behavior.

Rollback
→ Restore a previous known-good version.
```

## Day 8 — Main Takeaway

> **GenAIOps applies DevOps practices to prompts and AI agents: store prompts in Git, develop them in branches, test and validate changes, review them through Pull Requests, tag releases, deploy controlled versions to Microsoft Foundry, monitor production, and roll back when necessary.**

This connects directly to the DevOps/MLOps workflow you've already learned:

```text
DevOps
Git → Branch → PR → CI → CD → Monitor → Rollback

GenAIOps
Prompt → Git → Branch → PR → Evaluation → Deploy → Monitor → Rollback
```

**Microsoft Learn modules covered:** Prompt versioning and management, Foundry agent versioning, GitHub repository structure, and safe prompt workflow development.
