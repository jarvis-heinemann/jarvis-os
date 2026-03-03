# Obsidian Integration — Mission Control

This folder contains templates and structures for your Obsidian vaults.

## Structure

```
obsidian/
├── templates/           # Reusable templates
│   ├── project.md      # New project template
│   ├── mvu.md          # Minimum Viable Universe spec
│   ├── core-loop.md    # Core loop definition
│   └── entity.md       # LLC/Corp/Agent template
├── entities/            # Entity definitions
│   ├── llc-template.md
│   ├── domain-template.md
│   └── agent-template.md
└── projects/            # Project documentation
```

## How to Use

### 1. Link Your Existing Vaults

Your 5,000+ research reports and multiple vaults should be organized as:
- **Master Vault** — Aggregates everything
- **Domain Vault** — 600+ domains with metadata
- **Research Vault** — 5,000+ reports, categorized
- **Entity Vault** — LLCs, INCs, properties, accounts
- **Project Vaults** — One per active universe

### 2. Use Templates

When starting a new project:
1. Copy `templates/project.md` to your project vault
2. Fill in the core loop, MVU, and dependencies
3. Link back to Mission Control dashboard

### 3. Dataview Queries

Use Dataview plugin to create dynamic views:
- Active projects table
- Domain portfolio by status
- Agent deployment status
- Revenue by project

---

See individual template files for usage.
