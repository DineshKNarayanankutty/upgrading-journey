# AI-300 Learning Log - Day7

**Date:** 2026-09-21
**Topic:** GenAIOps — Plan & Prepare
**Microsoft Learn Module:** Plan and prepare for GenAIOps

---

# 1. What is GenAIOps?

GenAIOps = practices used to **develop, evaluate, deploy, monitor, govern, and continuously improve GenAI applications and agents**.

### Traditional MLOps

```text
Data
 ↓
Train
 ↓
Evaluate
 ↓
Register
 ↓
Deploy
 ↓
Monitor
 ↓
Retrain
```

### GenAIOps

```text
Plan
 ↓
Build
 ↓
Evaluate
 ↓
Deploy
 ↓
Monitor
 ↓
Improve
 ↺
```

GenAIOps adds AI-specific concerns such as:

* Prompts
* Foundation models
* RAG
* Agents
* Tools
* Groundedness
* AI evaluation
* Token usage
* Cost
* Safety
* Tracing

---

# 2. Agent Specifications

Before building an agent, define what it is supposed to do.

## User intent

Define:

```text
Why?
Who?
What problem?
```

**One line:** User intent defines the purpose, audience, and problem the agent solves.

---

## Suggested prompts

Two important types:

### Display prompt

What the user sees as an example.

### Command prompt

Instructions that control agent behavior.

**One line:** Display prompts guide users; command prompts guide the agent.

---

## Capabilities

Define:

```text
Functions
+
Tools / Data
+
Restrictions
```

**One line:** Capabilities define what the agent can do, access, and must not do.

---

## Evaluation

Define how you will determine whether the agent works correctly.

Common evaluation criteria:

* Relevance
* Groundedness
* Coherence
* Safety
* Task adherence

### Rubric

A predefined set of criteria used to judge AI responses.

**One line:** Rubric = predefined rules for measuring AI output quality.

### Shadow rating

AI operates alongside humans and its responses are evaluated without affecting the real user experience.

**One line:** Shadow rating = evaluate AI responses alongside human responses before fully trusting the AI.

---

## Test data

### Smoke tests

Small, quick tests to verify basic functionality.

### Automated evaluation

Run a larger set of test cases automatically.

### Coverage mix

Include:

* Normal cases
* Edge cases
* Ambiguous cases
* Invalid requests
* Requests the agent should refuse

**One line:** Good test data checks both normal behavior and failure/edge cases.

---

# 3. Model Selection

When selecting a model, consider:

```text
Task
Quality
Latency
Cost
Model capability
```

---

## Chat completion model

Used for:

* Conversations
* Question answering
* Summarization
* General text generation

**One line:** Chat models are optimized for conversational/generative tasks.

---

## Reasoning model

Used for:

* Complex reasoning
* Multi-step logic
* Difficult mathematical/problem-solving tasks

**One line:** Reasoning models are designed for more complex reasoning tasks.

---

## LLM vs SLM

### LLM

Large Language Model:

* More capable
* Usually more expensive
* Suitable for complex tasks

### SLM

Small Language Model:

* Smaller
* Faster
* Usually cheaper
* Suitable for simpler/focused tasks

**Exam rule:**

> Choose the smallest model that satisfies the required quality.

---

# 4. Grounding

Grounding means providing the model with reliable external information so that responses are based on relevant data.

Two important approaches:

```text
Grounding
│
├── RAG
└── Fine-tuning
```

---

## RAG

Retrieval-Augmented Generation.

```text
Question
 ↓
Retrieve relevant information
 ↓
Provide context to model
 ↓
Generate answer
```

Use RAG when information is:

* Current
* Frequently changing
* Private
* External to the model
* Enterprise-specific

Examples:

```text
Company policies
Product catalog
Inventory
Knowledge base
Internal documents
```

**One line:** RAG gives the model relevant external information at runtime.

### Exam trigger

```text
Current data
Frequently changing data
Enterprise knowledge
↓
RAG
```

---

# 5. Fine-tuning

Fine-tuning takes a pretrained model and trains it further using task-specific examples.

```text
Pretrained model
+
Training examples
 ↓
Fine-tuned model
```

Useful for:

* Specialized behavior
* Consistent style
* Consistent tone
* Specific task patterns

**One line:** Fine-tuning changes/specializes model behavior.

---

## RAG vs Fine-tuning

| Requirement                         | Use               |
| ----------------------------------- | ----------------- |
| Current information                 | RAG               |
| Frequently changing data            | RAG               |
| Private enterprise knowledge        | RAG               |
| Current product catalog             | RAG               |
| Specific behavior                   | Fine-tuning       |
| Consistent tone/style               | Fine-tuning       |
| Current data + specialized behavior | RAG + Fine-tuning |

### Memory trick

> **RAG changes the information the model sees.**
> **Fine-tuning changes the behavior of the model.**

