# AWS Database Services — DynamoDB & RDS

DynamoDB and RDS provide different database models. The choice depends on data structure, query patterns, and application requirements.

---

## DynamoDB — NoSQL (Key-Value / Document)

A managed, serverless key-value and document database. AWS handles infrastructure management; application developers still design keys, access patterns, permissions, and capacity settings. [AWS DynamoDB overview](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)

### Core Concepts

**Tables** — top-level containers for data. No schema beyond the primary key.

**Items** — individual records. Each can have different attributes.

**Attributes** — key-value pairs inside items. Can be strings, numbers, lists, maps, binary, sets.

**Partition Key** — DynamoDB hashes its value to distribute data across physical partitions. With a simple primary key, this value must be unique; with a composite key, the partition key and sort key together identify an item.

**Sort Key (optional)** — second part of a composite primary key. Lets you query multiple items with the same partition key, sorted.

```
Table: Orders
Partition Key: UserId
Sort Key: OrderDate

{UserId: "u123", OrderDate: "2026-01-01", Total: 99.99}
{UserId: "u123", OrderDate: "2026-01-15", Total: 45.00}
```

### Use Cases
- High-traffic session storage, shopping carts, user preferences
- Serverless app backends (works great with Lambda)
- Real-time leaderboards and counters
- IoT telemetry at massive scale

### When Not to Use
- Complex joins and relational queries (use RDS)
- Ad-hoc analytics (use Redshift or Athena)
- Full-text search (use OpenSearch)

---

## RDS — Relational Database Service

Managed SQL databases — AWS handles backups, patching, failover, replication. You bring the schema and queries.

### Core Concepts

**Relational Database** — tables with rows and columns, enforced schema, foreign keys, SQL joins.

**Supported Engines**
- Amazon Aurora (MySQL- and PostgreSQL-compatible)
- MySQL
- PostgreSQL
- MariaDB
- Oracle
- SQL Server
- IBM Db2

Engine features and availability vary. [AWS RDS overview](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html)

**DB Instances** — the actual VM running your database. Size and class (`db.t3.medium`, `db.r5.xlarge`) sets CPU/RAM.

**Security**
- Runs inside a VPC, in private subnets ideally
- Access controlled by Security Groups
- Encryption at rest (KMS) and in transit (TLS)
- IAM database authentication on supported engines, using temporary authentication tokens

**Backups**
- **Automated backups** — daily snapshots, point-in-time restore within retention window (1–35 days)
- **Manual snapshots** — triggered on demand, kept until deleted

**Multi-AZ Deployment**
A Multi-AZ DB instance has a synchronous standby in another Availability Zone for automatic failover. This standby does not serve read traffic. Multi-AZ DB clusters are a separate deployment option that also provides readable instances. [Multi-AZ DB instances](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZSingleStandby.html), [Multi-AZ DB clusters](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/multi-az-db-clusters-concepts.html).

**Read Replicas**
Read-only copies used to offload read queries from the primary. Replication is generally asynchronous; replica limits and cross-region support depend on the engine and deployment.

### Use Cases
- Traditional web/mobile app backends with structured data
- Reporting and BI dashboards
- Any app needing ACID transactions
- Legacy apps migrating to the cloud

---

## Quick Comparison

| | DynamoDB | RDS |
|---|---|---|
| Model | NoSQL (key-value) | Relational SQL |
| Schema | Flexible | Strict |
| Scale | Managed horizontal scaling, subject to quotas | Instance scaling + read replicas |
| Latency | Single-digit ms | Depends on query |
| Joins | No | Yes |
| Transactions | ACID transactions with service limits | ACID transactions |
| Pricing | Per request + storage | Per instance hour + storage |
| Ops effort | AWS manages infrastructure; application design remains | AWS manages common administration; tuning remains |
