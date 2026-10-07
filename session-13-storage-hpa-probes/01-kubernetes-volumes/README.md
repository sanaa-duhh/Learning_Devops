# Kubernetes Volumes — What I Learned

Containers are stateless by nature — anything written inside them is lost when the container restarts. Volumes solve that by giving pods a place to store data that outlives the container.

---

## 1. emptyDir

A fresh, empty directory created when the Pod starts. Lives as long as the Pod lives — if the Pod is deleted, data is gone.

**Use when:** short-term scratch space, sharing data between containers in the same Pod.

```yaml
volumes:
  - name: cache
    emptyDir: {}
```

---

## 2. hostPath

Mounts a file or directory from the actual **node's filesystem** into the Pod.

**Use when:** learning, local testing, or node-level stuff like node agents reading `/var/log`. **Not** for production app data — if the Pod moves to a different node, the data stays behind on the old node.

```yaml
volumes:
  - name: node-logs
    hostPath:
      path: /var/log
      type: Directory
```

---

## 3. PersistentVolume (PV)

A cluster-level storage resource created by the admin (or dynamically). It's an actual piece of storage — a disk, an NFS share, cloud storage, etc. Exists independently of any Pod.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-demo
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /mnt/data
```

Access modes:
- **ReadWriteOnce (RWO)** — one node can mount it as read-write
- **ReadOnlyMany (ROX)** — many nodes can mount as read-only
- **ReadWriteMany (RWX)** — many nodes can mount as read-write

---

## 4. PersistentVolumeClaim (PVC)

A request for storage made by the user. The Pod references the PVC, not the PV directly. Kubernetes finds a matching PV (or creates one dynamically) and binds them.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-demo
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
```

Pod uses it:
```yaml
volumes:
  - name: app-data
    persistentVolumeClaim:
      claimName: pvc-demo
```

**Key idea:** PV is the actual storage, PVC is the claim ticket for it. The pod talks to the PVC.

---

## 5. StorageClass

Defines a "class" of storage. Each StorageClass has a provisioner that knows how to dynamically create PVs on demand.

On Minikube the default class is `standard` which uses the hostpath provisioner. In cloud environments it'd be something like `gp2` on AWS or `pd-ssd` on GCP.

```bash
kubectl get storageclass
```

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-ssd
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-ssd
```

---

## 6. Dynamic Provisioning

Instead of an admin pre-creating a PV, Kubernetes creates one automatically when a PVC asks for storage. The PVC references a StorageClass, and the StorageClass's provisioner creates the matching PV on the fly.

Flow:
```
PVC created → StorageClass → Provisioner → PV auto-created → PVC bound
```

Without dynamic provisioning, you'd have to manually create a PV for every PVC — not scalable.

---

## Quick Comparison

| Volume Type | Lifetime | Survives Pod Restart | Survives Pod Delete | Use Case |
|---|---|---|---|---|
| emptyDir | Pod | Yes | No | Scratch space, inter-container sharing |
| hostPath | Node | Yes | Yes (but node-bound) | Local testing, node agents |
| PV + PVC | Cluster | Yes | Yes | Application data, databases |

---

## Reference

https://kubernetes.io/docs/concepts/storage/volumes/
https://kubernetes.io/docs/concepts/storage/persistent-volumes/
https://kubernetes.io/docs/concepts/storage/storage-classes/
