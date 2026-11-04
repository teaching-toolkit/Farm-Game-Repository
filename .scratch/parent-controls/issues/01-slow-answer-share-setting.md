# 01: A grown-up setting for how much energy a slow Rest answer gives

**What to build:** In ⚙️ Settings → grown-up settings the parent sets how much energy a slow right Rest answer gives, in percent of a quick one (steps of 10 %, 0–100 %). The default drops from 50 % to **20 %**. The child sees no change apart from the smaller gain.

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The grown-up settings show the share with ➖ / ➕, like the review share, and say what it means in one plain line
- [x] Default 20 % for new farms; old saves load and get 20 % unless the parent has changed it
- [x] Kept per farm (like the review share), saved and loaded
- [x] Rest gives exactly that share for a slow right answer (a test checks 0 %, 20 % and 100 %)
- [x] German through `i18n.py`; smoke test passes
- [x] The bot plays with the new default; full golden runs re-saved on purpose and the pace change written in the log
- [x] `docs/design/rest.md` and `docs/design/learning-record.md` describe the setting

---
Parent, 30 Oct 2026 (review pass, round 2; `assumptions/02`). Today the share is a fixed number in the game's settings data (0.5).

## Result (3 Nov 2026)

- **Built:** ⚙️ Settings → grown-up settings has a card "⚡ Energy for a slow right sum" with ➖ / ➕ and a bar (10 % steps, 0–100 %) and one plain line under it. The share lives per farm in the save key `rest_slow_share` (written only when the parent changes it; owner `G.needs.slow_share()` / `set_slow_share()`); without the key the farm follows `restSlowShare` in `data/settings.json`, now **0.2** (was 0.5). Old saves therefore get 20 % unless the parent changed it. The Rest line after a slow answer now says "⚡ +1 (a bit slow)" (no longer "half"); the number shows the gain.
- **Agent's choices:** the key is optional like `review_share` (no `save_defaults` entry, no `SAVE_VERSION` step, so the new-game state is unchanged); amber bar colour.
- **Checked:** the smoke test checks the share: default 0.20; slow answers at 0 / 20 / 100 % give 0 / 1 / 5 energy against 5 for a quick one; 0.34 snaps to 0.30. All unit tests pass; i18n --check 0; screenshots of the grown-up settings in EN and DE.
- **Bot and golden runs:** the bot answers every Rest sum quickly (`G.needs.rest_correct()`), so the new default does not touch its pace: short golden runs identical (332 and 525 steps). The full runs were recorded later together with skills-quality/03 and crops-and-items/02 (see those tickets); this ticket alone changes nothing in them.
- **Play-test:** whether 20 % feels fair to the child when the timer runs out (a slow right sum gives ⚡ +1 instead of +2.5).
