# Day 11 — Monitor Generative AI Applications
Date - 28-09-2026

**Microsoft Learn module:** [Monitor generative AI applications](https://learn.microsoft.com/en-us/training/modules/monitor-generative-ai-app/)

> **Core idea:**
> **Monitor → Understand → Diagnose → Optimize → Monitor again**

---

# 1. COMPLETE MENTAL MAP

```text
MONITOR GENERATIVE AI APPLICATIONS
│
├── 1. WHY MONITOR?
│   │
│   ├── Move from Experiment → Production
│   │
│   ├── Deployment decisions
│   │   ├── Performance
│   │   ├── Cost
│   │   └── Scalability
│   │
│   └── Feedback Loop
│       ├── Deploy
│       ├── Simulate traffic
│       ├── Monitor
│       ├── Analyze trade-offs
│       ├── Adjust
│       └── Monitor again
│
├── 2. WHAT TO MONITOR?
│   │
│   ├── Latency
│   │   └── Delay before processing/response begins
│   │
│   ├── Response Time
│   │   └── Complete request → complete response
│   │
│   ├── Throughput
│   │   └── Requests processed per time period
│   │
│   ├── Token Usage
│   │   ├── Input tokens
│   │   ├── Output tokens
│   │   └── Cost + performance impact
│   │
│   └── Errors / Failures
│       ├── Timeout
│       ├── Input parsing
│       └── Infrastructure limits
│
├── 3. HOW TO MONITOR?
│   │
│   ├── Tracing
│   │   ├── Azure AI Tracing
│   │   ├── OpenTelemetry
│   │   └── Spans
│   │
│   ├── Online Evaluation
│   │   ├── Groundedness
│   │   ├── Coherence
│   │   └── Custom evaluators
│   │
│   └── Azure Monitor
│       └── Application Insights
│           ├── Dashboards
│           ├── Visualization
│           └── Alerts
│
├── 4. IMPLEMENT IN CODE
│   │
│   ├── Microsoft Foundry SDK
│   │   └── Model inference
│   │
│   ├── OpenTelemetry
│   │   └── Capture spans
│   │
│   ├── Tracer
│   │   └── Creates/manages spans
│   │
│   └── Application Insights
│       └── Automatically receives telemetry
│
└── 5. INTERPRET RESULTS
    │
    ├── Workbooks
    │   └── Visualize + correlate data
    │
    ├── Token spikes
    │   ├── Cost ↑
    │   └── Latency ↑
    │
    ├── Timeout
    │   └── Check compute capacity
    │
    ├── Rate limit
    │   └── Check service quota
    │
    ├── Flow-step failure
    │   └── Check logic/data
    │
    └── Feedback Loop
        └── Optimize → Monitor again
```

The official module follows this progression from deployment decisions, through metrics and Azure monitoring, to implementation and interpretation. ([Microsoft Learn][1])

---

# 2. WHY DO WE NEED TO MONITOR?

When moving a GenAI application from **experimentation → production**, you need to decide how to deploy it.

The key questions are:

```text
How fast is it?
How many users can it handle?
How much does each request cost?
```

GenAI workloads are different from traditional applications because behavior depends heavily on:

* Prompt length
* Response length
* Model complexity
* Backend resources
* User traffic

Therefore, you cannot reliably choose the right deployment configuration just by guessing. You need **measured data**. ([Microsoft Learn][1])

### Small vs large compute

```text
Small compute
├── Lower cost
├── May have slower response
├── Limited concurrency
└── Possible timeout/retry issues

Large compute
├── Better performance
├── Better concurrency
├── Higher cost
└── May be unnecessary for low traffic
```

**Important:** A larger VM does not automatically guarantee better token efficiency. ([Microsoft Learn][1])

---

# 3. THE MONITORING FEEDBACK LOOP

This is one of the most important concepts in the entire module.

```text
        DEPLOY
           ↓
    SIMULATE TRAFFIC
           ↓
        MONITOR
           ↓
       ANALYZE
           ↓
   IDENTIFY TRADE-OFF
           ↓
        ADJUST
           ↓
      MONITOR AGAIN
```

### Why simulate traffic?

You want to understand how the application behaves under realistic usage **before relying entirely on production traffic**.

Monitor:

* Latency
* Throughput
* Cost

Then use those measurements to adjust the deployment. ([Microsoft Learn][1])

### Exam phrase

> **Data-driven deployment optimization**

---

# 4. WHAT TO MONITOR?

Microsoft identifies **four core areas**. ([Microsoft Learn][2])

```text
1. Latency / Response time
2. Throughput
3. Token usage
4. Error / failure rates
```

---

# 5. LATENCY vs RESPONSE TIME

This distinction is important.

### Latency

> Time from the request reaching the system until processing/response begins.

```text
Request
   ↓
Network
   ↓
System receives request
   ↓
START PROCESSING
```

### Response time

> Total time from sending the request until the complete response is received.

```text
Request
   ↓
Latency
   ↓
Processing
   ↓
Response transmission
   ↓
Complete response
```

Therefore:

```text
Response Time =
Latency
+ Processing time
+ Response transmission
```

([Microsoft Learn][2])

### Easy memory

**Latency → How quickly does it start?**

**Response time → How long until it's completely done?**

---

# 6. THROUGHPUT

> **Throughput = number of requests an application can process within a given time.**

Example:

```text
100 requests
──────────────
   1 minute

= 100 requests/minute
```

Throughput becomes particularly important with **concurrent users**.

Compute limitations and queueing can limit throughput. ([Microsoft Learn][2])

### Remember

```text
Latency    → How fast?
Throughput → How many?
```

---

# 7. TOKEN USAGE

Tokens are the units of text processed by the language model.

Both sides consume tokens:

```text
Input prompt
     +
Output response
     =
Token usage
```

Token usage matters because it affects:

* Cost
* Performance
* Latency

Unexpected token spikes can indicate problems with prompt design or inefficient response handling. ([Microsoft Learn][2])

### Key relationship

```text
Token usage ↑
      ↓
Cost ↑
      +
Latency can ↑
```

---

# 8. ERROR & FAILURE RATES

Monitor how frequently your application fails to respond correctly.

Important failure categories:

### Model timeout

```text
Request
   ↓
Model takes too long
   ↓
Timeout
```

Possible causes:

* Complex computation
* High server load

### Input parsing issue

```text
Unexpected input
      ↓
Application can't interpret it
      ↓
Failure
```

### Infrastructure limit

```text
Traffic ↑
    ↓
Resources insufficient
    ↓
Failure
```

([Microsoft Learn][2])

---

# 9. METRICS INTERACT

Do **not** memorize the metrics as isolated concepts.

They affect each other.

```text
Token usage ↑
     ↓
Latency ↑
     ↓
Cost ↑
```

Another example:

```text
Traffic ↑
     ↓
Infrastructure pressure ↑
     ↓
Failure rate ↑
```

Another:

```text
Compute exhausted
     ↓
Attempt to improve latency
     ↓
Throughput may decrease
```

Microsoft explicitly highlights these trade-offs. ([Microsoft Learn][2])

---

# 10. HOW DO WE MONITOR?

The module introduces three major components:

```text
Tracing
   +
Online Evaluation
   +
Azure Monitor / Application Insights
```

([Microsoft Learn][3])

---

# 11. TRACING

> **Tracing captures detailed telemetry about the execution of your GenAI application.**

Azure AI Tracing can send trace data to **Azure Monitor Application Insights**.

The trace data follows the **OpenTelemetry standard**. ([Microsoft Learn][3])

```text
GenAI Application
       ↓
Azure AI Tracing
       ↓
OpenTelemetry
       ↓
Application Insights
```

Tracing can help you understand:

* Request flow
* Latency
* Resource consumption
* Token usage
* API calls

---

# 12. OPENTELEMETRY

> **OpenTelemetry = standard framework for collecting and structuring telemetry.**

Think:

```text
Application
     ↓
Instrumentation
     ↓
OpenTelemetry
     ↓
Telemetry
```

### AI-300 trigger

If the question asks for a **standardized telemetry/tracing approach**:

**OpenTelemetry**

---

# 13. SPAN

This becomes important in the implementation section.

> **Span = an individual unit of work in an application.**

Examples:

```text
Trace
│
├── Span: Receive request
├── Span: Call model
├── Span: Call API
└── Span: Generate response
```

Each span can contain metadata such as:

* Duration
* Success/failure status
* Custom attributes

Spans are the **building blocks of a trace**. ([Microsoft Learn][4])

---

# 14. TRACER

> **Tracer = component responsible for creating and managing spans.**

Think:

```text
Tracer
   ↓
Creates/manages
   ↓
Spans
   ↓
Together form
   ↓
Trace
```

### Easy memory

**Tracer creates spans.**

**Spans build traces.**

---

# 15. ONLINE EVALUATION

Tracing tells you:

> **What happened technically?**

Online evaluation tells you:

> **How good/safe/appropriate was the output?**

```text
TRACING
├── Token usage
├── API calls
├── Response time
└── Execution flow

ONLINE EVALUATION
├── Groundedness
├── Coherence
├── Quality
├── Safety
└── Security
```

Azure AI Online Evaluation can continuously evaluate application responses. ([Microsoft Learn][3])

---

# 16. BUILT-IN vs CUSTOM EVALUATORS

### Built-in evaluators

Examples:

```text
Groundedness
Coherence
```

### Custom evaluators

Used when you need a **domain-specific metric**.

Example:

```text
Finance application
       ↓
Custom evaluator
       ↓
"Does the response follow company policy?"
```

([Microsoft Learn][3])

### Exam distinction

```text
Generic quality metric
        ↓
Built-in evaluator

Business/domain-specific requirement
        ↓
Custom evaluator
```

---

# 17. APPLICATION INSIGHTS

**Application Insights** provides the observability layer.

It can provide:

* Custom dashboards
* Real-time evaluation visualization
* Configurable alerts
* Token usage visibility
* Latency visibility
* Request-volume visibility

([Microsoft Learn][3])

Think:

```text
Application
     ↓
Telemetry
     ↓
Application Insights
     ↓
Observe + Analyze + Alert
```

---

# 18. ALERTS

Alerts notify you when something important happens.

Two major types:

### Metric alerts

> Based on collected metric values.

```text
Latency > threshold
       ↓
Metric Alert
```

They provide **near-real-time** alerts. ([Microsoft Learn][3])

### Log alerts

> Based on log data and can use complex logic across multiple data sources.

```text
Multiple logs
     ↓
Complex query
     ↓
Log Alert
```

([Microsoft Learn][3])

### Easy memory

```text
Simple metric threshold
        ↓
Metric alert

Complex log/query condition
        ↓
Log alert
```

---

# 19. ACTION GROUPS

An alert tells Azure:

> **Something happened.**

An action group tells Azure:

> **What should I do about it?**

```text
Alert
  ↓
Action Group
  ├── Email
  ├── SMS
  ├── Webhook
  └── ITSM integration
```

Action groups can be reused by multiple alert rules. ([Microsoft Learn][3])

---

# 20. ALERT RETENTION

Small but potentially testable detail:

```text
Triggered alerts
      ↓
Stored for 30 days
      ↓
Deleted after 30 days

Alert rules
      ↓
Remain active
```

([Microsoft Learn][3])

---

# 21. IMPLEMENTATION — MICROSOFT FOUNDRY SDK

The hands-on section uses the **Microsoft Foundry SDK** to run model inference and emit telemetry.

Conceptually:

```text
Microsoft Foundry SDK
       ↓
Model inference
       ↓
Telemetry
```

The SDK connects your application to a Microsoft Foundry project and allows you to interact with a deployed AI service. ([Microsoft Learn][4])

---

# 22. MODEL INFERENCE

Model inference could be:

```text
Simple
Language model completion

        OR

Complex
Multi-turn assistant / agent
```

The important exam concept is:

> **The Microsoft Foundry SDK is used to interact with the deployed model/service.** ([Microsoft Learn][4])

---

# 23. INSTRUMENTATION

> **Instrumentation = adding monitoring capability to your application.**

Without instrumentation:

```text
App → Model → Response
```

With instrumentation:

```text
App
 ↓
Tracer
 ↓
Model
 ↓
Span
 ↓
Telemetry
 ↓
Application Insights
```

---

# 24. CODE CONCEPTS TO REMEMBER

You don't need to memorize every Python line.

Understand the purpose of the major pieces:

```python
DefaultAzureCredential()
```

→ Uses Azure identity/authentication.

```python
AIProjectClient
```

→ Connects to the Microsoft Foundry project.

```python
chat_client.complete()
```

→ Runs model inference.

```python
trace.get_tracer()
```

→ Gets an OpenTelemetry tracer.

```python
tracer.start_as_current_span(...)
```

→ Creates a span for an operation.

```python
AIInferenceInstrumentor().instrument()
```

→ Automatically instruments AI inference operations.

The official module uses these concepts in its implementation example. ([Microsoft Learn][4])

---

# 25. AUTOMATIC TELEMETRY EXPORT

The final implementation flow is:

```text
Microsoft Foundry Project
        ↓
Application Insights connection
        ↓
Azure Monitor configuration
        ↓
AIInferenceInstrumentor
        ↓
AI inference operations
        ↓
Automatically traced
        ↓
Application Insights
```

The module shows that connecting Application Insights to the Microsoft Foundry project allows telemetry to be exported automatically, while `AIInferenceInstrumentor` automatically traces AI inference operations. ([Microsoft Learn][4])

---

# 26. INTERPRETING MONITORING RESULTS

Now we move from:

**Collecting data**

to:

**Making sense of the data.**

The central concept is again:

```text
Observe
  ↓
Interpret
  ↓
Decide what needs attention
  ↓
Optimize
  ↓
Observe again
```

This is the **monitoring feedback loop**. ([Microsoft Learn][5])

---

# 27. AZURE WORKBOOKS

> **Azure Workbooks = interactive visual reports for analyzing and correlating monitoring data.**

They can:

* Query multiple data sources
* Combine datasets
* Correlate data
* Create visualizations
* Update interactively
* Be shared across teams

([Microsoft Learn][5])

### Mental model

```text
Application Insights
        ↓
Telemetry
        ↓
Azure Workbook
        ↓
Visualize + Correlate
        ↓
Understand bottlenecks
```

---

# 28. PREBUILT GENAI WORKBOOK

When Application Insights is connected to a Microsoft Foundry project, the **Insights for Generative AI applications** dashboard provides a prebuilt Azure Workbook.

It can provide visibility into:

* Execution times
* Token consumption
* Error rates
* Usage patterns
* Operational efficiency

([Microsoft Learn][5])

### Exam trigger

> Need a visual/correlated view of GenAI monitoring data?

**Azure Monitor Workbooks**

---

# 29. INTERPRETING TOKEN USAGE

This is one of the most useful diagnostic sections.

### High input tokens

May indicate:

```text
Prompt too verbose
      ↓
Unnecessary context/preamble
```

### High output tokens

May indicate:

```text
Model returns more than necessary
      ↓
Response requirements may need optimization
```

### Token spikes

```text
Token usage ↑
     ↓
Latency ↑
     +
Cost ↑
```

([Microsoft Learn][5])

### Important insight

Before changing infrastructure, investigate whether **prompt/output design** is causing excessive token usage.

---

# 30. INTERPRETING ERRORS

Memorize this table.

| Signal                         | Likely area to investigate      |
| ------------------------------ | ------------------------------- |
| **Timeout**                    | Compute capacity                |
| **Rate limit**                 | Service quota / throughput      |
| **Flow-step failure**          | Logic / data quality            |
| **Errors increase with usage** | Compute capacity or flow design |

These relationships are directly described in the Microsoft Learn module. ([Microsoft Learn][5])

---

# 31. THE MOST IMPORTANT DIAGNOSTIC MAP

```text
                    MONITORING SIGNAL
                           │
          ┌────────────────┼────────────────┐
          ↓                ↓                ↓
      TOKEN SPIKE       TIMEOUT         RATE LIMIT
          │                │                │
          ↓                ↓                ↓
   Prompt/output       Compute may      Quota /
     efficiency        be too small     throughput
          │                │                │
          └────────────────┼────────────────┘
                           ↓
                       OPTIMIZE
                           ↓
                    MONITOR AGAIN
```

And:

```text
FLOW STEP FAILURE
       ↓
Check application logic
       +
Check data quality
```

---

# 32. HIGH-VALUE AI-300 SERVICE MAPPING

This is the section I would **memorize before the exam**.

| If the question says...             | Think...                    |
| ----------------------------------- | --------------------------- |
| Need application telemetry          | **Tracing**                 |
| Standard telemetry format           | **OpenTelemetry**           |
| Individual unit of work             | **Span**                    |
| Component that creates spans        | **Tracer**                  |
| Run model inference                 | **Microsoft Foundry SDK**   |
| Automatically trace AI inference    | **AIInferenceInstrumentor** |
| Store/analyze telemetry             | **Application Insights**    |
| Visualize/correlate monitoring data | **Azure Workbooks**         |
| Evaluate output quality             | **Online Evaluation**       |
| Check groundedness                  | **Groundedness evaluator**  |
| Check coherence                     | **Coherence evaluator**     |
| Domain-specific quality             | **Custom evaluator**        |
| Near-real-time metric threshold     | **Metric alert**            |
| Complex logic across logs           | **Log alert**               |
| Notify external systems             | **Action Group**            |
| High token usage                    | **Review prompt/output**    |
| Timeout                             | **Check compute**           |
| Rate limit                          | **Check quota**             |
| Flow step failure                   | **Check logic/data**        |

---

# 33. DON'T MIX THESE UP

### Tracing vs Evaluation

```text
TRACING
"What happened?"

→ latency
→ tokens
→ API calls
→ execution flow


EVALUATION
"How good was the output?"

→ groundedness
→ coherence
→ quality
→ safety
```

### Application Insights vs Workbooks

```text
APPLICATION INSIGHTS
→ telemetry / observability


WORKBOOK
→ visualize + analyze + correlate
```

### Metric Alert vs Log Alert

```text
METRIC ALERT
→ metric threshold
→ near real-time


LOG ALERT
→ log data
→ complex query/logic
```

### Alert vs Action Group

```text
ALERT
→ detects condition

ACTION GROUP
→ performs notification/action
```

---

# 34. EXAM SCENARIO PATTERNS

### Scenario 1

> Users report that responses are slow.

Think:

```text
Response time
   ↓
Latency
   ↓
Check monitoring data
   ↓
Check compute / load / token usage
```

---

### Scenario 2

> Application cost suddenly increases.

Think:

```text
Cost ↑
 ↓
Token usage?
 ↓
Input/output token spike?
 ↓
Prompt / response optimization
```

---

### Scenario 3

> Requests are being rejected because the service is receiving too many requests.

Think:

```text
Rate limit
   ↓
Service quota / throughput
```

---

### Scenario 4

> A particular workflow step consistently fails.

Think:

```text
Flow-step failure
      ↓
Application logic
      +
Data quality
```

---

### Scenario 5

> You need to evaluate whether generated answers are supported by the provided information.

Think:

```text
Online Evaluation
       ↓
Groundedness
```

---

### Scenario 6

> You need to combine logs and metrics from several sources in an interactive visualization.

Think:

```text
Azure Monitor
     ↓
Workbooks
```

---

### Scenario 7

> You need an alert when latency exceeds a defined threshold.

Think:

```text
Metric
  ↓
Metric Alert
```

---

### Scenario 8

> You need an alert based on a complex query involving data from multiple sources.

Think:

```text
Log data
   ↓
Log Alert
```

---

### Scenario 9

> When an alert fires, notify the operations team through email and trigger an external process.

Think:

```text
Alert
 ↓
Action Group
 ├── Email
 └── Webhook
```

---

# 35. WHAT NOT TO MEMORIZE

For AI-300, don't waste too much time memorizing the entire Python implementation line-by-line.

Focus on:

```text
WHY
 ↓
WHAT
 ↓
WHICH AZURE TOOL
 ↓
WHAT IT MEASURES
 ↓
HOW TO INTERPRET IT
```

The code is mainly demonstrating these concepts.

Microsoft itself notes that the snippets in the module highlight what each part of the code does, with the complete working example provided in the exercise. ([Microsoft Learn][4])

---

# 36. 30-SECOND REVISION

If you have almost no time before the exam, read this:

```text
GENAI MONITORING
│
├── WHY?
│   └── Optimize performance, cost, scalability
│
├── WHAT?
│   ├── Latency
│   ├── Response time
│   ├── Throughput
│   ├── Tokens
│   └── Errors
│
├── HOW?
│   ├── Tracing
│   ├── Online Evaluation
│   └── Application Insights
│
├── TRACE WITH?
│   ├── OpenTelemetry
│   ├── Tracer
│   └── Spans
│
├── VISUALIZE?
│   └── Azure Workbooks
│
├── ALERT?
│   ├── Metric Alert
│   ├── Log Alert
│   └── Action Group
│
└── DIAGNOSE
    ├── Token spike → prompt/output
    ├── Timeout → compute
    ├── Rate limit → quota
    └── Flow failure → logic/data
```

---

# 37. FINAL MEMORY CHAIN

Memorize this sentence:

> **Deploy → simulate traffic → monitor latency, throughput, tokens and errors → trace with OpenTelemetry → store/observe with Application Insights → evaluate quality with online evaluation → visualize with Workbooks → alert with metric/log alerts → diagnose → optimize → monitor again.**

That single chain reconstructs almost the entire module. ([Microsoft Learn][1])

---

## Day 11 — Final AI-300 Cheat Sheet

```text
                    GENAI MONITORING
                           │
          ┌────────────────┼────────────────┐
          ↓                ↓                ↓
       PERFORMANCE       QUALITY           COST
          │                │                │
    Latency             Groundedness      Tokens
    Response time       Coherence         Usage
    Throughput          Safety
          │                │
          └────────┬───────┘
                   ↓
              MONITORING
                   │
        ┌──────────┼──────────┐
        ↓          ↓          ↓
    Tracing    Evaluation   Insights
        │          │          │
 OpenTelemetry     │     Application
    Spans          │      Insights
   Tracer          │          │
        │          │      Workbooks
        └──────────┼──────────┘
                   ↓
                 ALERTS
             ┌─────┴─────┐
             ↓           ↓
          Metric        Log
           Alert       Alert
             │           │
             └─────┬─────┘
                   ↓
             Action Group
                   ↓
          Email / SMS / Webhook
                   ↓
              DIAGNOSE
                   ↓
          OPTIMIZE + REPEAT
```

**Day 11 core takeaway:**
**Monitoring isn't just collecting metrics. The AI-300 skill is knowing which metric/tool to use, interpreting the signal, identifying the likely bottleneck, and feeding that information back into the deployment decision.** ([Microsoft Learn][5])

[1]: https://learn.microsoft.com/en-us/training/modules/monitor-generative-ai-app/2-why-monitor "Why do you need to monitor? - Training | Microsoft Learn"
[2]: https://learn.microsoft.com/en-us/training/modules/monitor-generative-ai-app/3-what-to-monitor "Understand key metrics to monitor - Training | Microsoft Learn"
[3]: https://learn.microsoft.com/en-us/training/modules/monitor-generative-ai-app/4-how-to-monitor "Explore how to monitor with Azure - Training | Microsoft Learn"
[4]: https://learn.microsoft.com/en-us/training/modules/monitor-generative-ai-app/5-prepare-scripts "Integrate monitoring into your app - Training | Microsoft Learn"
[5]: https://learn.microsoft.com/en-us/training/modules/monitor-generative-ai-app/6-informed-decisions "Interpret monitoring results - Training | Microsoft Learn"
