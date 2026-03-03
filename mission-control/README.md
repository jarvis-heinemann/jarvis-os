# IP Mission Control - Documentation

## Files

| File | Purpose |
|------|---------|
| `ip-mission-control.html` | Main dashboard (6 panels) |
| `ip-mission-control.js` | Core logic, data model, rendering |
| `ip-patent-detail.html` | Individual patent view |
| `ip-import.js` | CSV import/export |
| `ip-alerts.js` | Deadline alert system |
| `ip-portfolio-template.json` | Data schema |
| `ip-research-notes.md` | USPTO fee research |

## Features

### ✅ Completed
- Dashboard with stats (total, provisionals, continuations, granted)
- Patent CRUD (create, read, update, delete)
- Cost tracking per patent
- Portfolio cost summary + projections
- 12-month continuation deadline calculator
- Maintenance fee tracking (3.5, 7.5, 11.5 years)
- USPTO template generator (5 types)
- CSV bulk import/export
- Patent detail view
- Deadline alerts (critical, warning, info)
- LocalStorage persistence

### 🚧 In Progress
- Alert notifications
- Document library UI

## Usage

1. Open `ip-mission-control.html` in browser
2. Add patents via "+ Add Patent" button
3. Import via CSV for bulk loading
4. Track costs and deadlines
5. Generate USPTO templates
6. Export portfolio

## Data Model

```json
{
  "patents": [...],
  "deadlines": [...],
  "documents": [...],
  "costs": [...],
  "settings": {...}
}
```

## Cost Categories

- `filing` - USPTO filing fees
- `attorney` - Attorney/legal fees
- `maintenance` - Maintenance fees
- `drawing` - Drawing preparation
- `search` - Prior art searches
- `office-action` - Response costs
- `other` - Miscellaneous

## USPTO Fees (2024-2025)

- Provisional: $280
- Utility (full): $4,580
- Maintenance 1: $2,000
- Maintenance 2: $3,760
- Maintenance 3: $7,850
