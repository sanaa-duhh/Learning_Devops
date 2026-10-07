# AWS S3 — Simple Storage Service

S3 stores data as objects inside buckets. It supports workloads such as backups, media storage, static website assets, and data lakes. [AWS S3 overview](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)

---

## Core Concepts

### Buckets
Top-level containers for objects, created in a specific region. General purpose bucket names in the shared namespace must be unique within an AWS partition. [AWS bucket naming rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)

### Objects
An object contains data, metadata, and a key identifying it within the bucket. A key such as `images/photo.png` can resemble a file path without creating a filesystem directory.

### Storage Classes
Tradeoff between retrieval speed and cost:
- **Standard** — hot data, high availability
- **Standard-IA** — infrequent access, cheaper storage, retrieval cost
- **One Zone-IA** — single AZ, cheaper, less resilient
- **Glacier Instant Retrieval** — archive, millisecond retrieval
- **Glacier Flexible** — minutes to hours retrieval, super cheap
- **Glacier Deep Archive** — hours retrieval, cheapest

### Versioning
Keep multiple versions of the same object. Enables undo for accidental deletes/overwrites. Each version is billed separately.

### Lifecycle Policies
Rules to automatically transition objects between storage classes or delete them after N days. Classic pattern: logs → Standard for 30 days → Glacier for 90 → delete.

### Encryption
- **SSE-S3** — AWS-managed keys, zero config
- **SSE-KMS** — your KMS key, audit trail of access
- **SSE-C** — customer-supplied keys
- **Client-side** — encrypt before upload

### Bucket Policies
Resource-based JSON policies attached to a bucket. AWS evaluates them alongside other applicable policies; an explicit deny overrides an allow. [AWS policy evaluation](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_evaluation-logic.html)

---

## Common Use Cases

- Static website hosting
- Backup and archive storage
- Data lake (CSV/Parquet files for Athena/Spark)
- Container image/binary artifact storage
- CDN origin (served via CloudFront)
- Image and video storage for web/mobile apps
