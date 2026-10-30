# 01: A grown-up setting for how much energy a slow Rest answer gives

**What to build:** In ⚙️ Settings → grown-up settings the parent sets how much energy a slow right Rest answer gives, in percent of a quick one (steps of 10 %, 0–100 %). The default drops from 50 % to **20 %**. The child sees no change apart from the smaller gain.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

**Milestone:** prototype

- [ ] The grown-up settings show the share with ➖ / ➕, like the review share, and say what it means in one plain line
- [ ] Default 20 % for new farms; old saves load and get 20 % unless the parent has changed it
- [ ] Kept per farm (like the review share), saved and loaded
- [ ] Rest gives exactly that share for a slow right answer (a test checks 0 %, 20 % and 100 %)
- [ ] German through `i18n.py`; smoke test passes
- [ ] The bot plays with the new default; full golden runs re-saved on purpose and the pace change written in the log
- [ ] `docs/design/rest.md` and `docs/design/learning-record.md` describe the setting

---
Parent, 30 Oct 2026 (review pass, round 2; `assumptions/02`). Today the share is a fixed number in the game's settings data (0.5).
