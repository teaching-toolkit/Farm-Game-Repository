# Game hooks: what the story needs from the game, and the reverse

A running list. Nothing here is built yet. Before anything is built, the parent decides. Labels: ✅ decided · 💡 proposed · ❓ open.

## 1. Decided by the parent ✅

- **Six chapters, six magical pets.** A **medicine chapter** goes between the current chapters 4 and 5; its pet is the
  **badger**. The Master Farm stays last. (So chapters become: 1 Ashes · 2 Homestead · 3 Smallholding · 4 Village Trade ·
  **5 Medicine** · 6 Master Farm.)
- **Pets do real jobs.** Not only a small perk: automation, simple loops, if-then tasks, in the spirit of Factorio. Magical
  animals are clever, so we can think outside the box.
- **The forest is a separate screen in the medicine chapter.** Tapping the forest edge on the farm offers *Enter*. In the forest
  the player walks around and does different tasks (a mini-game), including finding the right plants.
- **Time still works as everywhere:** going into the forest and coming out each cost one unit of time (one Time Quiz question);
  cooking and potion-making at the farm take time; vials and equipment cost coins, so the player still farms, which advances time
  too. Energy still comes from Rest.
- **Medicine content:** real plants of European woods and fields, processed into real kinds of medicine, with simplified recipes
  and approximate real knowledge.
- **Story UI:** story texts pop up **between goals and achievements and when the player first meets a problem** (message board, a
  patch of stumps); a **📜 story scroll** in the top right replaces the 🎒 backpack and holds every story seen, for re-reading.

## 2. Proposals 💡 (for Round 4; now worked out in `game-design-round4.md`, which wins where they differ)

### Pets as helpers
- **Rule: learning stays the economy.** Pets act on each Time Quiz step (one "tick" per right answer), so automation never
  bypasses the quiz. A pet does nothing while the child is not playing.
- **A small rule language:** WHEN (a thing is true) → DO (a job), with a few slots per pet that open as the chapters go. Start
  with one fixed job per pet, then let the child choose between two or three, then let them pick the trigger.
- **Rough domains:** bunny: weeds and clover (soil). Tortoise: water. Goat: scrub, compost, brambles. Pony: carrying and selling.
  Badger: medicine (collecting, drying, mixing). Alpaca: guarding (pests) and wool.
- **Open:** how many slots, how the child sees them (cards on a board?), how to tell the child why a pet did not act.

### The forest screen
- One walkable screen; spots with tasks (find, dig, pick, carefully); a limit of what can be carried; one tick in, one tick out.
- **Safety framing:** plants are learnt as *knowledge cards* and as a "find the right one, not its look-alike" game; never a
  recipe the child could act on at home without a grown-up; a line in the game says so.
- All plant facts to be **checked against sources** and **reviewed by the parent** before shipping.

### Medicine stations
- Drying rack, mortar, tincture jar, still (glass kiln is chapter 4, so vials and glass are available), salve pot, press.
- The sixth pet returns when the player can make *really good* medicine (a quality bar of a few ingredients, not luck).

### The village strand (decided: Fenna reconnects with Hazelwood through her dishes) ✅ idea, 💡 mechanics
- The game already works this way: `delivery` nodes (18) open the merchants (14) and the Harvest Fair ribbons, favours (28) are
  requests from neighbours, the notice board carries little jobs. The story only has to **give those moments faces and memory**.
- Story boxes after a delivery: who ate it, what they remembered about the girl or the farm. First boxes cautious, later warm.
- The favour-givers become **half-remembered faces** (re-cast in Round 3/6). A friend's postcard can come from someone who
  moved away too.
- Possible small mechanic (❓ later): a "who has tasted your cooking" list in the album (the people she has reconnected with).

### Ruins and clues (checked 7 Oct 2026 against `farm-progression.json`)
- Ruins now: ch 1 `ruins_workshop`; ch 2 `ruins_lumber`, `ruins_barn`, `ruins_compost`; ch 3 `ruins_windmill`; ch 4 `ruins_greenhouse`.
  **Nothing in the old chapter 5**: it only has land clearings (`orchard_2`, `river_meadow_drain`).
