# AWS VPC — Virtual Private Cloud

A VPC is a logically isolated network in AWS. It provides control over IP ranges, subnets, routing, and network access for resources such as EC2 instances. Regional services such as S3 are not deployed into a customer's subnet. [AWS VPC overview](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)

---

## Core Concepts

### CIDR (Classless Inter-Domain Routing)
The IP range for your VPC, e.g. `10.0.0.0/16` gives you ~65k addresses. The `/16` is the netmask — smaller number = bigger block. Common VPC size is `/16`, subnets usually `/24` (256 IPs).

### Subnets
Subdivisions of the VPC CIDR, each contained in one Availability Zone. Public and private subnets are common configurations:
- **Public subnet** — has a route to the internet via Internet Gateway
- **Private subnet** — no direct route to an Internet Gateway; it can use NAT for outbound IPv4 internet access

A private subnet does not have to provide internet access. Its route table determines which destinations can be reached. [AWS subnet documentation](https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html)

### Route Tables
Rules deciding where traffic goes based on destination CIDR. Each subnet is associated with one route table. Default route (`0.0.0.0/0`) usually points to IGW (public) or NAT (private).

### Internet Gateway (IGW)
Attached to the VPC. The thing that makes outbound/inbound internet traffic possible for public subnets.

### NAT Gateway
Lets private subnet resources reach the internet (for updates, API calls) but doesn't let anything from the internet reach them. Lives in a public subnet.

### Security Groups
Instance-level stateful firewall. Allow rules only — anything not explicitly allowed is blocked. Stateful means if inbound is allowed, matching outbound response is auto-allowed.

### Network ACLs (NACLs)
Subnet-level stateless firewall. Allow AND deny rules, numbered priorities. Harder to manage; most teams rely on Security Groups.

### Public vs Private Subnet
```
Public subnet (10.0.1.0/24)
  → Route: 0.0.0.0/0 to IGW
  → Hosts public-facing load balancers, bastions

Private subnet (10.0.2.0/24)
  → Route: 0.0.0.0/0 to NAT Gateway in public subnet
  → Hosts databases, backend services
```

---

## Typical VPC Setup

- VPC `10.0.0.0/16`
- Public subnet per AZ for ALBs and NAT gateways
- Private subnet per AZ for app servers
- Database private subnet per AZ for RDS
- IGW attached, NAT in public subnet
- Security groups layered: ALB → App → DB
