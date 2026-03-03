# VIBE CODING SOP (Grown-Up)

## Beginner Failure Mode
Prompt → build immediately → AI slob → endless debugging.

## The Real Workflow
1) Setup preferences + memory + rules first (SOUL/AGENTS/MEMORY/FEEDBACK)
2) Add skills + connectors/MCP servers
3) Test agent on small tasks; fix rules and handoffs
4) Only then: choose what to build
5) Brainstorm in Claude/Cursor: clarify scope + constraints
6) Generate PRD (problem, users, flows, requirements, non-goals)
7) Plan build (milestones + tasks)
8) Delegate tasks to worker agents (one task each)
9) Build MVP to ~70% functionality
10) Harden: tests, edge cases, logging, UX polish

## Quality Gate
If output is "blobby" or generic, don't debug code first. Fix: requirements, file context, examples, banned patterns, and task briefs.
