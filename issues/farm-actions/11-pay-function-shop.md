# 11: One pay function: shop purchases

**What to build:** Every coin payment follows one rule through one pay function: blocked while the Lord's share is owed, the coins fly to the payee, and the payment of the share itself is exempt. Shop purchases (the trade system) are the first to use it.

**Blocked by:** farm-actions/03

**Status:** done

- [x] Shop purchases use the pay function; the trade system no longer checks the Lord's share itself
- [x] The `paid` signal comes from the pay function
- [x] The Lord's share payment is exempt from the block
- [x] A test covers: owed share blocks a purchase with the right reason key; paid share lets it through
- [x] Wren's favour is not changed here
- [x] The full golden runs (seeds 1 and 2, to chapter 6) are identical
- [x] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

## Progress

Built 24 Oct 2026. `G.lord.pay_coins(amount, exempt := false)` (in `lord.gd`, the system that owns the rule) is the one way coins leave the purse: returns `""` when paid, else the reason key `lord` (share owed) or `coins` (short, same 0.0001 slack as before); it takes the coins and fires `G.paid` once. It says nothing; the caller words the refusal. `trade.gd` has a small `_pay` that words it and `buy_seeds` / `buy_item` use it (same sentences, same order: room first, then the Lord, then coins). `Lord.pay` (the share) calls it with `exempt = true`. Pace's `missing_cost`/`pay` (goals and buildings) and Wren's coin favour are untouched: ticket 12 and later. Test: `_pay_function` in `actions_test` (owed share blocks with `lord`, too few coins `coins`, no signal on a refusal, exempt share payment, a shop purchase refused, `paid` once per payment).

---

**Feature:** `farm-actions` · **Source:** `spec.md` in this folder and the decisions in `01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
