# devops-heros

**Name:** Sanaa Ara

**Roll Number:** 24BCS10304

**Email:** sanaa.24bcs10304@sst.scaler.com

DevOps homework submissions, every task documented with the actual commands run and the real output they produced.

---

## Homework Submissions

| Session | Topic | Submission |
|---|---|---|
| 2 | **Linux Fundamentals** | [session2-linux/session2_assignment.md](session2-linux/session2_assignment.md) |
| 3 | **Shell Scripting** | [session3-shell-scripting/session3_assignment.md](session3-shell-scripting/session3_assignment.md) |
| 4 | **Networking** | [session4-networking/session4_assignment.md](session4-networking/session4_assignment.md) |
| 5 | **Git & GitHub** | [session5-git-github/session5_assignment.md](session5-git-github/session5_assignment.md) |
| 6 | **Docker Fundamentals** | [session6-7-docker/session6_assignment.md](session6-7-docker/session6_assignment.md) |
| 7 | **Docker Multi-Stage Build** | [session6-7-docker/session7_assignment.md](session6-7-docker/session7_assignment.md) |
| 8 | **Docker Networking & Volumes** | [session8-docker-networking-volume/session8_assignment.md](session8-docker-networking-volume/session8_assignment.md) |
| 9 | **Kubernetes Fundamentals** | [session9-k8s/session9_assignment.md](session9-k8s/session9_assignment.md) |
| 10 | **Kubernetes Pods, ReplicaSets & Deployments** | [session10-k8s-core-objects/session10_assignment.md](session10-k8s-core-objects/session10_assignment.md) |
| 11 | **Kubernetes Networking & Services** | [session-11-kubernetes-services/session11_assignment.md](session-11-kubernetes-services/session11_assignment.md) |
| 12 | **Kubernetes Ingress, ConfigMaps & Secrets** | [session-12-ingress-configmaps-secrets/session12_assignment.md](session-12-ingress-configmaps-secrets/session12_assignment.md) |

---

## What's covered

### [Session 2 — Linux Fundamentals](session2-linux/session2_assignment.md)
Soft links vs hard links (inodes, creation, deletion) · `adduser` vs `useradd` on Ubuntu · `journalctl` for system and per-service logs · Linux command cheat sheet practised end to end.

### [Session 3 — Shell Scripting](session3-shell-scripting/session3_assignment.md)
[`system_info.sh`](session3-shell-scripting/system_info.sh) — prints date, hostname, username, disk usage and running processes · uses variables and `read -p` · creates a directory with `mkdir` and a file with `touch` · saves process info using `>` redirection.

### [Session 4 — Networking](session4-networking/session4_assignment.md)
`ifconfig` · `ping` and `traceroute` · DNS with `dig` and `nslookup` · ports with `netstat` · `curl` · ARP table with `arp -a`.

### [Session 5 — Git & GitHub](session5-git-github/session5_assignment.md)
`git commit -a -m` vs `git commit -m` · full cherry-pick workflow across branches with verification.

### [Session 6 — Docker Fundamentals](session6-7-docker/session6_assignment.md)
Six Hello World web applications each with their own Dockerfile, built and verified in the browser: **Node.js**, **Python (Flask)**, **Nginx**, **Java**, **Apache** and **React**.

### [Session 7 — Docker Multi-Stage Build](session6-7-docker/session7_assignment.md)
Multi-stage Dockerfile with a builder stage and a lean production stage · container verified running on port 8085 · 3 different app types deployed.

### [Session 8 — Docker Networking & Volumes](session8-docker-networking-volume/session8_assignment.md)
Three containers across three networks with backend connected to two · host networking with Apache · bind mount updating live without container restart · overlay network research.

### [Session 9 — Kubernetes Fundamentals](session9-k8s/session9_assignment.md)
Minikube installed on Mac · single-node cluster verified with `kubectl get nodes` and `cluster-info` · first hello-nginx deployment exposed via NodePort · K8s architecture notes (control plane + worker node components).

### [Session 10 — Kubernetes Pods, ReplicaSets & Deployments](session10-k8s-core-objects/session10_assignment.md)
Pod lifecycle lab covering all major states (Running, Pending, Succeeded, Failed, CrashLoopBackOff, ImagePullBackOff, readiness/liveness/startup probes, init and multi-container pods) · ReplicaSet scaling up and down · all 4 deployment strategies — **rolling update**, **blue-green**, **canary** (90/10 split verified with curl loop), and **recreate**.

### [Session 11 — Kubernetes Networking & Services](session-11-kubernetes-services/session11_assignment.md)
All 5 service types applied and tested: **ClusterIP** (internal only), **NodePort** (external via node port), **LoadBalancer** (pending on Minikube, expected), **ExternalName** (DNS CNAME to `api.github.com`), and **Headless** (multiple A records for StatefulSet pods).

### [Session 12 — Kubernetes Ingress, ConfigMaps & Secrets](session-12-ingress-configmaps-secrets/session12_assignment.md)
End-to-end demo — ConfigMap and Secret feeding a backend deployment as environment variables · frontend and backend both `ClusterIP` · single Ingress routing `/` to frontend and `/api/*` to backend on host `yatri.local` · base64 encoding vs actual encryption discussed.

---

## Course Links

- DevOps Homework — https://docs.google.com/document/d/1cjXFYf2Thm8cBEN-0C48B-v02cj3jGLd47lcO18prHE/edit?usp=sharing
- Submission — Section A: https://forms.gle/ydjAJcwxjpjBXgxB8
- Submission — Section B: https://forms.gle/pAuXQaokwVzhRzit6
