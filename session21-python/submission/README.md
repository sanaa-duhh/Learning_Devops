# Session 21 - Running TaskBoard with Docker Compose

Ran the TaskBoard demo with the frontend and backend started manually, then built and ran the complete application through Docker Compose. Verified database access, task storage, dashboard statistics, and the create, read, update, and delete APIs.

## Application Overview

| Component | Technology | Role |
|---|---|---|
| Frontend | React and Vite; nginx in the container | Task dashboard, creation form, and status updates |
| Backend | Python 3.12 and FastAPI | REST APIs and health/readiness endpoints |
| Database | PostgreSQL 15 | Persistent task storage |
| Database tooling | SQLAlchemy and Alembic | Models, database queries, and schema migrations |

The manual run uses Vite on port `5174` and FastAPI on port `8002`, with PostgreSQL provided by the Compose database service. The full Compose run serves the frontend through nginx on port `3005`.

```mermaid
flowchart LR
    Browser["Browser: localhost:3005"] --> Frontend["Frontend: nginx, port 80"]
    Frontend -->|"/api requests"| Backend["Backend: FastAPI, port 8000"]
    Backend --> PostgreSQL["PostgreSQL: port 5432"]
    PostgreSQL --> Volume["Named volume: postgres-data"]
```

---

## Task 1 — Run the Application Manually

### Start PostgreSQL and Prepare the Backend

From the repository root:

```bash
cd session21-python
docker compose up -d postgres
docker compose exec postgres pg_isready -U taskboard -d taskboard
```

The database readiness check returned:

```text
/var/run/postgresql:5432 - accepting connections
```

Created a Python 3.12 virtual environment and installed the backend dependencies:

```bash
cd backend
uv venv --python 3.12 .venv-session21
source .venv-session21/bin/activate
uv pip install --python .venv-session21/bin/python -r requirements.txt
```

The installation used Python `3.12.13` and installed 34 packages, including FastAPI `0.115.6`, Uvicorn `0.34.0`, SQLAlchemy `2.0.36`, psycopg `3.2.3`, and Alembic `1.14.0`.

Configured the connection to PostgreSQL's published host port and applied the migrations:

```bash
export DATABASE_URL='postgresql+psycopg://taskboard:taskboard@localhost:55434/taskboard'
.venv-session21/bin/python -m alembic upgrade head
```

![PostgreSQL startup, readiness check, Python environment, and backend dependency installation](../../.screenshots/session21_1.png)

### Start FastAPI

```bash
.venv-session21/bin/python -m uvicorn app.main:app --reload --port 8002
```

The explicit Python path ensures Uvicorn uses the project environment. The successful startup showed:

```text
Uvicorn running on http://127.0.0.1:8002
Waiting for application startup.
Application startup complete.
```

