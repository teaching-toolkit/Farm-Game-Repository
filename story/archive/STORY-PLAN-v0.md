# Farm Quiz Game: story plan (draft 1)

Status: **plan only, nothing changed in the game yet.** Written 7 Oct 2026 from the parent's brief, the *Minena 01* chapter, the
Willem/Britta/Lark fish story and the *Forest Within* character profiles. Texts are in English; German comes from `tools/i18n.py`
when we build it. Every story text is **2–4 short sentences** (about 35–45 words) so an 8-year-old reads it in under a minute.

---

## 1. What was decided (and what is still a guess)

Decided by the parent:

- The farm is **back in Hazelwood**: a burnt homestead at the edge of the **Moonstone Forest**. No new world. The conch and the dream
  are a mystery that unfolds across the five chapters.
- Secondary characters come from **Hazelwood village and the Moonstone Forest**.
- **Mumyo** the imp shows up every now and then. **Lark** from the fish story shows up at some point.
- A **📜 story scroll** replaces the 🎒 backpack in the top right (it must not look like the 📖 quest book).
- Problems from the environment get a story box **the first time they are tapped**, and can be read again later from the scroll.

My assumptions (please confirm or change; each is cheap to change before we build):

1. **The farmer is Minena** by default (green hooded cloak, brown hair, hazel eyes). The child still names the pets. A later
   "Make your farmer" screen could let another child pick a different look; the story would still say Minena. ❓
2. **The farm was Grandmother's.** It burned long ago in a dry summer, nobody hurt. This gives the game's welcome text a reason
   and ties in Grandmother's stories, her illness (she gets better as the farm grows) and the box with the book in it. ❓
3. **The dream melody has five notes. Each pet brings one home.** After the alpaca the melody is whole and points to the conch.
   The game ends at the conch's doorstep; the fall into the pool of light is the start of *The Forest Within*, not part of this game.
4. **Nothing in the story ever costs the player anything.** Mumyo's pranks are harmless (things are moved, never lost).
5. The psychological notes in the profiles stay **behind the scenes**. In the game they show only as gentle behaviour.

---

## 2. The thread through five chapters

| Ch | Place | Minena's feeling | Mumyo | Lark | Pet / melody note |
|---|---|---|---|---|---|
| 1 Ashes | tent | "Is small enough?" Grandmother's book says: *Start small. Small is plenty.* | only bells and a silly pile of sticks | – | 🐰 Pip: note 1 |
| 2 Homestead | cottage | "I can build something that stays." | hides the hammer; Minena waits instead of chasing | opens the market stall, tells the fish tale at the pond | 🐢 Mossy: note 2 |
| 3 Smallholding | cottage | "People see me differently now." Scarlet says sorry. | a prank at the harvest dance goes too far | – | 🐐 Bramble: note 3 |
| 4 Village Trade | farmhouse | "Grandmother walks to the door." | meets Lark, who agrees to everything, which confuses him | sorts the farmhouse library by weight | 🐴 Hazel: note 4 |
| 5 Master Farm | farmhouse | "I am enough." (said quietly, once) | shows his hidden night garden | is the Import Broker | 🦙 Alfie: note 5, melody whole, conch glimpsed |

Moonstone thread: a faint hum from white stones (ch1 rocks), a big egg-shaped stone in the North Field (ch4), the conch seen
between the trees at the very end.

---

## 3. The cast

**Family:** Mum (leg healing), Dad (plants; gives seeds and the first boots), Grandmother (in bed, then walking), little sister
**Manjiva** ("Nene!", toddler, says "Mine."). **Hazelwood:** Mrs. Appleby (baker), Mr. Odinson (blacksmith), Mr. Greenstem
(herbalist; pins the notes on the message board), Mrs. Solemate (cobbler), Irian (sewing), the children, **Scarlet** (first
gossips, later helps; her sorry is in chapter 3). **Moonstone Forest:** bumblebee, butterflies, the five pets, **Mara** the magpie
(gossip and "borrower": she is the face of the pests; she likes Minena anyway), a plump squirrel who hides the golden acorns
(*optional: this is Nutmeg; he gets his name in chapter 5* ❓).

**Mumyo** (hand-sized imp, grey vest with bells that jingle when he moves, appears and vanishes): jokes, songs, games, tries to
trick Minena into mischief, goes too far, gets into trouble. The bells give him away: they jingle softly when he is sad.
Secretly he tends a garden of night-blooming flowers. In the game he is never a threat; he is a friend who has not noticed yet.

