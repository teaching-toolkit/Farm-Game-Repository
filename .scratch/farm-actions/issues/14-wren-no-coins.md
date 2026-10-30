# 14: Wren stops asking for coins

**What to build:** Content change after the refactor. Wren never asks for coins. She may ask for something that takes energy, time or water, or something the player can craft or cook at any time without coins. The parent decides what she asks for instead; the coin option leaves her check.

**Blocked by:** farm-actions/13

**Status:** ready-for-agent

**Milestone:** refactor

- [x] The parent has said what Wren asks for instead of coins (a 💡 recommendation is written in this ticket first)
- [ ] Her favour never asks for coins; no path asks for coins without the Lord's-share rule
- [ ] Her story texts (English and German) match
- [ ] Full golden runs are re-saved on purpose and the change is explained in the log

## 💡 Recommendation (30 Oct 2026)

Wren takes the cheapest dish or remedy from the store, as now. **If there is none, she asks you to fetch her a bucket of water**
(a chore: energy and water, through the actions module). If you can't do that either, she checks the basket for free today. She
never asks for coins, and the child is never stuck.

Other options: (b) only a chore, never an item: simpler, but it loses the nice "she takes a dish" moment; (c) she always checks for
free: simplest, but the plant check stops costing anything, and the poisoning (ADR-0004) loses its point.

## ✅ Parent's answer (30 Oct 2026)

Yes, with one change: **what she asks for is worth about 30 coins** (it need not be exact). So she takes the dish or remedy whose
value is closest to about 30 coins (several cheap ones together are fine), not simply the cheapest. If there is none, she asks for a
chore of about that worth (fetching her water); if that can't be done either, she checks for free. Never coins.

---

**Feature:** `farm-actions` · **Source:** `.scratch/farm-actions/spec.md` in this folder and the decisions in `.scratch/farm-actions/issues/01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
