# HEARTBEAT.md (Ops)

## Ops Heartbeat Checklist
Run each item once, then stop.

1) **Queue counts:**
   - Count files in queue/todo, doing, blocked, done (last 24h)
   - Update STATUS.md snapshot

2) **Stuck work detection:**
   - Any task in queue/doing older than 90 minutes → move to queue/blocked with a BLOCKED note and suggested next steps.

3) **Handoff freshness:**
   - If researcher exists: ensure intel/DAILY-INTEL.md updated within 24h (or note stale)

4) **Crash signals:**
   - If you see repeated identical failures in logs/summaries, record in STATUS.md "Alert".

5) **End:**
   - Write "last check" timestamp in STATUS.md
