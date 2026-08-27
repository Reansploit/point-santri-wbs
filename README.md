# Qism Natijah

Internal app for recording **point** (merit/demerit scores) of **santri** (pesantren
students). This repository contains two ways to run it:

- A **web app** — `backend/` (Laravel API) + `frontend/` (Next.js) talking to PostgreSQL.
- A **desktop app** — `desktop/` (Tauri v2, Windows `.exe`, offline, local SQLite).
  See [desktop/README.md](desktop/README.md) for that build.

The web app can optionally forward client errors to a separate **DevHub** bug service
(see [Report Bug Integration](#report-bug-integration-optional)).

## Repository layout

```
.
├── backend/      Laravel 12 API · PHP 8.3 · Sanctum · PostgreSQL · Excel export
├── frontend/     Next.js 15 (App Router) · TypeScript · Tailwind
├── desktop/      Tauri v2 Windows desktop app (offline, SQLite) — separate README
├── docker-compose.yml   Postgres + backend + frontend, one command
└── backup.sql / qism_point.sqlite   legacy data + migrated SQLite (see desktop README)
```

## Prerequisites

- **PHP** >= 8.3 and **Composer** (for the web backend)
- **Node.js** >= 18 (frontend) — Next.js 15; the desktop migration script needs Node 22+
- **PostgreSQL** 16 — or just use Docker (recommended, see below)
- **Docker** + Docker Compose (optional but recommended for the web stack)

---

## Quick start with Docker (recommended)

This brings up PostgreSQL, the backend, and the frontend together:

```bash
docker compose up --build
```

- API:        http://localhost:8000
- Frontend:   http://localhost:3000

The backend container runs `php artisan migrate --seed` on first boot via its
`Dockerfile`. If you change `.env` values, recreate the stack:

```bash
docker compose down && docker compose up --build
```

---

## Manual setup (web app)

### 1) Backend

```bash
cd backend
cp .env.example .env
composer install
php artisan key:generate
php artisan migrate --seed
php artisan serve --host=0.0.0.0 --port=8000
```

Required `backend/.env` (the values below match `.env.example`):

```env
APP_URL=http://localhost:8000
FRONTEND_URL=http://localhost:3000

DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=qism_point
DB_USERNAME=postgres
DB_PASSWORD=postgres

SANCTUM_STATEFUL_DOMAINS=localhost:3000
SESSION_DOMAIN=localhost
```

The `DEVHUB_*` lines are **optional** — see
[Report Bug Integration](#report-bug-integration-optional). Leave them out to skip
bug reporting entirely.

### 2) Frontend

```bash
cd frontend
cp .env.example .env.local
npm install
npm run dev
```

Recommended `frontend/.env.local`:

```env
NEXT_PUBLIC_API_URL=http://localhost:8000/api
NEXT_PUBLIC_DEVHUB_SOURCE_APP_NAME=YourClientApp
NEXT_PUBLIC_APP_VERSION=1.0.0
```

The `DEVHUB_*` block is optional (see below). When omitted, the app still runs; only
automatic bug reporting is disabled.

---

## Report Bug Integration (optional)

**What DevHub is:** a *separate* internal bug-collecting service. Its source is **not**
part of this repository — you point the app at an already-running DevHub instance via
env vars. If those vars are missing, the app logs a warning and skips reporting safely;
nothing breaks.

Web report UI route: `http://localhost:3000/report-bug`

Automatically attached to every report:

- source app name (`DEVHUB_SOURCE_APP_NAME`)
- current route
- user agent
- app version
- timestamp
- viewport size

Automatic reporting is triggered by:

- unhandled browser errors
- unhandled promise rejections
- backend 5xx exceptions

Reliability and safety:

- timeout: 9 seconds
- retries once on network/5xx path
- duplicate throttle window
- payload truncation for large text/stack
- sensitive-field redaction (`password`, `token`, `authorization`, `cookie`, `secret`, `api key`, credit card patterns)
- app flow is never blocked if DevHub is down

> **Endpoint is deployment-specific.** The README examples use a LAN IP placeholder.
> Copy the real value from your running DevHub instance (note: `backend/.env.example`
> and `frontend/.env.example` currently list *different* LAN addresses — use whichever
> DevHub you actually deployed).

### Backend env

```env
DEVHUB_BUG_ENDPOINT=http://192.168.1.10:3000/api/client-bugs
DEVHUB_BUG_API_KEY=your_shared_key
DEVHUB_SOURCE_APP_NAME=YourClientApp
APP_VERSION=1.0.0
```

### Frontend env

```env
DEVHUB_BUG_ENDPOINT=http://192.168.1.10:3000/api/client-bugs
DEVHUB_BUG_API_KEY=your_shared_key
DEVHUB_SOURCE_APP_NAME=YourClientApp
APP_VERSION=1.0.0
```

### Manual test steps

1. Open `/report-bug`.
2. Submit a test report with title and description.
3. Confirm success toast and optional bug ID.
4. Confirm payload arrives at DevHub `/api/client-bugs`.

### API connectivity test (curl)

```bash
curl -X POST "http://192.168.1.10:3000/api/client-bugs" \
  -H "Content-Type: application/json" \
  -H "x-devhub-api-key: your_shared_key" \
  -d '{
    "title":"Manual API test",
    "description":"Connectivity check from LAN",
    "sourceApp":"YourClientApp",
    "severity":"medium"
  }'
```

### API connectivity test (PowerShell)

```powershell
$body = @{
  title = "Manual API test"
  description = "Connectivity check from LAN"
  sourceApp = "YourClientApp"
  severity = "medium"
} | ConvertTo-Json

Invoke-RestMethod -Method Post -Uri "http://192.168.1.10:3000/api/client-bugs" `
  -Headers @{ "x-devhub-api-key" = "your_shared_key" } `
  -ContentType "application/json" `
  -Body $body
```

---

## Troubleshooting

- `401 unauthorized` (DevHub)
  - Verify `DEVHUB_BUG_API_KEY` exactly matches DevHub.
- Network timeout / endpoint unreachable
  - Verify LAN IP/port, firewall rules, and that both servers are on the same network.
- Missing env variables
  - Check `frontend/.env.local` and `backend/.env`, then restart servers.

## LAN HTTP and mixed content

This app avoids browser mixed-content issues by sending reports to the Next.js server
route `/api/report-bug`, which then forwards to DevHub over HTTP server-side. The
browser never calls DevHub directly.

If you bypass this route and call `http://...` from an HTTPS page in browser JavaScript,
modern browsers may block it. Safe LAN workaround:

- keep frontend and DevHub both on HTTP in a trusted LAN, or
- place DevHub behind HTTPS (reverse proxy) and call the HTTPS endpoint.

---

## Desktop app

The offline Windows desktop build (Tauri v2, local SQLite, no server) lives in
[desktop/](desktop/README.md). It has its own README covering build, default accounts,
logo, project structure, and one-time PostgreSQL → SQLite data migration.