---

# 6. Agent Optimization

Agent optimization is iterative.

```text
Change prompt/model/RAG
        ↓
Smoke test
        ↓
Automated evaluation
        ↓
Compare against rubric
        ↓
Improve
        ↺
```

**One line:** Don't optimize an agent based on a few examples; repeatedly evaluate changes against a defined test set.

---

# 7. GenAIOps Lifecycle

The GenAIOps lifecycle has three main loops:

```text
EXPLORE
   ↓
BUILD
   ↓
OPERATIONALIZE
```

With **Management** applying across everything.

---

## Explore

Question:

> What should we build?

Includes:

* Business use case
* Requirements
* Architecture
* Model selection
* Prompt design
* Data/knowledge requirements

**One line:** Explore = define and design the GenAI solution.

---

## Build

Question:

> Does it actually work?

Includes:

* Develop application/agent
* Configure prompts
* Connect tools/data
* Evaluate
* Improve
* Repeat

**One line:** Build = develop, evaluate, and iteratively improve the AI application.

---

## Operationalize

Question:

> Can we reliably run it in production?

Includes:

* CI/CD
* Deployment
* Monitoring
* Reliability
* Performance
* Cost management

**One line:** Operationalize = deploy and reliably operate the AI application.

---

## Management

Applies across all lifecycle stages:

```text
Governance
Security
Compliance
```

**One line:** Management ensures the GenAI system remains secure, governed, and compliant throughout its lifecycle.

---

# 8. GenAIOps Lifecycle Mental Model

```text
                     GEN AIOPS
                         │
          ┌──────────────┼──────────────┐
          ↓              ↓              ↓
       EXPLORE          BUILD      OPERATIONALIZE
          │              │              │
       Define         Develop          Deploy
       Design         Evaluate         Monitor
       Model          Improve          Operate
       Prompt         Test             Optimize
       Data
          └──────────────┬──────────────┘
                         ↓
                 MANAGEMENT
              Governance
              Security
              Compliance
```

### Instant recall

> **Explore → Build → Operationalize**

> **Management → Governance + Security + Compliance**

---

# 9. GenAIOps Tools & Frameworks

## SET UP

### Azure Developer CLI (`azd`)

Used to provision and deploy Azure application environments.

**Remember:** `azd = Azure environment setup/deployment`

### Foundry Chat Playground

Used to interactively test and compare models.

**Remember:** `Playground = experiment with models`

---

# 10. CUSTOMIZE

### RAG / Foundry IQ

Provides knowledge grounding using external/enterprise data.

**Remember:** `Current knowledge → RAG / Foundry IQ`

### Fine-tuning

Specializes model behavior using training examples.

**Remember:** `Behavior/style → Fine-tuning`

### Azure AI Agent

Combines:

```text
Model
+
Instructions
+
Tools
+
Knowledge
```

**Remember:** `Agent = model + instructions + tools + knowledge`

---

# 11. EVALUATE

### Azure AI Evaluation SDK

Used to automatically evaluate:

* Groundedness
* Relevance
* Coherence
* Safety
* Agent behavior

**Remember:** `Evaluation SDK = automated AI quality evaluation`

---

### ASSERT

Used for agent regression testing based on specifications/rules.

**Remember:** `ASSERT = agent regression testing`

---

### Foundry Content Safety

Detects harmful or unsafe AI content.

**Remember:** `Content Safety = AI safety checking`

---

# 12. DEPLOY / OPERATE

### Microsoft Agent Framework

Framework for building and orchestrating AI agents and workflows.

**Remember:** `Agent Framework = build/orchestrate agents`

### LangChain

Framework for building AI applications and connecting models with tools/data.

**Remember:** `LangChain = AI application/agent framework`

### Tracing

Tracks the complete execution path of an AI request.

```text
User
 ↓
Agent
 ↓
LLM
 ↓
RAG
 ↓
Tool
 ↓
LLM
 ↓
Response
```

**Remember:** `Tracing = see the journey of an AI request`

---

### Azure Monitor

Monitors production AI applications.

**Remember:** `Azure Monitor = production monitoring`

### Application Insights

Provides application telemetry such as:

* Requests
* Latency
* Errors
* Traces
* Dependencies

**Remember:** `Application Insights = application-level telemetry`

### GitHub Actions

Automates:

```text
Build
 ↓
Test
 ↓
Evaluate
 ↓
Deploy
```

**Remember:** `GitHub Actions = GenAI CI/CD`

---

# 13. Complete GenAIOps Mental Map

```text
                         GEN AIOPS
                             │
              ┌──────────────┴──────────────┐
              │                             │
          LIFECYCLE                     MANAGEMENT
              │                             │
    ┌─────────┼─────────┐          ┌────────┼────────┐
    ↓         ↓         ↓          ↓        ↓        ↓
 EXPLORE    BUILD   OPERATIONALIZE Governance Security Compliance
    │         │         │
    │         │         │
    ↓         ↓         ↓
 Model      Prompt    CI/CD
 Prompt     RAG       Deploy
 Data       Agent     Monitor
 Architecture Eval    Trace
                       Cost
                       Safety
```

