# Qism Natijah

Monorepo internal app:
- `backend/` Laravel 12 API + Sanctum + PostgreSQL + Excel export
- `frontend/` Next.js 15 App Router + TypeScript + Tailwind

## 1) Backend Setup

```bash
cd backend
cp .env.example .env
composer install
php artisan key:generate
php artisan migrate --seed
php artisan serve --host=0.0.0.0 --port=8000
```

Set `backend/.env`:

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

DEVHUB_BUG_ENDPOINT=http://192.168.1.10:3000/api/client-bugs
DEVHUB_BUG_API_KEY=your_shared_key
DEVHUB_SOURCE_APP_NAME=YourClientApp
APP_VERSION=1.0.0
```

## 2) Frontend Setup

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

DEVHUB_BUG_ENDPOINT=http://192.168.1.10:3000/api/client-bugs
DEVHUB_BUG_API_KEY=your_shared_key
DEVHUB_SOURCE_APP_NAME=YourClientApp
APP_VERSION=1.0.0
```

## 3) Report Bug Integration

Route: `http://localhost:3000/report-bug`

What is included automatically:
- source app name (`DEVHUB_SOURCE_APP_NAME`)
- current route
- user agent
- app version
- timestamp
- viewport size

Automatic reporting is enabled for:
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

If `DEVHUB_BUG_ENDPOINT` or `DEVHUB_BUG_API_KEY` is missing, the app logs a warning and skips reporting safely.

## 4) Manual Test Steps

1. Open `/report-bug`.
2. Submit a test report with title and description.
3. Confirm success toast and optional bug ID.
4. Confirm payload arrives at DevHub `/api/client-bugs`.

## 5) API Connectivity Tests

Curl:

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

PowerShell:

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

## 6) Troubleshooting

- `401 unauthorized`
  - Verify `DEVHUB_BUG_API_KEY` exactly matches DevHub.
- Network timeout / endpoint unreachable
  - Verify LAN IP/port, firewall rules, and that both servers are on the same network.
- Missing env variables
  - Check `frontend/.env.local` and `backend/.env`, then restart servers.

## 7) LAN HTTP and Mixed Content

This app avoids browser mixed-content issues by sending reports to Next.js server route `/api/report-bug`, then server-side forwarding to DevHub over HTTP. Browser does not call DevHub directly.

If you bypass this route and call `http://...` from an HTTPS page in browser JavaScript, modern browsers may block it. Safe LAN workaround:
- keep frontend and DevHub both on HTTP in trusted LAN, or
- place DevHub behind HTTPS (reverse proxy) and call the HTTPS endpoint.
