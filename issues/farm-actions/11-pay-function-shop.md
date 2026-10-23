# 11: One pay function: shop purchases

**What to build:** Every coin payment follows one rule through one pay function: blocked while the Lord's share is owed, the coins fly to the payee, and the payment of the share itself is exempt. Shop purchases (the trade system) are the first to use it.

**Blocked by:** farm-actions/03

**Status:** ready-for-agent

- [ ] Shop purchases use the pay function; the trade system no longer checks the Lord's share itself
- [ ] The `paid` signal comes from the pay function
- [ ] The Lord's share payment is exempt from the block
- [ ] A test covers: owed share blocks a purchase with the right reason key; paid share lets it through
- [ ] Wren's favour is not changed here
- [ ] The full golden runs (seeds 1 and 2, to chapter 6) are identical
- [ ] `tests/check_all.sh` passes, the short golden runs (seeds 1 and 2, to chapter 2) are identical, and old saves load

---

**Feature:** `farm-actions` · **Source:** `spec.md` in this folder and the decisions in `01-grill-and-spec.md`. Filed 23 October 2026. Words: `GLOSSARY.md`. This slice changes no game rule unless the ticket says so.
