# Observability — The Three Pillars

Observability is the ability to understand a system's internal state through the data it emits. Monitoring tracks known conditions, such as availability or error rate. Observability combines that evidence with request and event context to investigate unexpected behavior.

---

## Why Observability?

In a distributed application, one request may involve an API gateway, several services, a cache, and a database. An increase in response time establishes a symptom; finding its cause requires more context. Metrics reveal trends, logs describe events, and traces connect work performed across services.

---

## The Three Pillars

### 1. Metrics

Numeric measurements recorded over time, such as request counts, memory use, or latency distributions. They support dashboards, trends, and alerts. Labels allow grouping by service or endpoint, but excessive label cardinality increases storage and query costs.

**Examples:**

- CPU utilization: 73%
- Request rate: 1200 req/sec
- Error rate: 0.2%
- Response time p95: 240ms
- Memory used: 1.2 GB

**Tools:** Prometheus, Datadog, CloudWatch Metrics, New Relic.

---

### 2. Logs

Timestamped records of discrete events. Structured logs can include severity, service name, request ID, and error details. Their volume and retention affect storage cost; log records are not necessarily unique.

**Illustrative log records:**

```text
2026-10-07 14:22:03 INFO  user_id=u123 action=login status=200
2026-10-07 14:22:04 ERROR db_query_failed timeout=5s host=db-primary
2026-10-07 14:22:05 WARN  retrying attempt=2 endpoint=/orders
```

**Tools:** Elasticsearch + Kibana (ELK), Loki, Splunk, CloudWatch Logs, Datadog Logs.

---

### 3. Traces

A trace records work associated with a request across a system. Each span represents an operation with timing, attributes, and relationships to other spans. This helps locate slow operations and identify how services interact.

**Illustrative request trace:**

```text
Request /checkout (430ms total)
  ├─ api-gateway        5ms
  ├─ auth-service      25ms
  ├─ cart-service      80ms
  │   └─ redis-cache   12ms
  ├─ payment-service  280ms   ← bottleneck!
  │   └─ stripe-api   260ms
  └─ order-service     40ms
```

**Tools:** Jaeger, Zipkin, Tempo, Datadog APM, AWS X-Ray.

---

## Comparison

| Signal | Data structure | Typical investigation |
|---|---|---|
| Metrics | Numeric series with labels | Trends, thresholds, and aggregate behavior |
| Logs | Event records with context | Errors and events around a specific operation |
| Traces | Related spans grouped by trace ID | Request paths, dependencies, and latency |

Storage cost depends on volume, attributes, sampling, and retention. Request or trace IDs can connect a slow request's trace to its corresponding logs. These signals complement each other. [OpenTelemetry signal concepts](https://opentelemetry.io/docs/concepts/signals/)

---

## Kubernetes Observability

Common Kubernetes observability components:

- **Metrics:** Prometheus (scrapes `/metrics` endpoints) + Grafana (dashboards) + Alertmanager (alerts)
- **Logs:** Fluent Bit / Fluentd ships pod logs → Loki or Elasticsearch
- **Traces:** OpenTelemetry collectors → Jaeger / Tempo
- **Cluster-level:** metrics-server (for HPA), kube-state-metrics (K8s object state)

For example, a latency metric can reveal slower checkout requests, a trace can locate time spent in the payment service, and a correlated log can explain a downstream timeout. Instrumentation and correlation are needed to connect those observations.

In the Session 20 practical, Prometheus scrapes its own metrics and Grafana displays target availability. Logging and tracing backends are studied here; they were not deployed as part of that monitoring stack.
