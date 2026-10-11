# How the story is delivered in the game

Round 4, part 1, draft 1 (8 Oct 2026). Built on `research/story-in-games.md`. Labels: ✅ decided · 💡 proposed · ❓ open.
Replaces the loose interface notes in `game-hooks.md` §4 (they still hold and are folded in here).

## 1. Seven kinds of story piece 💡

| Kind | What it is | Triggered by | Missable? | In the 📜 scroll? | Borrowed from |
|---|---|---|---|---|---|
| **Frame** | Grandchildren at your bed (✅ start and between chapters) | chapter start | no | yes | – |
| **Beat** | A plot step of the chapter: a Helper comes home, the steward arrives, a big reveal | a goal node done (the critical path) | **no** | yes | Stardew events |
| **Discovery** | What you find when you first tap a thing: the notice board, a stump patch, a ruin's find | the player's own tap | yes (you may never tap it) | yes, once found | environmental storytelling |
| **Moment** | A small scene with a person: Greenstem after your first soup, Granny Maud's goat | conditions (built, delivered, season, seen) | yes | yes | storylets |
| **Letter** | From your mother, by the river barge | conditions, roughly one a chapter | no (it waits in the scroll) | yes | Stardew mail |
| **Bark** | One line from a villager or Lark reacting to what you just did. ✅ A **speech bubble you tap away** when read | a pool, least recently seen first | yes | no | Hades |
| **Visit** 💡 (parent's idea, 8 Oct 2026) | A villager **walks onto the farm as a little figure** and meets you at the right moment: Greenstem at the gate, Quill with his ledger, Granny Maud chasing her goat. Their words come as speech bubbles or a short box | the same conditions as a Moment | depends | yes | Stardew visits |
| **Scene** 💡 (parent's idea) | A **pop-up window showing you on the village square**, handing over a delivery, with the people who receive it | a delivery done (`done:d_…`) | no for key deliveries | yes | – |
| **Trace** | Mumyo's prank on the map, a bell sound, flowers on the step. No text | conditions | yes | no (but a Discovery can follow) | embedded narrative |

## 2. When a piece may show 💡

1. **Never during the Time Quiz or Rest.** Story waits until you are back on the farm.
2. **One box at a time.** Celebrations first, then story.
3. **Priority** when several are ready: Frame > Beat > Discovery (you just tapped it) > Letter > Moment > Bark.
4. **Unprompted pieces are rationed:** ✅ at most one Moment, Visit or Letter per 3 Time Quiz questions, so story never buries play.
   Beats and Discoveries are not rationed (you earned or asked for them).
5. **No real-time gating** (the Cozy Grove lesson). The only clock is play.
6. ✅ **Barks** appear in a small speech bubble; you tap it away when you have read it. They never block anything else.
7. **Every box has one big button.** Re-reading is always possible from the scroll.

## 3. Freedom without losing the plot 💡

- The game's goals already form a tree where some nodes **must** be done (each pet, key buildings, the chapter's goal). **Beats hang only
  on those**, so their order is guaranteed whatever the player does first.
- Everything else (Moments, Discoveries, Letters) is a **storylet**: self-contained, true in any order the game allows. If two could fire,
  the more specific one wins; a general fallback exists for barks.
- A piece may require another to have been seen (`seen:<id>`), which is how short chains (a Moment with a follow-up) are built.

## 4. Tension and release inside a chapter 💡

Each chapter has the same shape. It hangs on goals the game already has.

| Part | What happens | Kind |
|---|---|---|
| Hook | A question from the grandchildren; a strange thing on the farm | Frame, Beat |
| Middle | Clues from ruins and traces; people warming up; a letter that raises the stakes | Discoveries, Moments, Letter |
| Turn | A reveal that changes how you see something (the scorch began low) | Beat |
| Climax | **A Helper comes home** (dish + comfort item, which the game already asks for) | Beat |
| Hook out | One line that opens the next question | Beat (last of the chapter), then the next Frame |

The first ten minutes of chapter 1 get a hook, a strange thing (the nibbled stalk, the bells) and a first payoff early (the Wylde Flowers lesson).

## 5. Writing rules for the pieces ✅/💡

- ✅ **Second person;** people use `{player}`; no gendered word for the farmer; nobody talks *about* you in the third person.
- ✅ **The Helpers do not talk.** Write what they do and what you take it to mean: *The goat looks at your list. Then at you. Then she eats it.*
- 💡 Tell the player as little as possible about what *you* feel; let the world react.
- Short: 2–4 sentences, words a six-year-old knows; one picture per box. Read aloud before it counts as done.
- Optional pieces may be missed; **critical ones never**.

## 6. The data, roughly 💡 (for Round 8)

`data/story.json`, one entry per piece:

```json
{ "id": "c1_stalk", "kind": "beat", "chapter": 1,
  "when": ["start"], "priority": 90, "once": true,
  "speaker": "", "picture": "story/c1_stalk.png", "mumyo": false,
  "text": "On the one green patch stands one ripe wheat stalk. Every grain is nibbled off. All but one." }
```

Conditions (`when`, all must be true): `start`, `done:<node>`, `tap:<place>`, `tap_patch:<kind>`, `has:<item>:<n>`, `season:<name>`,
`seen:<id>`, `chapter:<n>`, `step>=<n>`, `chance:<0..1>`. A `seen` list in the save marks what has shown. Barks have `once: false` and
are picked least-recently-seen. German via `tools/i18n.py`. Tests: the bot skips boxes; a check that every condition names something
that exists.

## 7. Visits and village scenes 💡 (parent's idea, 8 Oct 2026)

- **What the game already has:** the farmer is an avatar built from data (`data/avatar.json`) who walks to places and acts things out
  from `data/acts.json` (walk to, pose, hold a prop, repeat). **Villagers can reuse the same avatar maker** with their own look, so a
  visit needs no new drawing system: a villager is an avatar with a fixed look, walking in from the village road at the top right.
- **A Visit:** the villager walks to the place the moment is about (the gate, the pond, the field), you walk over, a speech bubble or a
  short box, then they walk off. They stand where the player can see them; no text on the map.
- **A Scene:** for deliveries to the village (porridge for the merchant, soup for the village, the Fair tables), a pop-up window shows the
  village square as a small painted picture, with your avatar handing over the dish and the people taking it, and one or two lines.
  The square is a painted background; the figures are avatars, so your own avatar (any look) is in it.
- **Second person still holds:** they talk *to* you, by your chosen name.
- **Art:** one village-square background (later: the Fair version); a look per recurring villager in `avatar.json` style.
- **Who visits** (first list): Greenstem, Granny Maud, the miller (once, on the bridge), Wren, Master Quill, Lark, Captain Mei with a letter.

## 8. Questions for the parent ❓

1. ~~Barks~~ ✅ speech bubbles, tapped away. ~~Letters~~ ✅ stay. ~~Rationing~~ ✅ one per 3 questions.
2. The bend in chapter 6 as a tap or a text: ❓ open, decide later.