**Lark** (rust-brown coat, mismatched buttons, a bit of everything, agrees with whatever you say): lines to reuse: *"Probably
fine."* · *"Sorted."* · *"Heavy books at the bottom."* · *"Good chat."* His bells jingle too, the warm kind. Three appearances only:
market stall (ch2), farmhouse library (ch4), Import Broker (ch5). He is a wanderer, so no explanation is needed.

### The 28 favour-givers (`sq_*`, kept as data; only names and blurbs change)

Their jobs and requirements stay exactly as they are. **Check first:** round 8 generated album pictures for these favours; any
renamed person needs a new picture, so the table prefers keeping the person and only re-skinning the setting.

| Favour | Now | Fits Hazelwood? | Proposal |
|---|---|---|---|
| sq_cold_shepherd | Tom the shepherd boy | yes | keep (hill pasture above Hazelwood) |
| sq_lost_goat | Granny Maud | yes | keep; the goat foreshadows Bramble |
| sq_twins_porridge | Lotte and Linus | yes | keep; they are in the group of children |
| sq_miller_basket | Ella, miller's daughter | yes | keep (mill on the Hazel stream) |
| sq_washing_line | Hilde the washerwoman | yes | keep |
| sq_sick_neighbour | Old Jan | yes | keep |
| sq_bridge | Otto the ferryman | yes | keep (the stream, not the sea) |
| sq_healer_honey | Wren the healer | yes | keep; Mr. Greenstem recommends her |
| sq_stray_kitten | Ginger the cat | yes | keep; Mumyo claims he did not feed it |
| sq_apprentice | Bo, smith's apprentice | yes | **Mr. Odinson's** apprentice (named in text) |
| sq_baby_blanket | Baby Lena's family | yes | **Irian and Mrs. Solemate** bring the wool news |
| sq_harvest_dance | Rosa the fiddler | yes | **Scarlet** organises it; Rosa plays; Scarlet says sorry |
| sq_chapel_roof | Ansel the bell-ringer | yes | keep (his bell answers Mumyo's) |
| sq_school_window | Miss Ines | yes | keep |
| sq_wedding_cake | Anna and Ben | yes | **Mrs. Appleby** bakes the base, you add the cake |
| sq_night_watch | Pieter the night watchman | yes | keep; sees "a tiny light in the forest at night" (Mumyo's garden) |
| sq_long_voyage | Captain Mei | sea | **river-barge** Captain Mei, pickles for the trip down the Hazel |
| sq_poet_scarf | Kit the little poet | yes | keep |
| sq_painter_saffron | Lucia the painter | yes | keep |
| sq_school_garden | the school children | yes | keep; Scarlet is among them |
| sq_theatre_cheese | travelling theatre | visitors | keep; they pass through for the Harvest Fair |
| sq_orphanage_jam | Matron Elsie | no orphanage | rename **the Hazelwood children's home** or "Mrs. Elsie's school of little ones" ❓ |
| sq_lamp_maker | Ferdinand | yes | keep; makes lanterns for moon nights |
| sq_elders_feast | Elder Agnes | yes | keep |
| sq_festival_flags | Mayor Juno | yes | keep (Hazelwood Harvest Fair) |
| sq_village_well | Young Sami | yes | keep; the well from Minena's first morning |
| sq_telescope | Vega the astronomer | yes | **the moon-watcher**: studies the moonstones |
| sq_healer_garden | Wren | yes | keep |

---

## 4. Story beats (trigger, picture, text)

Pictures are generated as before (OpenArt, one picture per beat, style from the existing map art). Until a picture exists, the
box shows a large emoji. Triggers are checks on the game data that already exist.

### Chapter 1 · Ashes

| Id | Trigger | Picture | Text |
|---|---|---|---|
| 1.01 | new game (replaces the welcome text) | tent in the ashes at the forest edge, Hazelwood roofs below | Long ago, Grandmother's farm burned down in a dry summer. Nobody was hurt, but the ashes stayed. This morning Minena followed a melody from her dream to the forest edge. She has a tent, a dented bucket, a tin pot, and one wheat seed. |
| 1.02 | first book opened | Grandmother's box, wobbly handwriting | Inside Grandmother's box lies her farm book. The first page, in wobbly writing, says: *Start small. Small is plenty.* Minena reads it twice. |
| 1.03 | `clear_thistles` done | silly pile of sticks, bells in the air | *Ting-a-ling!* Something small in a grey vest zips past. Three sticks are now in a very silly pile. Nothing is lost, just moved. A giggle, and he is gone. |
| 1.04 | first seed planted | Minena watering, a bumblebee beside her | Minena hums the dream melody while she waters the seed. A bumblebee circles her head and hums one wobbly note back. "Not yet," Minena says. "But soon." |
| 1.05 | `campfire` built | smoke over the trees, Mrs. Appleby sniffing | Smoke curls over the trees. Down in Hazelwood, Mrs. Appleby sniffs the air. "Porridge," she says. "Somebody is cooking up at Grandmother's!" |
| 1.06 | first golden acorn found | plump squirrel, golden acorn | A plump squirrel drops a golden acorn at Minena's boot. "That one is for you," he squeaks. "I have a SYSTEM." Then he runs into the wrong tree. |
| 1.07 | `pet_bunny` | bunny in clover | A bunny with one floppy ear hops out of the clover and sits on Minena's foot. When she hums, the forest hums back: one clear note. The first of five. |

### Chapter 2 · Homestead

| Id | Trigger | Picture | Text |
|---|---|---|---|
| 2.01 | chapter 2 starts | Dad with a handcart of planks | Dad comes up the path with a handcart of old planks. "A real roof, Minena. Let's start with logs." Mum waves from the road, leaning on her stick. |
| 2.02 | `cottage` built | Manjiva patting the wall | Little Manjiva toddles in, pats the wall, and says: "Mine." Everybody laughs. It is a good wall. |
| 2.03 | `market_stall` built | **Lark** with crates | A man in a rust-brown coat leans on your new stall. "I'm Lark. I do a bit of everything." He carries three crates, stacks them wrongly, and says: "Probably fine." It is. Mostly. |
| 2.04 | `pond` built | Lark skimming a stone | Lark skims a stone across the pond. "I once knew a man who caught a talking fish. It offered him anything. He asked for a patch for his boat." He grins. "Best wish I ever heard." |
| 2.05 | `workbench` / `shed` built | hammer on the roof corner, bells at the chimney | Where is the hammer? *Ting-a-ling!* It is balanced on the roof corner. "Come and get it!" Minena does not chase. She sits and waits. After a while a small grey vest slides down and hands it over. |
| 2.06 | `pet_tortoise` | tortoise at the gate | Tap, tap, tap. A tortoise with moss on its shell arrives at the new gate. Minena hums, and the forest answers with a second note, low and warm. |

### Chapter 3 · Smallholding

| Id | Trigger | Picture | Text |
|---|---|---|---|
| 3.01 | chapter 3 starts | frosted moonstone, cracked | A moonstone cracked in the frost, and inside it lies a thread of dark iron. Mr. Odinson sends a message: "Come to the smithy. Bring your hands." |
| 3.02 | `forge` built | Mr. Odinson with tongs | Clang! Mr. Odinson lets Minena hold the tongs. "Good hands," he says. "Grandmother's hands." Minena stands a little taller. |
| 3.03 | `hand_loom` built | Irian with a cloak | Irian mends Minena's cloak with wool from your sheep. "Mrs. Solemate says you wear out boots," she says. "Now we will make the cloak last." |
| 3.04 | `sq_harvest_dance` started | Scarlet at the gate | Scarlet stands at the gate, holding her elbows. "I said things. Not nice things." She looks at the ground. "Can I help with the cider?" Minena nods. "Yes." |
| 3.05 | `sq_harvest_dance` done | mugs floating, Mumyo on the roof | Mumyo makes all the cider mugs float. Everyone laughs. Then one drops and Minena catches it. Mumyo sits on the barn roof, bells quiet. "I only wanted them to look up," he mumbles. |
| 3.06 | `pet_goat` | goat chewing a tiny vest | A goat trots in and nibbles something grey and tiny. "Not the bells!" squeaks Mumyo. The goat looks pleased. Minena hums, and a third note joins in. |

### Chapter 4 · Village Trade

| Id | Trigger | Picture | Text |
|---|---|---|---|
| 4.01 | `farmhouse` built | Grandmother in the doorway | Grandmother stands in the doorway of the new farmhouse, leaning on Minena's arm. "My kitchen was exactly here," she says. Then she is quiet for a while, and smiles. |
| 4.02 | `library_room` built | **Lark** with books on the floor | Lark is sorting your library. "By weight," he says. "Heavy books at the bottom, light ones at the top." He puts a book about flowers on the highest shelf. "Terrible book. Very committed." |
| 4.03 | `greenhouse` built | Mr. Greenstem and seedlings | Mr. Greenstem peers at the seedlings. "Sometimes the best things grow where nobody can see," he says. "In the dark. Like seeds." He winks. |
| 4.04 | `north_field` cleared | big white stone, moss | Under the scrub lies a big white stone, round as an egg. Minena puts her hand on it. It hums, very faintly. The same melody. |
| 4.05 | Lark and Mumyo both met | the two with bells | Mumyo tries every trick on Lark. Lark says yes to all of them. "Wonderful idea," says Lark. Mumyo is horribly confused. Nobody has ever said yes to him before. |
| 4.06 | `pet_pony` | pony in the meadow | A pony the colour of hazelnuts steps out of the trees. Minena hums, and the fourth note comes back clear and strong. Only one more. |

### Chapter 5 · Master Farm

| Id | Trigger | Picture | Text |
|---|---|---|---|
| 5.01 | `import_broker` built | **Lark** with a sign | Lark has a new sign: *Brokers of Everything.* "Barter? Yes! Whatever you like." He leans closer. "I once worked for a woman who counted everything. Lovely woman. Always one more field." |
| 5.02 | `river_meadow` drained | white night flowers, Mumyo among them | Where the marsh dried, white flowers open in the dusk. Mumyo sits among them, bells very quiet. "Don't tell anyone. I watered them all summer." Minena sits down beside him. |
| 5.03 | `sq_festival_flags` done | flags over Hazelwood | Flags in every colour hang over Hazelwood. Mayor Juno calls out, "Minena's flags!" and the whole village cheers. Minena looks for a place to hide, and does not find one. She laughs instead. |
| 5.04 | `pet_alpaca` | alpaca at dusk, the conch between the trees | The alpaca hums the fifth note, and the melody is whole. Far between the trees, something white and spiral gleams. "Tomorrow," Minena thinks. "Tomorrow I will go and see." |
| 5.05 | master farm complete (end card) | the farm, evening | Minena looks back at the farm. It is not big, and it is not perfect. "I am enough," she whispers. The forest hums along. *To be continued in The Forest Within.* |

---

## 5. Problems from the environment: first-tap stories

Each opens a story box **once**, the first time the thing is tapped, then sits in the 📜 scroll for good. The text *adds* the
existing note ("Patch 3 is not ready yet…"); it never replaces it. The box closes with one big button, so it never blocks play.

| Trigger (the thing tapped) | Text |
|---|---|
| **Message board** (`board`) | Hazelwood's message board stands by the well. Mr. Greenstem pins a note: *Little jobs, small coins, big thanks.* Under it, in crayon: *Mumyo was here.* |
| Patch: **thistles** (`clear_thistles`) | Thistles taller than Minena's knees. They prickle through her gloves. Grandmother's book says: *They only grow where nobody visits. So visit.* |
| Patch: **weeds** | Weeds grab at her boots like they want her to stay. "I do," Minena whispers. "Just not for long." |
| Patch: **rocks** | Rocks, rocks, and more rocks. Some are plain grey. A few are white and hum a little when she lifts them. She stacks them in two piles. |
| Patch: **stumps** | Old stumps, twisted like sleeping dragons. That one has eyes! That one has a tail! "I won't wake you," Minena tells them. "I will only move you." |
| **Scrub** (`north_field_clear`) | Thorny scrub, thick as a hedge. Something small rustles inside and goes *ting-a-ling.* "Did you live here?" asks Minena. No answer. |
| **Marsh** (`river_meadow_drain`) | A wet marsh that goes *squelch* with every step. Frogs, dragonflies, and one very surprised heron. It all has to move over, just a little. |
| **Old bucket / wild pond** (`well_1`) | A dented bucket and a wild pond. Two sips of water per trip. "Fetching water is walking and thinking," Dad says. "Both are good for you." |
| **Ruins** (`ruins_workshop` and others) | Black beams and cold ash. Somebody's work stood here once. Minena puts a hand on a post. It is warm from the sun. |
| **Mystery sign** (a place beyond the chapter) | *Something stood here once… You will find out what belongs here later.* Below it, in scribbly letters: *Not yet! (M.)* |
| First **pests** | A magpie lands on the fence. "Just borrowing, dear!" says Mara. She means the seeds. She likes Minena, so she only takes a few. |
| First **winter** | Frost lifts the stones and the pond wears a lid of ice. Even the bees are asleep. Minena puts on her green cloak and keeps going, step by step. |
| First **stale food** | The porridge smells wrong. It is not sad, only old. "Next time we eat it sooner," says Minena. |

*Rule:* a trigger that fires earlier or later than planned is fine; the text must not mention anything the player has not met yet.

---

## 6. The 📜 story scroll (interface)

- **Where:** the top-right icon row becomes 📜 · 📖 · 🖼️ · ⚙️. Replace 🎒 in `main.gd` (the row with `_open_pantry`). The scroll icon
  gets a small **gold dot** when there is a story not opened yet. The 📖 quest book keeps its look and its place.
- **The pantry** moves: tapping the stock display opens it (to verify in the code which on-screen element is that display), and
  ⚙️ Settings gets a "Pantry" link as a second way in. Nothing disappears.
- **Opening it:** a window like the album: one tab per chapter, **newest first**, each seen story as a card (small picture, title,
  first line). Tap a card to read it again in the same story box.
- **Locked entries:** no spoilers. Unseen stories of the *current* chapter show as a covered scroll with "?"; later chapters show
  nothing (same rule as the map: no sheet shows anything beyond the current chapter).
- **The story box:** a modal like `_show_welcome`: picture on top (emoji until it exists), the speaker's name in small letters,
  2–4 sentences at 18–20 px, one button **"Carry on"**. Mumyo's boxes play a small bell sound (`Sound`); Lark's play two soft
  chimes. No text on the map; the box only appears after a tap or a finished goal.
- **Manners:** one box at a time; if a celebration is showing, the story waits until it closes; never during the Time Quiz or
  Rest; at most one *unprompted* story (goal-triggered) per few questions, so the child is not buried in text.
- **Save and data:** `G.S["story_seen"]` holds ids; `data/story.json` holds all beats (`id`, `chapter`, `trigger`, `speaker`,
  `picture`, `text`). Triggers are data: `start`, `node_done:<id>`, `tap:<spot>`, `tap_patch:<kind>`, `chapter:<n>`, `first:<event>`.
  German in `data/i18n/story-de.json` through the existing `tools/i18n.py` flow. Pictures in `assets/story/<id>.png`.
- **Tests:** the smoke test opens the scroll and a story; the bot gets a flag that dismisses story boxes so it does not hang.
  A new check lists every `story.json` trigger and confirms the node or spot exists in the data.

---

## 7. Pictures needed (for `art-inbox/ART_LIST.csv`)

43 new pictures: 30 for the beats (7 + 6 + 6 + 6 + 5; five show Lark, six show Mumyo) plus 13 for the first-tap problems (many can
reuse the map art of the patch and add Minena or Mumyo). Style: the existing map art, Minena in her green hooded cloak, Mumyo
small, white-haired, grey vest with bells (from the profile prompt), Lark in the rust-brown coat. The three pictures from the
Minena chapter (*Hazelwood*, *Minena 3*, *white conch shell*) can be the first references; I could not check whether they are in
the game folder.

---

## 8. Questions for the parent

1. Is **Minena the farmer** by default (assumption 1), and **Grandmother's farm** the reason it burned (assumption 2)?
2. Should the squirrel with the golden acorns be **Nutmeg from the start**, or stay a nameless squirrel until chapter 5?
3. **Orphanage jam** (ch5): rename to a Hazelwood children's home, or something else?
4. Which pet arrival may carry the **biggest** story box? (I would give the bunny and the alpaca a picture each and keep the middle three smaller.)
5. Is **Mara the magpie** acceptable as the "face of the pests", given she is a gossip in your other stories?

---

## 9. Log and to-do entries to add (the standing rule)

*PROJECT-LOG.md row:* `7 Oct 2026 · Story plan (draft 1) written as STORY-PLAN.md: Minena + Hazelwood/Moonstone setting, five-note melody,
Mumyo and Lark appearances, 28 favour-givers re-cast, first-tap problem stories, 📜 story scroll replacing 🎒. No game changes.`
*New assumptions for §2.6:* the five points in section 1 above.
*READ-ME §6 new group "I. Story":* I1 parent answers the five questions · I2 build `story.json`, the story box and the 📜 scroll with
chapter 1 · I3 chapters 2–5 · I4 pictures for the beats · I5 German proofreading · I6 move the pantry link.
