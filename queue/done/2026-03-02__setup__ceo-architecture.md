---
task_id: 2026-03-02__setup__ceo-architecture
owner: ceo
worker: ops
priority: P0
budget: "max 30 minutes"
---

## Objective
Initialize the CEO/worker architecture by setting up the queue system and confirming all agents have their files in place.

## Definition of Done
- [ ] STATUS.md updated with initial queue counts
- [ ] Each agent folder confirmed readable
- [ ] First heartbeat run completed

## Inputs
- agents/*/SOUL.md (all agents)
- queue/todo/ (this file)

## Output Contract
- Update: STATUS.md with initial state
- Write: handoffs/ops/2026-03-02__setup__ceo-architecture.md with confirmation

## Validation Steps
1) Count files in each queue folder
2) Verify all 6 agent directories exist with SOUL.md
3) Run ops heartbeat checklist
