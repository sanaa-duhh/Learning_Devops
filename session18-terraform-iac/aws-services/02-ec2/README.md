# AWS EC2 — Elastic Compute Cloud

EC2 provides virtual servers in the cloud. An AMI, instance type, storage, and network configuration define the server you launch. [AWS EC2 overview](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)

---

## Core Concepts

### AMI (Amazon Machine Image)
A template for the OS and software stack an instance boots from. Standard ones (Amazon Linux, Ubuntu, Windows Server) or custom AMIs you build yourself.

### Instance Types
The hardware spec — CPU, memory, network, storage. Families target workloads:
- **t3/t4g** — general purpose, burstable
- **m5/m6** — balanced for apps
- **c5/c6** — compute optimized
- **r5/r6** — memory optimized (DBs, caching)
- **p3/g4** — GPU for ML/graphics

### Key Pairs
SSH key pair used to log into Linux instances. You download the private key once at creation; AWS stores the public key.

### Security Groups
Virtual firewall at the instance level. Define allowed inbound/outbound rules. Default: deny inbound, allow outbound.

### EBS (Elastic Block Store)
Persistent block storage attached to instances. Whether a volume survives termination depends on its `DeleteOnTermination` setting; a root volume attached at launch is deleted by default. Examples include gp3 for general purpose SSD, io2 for high IOPS, and st1 for throughput-oriented HDD. [AWS volume persistence](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/preserving-volumes-on-termination.html)

### Public vs Private IP
- **Private IP** — internal VPC address, used for inter-service traffic
- **Public IP** — an internet-routable address; access also requires suitable routes and firewall rules
- **Elastic IP** — static public IP you own, survives instance stop/start

### Instance Lifecycle
Pending → Running → Stopping → Stopped (or Terminated)
Stopped instances don't incur compute charges, but EBS storage still costs.
Terminated instances are gone forever.

---

## Common Use Cases

- Hosting web servers, APIs, backend services
- Build/CI runners for pipelines
- Running databases (though RDS is usually better)
- GPU workloads (ML training, rendering)
- Bastion hosts for SSH access into private subnets