- Needed: a new ruin for the medicine chapter (💡 the still-room, `ruins_stillroom`); chapter 6 can use `river_meadow_drain` as its
  clue site. When chapters are renumbered (old 5 becomes 6), these nodes' `chapter` values move too.
- The barn is rebuilt in chapter 2 (`barn_1`–`barn_3`), so nothing hidden can stay "where the barn stood".

### Found in the critical pass (7 Oct 2026) 💡
- **Start texts:** `_show_welcome` says "Your farm burned down. All that's left: a tent, an old bucket …, one wheat seed — and a box with
  a book in it", and `well_1` says "All that is left: a small dented bucket". The story now has the bucket, pot and book come in Berit's
  box, and the seed found on the one live patch. Both texts get rewritten in Round 7.
- **Mumyo glimpses:** some story pictures (about one per chapter) show Mumyo half-hidden; the art list must say so, and Fenna looks away.
- **Mumyo's pranks never cost the player anything** (moved, never lost). If a prank is shown on the map (sticks in a silly pile, the
  scarecrow in a hat), it is decoration only.
- **Favours:** two favours (`sq_healer_garden`, `sq_lamp_maker`) could move into the medicine chapter so it has its own (Round 4).
- **Import Broker:** opens with the 4th pet (pony) today. With the medicine chapter inserted, it comes in chapter 5 or 6 (Round 4).
- **Letters from home:** 💡 a letter from Fenna's mother about once a chapter, brought by the barge. A story box, no mechanic.

## 3. Where the code and data will change (so far)

- `data/farm-progression.json`: `chapters` goes from 5 to 6; a new pet node (`pet_badger`); about 70–100 new nodes (medicine
  chapter); sidequest names and blurbs; chapter numbers of later nodes shift.
- `scripts/game.gd`: pet lists are hard-coded (lines near 363 and 1907: `pet_bunny … pet_alpaca`); a pet-automation tick.
- `scripts/main.gd`: the top-right row (`_open_pantry` → story scroll), `_show_welcome` (the start story), `_on_patch` and
  `_part_patch_note` (first-tap problem stories), the new forest screen.
- New: `data/story.json`, `scripts/story.gd`, `assets/story/`, `data/i18n/story-de.json`.
- Tests: the bot needs to dismiss story boxes; the smoke test opens the scroll; a check that every story trigger exists.
- Docs: design document (after decisions, marked *(planned)*), progression explorer data.

## 3b. Changes the story now asks of the data (8 Oct 2026)
- `sq_chapel_roof` "Fix the chapel roof" → **"Fix the village hall roof"** (✅ no religion); its English and German texts and the album
  picture prompt ("waving from the dry chapel") change too. The only religious word found in the data (checked 8 Oct 2026).
- Every player-facing story text in second person with `{player}`; check existing texts (welcome, postcards) for "she/he" or gendered German.
- How story pieces reach the player: see `story-delivery.md` (supersedes §4 below where they differ).

## 3c. From the outline (Round 5, 8 Oct 2026) 💡
- `pet_tortoise` to require `pond`; `pet_alpaca` to require `river_meadow_drain` (so those beats cannot be missed). Re-run the explorer.
- Triggers needed: `chapter:<n>` (chapter start), `step>=1` (first night), first forest trip, `seen:<id>` chains.

## 4. From the first story plan (archive/STORY-PLAN-v0.md) that still holds

- The 📜 scroll interface: the top-right icon with a gold dot for new stories; tabs by chapter; locked entries show "?" and never
  spoil; the pantry moves to the stock display and Settings.
- Story boxes: picture on top (emoji until it exists), a speaker name, 2–4 short sentences, one big button; one at a time;
  not during the Time Quiz or Rest; waits behind celebrations.
- First-tap problem stories: message board, thistles, weeds, rocks, stumps, scrub, marsh, wild pond, ruins, mystery sign, pests,
  winter, stale food. **The texts must be rewritten** for the new setting (Hazelwood in the Grandmother's time; no Minena; the
  magpie is no longer in the normal world, so pests become ordinary birds).
- Data-driven triggers: `start`, `node_done:<id>`, `tap:<spot>`, `tap_patch:<kind>`, `chapter:<n>`, `first:<event>`.

## 5. Not carried over
The first plan's cast and beats (Minena as farmer, Mara as the pests' face, the five notes of the melody) are superseded.
