# Day 12 — Analyze and Debug Generative AI Applications with Tracing

Date - 29-09-2026

**Microsoft Learn module:** [Analyze and debug your generative AI app with tracing](https://learn.microsoft.com/en-us/training/modules/tracing-generative-ai-app/)

---

# 1. COMPLETE MENTAL MAP

```text
TRACE GENERATIVE AI APPLICATIONS
│
├── 1. WHY TRACE?
│   │
│   ├── Understand application execution
│   ├── Debug complex workflows
│   ├── Identify bottlenecks
│   ├── Investigate failures
│   └── Optimize reliability + performance
│
├── 2. WHAT TO TRACE?
│   │
│   ├── Trace
│   │   └── Complete request journey
│   │
│   ├── Span
│   │   └── Individual operation
│   │
│   ├── Attributes
│   │   └── Metadata about operation
│   │
│   ├── Model calls
│   ├── Retrieval / data operations
│   ├── Business logic
│   ├── Structured output
│   └── Parsing / validation
│
├── 3. HOW TO TRACE?
│   │
│   ├── OpenTelemetry
│   │   ├── Standard telemetry framework
│   │   └── Instrumentation
│   │
│   ├── Automatic instrumentation
│   │   └── OpenAI / AI inference calls
│   │
│   ├── Custom instrumentation
│   │   └── Application-specific logic
│   │
│   ├── Tracer
│   │   └── Creates/manages spans
│   │
│   └── Microsoft Foundry
│       └── Trace visualization / analysis
│
├── 4. ADVANCED TRACING
│   │
│   ├── Nested spans
│   │   ├── Session
│   │   ├── Business operation
│   │   └── Model operation
│   │
│   ├── Structured output
│   │   ├── Generation
│   │   ├── Cleaning
│   │   ├── Parsing
│   │   └── Validation
│   │
│   ├── Parsing failure
│   │   ├── parsing.success
│   │   ├── error.type
│   │   ├── error.message
│   │   └── response.raw
│   │
│   └── Business effectiveness
│       ├── Input metrics
│       ├── Output metrics
│       └── Success rate
│
└── 5. ANALYZE TRACE DATA
    │
    ├── Quality
    │   ├── Parsing success
    │   └── Validation
    │
    ├── Performance
    │   ├── Span duration
    │   └── Token usage
    │
    ├── Reliability
    │   ├── Error patterns
    │   └── Transient failures
    │
    └── Feedback Loop
        ├── Trace
        ├── Analyze
        ├── Diagnose
        ├── Optimize
        └── Trace again
```

The Microsoft Learn module contains the tracing concepts, implementation, advanced tracing patterns, trace-data analysis, an exercise, knowledge check, and summary.

---

# 2. WHY DO WE NEED TRACING?

Tracing is used when you need to understand **how a request moved through the application** and determine where a problem occurred.

A GenAI application can have:

```text
User
 ↓
API
 ↓
Business Logic
 ↓
Retrieval
 ↓
Prompt Construction
 ↓
LLM
 ↓
Structured Output
 ↓
Parsing
 ↓
Response
```

Without tracing, you may only know:

```text
Request failed
```

With tracing:

```text
Request failed
      ↓
Which operation?
      ↓
Which service?
      ↓
Which model call?
      ↓
Which step was slow/incorrect?
```

### Core idea

```text
Monitoring → What is happening?
Tracing    → Why is it happening?
```

Tracing is especially useful for complex AI workflows where many operations contribute to the final response. Microsoft describes the module as using tracing to capture detailed execution flows and debug complex workflows.

---

# 3. TRACE vs SPAN vs ATTRIBUTE

These are the **most important basic tracing concepts**.

## Trace

> **Trace = complete journey of a request.**

```text
Request
  ↓
API
  ↓
Retrieval
  ↓
LLM
  ↓
Post-processing
  ↓
Response

        = TRACE
```

---

## Span

> **Span = one operation within a trace.**

Examples:

```text
API request
Database query
Retrieval
Model call
JSON parsing
Business logic
```

A span can record:

* Start time
* End time
* Duration
* Status
* Attributes

---

## Attribute

> **Attribute = metadata attached to a span/operation.**

Examples:

```text
model
session.id
operation.type
token usage
error.type
parsing.success
```

### Easy memory

```text
Trace     → Whole journey
Span      → One operation
Attribute → Details
```

---

# 4. TRACE HIERARCHY

A trace can contain nested spans.

```text
session
│
├── recommend_hike
│   │
│   └── model_call
│       │
│       └── LLM
│
└── trip_profile_generation
    │
    └── model_call
        │
        └── LLM
```

This lets you move from:

```text
Entire session
      ↓
Business operation
      ↓
Model operation
      ↓
Specific AI call
```

### Why it matters

If the complete request takes:

```text
8 seconds
```

you can inspect the child spans:

```text
API          → 100 ms
Retrieval    → 300 ms
Model call   → 6.5 sec
Parsing      → 100 ms
```

The trace immediately shows where the time is being spent.

---

# 5. DISTRIBUTED TRACING

When an application consists of multiple services:

```text
Frontend
   ↓
API Service
   ↓
Retrieval Service
   ↓
Database
   ↓
LLM Service
```

**Distributed tracing → follows the same request across multiple services.**

### Exam trigger

> "Track a request across multiple services."

→ **Distributed tracing**

### Why?

It helps correlate:

* Latency
* Errors
* Service dependencies
* Bottlenecks
* Request flow

---

# 6. WHAT SHOULD BE TRACED?

Do not trace only the LLM.

A complete GenAI workflow may include:

```text
Application logic
       ↓
Retrieval
       ↓
Model call
       ↓
Structured output
       ↓
Parsing
       ↓
Business processing
```

Trace the operations that can affect the final result.

### Important areas

```text
├── API calls
├── Retrieval
├── Model inference
├── Database/data access
├── Business logic
├── Tool calls
├── Structured output
└── Parsing / validation
```

---

# 7. MODEL INFERENCE TRACING

A model span can capture information about the AI operation.

Potential information:

```text
Model
Duration
Token usage
Request/response information
Status
Errors
```

This helps answer:

```text
Is the model slow?
Is token usage increasing?
Is the model call failing?
Is the model responsible for the latency?
```

---

# 8. BUSINESS LOGIC TRACING

A model can work correctly while the application still produces an incorrect result.

Example:

```text
LLM
 ↓
"boots, jacket, daypack"
 ↓
Product matching
 ↓
No matching products
```

The model succeeded.

The **business logic failed**.

Therefore:

```text
LLM tracing
      +
Business logic tracing
```

gives a more complete view.

### Important principle

> **Model success ≠ application success.**

---

# 9. HOW TO TRACE — OPENTELEMETRY

**OpenTelemetry → standardized framework for collecting telemetry.**

Conceptually:

```text
Application
     ↓
Instrumentation
     ↓
OpenTelemetry
     ↓
Telemetry
```

For this module, OpenTelemetry is the key tracing/instrumentation technology.

### AI-300 trigger

> "Standardized telemetry/tracing framework"

→ **OpenTelemetry**

The current GenAIOps learning path explicitly describes this tracing module as implementing tracing with **Microsoft Foundry and OpenTelemetry**.

---

# 10. AUTOMATIC INSTRUMENTATION

Automatic instrumentation allows supported AI/model operations to generate telemetry without manually creating every span.

Concept:

```text
AI inference call
       ↓
Automatic instrumentation
       ↓
Span / telemetry
```

Example concept from the module:

```python
OpenAIInstrumentor().instrument()
```

### Remember

```text
Automatic instrumentation
        ↓
Supported SDK / AI operations
```

---

# 11. CUSTOM INSTRUMENTATION

Automatic instrumentation doesn't understand your entire application.

For application-specific operations:

```python
with tracer.start_as_current_span("recommend_hike"):
    ...
```

creates a custom span.

### Remember

```text
Automatic
→ AI/SDK operations

Custom
→ Your application logic
```

This distinction is highly relevant to scenario-based questions.

---

# 12. TRACER

> **Tracer = component used to create and manage spans.**

```text
Tracer
   ↓
Creates span
   ↓
Span records operation
   ↓
Multiple spans
   ↓
Trace
```

### Easy memory

> **Tracer creates spans.**

---

# 13. MICROSOFT FOUNDRY + APPLICATION INSIGHTS

Tracing can integrate with Microsoft's observability stack.

Conceptually:

```text
GenAI Application
       ↓
OpenTelemetry
       ↓
Application Insights
       ↓
Microsoft Foundry
       ↓
Trace visualization / analysis
```

Application Insights provides the telemetry backend/observability layer, while Foundry provides AI-focused trace visibility.

The current Microsoft Foundry documentation states that Foundry tracing uses OpenTelemetry standards and stores trace data in connected Azure Monitor Application Insights resources.

---

# 14. SESSION-LEVEL TRACING

For a complete user interaction, use a top-level session span.

```text
session
│
├── operation A
│   └── model call
│
├── operation B
│   └── retrieval
│
└── operation C
    └── model call
```

Possible session-level information:

```text
session.id
session.success
```

### Purpose

> Provides an end-to-end view of a user interaction.

---

# 15. ADVANCED TRACING — STRUCTURED OUTPUT

GenAI applications often request JSON or another structured response.

```text
LLM
 ↓
Structured response
 ↓
Cleaning
 ↓
Parsing
 ↓
Validation
 ↓
Application object
```

Important point:

> **The model call can succeed while parsing fails.**

Therefore, trace the post-model processing too.

---

# 16. STRUCTURED-OUTPUT TRACE DATA

Important signals:

```text
parsing.success
error.type
error.message
response.raw
response.cleaned
```

### Successful case

```text
LLM
 ↓
JSON
 ↓
Parse
 ↓
parsing.success = true
```

### Failed case

```text
LLM
 ↓
Malformed response
 ↓
JSON parsing ❌
 ↓
parsing.success = false
 ↓
error.type
 ↓
error.message
 ↓
response.raw
```

### Why capture raw response?

To determine **what the model actually returned** when parsing failed.

---

# 17. RESPONSE CLEANING

Sometimes model output requires cleanup before parsing.

Example:

````text
```json
{
   ...
}
````

````

The application may remove the Markdown code fence.

Concept:

```text
Model response
      ↓
Needs cleanup?
   ┌──┴──┐
  Yes    No
   ↓      ↓
Clean   Parse
   ↓
 Parse
````

Useful trace information:

```text
response.cleaned = true
```

---

# 18. BUSINESS EFFECTIVENESS METRICS

Advanced tracing can capture metrics related to application-specific processing.

Example:

```text
gear requested = 5
products matched = 4
```

Then:

```text
match.success_rate
```

can indicate how effectively the application processed the model output.

### Mental model

```text
Model output
     ↓
Business processing
     ↓
Application result
     ↓
Effectiveness metric
```

This is different from simply measuring model latency.

---

# 19. ANALYZE TRACE DATA

Once trace data is collected, analyze it across three major dimensions:

```text
TRACE DATA
    │
    ├── QUALITY
    ├── PERFORMANCE
    └── RELIABILITY
```

This is the **trace-data → engineering-decision** stage.

---

# 20. QUALITY

Quality-related trace signals include:

```text
parsing.success
validation.passed
business success metrics
```

Example:

```text
parsing.success = false
        ↓
Structured-output quality issue
```

Possible actions:

```text
Improve prompt
Validate output
Reprompt
Fallback handling
Improve business logic
```

---

# 21. PERFORMANCE

Important signals:

```text
Span duration
Token usage
```

### High span duration

```text
Span duration ↑
      ↓
Latency problem
      ↓
Find slow operation
      ↓
Optimize
```

Potential optimizations:

* Faster model
* Prompt simplification
* Caching
* Parallel processing

---

### High token usage

```text
Token usage ↑
      ↓
Cost ↑
      +
Latency may ↑
```

Investigate:

* Prompt size
* Response length
* Number of model calls
* Model selection
* Redundant context

---

# 22. RELIABILITY

Reliability problems can be identified through recurring errors.

```text
error.type
     ↓
Repeated failures
     ↓
Reliability problem
```

For transient failures:

```text
Failure
  ↓
Retry
  ↓
Wait
  ↓
Retry
```

Use:

> **Exponential backoff → progressively increase delay between retries.**

Example:

```text
Retry 1 → wait 1 sec
Retry 2 → wait 2 sec
Retry 3 → wait 4 sec
```

---

# 23. TRACE SIGNAL → ENGINEERING ACTION

| Trace signal              | Meaning                         | Investigate / Action           |
| ------------------------- | ------------------------------- | ------------------------------ |
| `parsing.success = false` | Structured-output issue         | Prompt / validation / fallback |
| `response.cleaned = true` | Output required cleanup         | Output formatting              |
| `error.type`              | Failure category                | Root cause / retry             |
| High span duration        | Bottleneck                      | Optimize slow operation        |
| High token usage          | Cost/efficiency issue           | Prompt/model optimization      |
| Low validation success    | Quality issue                   | Improve validation/logic       |
| Low business success rate | Application effectiveness issue | Fix processing/data            |
| Repeated transient errors | Reliability issue               | Retry + backoff                |

---

# 24. COMPLETE TRACING FLOW

```text
USER REQUEST
     ↓
    TRACE
     ↓
┌────┴──────────────────────┐
│                           │
SPAN                     SPAN
│                           │
├── API                     ├── Retrieval
├── Business logic          └── Model call
└── Parsing
     │
     ↓
ATTRIBUTES
     │
     ├── Duration
     ├── Token usage
     ├── Model
     ├── Error
     └── Success
     │
     ↓
TRACE ANALYSIS
     │
 ┌───┼──────────────┐
 ↓   ↓              ↓
QUALITY PERFORMANCE RELIABILITY
 ↓   ↓              ↓
Fix Optimize       Stabilize
     │
     ↓
MONITOR / TRACE AGAIN
```

---

# 25. TRACE vs MONITORING vs EVALUATION

This connects directly with Day 11.

```text
MONITORING
│
└── What is happening?
    ├── Latency
    ├── Throughput
    ├── Tokens
    └── Errors


TRACING
│
└── Why / where is it happening?
    ├── Execution flow
    ├── Spans
    ├── Dependencies
    └── Root-cause investigation


EVALUATION
│
└── How good is the output?
    ├── Groundedness
    ├── Coherence
    ├── Quality
    └── Safety
```

### Critical distinction

```text
Monitoring → Detect
Tracing    → Diagnose
Evaluation → Judge output quality
```

---

# 26. AI-300 SERVICE MAPPING

| Scenario                               | Think                           |
| -------------------------------------- | ------------------------------- |
| Standardized telemetry                 | **OpenTelemetry**               |
| Complete request journey               | **Trace**                       |
| Individual operation                   | **Span**                        |
| Metadata about operation               | **Attribute**                   |
| Component creating spans               | **Tracer**                      |
| Track request across services          | **Distributed tracing**         |
| Automatically trace supported AI calls | **Automatic instrumentation**   |
| Trace custom application logic         | **Custom spans**                |
| Trace complete user interaction        | **Session-level span**          |
| Store telemetry                        | **Application Insights**        |
| AI-focused trace visualization         | **Microsoft Foundry**           |
| Structured-output debugging            | **Parsing trace**               |
| Need raw malformed output              | **`response.raw`**              |
| Model succeeds but app fails           | **Business-logic tracing**      |
| Slow operation                         | **Span duration**               |
| Excessive model cost                   | **Token usage**                 |
| Repeated transient failures            | **Retry + exponential backoff** |

---

# 27. AI-300 EXAM SCENARIOS

### Scenario 1

> An application contains API calls, retrieval, model inference, and post-processing. You need to determine which operation causes latency.

```text
Trace
 ↓
Inspect spans
 ↓
Compare durations
 ↓
Find bottleneck
```

**Answer → Tracing / span analysis**

---

### Scenario 2

> An LLM successfully returns a response, but the application fails while converting it to JSON.

```text
Model call → SUCCESS
Parsing → FAILURE
```

**Answer → Trace structured-output parsing**

---

### Scenario 3

> A request passes through multiple Azure services and you need to follow the request end-to-end.

**Answer → Distributed tracing**

---

### Scenario 4

> You need to trace your own application-specific business operation.

**Answer → Custom span / custom instrumentation**

---

### Scenario 5

> You need to automatically capture supported AI inference operations.

**Answer → Automatic instrumentation**

---

### Scenario 6

> The model returns valid recommendations, but the application cannot match them to products.

**Answer → Investigate business-logic tracing**

---

### Scenario 7

> A trace shows one model call consuming most of the request duration.

**Answer → Investigate span duration / model performance**

---

### Scenario 8

> Token consumption has unexpectedly increased.

**Answer → Investigate prompt/output size, model calls, and model configuration.**

---

### Scenario 9

> A service experiences intermittent transient failures.

**Answer → Retry with exponential backoff**

---

# 28. DON'T MIX THESE UP

### Trace vs Span

```text
Trace → Entire request
Span  → One operation
```

### Span vs Attribute

```text
Span      → Operation
Attribute → Metadata about operation
```

### Automatic vs Custom instrumentation

```text
Automatic → Supported SDK / AI calls
Custom    → Application-specific logic
```

### Model failure vs application failure

```text
Model fails
→ Investigate model/API

Model succeeds
but processing fails
→ Investigate application logic/parsing
```

### Quality vs Performance vs Reliability

```text
Quality
→ Is the result usable?

Performance
→ Is it fast/efficient?

Reliability
→ Does it consistently work?
```

---

# 29. DAY 12 — CONNECTION TO PREVIOUS DAYS

```text
DAY 8–9
Prompt Management
      ↓
Version + manage prompts
      ↓
DAY 10
Evaluation
      ↓
Measure quality
      ↓
DAY 11
Monitoring
      ↓
Observe performance/cost
      ↓
DAY 12
Tracing
      ↓
Understand execution + diagnose
      ↓
ANALYZE
      ↓
OPTIMIZE
      ↓
EVALUATE AGAIN
```

The broader GenAIOps learning path explicitly connects evaluation, monitoring, and distributed tracing as parts of operationalizing GenAI applications.

---

# 30. FINAL MEMORY CHAIN

```text
TRACE
 ↓
WHOLE REQUEST
 ↓
SPANS
 ↓
INDIVIDUAL OPERATIONS
 ↓
ATTRIBUTES
 ↓
OPERATION DETAILS
 ↓
ANALYZE
 ├── QUALITY
 ├── PERFORMANCE
 └── RELIABILITY
 ↓
DIAGNOSE
 ↓
OPTIMIZE
 ↓
TRACE AGAIN
```

### One-line recall

> **Trace the complete request → inspect spans → use attributes to understand each operation → analyze quality, performance, and reliability → diagnose → optimize.**

---

# 31. 30-SECOND REVISION

```text
TRACING
│
├── WHY?
│   ├── Debug
│   ├── Diagnose
│   ├── Find bottlenecks
│   └── Optimize
│
├── WHAT?
│   ├── Trace
│   ├── Span
│   ├── Attributes
│   ├── Model calls
│   ├── Business logic
│   └── Parsing
│
├── HOW?
│   ├── OpenTelemetry
│   ├── Automatic instrumentation
│   ├── Custom spans
│   └── Tracer
│
├── ADVANCED?
│   ├── Nested spans
│   ├── Structured output
│   ├── Parsing errors
│   ├── Raw responses
│   └── Business effectiveness
│
└── ANALYZE
    ├── Quality
    ├── Performance
    ├── Reliability
    └── Optimize + repeat
```

---

# 32. FINAL AI-300 TAKEAWAY

**Day 12 core takeaway:**

> **Tracing provides the detailed execution path needed to move from “something is wrong” to “this specific operation caused the problem,” and trace analysis turns that information into quality, performance, and reliability improvements.**

The key progression to remember is:

```text
MONITOR
   ↓
Detect a problem
   ↓
TRACE
   ↓
Find where it happened
   ↓
ANALYZE
   ↓
Understand why
   ↓
OPTIMIZE
   ↓
TRACE / MONITOR AGAIN
```

**Day 12 completed — Analyze and Debug Generative AI Applications with Tracing.**
