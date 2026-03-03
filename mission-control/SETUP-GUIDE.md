# Mission Control + Convex + Obsidian Setup Guide

## 🚀 Overview

Mission Control now supports 3-way sync:

1. **LocalStorage** - Local browser storage (always available)
2. **Convex** - Real-time cloud database (sync across devices, team collab)
3. **Obsidian + Google Drive** - Markdown files in your vault (offline, portable)

---

## 📋 Prerequisites

- ✅ Mission Control v2 installed
- ✅ Convex account (free tier)
- ✅ Google Drive (for Obsidian sync)
- ✅ Obsidian installed (optional, but recommended)

---

## 🔧 Part 1: Convex Setup

### Step 1: Create Convex Account

1. Go to [convex.dev](https://convex.dev)
2. Sign up for free account
3. Create new project: "mission-control"

### Step 2: Install Convex CLI

```bash
cd ~/.openclaw/workspace/mission-control
npm install convex
```

### Step 3: Initialize Convex

```bash
npx convex dev
```

This will:
- Create `convex/` folder
- Generate `convex/_generated/api.js`
- Deploy your schema and functions

### Step 4: Get Your Convex URL

After running `npx convex dev`, you'll see:

```
Convex deployment ready: https://your-deployment.convex.cloud
```

Copy this URL - you'll need it for the app.

### Step 5: Update Mission Control

Add Convex to `index.html`:

```html
<script src="https://unpkg.com/convex@latest/dist/browser.bundle.js"></script>
<script src="lib/sync.js"></script>
<script src="lib/obsidian-sync.js"></script>
```

Initialize in `app.js`:

```javascript
// At the top of app.js
const sync = new MissionControlSync();

// Initialize Convex (replace with your URL)
const convex = new Convex.ConvexClient("https://your-deployment.convex.cloud");
sync.initConvex(convex);
```

---

## 📁 Part 2: Obsidian + Google Drive Setup

### Step 1: Create Vault in Google Drive

**Free sync via Google Drive (no Obsidian Sync needed!)**

1. Create folder: `Google Drive/Obsidian/Mission Control`
2. Open Obsidian → "Open folder as vault"
3. Select that folder
4. Done! Google Drive syncs automatically (free)

### How It Works

Obsidian is just markdown files in folders. Google Drive syncs those files:

```
Mission Control (browser)
        ↓
   Export markdown
        ↓
~/Google Drive/Obsidian/Mission Control/
        ↓
   Google Drive sync (free, automatic)
        ↓
   Available on all devices
        ↓
   Open in Obsidian (desktop/mobile)
```

**Zero cost.** Google Drive free tier = 15GB (plenty for markdown).

### Step 2: Configure Path

```javascript
// In browser console or app settings
sync.setObsidianPath('~/Google Drive/Obsidian/Mission Control');
```

### Step 3: Sync

Click "🔄 Sync" button or:

```javascript
await sync.syncToObsidian(state);
```

This exports all your Mission Control data as markdown files in that folder. Google Drive syncs them automatically. Open on any device with Obsidian.

### What Gets Exported

```
Mission Control/
├── Projects/
│   ├── Projects Overview.md
│   └── [Project Name].md
├── Ideas/
│   └── Ideas Overview.md
├── Domains/
│   └── Domain Portfolio.md
├── Agents/
│   └── Agent Registry.md
├── Tasks/
│   └── Tasks.md
├── Daily Notes/
│   └── 2025-01-21.md
└── Mission Control State.md
```

All standard markdown. Editable anywhere. Synced via Google Drive (free).

---

## 🔄 Part 3: How Sync Works

### Data Flow

```
┌─────────────┐
│   Mission   │
│  Control    │
│  (Browser)  │
└──────┬──────┘
       │
       ├──────► LocalStorage (always)
       │
       ├──────► Convex (if online)
       │         ↓
       │    Real-time sync
       │         ↓
       │    Multiple devices
       │
       └──────► Obsidian (local)
                 ↓
            Google Drive
                 ↓
            All your devices
```

### Sync Triggers

- **Auto-sync:** Every 5 minutes (when online)
- **Manual sync:** Click "Sync" button
- **On change:** Debounced sync after edits
- **Offline:** Queued, synced when back online

### Conflict Resolution

- **Convex wins:** Remote changes take priority
- **Merge:** Arrays are merged (not replaced)
- **Timestamp:** Last update wins for single fields

---

## 💾 Part 4: Export/Import

### Export All Data

```javascript
// In browser console
const exports = await sync.exportAllFormats();
console.log(exports);

// Download JSON backup
const blob = new Blob([exports.json], { type: 'application/json' });
const url = URL.createObjectURL(blob);
const a = document.createElement('a');
a.href = url;
a.download = 'mission-control-backup.json';
a.click();

// Download Obsidian vault
const vaultFiles = exports.obsidian;
// ... create zip and download
```

### Import Data

1. **From JSON:** Use "Import" button in dashboard
2. **From Obsidian:** Manual copy/paste or file upload
3. **From GitHub:** Already synced via Convex

---

## 🎯 Part 5: Usage

### Check Sync Status

```javascript
sync.getSyncStatus();
// Returns:
// {
//   convex: "connected",
//   obsidian: "ready",
//   online: true,
//   lastSync: 1703275200000,
//   userId: "user_123abc"
// }
```

### Force Full Sync

```javascript
await sync.forceSyncAll();
```

### Set Obsidian Path

```javascript
sync.setObsidianPath('~/Google Drive/Obsidian/My Vault');
```

---

## 🔐 Part 6: Security & Privacy

### What's Stored Where

| Data | LocalStorage | Convex | Obsidian | Google Drive |
|------|-------------|--------|----------|--------------|
| Repos | ✅ | ✅ | ✅ | ✅ (via Obsidian) |
| Domains | ✅ | ✅ | ✅ | ✅ (via Obsidian) |
| Ideas | ✅ | ✅ | ✅ | ✅ (via Obsidian) |
| Tasks | ✅ | ✅ | ✅ | ✅ (via Obsidian) |
| Agents | ✅ | ✅ | ✅ | ✅ (via Obsidian) |

### Convex Security

- ✅ Encrypted at rest
- ✅ Encrypted in transit
- ✅ Row-level security (your data only)
- ✅ No public exposure

### Google Drive Security

- ✅ Your Google account security
- ✅ 2FA supported
- ✅ Private by default

---

## 🚨 Troubleshooting

### Convex Won't Connect

1. Check deployment URL is correct
2. Run `npx convex dev` to ensure backend is running
3. Check browser console for errors

### Obsidian Not Syncing

1. Check vault path is correct
2. Ensure Google Drive is running
3. Check Obsidian is pointing to Google Drive folder

### Data Not Syncing

1. Check sync status: `sync.getSyncStatus()`
2. Force sync: `sync.forceSyncAll()`
3. Check browser console for errors

### localStorage Full

1. Export data: `exportData()`
2. Clear old data
3. Import from backup

---

## 📚 Additional Resources

- [Convex Documentation](https://docs.convex.dev)
- [Obsidian Documentation](https://help.obsidian.md)
- [Google Drive Setup](https://support.google.com/drive)

---

## ✅ Checklist

Setup complete when:

- [ ] Convex CLI installed
- [ ] Convex project created
- [ ] Schema deployed
- [ ] Convex client initialized in app
- [ ] Obsidian vault created in Google Drive
- [ ] Obsidian path configured
- [ ] First sync successful
- [ ] Export/import tested

---

## 🎉 Benefits

With this setup, you get:

✅ **Real-time sync** across all devices  
✅ **Team collaboration** (add users to Convex project)  
✅ **Offline access** via localStorage + Obsidian  
✅ **Portable data** in markdown format  
✅ **Automatic backups** via Google Drive  
✅ **Jarvis can update it** from anywhere  
✅ **Mobile access** via Obsidian mobile app  

---

**Your Mission Control is now a living system that syncs everywhere.** 🚀
