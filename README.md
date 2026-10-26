# HarborPoint Learning Solutions

This repository contains the HarborPoint IT asset-management prototype based on
the AS-IS and TO-BE process assessment in `Deliverable-HarborPoint-AS-IS_TO_BE.docx`.

## HarborPoint UI

The asset-management dashboard is available at `/harborpoint-assets` after
logging into the Insights application. It covers:

- procurement and intake
- assignment and check-out
- movement and loaners
- maintenance and repair
- software licensing
- retirement and disposal

## Docker

From this repository root:

```powershell
docker compose up -d
```

Open `http://insights.localhost:8000/insights` and log in with:

- Username: `Administrator`
- Password: `admin`

The Docker setup mounts `insights-develop/`, so the UI changes in
`insights-develop/frontend/src2/` are available to the application.