---

# 14. Complete GenAI Architecture Mental Map

```text
                         USER
                           │
                           ↓
                     AI APPLICATION
                           │
                           ↓
                         AGENT
                           │
             ┌─────────────┼─────────────┐
             ↓             ↓             ↓
           MODEL         RAG           TOOLS
             │             │             │
             │         Knowledge       APIs
             │         Vector DB       Services
             │         Search          Databases
             │
             ↓
          RESPONSE
             │
             ↓
        AI EVALUATION
             │
      ┌──────┼──────┐
      ↓      ↓      ↓
 Relevance Grounded Safety
      │      │      │
      └──────┼──────┘
             ↓
         PRODUCTION
             │
      ┌──────┼──────────┐
      ↓      ↓          ↓
   Metrics  Traces     Cost
      │      │          │
      └──────┼──────────┘
             ↓
          IMPROVE
             │
             └──────→ BUILD
```

---

# 15. GenAIOps vs Your Existing Skills

| GenAIOps concept   | Your existing knowledge                    |
| ------------------ | ------------------------------------------ |
| AI application     | FastAPI + React                            |
| Model endpoint     | REST/API endpoint                          |
| Agent tool         | REST API integration                       |
| RAG                | Qdrant + embeddings + ADF                  |
| Knowledge pipeline | ADF + Databricks                           |
| Model evaluation   | MLflow evaluation                          |
| Prompt versioning  | Git                                        |
| AI CI/CD           | GitHub Actions                             |
| Containerization   | Docker                                     |
| Deployment         | Azure App Service / Kubernetes             |
| Infrastructure     | Terraform                                  |
| Secrets            | Azure Key Vault                            |
| Access control     | RBAC / Unity Catalog                       |
| AI monitoring      | Azure Monitor                              |
| AI tracing         | Application Insights / distributed tracing |
| AI quality         | ML evaluation concepts                     |
| AI safety          | DevSecOps/security controls                |

---

# 16. AI-300 Instant Recall Sheet

```text
LLM
→ Large Language Model

SLM
→ Smaller, cheaper model for focused tasks

Prompt
→ Instructions/context given to the model

Agent
→ Model + instructions + tools + knowledge

Tool
→ External capability an agent can call

RAG
→ Retrieve external knowledge at runtime

Embedding
→ Numerical representation of semantic meaning

Vector DB
→ Stores/searches embeddings for semantic retrieval

Grounding
→ Giving the model reliable external context

Fine-tuning
→ Further train a model to specialize behavior

Rubric
→ Criteria used to evaluate AI responses

Smoke test
→ Quick test after a change

Evaluation
→ Measure AI quality systematically

Groundedness
→ Is the answer supported by the provided information?

Relevance
→ Does the answer address the user's request?

Tracing
→ Track the execution path of an AI request

Token
→ Unit of text processed by the model

Token usage
→ Impacts cost, latency, and limits

Guardrail
→ Control that prevents/detects undesirable AI behavior

GenAIOps
→ Operate the complete GenAI application lifecycle
```

---

# 17. Most Important AI-300 Scenario Rules

```text
Current / changing information
→ RAG

Specialized behavior / style
→ Fine-tuning

Current information + specialized behavior
→ RAG + Fine-tuning

Complex reasoning
→ Reasoning model

Simple focused task / cost-sensitive workload
→ Smaller model / SLM

Try models interactively
→ Foundry Chat Playground

Automated AI quality evaluation
→ Azure AI Evaluation SDK

Agent regression testing
→ ASSERT

Harmful content detection
→ Content Safety

Build agent workflows
→ Microsoft Agent Framework / LangChain

Production telemetry
→ Azure Monitor + Application Insights

Understand agent execution
→ Tracing

Automated deployment
→ GitHub Actions

Lifecycle
→ Explore → Build → Operationalize

Cross-cutting controls
→ Governance + Security + Compliance
```

---

# Today's Key Takeaway

The entire module can be compressed into one mental model:

```text
             PLAN THE AGENT
                   ↓
        Choose Model + Data + Tools
                   ↓
              BUILD AGENT
                   ↓
       Evaluate + Improve Repeatedly
                   ↓
             OPERATIONALIZE
                   ↓
        Deploy + Monitor + Trace
                   ↓
       Governance + Security + Cost
                   ↓
              CONTINUOUSLY
                IMPROVE
```

**Core AI-300 phrase to remember:**

> **GenAIOps extends DevOps/MLOps practices to manage the unique lifecycle of generative AI applications, including models, prompts, agents, knowledge, evaluation, safety, observability, and cost.**