![FastAPI starting successfully with the project's Python virtual environment](../../.screenshots/session21_2.png)

### Start the Frontend

Kept the backend running and opened another terminal:

```bash
cd ~/Codes/devops/devops-heros/session21-python/frontend
npm install
npm run dev -- --host 127.0.0.1 --port 5174 --strictPort
```

Opened `http://localhost:5174`. The [Vite configuration](../frontend/vite.config.js) forwards `/api` requests to `http://localhost:8002`.

Created the task **start minikube**, assigned it to **Sanaa Ara**, and advanced its status to **DONE**. The dashboard displayed one total task and one completed task.

![Manual frontend at localhost:5174 showing the completed task and matching dashboard counts](../../.screenshots/session21_3.png)

---

## Task 2 — Dockerfiles

### Backend Image

The [backend Dockerfile](../backend/Dockerfile) uses `python:3.12-slim`, installs the dependencies, and copies the application and migration files. It runs as the non-root user with UID `10001`.

Its startup command applies migrations before starting FastAPI:

```dockerfile
CMD ["sh", "-c", "alembic upgrade head && uvicorn app.main:app --host 0.0.0.0 --port 8000"]
```

The backend listens on container port `8000`; Compose publishes it on host port `8002`.

### Frontend Image

The [frontend Dockerfile](../frontend/Dockerfile) uses a multi-stage build:

```text
node:22-alpine
    → install dependencies
    → npm run build
    → copy dist/ into nginx:1.27-alpine
```

The final image serves the built frontend on port `80`. The [nginx configuration](../frontend/nginx.conf) forwards `/api/` requests to `http://backend:8000`, using the Compose service name.

---

## Task 3 — Build and Run with Docker Compose

Stopped the manual Vite and Uvicorn servers with `Ctrl+C`, leaving PostgreSQL running. From the application directory:

```bash
cd ~/Codes/devops/devops-heros/session21-python
docker compose up -d --build
docker compose ps
```

The [Compose configuration](../docker-compose.yml) defines all three services:

| Service | Image | Host mapping | Captured status |
|---|---|---|---|
| PostgreSQL | `postgres:15` | `127.0.0.1:55434 → 5432` | Running, healthy |
| Backend | `session21-python-backend` | `127.0.0.1:8002 → 8000` | Running, healthy |
| Frontend | `session21-python-frontend` | `127.0.0.1:3005 → 80` | Running |

PostgreSQL's health check tests whether it accepts connections. The backend waits for PostgreSQL to become healthy and checks its own `/ready` endpoint. The frontend starts after the backend is healthy.

Both application images built successfully. The captured startup summary shows:

```text
Image session21-python-backend           Built
Image session21-python-frontend          Built
Container session21-python-postgres-1    Healthy
Container session21-python-backend-1     Healthy
Container session21-python-frontend-1    Started
```

![Docker Compose image builds and status showing all three services running](../../.screenshots/session21_4.png)

### Test the Containerized Application

Opened `http://localhost:3005`. The **start minikube** task from the manual run was still present. Created a second task, **go to protest**, assigned to **Super Sanaa**, with priority **HIGH** and status **TODO**.

The dashboard displayed:

```text
Total tasks: 2
To do: 1
In progress: 0
Completed: 1
```

The earlier task appearing in the Compose frontend confirms that the manual and containerized backends used the same PostgreSQL database. The `postgres-data` named volume stores the database files independently of the application containers.

![TaskBoard at localhost:3005 showing the earlier completed task and the new task](../../.screenshots/session21_5.png)

---

## Task 4 — Test the Backend APIs

### Health, Readiness, Task Listing, and Statistics

Ran the following commands against the containerized backend:

```bash
curl -sS http://localhost:8002/health | python3 -m json.tool
curl -sS http://localhost:8002/ready | python3 -m json.tool
curl -sS http://localhost:8002/api/tasks | python3 -m json.tool
curl -sS http://localhost:8002/api/tasks/stats | python3 -m json.tool
```

`/health` returned `{"status": "UP"}`. `/ready` returned `{"status": "READY"}` after querying the database. The task-list response contained the two dashboard tasks, with IDs `1` and `2`.

At this point, the statistics response was:

```json
{
  "total": 2,
  "todo": 1,
  "inProgress": 0,
  "done": 1
}
```

These counts matched the frontend dashboard.

![curl responses confirming health, database readiness, stored tasks, and task statistics](../../.screenshots/session21_6.png)

### Create a Task — POST

Opened the Swagger interface at `http://localhost:8002/docs` and used **Try it out → Execute** on `POST /api/tasks` with:

```json
{
  "title": "API verification task",
  "description": "Testing task creation through Swagger",
  "priority": "HIGH",
  "status": "TODO",
  "assignee": "Sanaa"
}
```

The server returned **201 Created** with the new task's ID, `3`.

![Swagger POST request returning 201 and creating the API verification task with ID 3](../../.screenshots/session21_post.png)

### Read the Task — GET

Requested `GET /api/tasks/3`. The server returned **200 OK** with the same title, assignee, priority, and `TODO` status. The response also included its creation timestamp.

![Swagger GET request returning 200 and the stored task with ID 3](../../.screenshots/session21_get.png)

### Update the Task — PUT

Sent `PUT /api/tasks/3` with:

```json
{
  "status": "DONE"
}
```

The server returned **200 OK**. The response showed the task's status changed to `DONE`, while its other details remained the same.

![Swagger PUT request returning 200 and updating task 3 to DONE](../../.screenshots/session21_put.png)

### Delete the Task — DELETE

Sent `DELETE /api/tasks/3` to remove the temporary test task. The server returned **204 No Content**, with no response body.

![Swagger DELETE request returning 204 for the temporary task](../../.screenshots/session21_delete.png)

### API Test Results

| Operation | Endpoint | Recorded result |
|---|---|---|
| Health | `GET /health` | `status: UP` |
| Database readiness | `GET /ready` | `status: READY` |
| List tasks | `GET /api/tasks` | Returned tasks `1` and `2` |
| Task statistics | `GET /api/tasks/stats` | Two tasks: one TODO and one DONE |
| Create | `POST /api/tasks` | `201`, created task `3` |
| Read | `GET /api/tasks/3` | `200`, retrieved task `3` |
| Update | `PUT /api/tasks/3` | `200`, changed status to DONE |
| Delete | `DELETE /api/tasks/3` | `204`, no response body |

---

## Local Configuration and Troubleshooting

| Issue | Resolution |
|---|---|
| Original host ports were occupied by other services | Used `3005` for the containerized frontend, `8002` for the backend, and `55434` for PostgreSQL |
| Vite's API proxy pointed to port `8080` | Updated it to the backend at `http://localhost:8002` |
| Pulling `postgres:16-alpine` encountered a Docker Hub TLS timeout | Used the locally cached `postgres:15` image |
| Bare `uvicorn` launched global Python 3.11 and could not import SQLAlchemy | Started Uvicorn through `.venv-session21/bin/python -m uvicorn` |

The task form also retains its form reference before awaiting the API response, allowing it to reset and close after task creation. Python environments, local `.env` files, dependency directories, and generated build files are excluded by the application's [.gitignore](../.gitignore).

## Cleanup

From the `session21-python` directory:

```bash
docker compose down
```

This stops and removes the stack's containers and network while preserving the named database volume. All ten screenshots above document the manual run, image builds, Compose deployment, application behavior, and API results.
