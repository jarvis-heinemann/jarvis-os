# Mission Control v2 — Quick Reference

## 🆕 New Features

### 📦 GitHub Integration
- Track your repos (1,800+)
- Link repos to projects
- Visual status indicators
- **Add:** Click "+ Add Repo" in GitHub panel

### 🌐 Domain Portfolio
- Manage 600+ domains
- Filter by status (Active/Parked/For Sale)
- Track by project
- **Add:** Click "+ Add Domain" in Domains panel

### 🤖 Agent Registry
- Register 3,000+ agents
- Track by type (research/content/ops/monitor/integration)
- Monitor activity
- **Add:** Click "+ Register Agent" in Agents panel

### 💾 Export/Import
- **Export:** Backup all data to JSON
- **Import:** Restore from backup
- **Location:** Bottom-right floating buttons

### 🔍 Global Search
- Search across all data
- **Shortcut:** `⌘K` (Mac) / `Ctrl+K` (Windows)

---

## ⌨️ Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `⌘K` | Focus search |
| `⌘N` | New idea |
| `⌘1` | Focus Mode |
| `⌘2` | Idea Vault |
| `⌘3` | Projects |
| `⌘4` | Delegation Hub |
| `⌘5` | Automation |
| `⌘6` | Metrics |
| `⌘7` | Library |
| `⌘8` | Vision Room |

---

## 📊 Data Structure

All data stored in localStorage. Export regularly!

```json
{
  "flagship": "Project Name",
  "ideas": [...],
  "projects": [...],
  "repos": [...],
  "domains": [...],
  "agents": [...],
  "tasks": [...],
  "activeSeed": {...},
  "todayTask": {...},
  "completed": [...],
  "energy": [...]
}
```

---

## 🎯 Daily Workflow (Enhanced)

### Morning
1. Open Mission Control
2. Check Focus Mode → Review flagship, seed, today's task
3. Check GitHub panel → See repo activity
4. Check Domains → Review any renewals

### Throughout Day
5. Capture ideas → `⌘N` or Idea Vault
6. Delegate tasks → Delegation Hub
7. Register new agents → Agents panel
8. Add new domains → Domains panel

### Evening
9. Export data → 💾 button (backup)
10. Review metrics

---

## 🔄 Coming in v3

- [ ] Auto GitHub API sync
- [ ] Real-time agent monitoring
- [ ] Calendar integration
- [ ] Email scanning
- [ ] Priority decay visualization
- [ ] Mobile companion app

---

## 🐛 Known Issues

- Domains need manual entry (no whois API yet)
- Repos need manual entry (no GitHub API yet)
- Agents need manual entry (no agent API yet)
- Search is basic (full-text search coming)

---

## 📝 Tips

1. **Export weekly** — Don't lose your data
2. **Link everything** — Connect repos/domains/agents to projects
3. **Review domains monthly** — Check renewals, update status
4. **Archive old agents** — Keep registry clean
5. **Use keyboard shortcuts** — Faster navigation

---

**Version:** 2.0
**Last Updated:** 2025-01-21
