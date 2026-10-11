# To-do list — Farm Quiz Game

The project's to-do list and plan. Moved out of `00-READ-ME-FIRST.md` §6 on **9 October 2026**; finished tasks live in
`PROJECT-LOG.md`, not here. **Last updated: 9 October 2026** (the parent's notes of 9 Oct sorted in; nothing built yet).

**Standing rule** (from `00-READ-ME-FIRST.md`): keep this file current *as you work*. Tick off or remove done tasks (and add a
row to `PROJECT-LOG.md`), add new ones, reword changed ones. A task that is not written here does not exist for the next chat.

**Labels** (as in `story/`): ✅ decided by the parent · 💡 proposed by Claude · ❓ open question · ⚠️ a clash with an existing rule,
decision or file · 🔗 depends on / ties in with.
**Sources:** `[#1]`…`[#16]` (game) and `[#S1]`…`[#S8]` (story) are the paragraphs of the parent's notes of 9 Oct 2026, kept word for
word in `planning/2026-10-09-parent-notes.md`. Older tasks keep their old ids (W1, H1, I5 …); the old "Later" list is now Z1–Z7.

---

## 0. The plan at a glance 💡

Proposed order. Each step lists what must be settled first. Nothing here is fixed; the parent re-orders as wanted.

| Step | What | Tasks | Waits for |
|---|---|---|---|
| 0 | Housekeeping: this file, the log, the notes sorted | done 9 Oct 2026 | – |
| 1 | **The parent:** pictures, play-test, checks, the decision queue, the curriculum list | W1–W7, §2 | – |
| 2 | **Small fixes the child will notice** (each on its own, then one web build to test) | J1–J7 | Q-J1, Q-J2 for J2/J6 |
| 3 | **Story Round 5 answers and Round 6 "loop back"**, now also covering the new systems (village and market, wellbeing, nature, epilogue, opening panels, picture rules, title) — on paper | I5, I6, I9–I13 | the parent's answers |
| 4 | **Foundations in the code:** what unlocks when (with frozen hidden numbers), item weight/bulk, the economy pass and coin kinds | O1–O3, M1–M4 | step 3 for the story reasons; Q-M decisions |
| 5 | **Story engine + chapter 1 texts** (panels, 📜 scroll, bubbles, frame) | I7, I8a, I9 | step 3 |
| 6 | **Market trips, merchants who visit, people as avatars, coin animations** | M5–M10, P1, M3 | step 4 |
| 7 | **Six chapters in the data; pets visible and job board level 1–2** | S1, S2 | step 5 |
| 8 | **Wellbeing and the energy model**, with its books and cards | L1–L7, K4 | O1–O3; Q-L decisions |
| 9 | **Nature and sustainability** | N1–N5 | O1–O3; Q-N decisions |
| 10 | **Medicine chapter and the forest screen** | S3, S4 | steps 7–9 (they share the energy, carrying and nature rules) |
| 11 | **Epilogue; pets' job board level 3–4** | I10, S5 | step 10 |
| always | **Curriculum:** map the frameworks onto cards and questions, as soon as the parent's list is there | K1–K6 | W6 |

Why this order: the small fixes give the child something new soon and need no big decisions. Every big new system (market, wellbeing,
nature) leans on three shared foundations (what unlocks when, item weights, a sane economy), so those come first. The story engine comes
before the market because the market's limits need a story reason the player is told. The medicine chapter comes late because it is
where carrying, energy, nature and the forest all meet.

**Every game change also needs** (from `00-READ-ME-FIRST.md` §4.5): German through `tools/i18n.py`; the smoke test; the bot (it must learn
any new mechanic, e.g. market trips); the explorer (pace in hours, Time Quiz and Rest answers per hour); the design document; a log row.

---

## 1. Waiting on the parent

- **W1. Round 8 pictures.** 29 sheets (283 pictures) were generated in OpenArt; the parent saves the best version of each into
  `art-inbox/` under the names in `art-inbox/ROUND8-PICK-LIST.md` (sheets 25–42 are not there yet). Then:
  `python3 tools/import_art.py all`, check them on the map with screenshots (sizes in `data/map_layout.json` may need
  adjusting — the layout editor helps), rebuild the layout editor (`tools/make_layout_editor.py`) and the web build. Sheets
  whose objects come out in the wrong order: fix `tools/art_sheets.json` or skip objects with `-`. In `art-inbox/ART_LIST.csv`
  these 280 pictures have the status `generated - pick sheetNN-….png` until their sheet is in `art-inbox/`; run
  `python3 tools/art_list.py` afterwards and they turn `done`. (Includes the straw picture, sheet 45: see R1.)
- **W2. GitHub repos and the double-click scripts.** The private repo exists. Still to do: the public web repo
  (`00-READ-ME-FIRST.md` §4.7), GitHub Pages, the first run of `Build web version.command` and `Publish web version.command` on the
  Mac, the iPad Home Screen link. Cloud sessions can push to the private repo (a 403 on 7 Oct 2026 went away once the Claude GitHub
  App had write access).
- **W3. Play-test round 8 on the iPad** and collect the findings (pace, picture questions, stoking, loads, the bar explanations).
  Several of the 9 Oct notes ([#8]–[#12]) came from this; keep adding.
- **W4. Check what was built on 7 Oct 2026** (details in `PROJECT-LOG.md`):
  - A1–A5 small fixes (planting water bar, overgrown patch note, why a perk came, no dark forest floor, the question share) and the
    grown-up lock (password "farm", hint shows it for now; later a real password and a reminder as the hint).
  - B1 the opening: one cleared patch, one wheat seed, the new *Clear the thistles* job.
  - C1 the Rest start page, C2 a sum left on screen leaves no trace.
  - D every window as a grid. Not converted (on purpose so far, ❓ convert?): the woodpile's "+ Stick" chips, "Weed all / Pick
    stones" (they move anyway with J2), the quest book.
  - G the farmer's acts: watch them on the iPad and say which look wrong or too fast (each is a few numbers in `data/acts.json`).
- **W5. German.** Proofread (easiest in the game with the language on Deutsch, or in `data/i18n/*-de.json`).
  ❓ **"ss" instead of "ß"?** The game's German uses "ß" for now (quiz packs and Claude's drafts); one command can switch everything.
  💡 Your general writing preference is Swiss "ss", so the recommendation is to switch (see Q-X1).
- **W6. The curriculum** [#S1]: find out what the curriculum is and which broad frameworks of knowledge to prioritise; the parent
  provides these frameworks and the critical knowledge. Unblocks K2–K6.
- **W7. Answer the decision queue (§2)** and the five Round 5 questions (I5). The ones marked **blocking** hold up the next step.
- **W8. Sounds still missing** (system done 7 Oct; 83 files in `assets/sounds/`, 31 of 40 effects and all 6 music tracks): cow,
  sheep, goat, pony, bees, cat, birds, `extras/party`, `extras/wind` (stand-ins play until then). The Mudchute cow and sheep in
  `sound-inbox/unused/` are CC-BY-SA (share-alike): use only if the parent accepts that licence; the BigSoundBank/OpenGameArt CC0
  cow and sheep are better. The two "for now" music tracks are credited by artist and site only (farm: Zane Little, OpenGameArt, CC0;
  quiz/Rest: Kevin MacLeod, incompetech, CC BY 4.0); add the track titles to `sound-inbox/SOURCES.json` if known. **Nobody has
  listened yet** (volumes in `data/sounds.json`). The cloud machine cannot reach kenney.nl, opengameart.org, bigsoundbank.com or
  incompetech.com (7 Oct 2026): the parent downloads what `sound-inbox/README.md` lists, or allows those domains; then
  `python3 tools/import_sounds.py` and `$G --headless --path . --import`, listen, adjust volumes.

---

## 2. Decisions needed (the queue)

Each item: the question, why it comes up (often a clash with something already decided), the options, and Claude's recommendation
(💡). **Blocking** = the next step cannot start well without it. Answers go into `PROJECT-LOG.md` §2 and the task they belong to.

### Interface

- **Q-J1 (blocking J2). Where do the field's own things go when the field sign is removed?** [#8] The field sheet (opened from the
  sign) holds more than "Weed all / Pick stones": the pests and scarecrow bars, and field-level goals (patch levels, edging). 💡 All of it
  moves to a section **"🟩 The whole field"** at the bottom of the patch window: whole-field actions as tiles (harvest all, weed all,
  pick all stones, …), then the field's upgrades, then the pests line.
- **Q-J2 (blocking J6). Read aloud on/off** [#13]: does "off" hide the 🔊 buttons, or is the wish an **automatic** read-aloud that can
  be switched on? 💡 One grown-up setting with three choices: *off* (no 🔊 buttons) · *button* (as now) · *automatic* (reads each
  question and card page when it opens; the 🔊 button stays to repeat).

### Money and market ([#1], [#6], [#7])

- **Q-M1 (blocking M6). Does the market trip exist from the very first minutes?** ⚠️ [#3] wants the start very simple, and today the
  very first purchase (more wheat seeds) happens in minute 2–5. A trip with energy, carrying limits and a once-per-question rule is a
  lot to learn there. 💡 The **seed seller on foot keeps coming to the farm** in early chapter 1 (the data and the story already say
  "only the seed seller with her basket gets through" the muddy track); the **village sign** appears a little later (e.g. after the
  first porridge or the first harvest sold), with a short story box.
- **Q-M2 (blocking M6). What does a trip cost in time?** [#1] says "only available once per time unit" and "requires a time unit to
  pass". Two readings: (a) a trip may happen **once per Time Quiz question** (the question you just answered is the walk); (b) a trip
  **uses up** a question, like entering the forest (✅ forest: one question in, one out). 💡 (a): selling should not feel expensive,
  and (b) would make the child answer a question just to sell one porridge.
- **Q-M3 (blocking M6). When is the energy for a trip taken?** The parent asked "What do you think?" 💡 **Yes to your idea**, with
  three details so it stays light: (1) the **first** sale or purchase in a time unit opens the trip and takes a flat trip cost (e.g.
  2–3 ⚡), shown on that first button ("🚶 3⚡") so it is never a surprise; (2) after that, selling and buying cost no more energy until
  the next question, only **carrying room**; (3) a small "🎒 8/12" bar in the store and market shows what room is left, both ways.
  When the room is used up, the buttons grey out with ⏳ (as you described), and tapping ⏳ opens the Time Quiz. No extra screens, no
  "plan your trip" step.
- **Q-M4. One carrying limit or two?** [#1] limits both what you bring to the village and what you bring back. 💡 The same capacity
  each way, counted separately (you can carry a full load there and a full load back).
- **Q-M5. Do dish deliveries (porridge for the merchant, soups, the Fair tables) need a trip and carrying room?** 💡 No: a delivery is
  its own errand with its own energy (as now) and story scene; it never competes with selling. Otherwise a story beat could be blocked
  by a full bag.
- **Q-M6 (blocking M8). The gatekeeping logic** [#1]: why can you not buy everything in the village at once? The parent's open
  question, with the ideas so far: favour with travelling merchants (the old logic: they come out to you); dishes for merchants and
  craftspeople (✅ what the data does now: 18 deliveries open 14 merchants); a village wary of outsiders; things on sale but at
  outsider prices so high they are not even shown (the parent's own idea, "not really my favourite"). More options:
  - (a) **The village is poor.** Lord Wexley's rising shares squeezed Hazelwood too (`story/world/hazelwood.md`: "the market is
    thin"). Little is for sale because little is made. As your farm grows, the village grows with it, and more traders come (the
    story already says "the village prospers because the farm does").
  - (b) **Trust, with a story reason.** You are "the child from the burnt farm", and 💡 the Lord made sure no one in his lands would
    take the family on (`story/00-premise.md` §3). Sellers fear the steward. A dish, a favour or a friend vouching is what changes a
    seller's mind. This is the existing dish mechanic with a reason the player is told.
  - (c) **Knowledge.** The seller shows only what you know how to grow or use (crops already need their card: `crop_wheat` needs
    `k_wheat`). "What would you do with saffron, child?"
  - (d) **Distance.** Special seeds and heavy goods must be ordered from far away and come only when the road lets a cart through (the
    road ladder already gates heavy carts).
  - 💡 **Recommendation:** keep the gates the data already has and give each one its story reason: **dishes = trust** (b), **the
    road = what can be brought to you** (d), **cards = what you can use** (c), and (a) as the background of the whole village strand.
    Two separate axes fall out of it: *what* you may buy (trust, cards) and *where* you buy it (in the village on foot, or at your
    gate once the road is good). Little data has to change. Outsider prices (the parent's idea) not used.
- **Q-M7. Coins smaller than one** [#6]. ⚠️ Clashes with the rule "whole numbers on screen, no decimals anywhere" (design §5.8, parent's
  rule in `00-READ-ME-FIRST.md` §4.6). [#6] itself points at a way out: a **small bronze coin**. 💡 Two coin kinds, both always whole
  (e.g. 🪙 3 and 🟤 4), with **10 bronze = 1 coin**: no decimal point anywhere, and it teaches tens and ones (it also fits the bunches of
  10 in [#7]). Later, a grown-up setting could show money as decimals (3.40) for a child who is learning decimals (the maths
  curriculum has *Decimals & percent*).
- **Q-M8. Prices that change over the game** [#6] (wheat cheaper to buy and less profitable to sell as quantities grow). ⚠️ Rule from
  dynamic difficulty: "a price never changes in front of the child"; and recipes are meant to be learnable. 💡 Change base prices only at
  **a chapter start**, with a one-line story reason ("More farms sow wheat again; the miller pays less"), and switch to bigger units
  (a sack of 10 seeds) at the same moment, so a price never changes mid-goal.
- **Q-M9. The coin animation for everyone vs the *Coin shower* perk** [#7]. ⚠️ The perk "coins fly into the purse when selling" (earned
  for 8 different things sold) is exactly what [#7] wants for everyone. 💡 Plain coins fly for everyone; the perk becomes the fancy
  version (a shower, sparkle and its sound).

### Wellbeing and energy ([#2], [#3], [#4])

- **Q-L1 (blocking L). Hidden but working, or frozen until shown?** ⚠️ [#2] has effects work before the player can see them ("doesn't
  have any insight into why helping others lets them recover more quickly"); [#3] holds hidden numbers **still** until their interface
  is unlocked. 💡 **Good effects may work hidden** (a pleasant mystery the books later explain); **bad effects only once something is
  visible** (fairness: the child must be able to see why things got harder).
- **Q-L2 (blocking L). Optional, yet with penalties that grow with the farm?** ⚠️ [#2] calls the whole wellbeing side optional ("you can
  go through the whole game without these boosts and buffers"); [#4] wants penalties that grow with the farm if you neglect yourself.
  If the penalties only start once the dashboard is unlocked, a clever child would simply never read those books. 💡 From a fixed point
  in the game (e.g. chapter 2, when the farm gets bigger), a **single simple face** appears on the farmer or in the top bar (🙂/😐/😩)
  with a one-line reason when tapped; the penalties can start then, capped so that ignoring them makes the game **slower, never stuck**.
  The books open the **details and the levers** (the dashboard). So the boosts are optional; noticing the face is not.
- **Q-L3. Energy from time passing** [#4] (a better bed or a mindfulness practice gives a little energy per time unit). ⚠️ Design rule
  "the Time Quiz never gives energy" (§1.5), and the decision "the lever is energy per Rest answer" (log §2.3): energy is what the
  arithmetic earns. A trickle per question takes away from Rest. 💡 Allow a **small** trickle (and amend the rule), and re-check that
  Rest answers per hour stay in their band (§10.5); or, instead, a "well rested" bonus on the next Rest round. Parent's choice.
- **Q-L4. Energy draining with time; the maximum shrinking** [#4]. ⚠️ Rules "nothing punishes the child" and "soft pressure, never
  loss". 💡 Allowed with floors: a drain never takes energy below a quarter of the maximum; the maximum never shrinks below the home's
  base; every penalty names its cause and at least one cheap fix.
- **Q-L5. The bed: per Rest answer (now) or per time unit ([#4])?** Today the beds give +1/+2/+3 ⚡ **per Rest answer**. 💡 Keep that, and
  let passive rest come from new things (a mindfulness practice, the sun room …), so the existing balance holds.
- **Q-L6. Where does the dashboard open?** [#2] asks: a symbol in the top-right bar, or a natural place on the farm. 💡 **Tap the
  farmer** (today a tap only makes the farmer wave): "how you are doing" opens. Second choice: the bed in the house. The top bar is
  already full (coins, water, energy, season, 🎒→📜, 📖, 🖼️, ⚙️).
- **Q-L7. The chapter 5 low point and the wellbeing system.** The outline has you collapse from overwork in chapter 5 as a story beat
  with no penalty (`story/outline/ladder.md` 5.7). With a wellbeing system that beat could be felt in the game too. 💡 Keep the beat
  story-only, and let it be the moment the dashboard's "rest" and "calm" levers open (Wren and the badger teach them).

### Nature and sustainability ([#5])

- **Q-N1 (blocking N). Over-use vs "basic materials any time".** ⚠️ Decision of design 1.2: sticks, stones and fibre are always
  available at the forest edge (the campfire must never be impossible). 💡 Yields fall with over-use but **never below a floor**, and the
  floor is always enough for the basics.
- **Q-N2. Do the Helpers leave again if the land is over-used?** ⚠️ The world's rule 2 (`story/world/shell-and-magic.md`): "they leave
  when the Bargain is broken"; the game's rule: animals never leave, nothing is lost. 💡 They never leave; a Helper **stops one job and
  looks at you** (a thought bubble) until the balance is back.

### Story ([#S2], [#S3], [#S5], [#S6])

- **Q-I1. Where does the epilogue sit?** [#S2] The last frame scene ("tell him I was never angry") is the emotional end. An epilogue
  played after it would weaken it. 💡 The epilogue is played **before** the last frame: after the alpaca the farm runs in full, the loose
  ends are tied, and when the player is ready they tap **"Tell the end of the story"** (the last frame); after that, free play.
- **Q-I2. The grandchildren "have heard it many times"** [#S3] vs the frame's ending, where the truth is told (premise §6; ladder,
  Frame 6). If they know the story, what is new at the end? 💡 They have heard the farm story many times, but you always stopped at the
  Fair. Tonight, for the first time, you tell what happened in the barn. Their blurting ("Is this the part where the goat eats the
  ribbon?") is about the farm, never the secret.
- **Q-I3. "Skippable when replaying"** [#S3]: replaying = a new game by the same player, or any second time on the device? 💡 A *Skip*
  button from the second time a player sees the panels; everything stays re-readable in the 📜 scroll.
- **Q-I4. The player never in a picture** [#S5]: ⚠️ ladder 3.4 ("the player glimpses Mumyo in the picture; you look the other way")
  and the bedside frame pictures would show you. 💡 Painted pictures are seen **through your eyes**, or show the backlit silhouette from
  behind ([#S6]); avatars drawn by the game with the player's own look (village-square scenes, visits) are fine.
- **Q-I5. The travelling merchant's beat** (ladder 1.6: "the travelling merchant at your campfire: first porridge") ⚠️ vs [#1] (the
  merchants are not at the farm at the start). 💡 He passes by on the road once, as a story Visit: he is *travelling*. The delivery stays.
- **Q-I6. Bringing modern knowledge into an old-world setting** [#S8] (atoms, galaxies, world history in a pre-industrial world
  without any of that science). 💡 Two voices: **Lark** (immortal, Wit-like, says true things as jokes) knows things nobody else does;
  and a **"Today we know …"** line at the end of a card, as the medicine cards already plan ("Today: ask a grown-up or a doctor").
  The grandparent in the frame can add one too.

### Other

- **Q-X1. "ss" or "ß" in the game's German?** (W5) 💡 "ss".
- **Q-X2. Straw from grass** [#15]: botanically, cut and dried grass is **hay**; straw is the dry stalk of a cereal after the grain is
  threshed. 💡 Either (a) a **meadow-grass crop that gives hay** (fodder and bedding; and hay matters to the story: the fire began in
  the hay) while straw stays a by-product of wheat and oats, or (b) a cereal grown mainly for straw (rye was the classic thatching
  straw). (a) is the better lesson.
- **Q-X3. Replaying many questions at once** [#10]: if the child answers ten questions in a row, the replay must not last ten times as
  long. 💡 At most about 3 seconds in all; steps run faster when many passed.

---

## 3. Interface and feel (J) — small, can be done one by one

- **J1. Version numbers** [#14]. Show the game's version in ⚙️ Settings (and in 🎼 Credits); make versions a thing if they are not
  yet. Today there is **no game version**: `project.godot` has none, the data says `"version": "0.8"`, the design document 2.0, the
  rounds are counted in the log. 💡 One game version (e.g. **0.9.0** next), set in one place (`project.godot` →
  `application/config/version`), bumped with every web build, written in each log row, shown as "Version 0.9.0 · data 0.8 · 9 Oct
  2026". It also tells the parent whether the iPad really loaded the new web build (the web export has a service worker that caches).
  Do this first, before the other J tasks.
- **J2. Whole-field actions without the field sign** [#8]. Today, when the player taps the field sign for a whole-field job (weeding,
  picking rocks …), the farmer walks to the **sign** and acts there, which makes no sense; the farmer must go to the **field**. Fix:
  remove the field sign; when a patch is tapped, the bottom of its window has a titled section for the whole field ("🟩 The whole
  field" 💡) with *Harvest all*, *Pick all weeds*, *Pick all stones* and so on. 🔗 Q-J1 (where the pests bar and field upgrades go).
  Notes: today *Weed all* and *Pick stones* are in `_part_field` (`main.gd`), *Harvest all* in `_part_area` and at the storage basket
  (`_harvest_everything`); the art `deco/signpost.png` ("Field signpost, Home Field") goes unused; this applies to all three fields.
  💡 The farmer walks patch to patch while acting (the acts in `data/acts.json` can repeat).
- **J3. Rest: the farmer goes home** [#9]. When the energy bar is tapped and Rest starts, the farmer should walk to the tent or house.
  Note: the code already starts a "rest" act at the house (`main.gd` ~line 1251, `_act("rest", … "living")`), but the Rest window
  covers the farm, so it is not seen, or it does not work. Check on the iPad; 💡 let the farmer walk first and open the window when
  the farmer arrives (or after about half a second).
- **J4. The farm stands still during the Time Quiz, then catches up** [#10]. The quiz takes so much space and focus that the child
  misses what happens on the farm. So: while the quiz is open, nothing on the farm changes. After "⬅️ Back to the farm", wait half a
  second to a second, then play what the questions did, **step by step**: e.g. after three questions the wheat goes from sapling to
  middle to ripe; weeds grow back if they were due; signs appear or disappear as the numbers changed. Notes: the game already plays the
  pests after the quiz (`_play_fx` → `map.play_pending()`), so the replay can grow from there; the rules engine needs to record a small
  snapshot per question during the quiz. 🔗 Q-X3 (cap the length); later the same replay shows the pets' work per question (S2) and
  merchant arrivals (M7), so it is a foundation, not just polish.
- **J5. Notifications** [#12]. Can be tapped or swiped away (some stay longer than needed, some are about right); a bit smaller, and
  off to the right to begin with. Today (`_toast` in `main.gd`): every note stays 6.5 s (bar hints 3 s), max 3 at a time, centred above
  the bottom bar, and taps go through them (`MOUSE_FILTER_IGNORE`). 💡 Tap or swipe right removes one; a duration per kind (short for
  "too tired", longer for news); smaller cards on the right; same look family as the speech bubbles planned for barks
  (`story/story-delivery.md`). ⚠️ The Time Quiz clock is bottom right: keep the notes above it.
- **J6. Read aloud on/off in the grown-up settings** [#13]. 🔗 Q-J2. Today 🔊 buttons in the Time Quiz (question and answers) and on
  card pages (`_speak` in `main.gd`). Later the story boxes need it too (I8).
- **J7. Stale facts found in the documents** (found 9 Oct 2026 while sorting; fix in the design document):
  - §5.4 says "The game starts with 5 wheat seeds" (it is 1 since B1).
  - §10.3 tortoise bonus "+1 💧 every water trip" vs `story/game-design-round4.md` "+1 💧 per question": check the data, fix the wrong one.
  - §11.3 "The sounds are made by the game itself (no sound files)" and §13.6 "(planned) the whole interface in German": both outdated.
  - §10.5 "all five pets after about 700" (the bot stops before the alpaca; `00-READ-ME-FIRST.md` §4.2 is right).
  - §1.1 premise (tent, bucket, pot, one seed, a box with a book) vs the story (bucket, pot and book come in Berit's box; the seed is
    found on the one live patch; the tent is borrowed). Fix together with I9.
  - `story/characters/lark.md` has Lark turn up "the day the market stall opens" (chapter 2); the ladder has him walk up the new
    gravel road (`road_3`, 2.5). Pick one.

---

## 4. Pictures (R)

- **R1. Straw needs its own picture** [#15]. One is generated and waiting to be picked (`items/straw.png`, sheet 45; part of W1). Also:
  straw, wheat and flour all use the emoji 🌾, so wherever a picture is missing they look the same. 💡 Give straw and flour their own
  stand-in emoji.
- **R2. A picture for seeds** [#16]. Seeds are not items in the game (they are a separate count, `S["seeds"]` per crop, bought from the
  seed merchant), so nothing draws them today. 💡 One "seed bag" picture with the crop's small picture on it, rather than 22 seed
  pictures. 🔗 M4 (seeds need a weight too).
- **R3. Rules for story pictures** [#S5], [#S6]: the farmer (Fenna, working name) is **never** in a painted picture, because the
  player makes their own farmer, boy or girl. Where it helps, the **silhouette of a farmer with a farmer's hat, seen from behind, the
  light coming from the front**, dark enough to fit any hair, skin, hairstyle or gender. Add to `story/story-delivery.md` and to the
  prompt rules for `ART_LIST.csv`. 🔗 Q-I4.
- Art for the 67 card pages, gear and pests: see Z6.

---

## 5. Money and the market (M)

### The economy

- **M1. A critical pass on the economy** [#6]. A pizza that costs more than 100 coins is implausible (today: porridge 4, roast carrots 7,
  omelette 16, honey cake 49, apple pie 72, **pizza 166**, cheese board 212). The cause is the pricing rule (`meta.pricing`): worth of the
  inputs × (1.25 + 0.1 per different input) + extras, applied **again at every stage**, so long chains grow like compound interest. The
  parent's ideas: make base ingredients cheaper; wheat cheaper to buy and less profitable to sell as the game goes on (Q-M8); keep the
  simple start (1 coin to buy, 1 coin to sell); later, in bigger quantities, e.g. **10 seeds for 2 coins** and selling wheat at a slim
  margin of about **10 %**. 💡 Also look at the rule itself: a smaller mark-up for dishes made from dishes, or a mark-up added rather than
  multiplied, so the top of the chain lands in a believable range. Include the explorer's value-check notes for `rope_straw`, `compost`,
  `steel` and `jam` (recipes whose value change falls outside the expected band; was "Later 4"). Re-run the explorer and the bot; check
  that dynamic difficulty (`meta.flex`) still fits.
- **M2. Coins smaller than one** [#6]: "at some point we may need decimals for money, something like cents, shown as a smaller bronze
  coin in the animations". 🔗 Q-M7 (💡 10 bronze = 1 coin, both whole). Needs: the coin display in the top bar, prices on tiles, the
  rounding rule (§5.8: stocks down, costs up) for two kinds.
- **M3. Coin animations** [#7]: when paying, the coins fly to the merchant; when selling, they come from the merchant. More than 10 coins
  fly in tight bunches of 10 (the parent's example: 27 coins → three clusters flying; 💡 read as 10 + 10 + 7). 🔗 P1 (a merchant figure
  to fly to), M2 (bronze coins: bunches of ten bronze become one coin, a place-value lesson), Q-M9 (the *Coin shower* perk).

### The market

- **M4. Every thing gets a weight (bulk)** [#1]: each object, seed and raw material needs an attribute for how hard it is to carry
  (how bulky or heavy). Seeds are not items today (R2), so they need their own (very light). 💡 A few classes are enough (feather,
  light, normal, bulky, heavy) rather than exact numbers; straw is a nice example of light but bulky; logs, stones, iron ore are heavy
  (which is also why heavy carts need the gravel road: the road data already says so).
- **M5. How much the farmer can carry** [#1], [#2]: a number for the farmer's carrying, set by what they carry with (the parent names
  baskets, better backpacks and postcards, i.e. the postcard gifts such as *Deep pockets*) and, later, by **strength** (L2). The game
  already has carrying gear for gathering (Gathering Basket, Wicker Pack, Canvas and Frame Rucksacks; `meta.carry`, "gathering takes 2
  loads per tap"): 💡 the same gear sets the market load, so nothing new needs drawing. Later helpers that lift the limit: the
  wheelbarrow, the hand cart, and the **pony** (its planned job card "carry surplus to market and sell it", S2).
- **M6. The village sign and the market trip** [#1]. The merchants should not have their carts at the farm from the start. Instead, a
  **sign** right next to the road, pointing to the top-right corner, with a **village symbol** on it (no words, as on the whole map).
  Tapping it opens a window with the option to go to the market. Rules:
  - The trip is possible **once per time unit**; at first, buying and selling needs a time unit to pass (🔗 Q-M2).
  - What you can **buy** is severely limited at first, because you have to carry it back; what you can **sell** is limited too.
  - Postcards, baskets, better backpacks and so on raise how much you can take to the village and bring back (M5).
  - **Selling stays in the store window** (as now); when you have sold as much as this time unit allows, the sell buttons grey out
    with an ⏳. The same for buying.
  - The trip **costs energy**; the parent's proposal: the default trip energy is taken at the first sale (e.g. one bowl of porridge),
    then buying and selling are free in energy for the rest of that turn. Buying and selling should cost time and energy without being
    tedious to handle. 🔗 Q-M3 (💡 yes, with the trip cost shown on the first button and a carrying bar).
  - It becomes available after the Time Quiz (i.e. per question answered).
  - ⚠️ 🔗 Q-M1 (not in the first minutes), Q-M4 (two limits), Q-M5 (deliveries apart). Today the market stall, book cart, notice
    board and later the Import Broker stand by the road at the top right of the map (`data/map_layout.json`), and every merchant is "always
    there" (`seed_1`: "Always there, always takes coins"). The book cart (the books!) moves to the village too, so books need room in the
    bag. The *Market Stall* building (+10 % selling, chapter 2) needs a new meaning (💡 your own stall on market day in the village).
- **M7. Merchants come to your gate when the road is good** [#1]: once the road is improved, the travelling merchant now and then puts
  his cart next to your farm. **Slightly** random when; the better the road, the shorter the wait between visits. While the cart is
  there, no trip is needed (💡 and no carrying limit). 🔗 the road ladder (`road_1` … `road_5`), J4 (show his arrival in the replay), P1
  (he walks or drives in as a figure). ⚠️ Random timing is fine with "time only moves with answers" as long as it is counted in
  questions, never in real time.
- **M8. What you may buy, and why** [#1]: at the market, why only some seeds at first, when surely someone would sell more advanced
  seeds? 🔗 Q-M6 (the gatekeeping decision). Whatever is chosen gets told in the story (I6).
- **M9. A picture of the market square** [#1]: a preview of what the market square screen looks like, even though the player does not
  go there yet at the beginning. 💡 The same painted village-square background that the planned delivery scenes use
  (`story/story-delivery.md` §7), so one picture serves both.
- **M10. Notice board and Import Broker.** 💡 Decide where they stand once M6 is decided (the notice board's little jobs and favours
  are a village thing; the Import Broker came with the pony and the paved road).

---

## 6. Wellbeing and the energy model (L) — "a bit like The Sims" [#2], [#4]

Optional depth: the whole game can be played without using these boosts and buffers ✅ [#2] (🔗 Q-L2 for how that fits the penalties).

- **L1. The energy model on paper first** [#4]. Energy is shaped in three ways: (1) the **maximum**; (2) the energy per right **Rest**
  answer (quick or slow); (3) **natural rest per time unit**, zero by default, which things like a better bed or a mindfulness practice
  can make a small but meaningful passive gain (time passes and some energy comes back for free). So far the game has only ways to
  *raise* (1) and (2). Now also the factors that **lower** the energy per answer, the maximum and the passive rest, possibly even
  **negative energy per time unit**. 🔗 Q-L3, Q-L4, Q-L5. Write the formula and its numbers in the design document as *(planned)*
  before any code; check it in the explorer.
- **L2. Which body and mind numbers** [#2]: a parameter for **strength**, which could be the same as **endurance** (and feeds carrying,
  M5); one for **happiness**; one for **emotional regulation** or mental health. Aggregated through a function, they shape the energy:
  how fast it comes back and how high it can go. The parent wants to think about which parameters make sense. 💡 A first list, each
  with a lever the game already has or can easily have:
  - **Sleep** (bed, pillow, a regular rest, a warm house: the cold house already gives −25 % Rest in winter)
  - **Food** (variety: eating the same dish again and again vs a mix; the game has dishes and food bonuses)
  - **Strength / endurance** (carrying, walking, a little training)
  - **Friends** (favours, visits, letters, the Fair: the village strand; "being kind to others feels good")
  - **Calm** (breathing, sitting still, the forest, the night sky; mindfulness)
  - **Play** (doing something just for fun: 🔒 in the story, the farmer's buried need is exactly this, Mumyo's mischief; a strong fit)
  Kept positive and gentle in wording: no labels like "unhealthy" on the child's farmer; low values read as "low battery", never as
  failure.
- **L3. Hidden at first, opened by reading** [#2]: at first the player sees none of it and has no idea why, for example, helping others
  makes the farmer recover faster. To open the **health and mind dashboard**, the player reads books and passes their quizzes. At first
  there is little to see; with each book more numbers appear and more can be improved, again by reading: things like **meditation** or
  **endurance training** become available step by step. 🔗 K4 (the books), Q-L1.
- **L4. Where the dashboard opens** [#2]: a symbol in the top-right bar (maybe the easiest) or a natural place on the game screen.
  🔗 Q-L6 (💡 tap the farmer).
- **L5. Things that pull energy down** [#4]: unhealthy habits; things that grow with the size of the farm or with how much you carry.
  The idea: the more you build, grow, harvest, water and automate, the more you must balance it by looking after yourself (a good bed,
  being kind to others so you feel good, and so on). If you don't, the energy per answer gets low, each time unit costs energy, the
  maximum may shrink. 💡 Examples that fit the world: long working stretches without a rest; always the same food; nobody visited in a
  long time; carrying too much; a cold house (exists). ⚠️ 🔗 Q-L2, Q-L4. Note: the game already scales the work (energy per job grows
  about twelvefold from chapter 1 to 5), so the new pressure must not double that; balance them together.
- **L6. Knowledge cards for modern life** [#2]: this side lets the game carry many more knowledge cards relevant to modern life (sleep,
  movement, food, feelings, friendship, calm). 🔗 K1–K6, Q-I6.
- **L7. Story ties** 💡: Berit's note *Rest the field. Rest yourself.* (ch 2); the badger's "tea first" (ch 5); Wren's "You never stop, do
  you?"; the running snag "Do you ever stop?". The farmer's flaw (never stopping) becomes something the player can *feel* in the
  numbers, and the cure is the story's cure. 🔗 Q-L7.

---

## 7. Nature and sustainability (N) [#5]

- **N1. The aim**: the game and the story address farming's impact on the environment and sustainability. There is already the slow
  reveal of what made the land dry (`story/world/lease-and-collapse.md`: each link of the chain is a game system). On top, **numbers
  about sustainability are introduced at some point**.
- **N2. Which resources** 💡: the parent names **water** and **gathering wood and rocks from the forest**. Others that fit: **soil**
  (already in the game: crop rotation, tired and rested soil, compost), **forest herbs** in the medicine chapter (the real foragers' rule
  "take only a third"), the **woodlot and lumbermill** (replanting; **coppicing hazel**, which fits a village called Hazelwood).
- **N3. Advice, then consequences**: after too much use, a resource gets a **recommendation** (how much is sustainable); if the player
  ignores it, the yield declines or other bad things happen. 🔗 Q-N1 (never below a floor), Q-N2 (Helpers do not leave). Maybe there are
  other or better ways (the parent is open): 💡 e.g. the pond level visibly drops; the forest edge shows stumps instead of trees; a Helper
  pauses a job; Berit's book has the old rule for each.
- **N4. Hidden until introduced** [#5], [#3]: until then the sustainability numbers run in the background, nailed to a harmless fixed
  value. 🔗 O2.
- **N5. Woven into the story** ✅ "It should definitely be woven into the story": the world's Bargain (`shell-and-magic.md` rule 3: "the
  people take only what the land can give back"); the family's old mistakes (forest edge cut, spring pond drained) are exactly what an
  over-using player would repeat in small; the North Field resting in chapter 4 (your first *no* to the steward) could become a real
  choice in the game; the Lord's letter asking for *a half* again in chapter 6. 🔗 I6.

---

## 8. Opening and what unlocks when (O) [#3]

With all the extra things to consider and optimise, the game must **start very simple, with very few options**, and new options,
possibilities and windows are unlocked or shown in sequence. ✅ idea, 💡 details.

- **O1. An unlock schedule for the interface.** List every button, bar, icon and window the child can see, and say when each appears
  (the parent's example: after the Home Field is cleared completely, a window that was not there before becomes available). Start with an
  audit of what the very first screen shows today (top bar: coins, water, energy, season bar, 🎒, 📖, 🖼️, ⚙️; bottom bar: next goal, Time
  Quiz clock; the market stall and carts by the road …). The game already follows "only what matters now" for goals and places; this
  extends it to the interface itself. One table in the design document; the data says what triggers each.
- **O2. The engine runs from the start, the numbers wait.** Everything that computes and aggregates (wellbeing, sustainability, carrying
  …) is there from the beginning; until its window is unlocked, it holds its numbers at a constant and does not change them. 🔗 Q-L1 (good
  effects may still act hidden).
- **O3. Triggers.** 💡 Reuse the story's trigger language (`story/story-delivery.md` §6: `done:<node>`, `chapter:<n>`, `step>=<n>`,
  `seen:<id>` …) so that unlocks and story pieces share one system, and an unlock can come with a story box that explains it.

---

## 9. People on the farm (P)

- **P1. Other characters as avatars** [#11] (e.g. the merchant). Same system as the farmer (`scripts/avatar.gd`, looks from
  `data/avatar.json`, acts from `data/acts.json`). Combines with: the story's **Visits** (villagers walk onto the farm:
  Greenstem, Granny Maud, the miller, Wren, Master Quill, Lark, Captain Mei; `story/story-delivery.md` §7), merchants walking about
  (was in "Later 2"), the merchant's cart at the gate (M7) and coins flying to him (M3). ⚠️ No words on the map: they are recognised by
  their look.
- **P2. "Make your farmer" screen** at the start (the farmer's look is already data, `data/avatar.json`; keep it per player). Needed
  for the gender-open farmer ✅ and for the silhouette rule (R3). (Was "Later 2".)
- **P3. Gear visible on the farmer** (fits the acts' props; upgrade idea 15 in `progression/upgrade-benefits-ideas.md`). (Was "Later 2".)

---

## 10. Knowledge and curriculum (K) [#S8], [#S1]

A **secondary** goal ✅: it must not overshadow the main ones (a game that is fun, not overwhelming, still challenging; a story that is
interesting, well made and makes you care). Use it wherever it does not conflict.

- **K1. The frameworks** ✅ the parent provides them (W6). Examples the parent gave: broad frameworks that make it easy for a child to
  slot new facts in. **What the world is made of**: molecules, crystalline structures, metals. **Nested scales**: molecules are made of
  atoms, atoms of electrons, protons and neutrons; the other way, the planet is part of the solar system, part of a galaxy, a galaxy
  cluster, the universe. **History** of our world in broad strokes only. **Facts about the body** that are not just nice to know but
  fundamental, so that learning at school gets easier. Ways for an eight-year-old to understand chemistry, physics and any other
  framework that makes learning easier.
- **K2. Map hooks in the existing cards** (can start before K1 arrives) 💡: go through the 67 cards and 201 card questions (KNW-001…201)
  and note where a framework fits. Hooks already in the game: photosynthesis (every crop; the parent's own example — check whether it is
  in already); compost and decomposers (soil life); bread rising (yeast is alive); smelting iron and making steel (metals, melting);
  quartz found in a stone (crystals); salt (crystals); glass from sand (melting, cooling); dyes and colour mixing (light); water carried,
  rain, evaporation; the moonstones "fallen from the sky" (meteorites, the solar system); the first night under the stars (ch 1 awe); the
  medicine chapter (the body); the wellbeing books (L6).
- **K3. Augment the cards**: add a question to an existing card, or add to a card, so the framework attaches to it. Rules: new
  questions get new ids through `tools/quiz_ids.py`; never change or reuse an id; German through `tools/i18n.py`.
- **K4. New books** 💡: a *body and mind* book (or two) that opens the wellbeing dashboard (L3); a *land and water* book for
  sustainability (N); *The Healer's Herbal* (already planned for chapter 5, `story/game-design-round4.md` §C). Each with a price,
  chapter and cards like the other 12 books.
- **K5. The external pool**: whatever cannot be made to fit goes into the Time Quiz question packs (one pack per framework or school
  topic), which is fine. But the more lives inside the game, the stronger the child's own motivation, because the relevance is obvious.
- **K6. How it is voiced** 🔗 Q-I6 (Lark; "Today we know …").

---

## 11. Upgrades (H)

- **H1. Upgrades that do more than save energy.** Written: `progression/upgrade-benefits-ideas.md` (7 Oct 2026: 119 of ~240 effects
  only save energy; 15 other kinds of benefit; a suggested rule; one idea per upgrade). Waiting for the parent's choice. 🔗 Choose
  together with L (beds, pillows, the house: per-Rest vs passive energy, Q-L5) and M5 (baskets and packs as market carrying).

---

## 12. Story (I) — files in `story/`, worked in rounds (see `story/README.md`)

- **I4 (leftovers of Round 4).** Plant facts still to be fully checked and reviewed by the parent before anything ships. Rename
  `sq_chapel_roof` to the village hall (texts, German, picture prompt "waving from the dry chapel").
- **I5. Round 5: outline** (`story/outline/ladder.md`, draft 1 of 8 Oct 2026). ❓ Five questions for the parent at its end: the low
  point in chapter 5 (too close to the poisoning?); the Lord's letter and climb-down in chapter 6; the cousin's accusation at the Fair
  and her answer (is the cousin a girl?); the one thing left unsaid at the night garden; awe on the first night with the tune. Also
  still open: the chapter 6 bend as a tap or a text (`story/story-delivery.md`).
- **I6. Round 6: loop back** (reconcile story and game). Now also: the village strand and the market's gatekeeping (Q-M6, M8: dishes as
  trust, the Lord's word, the poor village); the travelling merchant's beat (Q-I5); wellbeing as the farmer's flaw made playable (L7);
  sustainability in the story (N5); the principle below (I13); where Lark appears (J7).
- **I7. Round 7: texts** (chapter 1 first, read aloud, then German through `tools/i18n.py`).
- **I8. Round 8: build.** (a) `data/story.json`, the story box, the 📜 scroll (replaces 🎒), first-tap problem stories, frame scenes;
  (b) then pets' jobs, the medicine chapter, favour-giver renames, pictures (`ART_LIST.csv`); tests and web build. (The game parts are
  listed in §13, S1–S5.)
- **I9. The opening: story panels and the frame** [#S3]. The current opening text (the farm burned down, only a tent is left) does not
  fit the story (`_show_welcome` in `main.gd`: "Your farm burned down. All that's left: a tent, an old bucket …"; `well_1`: "All that is
  left: a small dented bucket"). The game will start with a few **story panels**: pictures and text, **skippable when replaying**, that
  explain the situation the player is in. This includes the larger **frame**: grandchildren looking up at the player, asking to hear
  the story again; a story they have heard many times, but they want it one more time. **Between chapters** the grandchildren poke the
  player to go on; some **blurt out foreshadowing** (they know the story: "Is this the part where …?") and get **hushed** by the others.
  🔗 Q-I2 (what is new at the end), Q-I3 (skipping), R3 (no player in the panels). ⚠️ Keep what the current welcome *teaches* (tap places;
  the ❓ Time Quiz moves time; tap ⚡ to rest): it must survive somewhere (💡 as the first story boxes' second line, or a short tip
  after the panels). Blurts must never spoil a 🔒 truth.
- **I10. An epilogue chapter** [#S2]. The last chapter brings the alpaca at the very end; afterwards there should be things to do:
  loose ends to tie up, enjoying everything built on the farm, **putting the Helpers to use**. Needs more story material, and more side
  quests and optional things: add-ons, perks and so on. 🔗 Q-I1 (where it sits). 💡 Loose ends the files already leave open: the cousin
  and the family after the Fair; the Lord's answer and Master Quill; Greenstem and Wren; the letters home; the miller; Lark naming the
  squirrel; the night garden. ⚠️ The thing left unsaid at the night garden is meant to stay unsaid (ladder 6.11, carried to Minena): the
  epilogue must not solve Mumyo. The pets' job board levels 3–4 (S5) give the "putting the Helpers to use" part real play.
- **I11. Pictures for the story follow R3** [#S5], [#S6] (the player never shown; the backlit silhouette from behind where it helps).
- **I12. A title** [#S7]. "Farm game" needs a better name, ideally the name of the story. First batch below, deliberately varied. 💡
  It has to work in English and German (or have both), and the farmer's name must not be in it (the player renames the farmer). Before
  deciding: check that no well-known game or book already uses it.
- **I13. Plot details in the game are flexible** ✅ [#S4]: the details of the game's plot events so far may be changed to fit the story,
  as long as the pacing of the game stays roughly sensible. (Recorded in `PROJECT-LOG.md` §2.7.)

### Title ideas, first batch (I12) 💡

| Title | Kind | Note |
|---|---|---|
| **Moonedge** | place name | the farm's name in the story; short, mysterious; German *Mondrand* |
| **Small Is Plenty** | the theme | the first line of Berit's book; German *Klein ist genug* |
| **One Grain Left** | the opening image | the stalk with one grain; German *Ein Korn übrig* |
| **The Farm at the Forest's Edge** | plain storybook | German *Der Hof am Waldrand* |
| **Tell Us About the Farm** | the frame | what the grandchildren ask |
| **The Helpers Come Home** | the quiet goal | six pets coming home |
| **Bells in the Hay** | the mystery | hints at Mumyo and the fire without saying it |
| **Hazelwood Harvest** | cosy, alliterative | the village and the Fair |
| **Ash & Clover** | before and after | the burnt farm and the land healed |
| **Seed by Seed** | the method | German *Korn um Korn* |
| **Before the Frost** | a deadline | the mother's first letter |
| **The Farm Book** | an object | Berit's book, handed on |
| **Moonstone Farm** | the world | the glowing stones in the first field |
| **What the Bunny Kept** | playful mystery | the first small secret |
| **Enough** | one word | the theme, bold; harder to search for |
| **Answer the Clock** | the mechanic | the Time Quiz clock that moves the farm |
| **Wie der Hof zurückkam** | German first | "How the farm came back" |
| **The Long Way Back to Moonedge** | journey | |
| **Tend** | one verb | farm, people, yourself |
| **Sit Down, Farmer** | funny, the bend | the farmer who never stops |

---

## 13. Six chapters, the pets' jobs, medicine, the forest (S) — from `story/game-design-round4.md` §E

Decided in Round 4 ✅ (six chapters; chapter 5 *Healing* with the badger; ~25 hours fine; job board to level 4; forest in and out a Time
Quiz question each; the Wren check and the poisoning exception). Build order:

- **S1. Six chapters in the data**: renumber (old 5 → 6), the badger as a placeholder, `pet_alpaca` and `import_broker` re-pointed to
  `pet_badger`, `sq_healer_garden`, `sq_lamp_maker` and `copper_still` into chapter 5; pet lists in `scripts/game.gd` (two places); bot and
  explorer re-run. 💡 From the outline: `pet_tortoise` to require `pond`, `pet_alpaca` to require `river_meadow_drain` (I5/I6 decide).
- **S2. Pets visible and their job board level 1–2** (they walk and act; today's bonuses become level 1). 🔗 J4 (replay shows their
  work), M5 (the pony carries to market).
- **S3. The medicine chapter**: the still-room (`ruins_stillroom`), stations, remedies, *The Healer's Herbal* (K4), the Wren check and
  the poisoning. 🔗 L (energy), N2 (herbs: take only a third).
- **S4. The forest screen.** 🔗 M5 (the basket's room), N (over-picking), L (energy).
- **S5. Pets' job board levels 3–4** (WHEN cards, a second rule), if play-testing says the child wants them; a parent setting could
  switch the WHEN cards off. 🔗 I10 (the epilogue uses them).

---

## 14. Later (Z) — parked, older tasks

- **Z1. Dynamic difficulty** (design §10.6) is built but **off by default**. Tune it with play-testing; ideas noted: look at the time
  per goal rather than only the pace; vary *which* dish an order wants rather than how much; a parent's slider for strength. `meta.flex`
  in the data holds every number. 🔗 M1 (re-check after the economy pass). (Was Later 1.)
- **Z2.** Was Later 2: now P2 (make your farmer), P3 (gear visible) and P1 (merchants walking about).
- **Z3. Orchard and greenhouse** still use a square patch grid inside their sheets; give them diamond rows like the fields. (Was Later 3.)
- **Z4.** Was Later 4 (explorer value-check notes): now part of M1.
- **Z5. Pixie chest** mini-game (an old idea for random rewards), not built. (Was Later 5.)
- **Z6. Still-open design questions** (from the old documents; was Later 6):
  - village projects (bundles with substitutes): still a maybe;
  - cider is alcoholic; rename it "apple must" for young players?
  - art for the 67 card pages, gear and pests (album pictures for favours came in round 8);
  - play-test with real 8-year-olds: how many review questions they tolerate, whether 30 questions per season feels right, whether pest
    pressure is noticeable but not annoying;
  - the assumptions listed in `PROJECT-LOG.md` §2.6.
- **Z7. Keep an eye on the public web build.** Everything in it (game data, quiz packs, pictures) can be downloaded by anyone with the
  link. Fine for now (parent's decision, 7 Oct 2026); revisit if content becomes personal (e.g. the child's name, photos, the learning
  record) or if the art should not be shared. Options then: a private host or a password-protected one. (Was Later 7.)
