# 01: U2: Seed saving for carrots, onions and beets (plants that flower in their second year)

**What to build:** The child can leave a carrot, onion or beet in the ground through one winter, and in spring it gives a lot of seed. Meanwhile the patch grows nothing else. The way is learned from the card *Saving seed* first. Grains already work (the harvest is the seed). Nothing for this exists in the data yet.

**Blocked by:** None (can start immediately)

**Status:** ready-for-agent

**Milestone:** prototype

- [ ] The parent looked for the flowering option on carrots and found none ([#23.16]): that is right, it is not built yet; the first visible sign is the "let it flower" choice on a two-year crop's patch
- [ ] A short plan is written into this ticket first (goal, files, saves, what the bot must learn, how it is checked; session skill §3)
- [ ] A planted two-year crop can be marked to go to seed, stays through one winter, and gives seed in spring; the patch is blocked meanwhile
- [ ] It needs the *Saving seed* card to be read first
- [ ] Seeds of every unlocked crop can still be bought
- [ ] Old saves load (new key in `save_defaults()`; a `SAVE_VERSION` step if a layout changes)
- [ ] The bot learns it; golden runs identical or re-recorded on purpose
- [ ] German through `tools/i18n.py`

---

**Id:** U2 · **Feature:** `crops-and-items` · **Moved from** `archive/todo-2026-10.md` §6 on 23 October 2026; the notes below are unchanged. Status labels in them (✅ 💡 ❓) are notes, not the status above.

## Original notes

- **U2. Seeds from your own harvest** ✅ (R2, R3, R4):
  - The harvested **grain is the seed** (wheat, oats, beans, peas …): one item you can plant, mill or cook. No conversion step. Medieval
    fields gave about 3–5 grains back per grain sown, so about 5 is honest (an ear has 30–50 grains).
  - **Every crop can make its own seed.** Carrots, onions, beets and other biennials only flower in their second year: a plant left to
    seed must **stay in the ground through one winter**, then gives a lot of seed in spring. Meanwhile the patch grows nothing else.
  - Each way of making seed is **learned from a knowledge card** first (K4).
  - **Seeds of every unlocked crop can always be bought**; buying is mostly for starting a new crop.
  - The **Seed Library** (chapter 5) keeps only its heirloom role. Data: seeds are a separate count today (`S["seeds"]`); grains become
    plantable items; the others get seed items.
