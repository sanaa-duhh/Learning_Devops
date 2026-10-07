# Session 16 - CI/CD & GitHub Actions

Built a complete CI/CD pipeline using GitHub Actions for a Python Flask demo app — covering build, test, Docker image creation, artifacts, secrets, and a deploy step.

Workflow file: [`.github/workflows/cicd.yml`](../.github/workflows/cicd.yml)
Demo app: `session16-cicd-demo/` (Flask + pytest + Dockerfile)

---

## Pipeline Structure

```
build-and-test  →  docker-build  →  deploy
     ↓                    ↓
test-report.xml      image.tar
  (artifact)         (artifact)
```

Three jobs chained with `needs:`:
1. **Build & Test** — installs deps, runs pytest, uploads test report as artifact
2. **Build Docker Image** — builds the image, saves it as a tar artifact
3. **Deploy** — only runs on `main` branch, uses a `DEPLOY_TOKEN` secret

---

## CI vs CD

- **CI (Continuous Integration)** — Build & Test jobs. Every push/PR runs them to catch bugs early.
- **CD (Continuous Deployment)** — the Deploy job. Only runs on `main` after CI passes.

---

## Concepts Covered

| Concept | Where in the workflow |
|---|---|
| Workflow | `cicd.yml` — the top-level pipeline definition |
| Jobs | `build-and-test`, `docker-build`, `deploy` |
| Steps | each `- name:` block inside a job |
| Runners | `runs-on: ubuntu-latest` — GitHub-hosted VMs |
| Secrets | `${{ secrets.DEPLOY_TOKEN }}` injected into deploy job |
| Artifacts | `actions/upload-artifact@v4` — test report and docker image |
| Triggers | `push`, `pull_request`, `workflow_dispatch` |
| Build | `pip install` + `docker build` |
| Test | `pytest tests/` with JUnit XML output |

---

## Running the Pipeline

Triggered automatically on push to `main` or any PR. Can also be run manually from the Actions tab → "Run workflow".

![session16_1](../.screenshots/session16_1.png)

Pipeline job graph — the three jobs chained with dependencies:

![session16_2](../.screenshots/session16_2.png)

Test step output — pytest running inside the Build & Test job:

![session16_3](../.screenshots/session16_3.png)

Deploy job showing the secret was accessed:

![session16_4](../.screenshots/session16_4.png)

Artifacts from the completed run — the test report and docker image tarball:

![session16_5](../.screenshots/session16_5.png)

---

## Local Verification

The demo app can also run outside the pipeline:

```bash
cd session16-cicd-demo
pip install -r requirements.txt
pytest tests/
docker build -t cicd-demo .
docker run -p 5000:5000 cicd-demo
```
