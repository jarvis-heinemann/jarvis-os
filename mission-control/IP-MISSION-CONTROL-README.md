# IP Mission Control - Patent Portfolio Manager

## Overview

A complete patent portfolio management system for tracking provisionals, continuations, deadlines, and documentation.

## Files Created

| File | Purpose |
|------|---------|
| `ip-mission-control.html` | Dashboard UI (6 panels) |
| `ip-mission-control.js` | Application logic |
| `ip-portfolio-template.json` | Data model schema |

## Features Built (Sprint 1)

### Dashboard
- **Stats cards:** Total patents, provisionals, continuations, granted
- **Deadline timeline:** 90-day view with urgency indicators (red = <30 days, yellow = <60 days)
- **Recent patents:** Quick overview of portfolio

### Provisionals Panel
- List all provisional applications
- **12-month deadline calculation** (continuation due date)
- Status tracking (draft, filed, pending, granted, abandoned)
- Visual urgency indicators

### Continuations Panel
- Track continuation applications
- Link to parent provisional
- Status management

### Deadlines Panel
- Consolidated deadline calendar
- Filter by type (continuation, maintenance fee, office action)
- Days remaining calculation

### Documents Panel
- Document library (ready for claims, drawings, specs)
- Upload/link functionality (TODO)

### Analytics Panel
- Portfolio value estimation
- Average time to grant
- Maintenance fees due
- Geographic coverage

## Data Model

```javascript
{
  patents: [{
    id: string,
    title: string,
    type: 'provisional' | 'continuation' | 'utility' | 'design',
    filingDate: date,
    applicationNumber: string,
    status: 'draft' | 'filed' | 'pending' | 'granted' | 'abandoned',
    description: string,
    inventors: string[],
    category: string,
    priority: 'low' | 'medium' | 'high',
    continuationDue: date,
    createdAt: timestamp,
    updatedAt: timestamp
  }],
  deadlines: [{
    id: string,
    type: 'continuation-due' | 'maintenance-fee' | 'office-action',
    date: date,
    label: string,
    patentId: string,
    status: 'pending' | 'completed'
  }],
  documents: [],
  settings: {
    defaultJurisdiction: 'US',
    maintenanceFeeSchedule: [3.5, 7.5, 11.5],
    continuationWindow: 12,
    alertDaysBefore: [90, 60, 30, 14, 7]
  }
}
```

## Next Steps (Sprint 2)

1. **Continuation Pipeline**
   - Auto-generate continuation from provisional
   - Copy claims/drawings
   - Calculate filing deadline

2. **Deadline Engine**
   - USPTO maintenance fee schedule (3.5, 7.5, 11.5 years)
   - Office action response windows
   - Email/alert notifications

3. **Document Generator**
   - USPTO-ready templates
   - Claims formatting
   - Drawing sheet preparation

4. **Import Function**
   - Load Gabriel's patent list
   - Parse from CSV/Excel
   - Bulk deadline calculation

## Launch

Open `ip-mission-control.html` in a browser to use.

## Technical Notes

- Data stored in localStorage (can upgrade to Convex later)
- Pure HTML/CSS/JS (no dependencies)
- Mobile-responsive design
- Dark theme (Mission Control style)
