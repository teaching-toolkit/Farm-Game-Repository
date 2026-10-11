# The ladder: six chapters

Round 5, draft 1 (8 Oct 2026). Written with *live-wire-style* (ladder pass: structure, not wording). Labels: ✅ decided · 💡 proposed ·
❓ open · 🔒 hidden. Beats name the game node that triggers them (checked against `farm-progression.json`, 8 Oct 2026).
**Critical** = the node is required for that chapter's pet, so the beat cannot be missed. Kinds: see `../story-delivery.md`.

## The book in one sentence 💡

You come alone to a burnt farm to make one seed grow, and to keep so busy that nobody asks about the fire; the farm, the village and six
lost Helpers come back only as you learn to let others help, to say "enough", and at last to sit down and tell what happened in the barn.

## The ladder at a glance

| Ch | Core sentence (want · in the way · how it ends) | Fails how (new each time) | Charge | Lever out |
|---|---|---|---|---|
| 1 Ashes | You want the one seed to grow, alone · ash, mud, a road no cart can use, and someone small keeps moving your things · the bunny comes home: someone kept this patch alive *for you* | the land itself fights back | **G**, W at the end, A on the first night | withhold: *who rings the bells?* |
| 2 Homestead | You want a real roof before the frost, because a letter says *come home before the frost* · you cannot build alone, and the village is wary · the barn ruin shows the fire began **low**, not from lightning; the tortoise comes home | other people (you need them) | **T**, W | withhold: *then what started it?* |
| 3 Smallholding | You want to stay, so you work twice as hard · the goat eats your plans, the miller still blames your family, the mill holds a bell too small for any cow · you let the goat do a job for you; you laugh at the dance | your own spine (you can't stop) | **G**, T | escalate: *your cousin asks after you* |
| 4 Village Trade | You want the farm to be yours · the Lord's steward arrives and counts everything; the old lease says *a half* · you tell him the field will rest: your first *no*; the pony carries your first big order and you are seen | the old pattern (*more*) | **T**, G (Lark) | escalate: *the steward rides back to the Lord* |
| 5 Healing | You want to stop the cough in Hazelwood · you try to make every remedy yourself, and the torn page says why the badger left: nobody let the children rest, and you were one of them · you collapse; you ask the badger; he comes home, tea first | your spine fails at what you care most (**low point**) | **T**, W, A (the conch) | escalate: *a letter with the Lord's seal* |
| 6 Master Farm | You want the Fair to be perfect, and the farm safe from *a half* again · the Lord's letter; your family arrives, and your cousin says in front of everyone that you were in the barn · **the bend**: you sit down and tell what happened; the alpaca comes home; the rhyme is whole | the past in public | **T** → A → W, ends **G** | (last chapter: ajar, not a question) |

**Checks (skill):** each chapter fails worse and differently ✔ · low point in chapter 5, bend in chapter 6 after it ✔ · no two G-only
chapters in a row ✔ · T rises across the book ✔ · awe three times (ch 1, 5, 6), never in a build ✔ · every W follows a G or T ✔.

---

## Chapter by chapter

Each chapter has the shape from `story-delivery.md` §4: hook, middle, turn, a Helper's return, hook out. Beats are listed in order of
likely play; Moments and Discoveries can fall anywhere the game allows.

### Frame 0 (before the game) ✅

The grandchildren crowd round your bed: "Tell us about the farm that burned down." You are not sure you remember it right.

### Chapter 1: Ashes · G, W, A

| # | Kind | Trigger | Critical? | What happens |
|---|---|---|---|---|
| 1.1 | Beat | `start` | yes | One green patch in the ash. One ripe wheat stalk, every grain nibbled off but one. (Who nibbled? 🔒 the bunny.) |
| 1.2 | Beat | first book opened | yes | Berit's book: *Start small. Small is plenty.* You remember one line of an old rhyme: *Long ears sow the clover green.* |
| 1.3 | Beat | first night (first Time Quiz question) | yes | **Awe:** the forest edge at night, white stones glowing faintly, a tune you can't place. You hum it without noticing. |
| 1.4 | Trace + Discovery | `clear_thistles` | no | Bells in the air. Three sticks in a very silly pile. Nothing lost. |
| 1.5 | Discovery | `ruins_workshop` | yes | A burnt ledger page: the Lord's share, a bigger number every year. (Plant for ch 4.) |
| 1.6 | Visit | `d_porridge` | yes | The travelling merchant at your campfire: first porridge, first trade. "You're the Moonedge child?" |
| 1.7 | Discovery | tap the notice board | no | Hazelwood's notice board; you are shy of it. |
| 1.8 | Bark | many jobs in one go | no | "Do you ever stop?" (the merchant; the running snag starts) |
| 1.9 | Beat | `pet_bunny` | yes | **The bunny comes home** and sits on the green patch. It was her. She kept it alive all this time, and nibbled the stalk, and left you one. **W.** The rhyme's first line now makes sense. |
| 1.10 | Beat (out) | after `pet_bunny` | yes | That night: two soft rings of a very small bell. *Who else is still here?* |

**Frame 1:** "Was there really a bunny?" "There was. She was rude about carrots."

### Chapter 2: Homestead · T, W

| # | Kind | Trigger | Critical? | What happens |
|---|---|---|---|---|
| 2.1 | Letter | chapter start | yes | Your mother: *Come home before the frost.* (A clock, and a reason to build fast.) |
| 2.2 | Beat | `cottage_walls` | yes | Walls. You built them alone, and it shows: they are crooked. You are proud of them anyway. |
| 2.3 | Visit | `d_stone_soup` | yes | **Young Greenstem** at the gate: "You're the Moonedge one. You used to carry a bucket bigger than you." He asks too many questions. |
| 2.4 | Discovery | `ruins_lumber` | no | Too many stumps for such a small farm. Someone cut the forest back. |
| 2.5 | Beat | `road_3` (gravel road) | yes | **Lark** walks up the new road as if he had always been on it. Sits on your fence while you work. "Probably fine." First meeting. |
| 2.6 | Beat (turn) | `ruins_barn` | yes | The scorch began **low, in the hay corner**, not on the roof. It was not lightning. **T.** |
| 2.7 | Moment | `ruins_compost` | no | A clean, dry compost pit. Berit's note: *Rest the field. Rest yourself.* |
| 2.8 | Moment | `cottage` | yes | A real roof, before the frost. You write home: *I'm staying a bit longer.* |
| 2.9 | Beat | `pet_tortoise` | yes | **The tortoise comes home**, slowly, to the pond (💡 data: make `pond` a requirement). She sits on the spot where the spring rose. You sit with her and **wait** while it fills. **W.** Second line of the rhyme. |
| 2.10 | Beat (out) | after `pet_tortoise` | yes | In the barn's new frame you find a lantern hook, blackened. *If not lightning, then what?* |

**Frame 2:** "Did you find out who started it?" "Not then. I didn't want to."

### Chapter 3: Smallholding · G, T

| # | Kind | Trigger | Critical? | What happens |
|---|---|---|---|---|
| 3.1 | Letter | chapter start | yes | *Stay if you must. Your cousin asks after you.* (You read it as a threat.) |
| 3.2 | Bark/Moment | various | no | The miller glares from the bridge; the stream is still low. |
| 3.3 | Beat | `forge` | yes | Clang. Old Odinson and young Bo; your hands are good with tongs. |
| 3.4 | Beat (turn) | `ruins_windmill` | yes | A bell far too small for any cow, on a nail in the old mill. **The player glimpses Mumyo** in the picture; you look the other way. **T.** |
| 3.5 | Moment | `pond` done + chapter 3 | no | The stream runs clear again. The miller, on the bridge, nods at you once. That is his whole apology. |
| 3.6 | Moment | `sq_harvest_dance` | no | The dance. You work the cider. The mugs float; one falls; you catch it; you laugh out loud. A single *tink*. |
| 3.7 | Running snag | `pet_goat` approaching | – | The goat (once back) eats your list, then your new list. |
| 3.8 | Beat | `pet_goat` | yes | **The goat comes home** and eats the thistles nobody could clear, and you **let her** (bend 1 ✅). Third line. |
| 3.9 | Beat (out) | after `pet_goat` | yes | Mumyo's scarecrow wears your hat. And a letter: *Your cousin may come to visit.* **Escalate.** |

**Frame 3:** "Were you scared of the cousin?" "More than of any imp."

### Chapter 4: Village Trade · T, G

| # | Kind | Trigger | Critical? | What happens |
|---|---|---|---|---|
| 4.1 | Beat | `farmhouse_base` | yes | A thin man with a ledger at the gate: **Master Quill**, the Lord's steward. "The old farm smokes again. The Lord wishes to know why." |
| 4.2 | Visit | `farmhouse_walls` | yes | Quill counts everything: cows, bags, windows. Mumyo turns two ledger pages into a paper boat. Quill is not amused. You are, a little. |
| 4.3 | Discovery | `ruins_greenhouse` | no | The old lease in a tin: *a half*. The ledger page from chapter 1 fits it. |
| 4.4 | Beat (turn) | `farmhouse` | yes | Quill asks for the Lord's share "as before". You say the North Field rests this year. **Your first *no*.** Lark on the fence: "You've counted the cows. Have you counted the clover? It counts *you*." |
| 4.5 | Moment | `library_room` | no | Lark sorts your library by weight. |
| 4.6 | Scene | `d_pizza` | no | Pizza night on the village square for the builders; your avatar among them. |
| 4.7 | Beat | `pet_pony` | yes | **The pony comes home** and carries your first big order down to Hazelwood: a Scene on the square; you are **seen**. Fourth line. |
| 4.8 | Beat (out) | after `pet_pony` | yes | Quill rides back to the manor with his numbers. "The Lord will want to know." **Escalate.** |

**Frame 4:** "Was the Lord a villain?" "He was afraid. That's worse, sometimes."

### Chapter 5: Healing (new) · T, W, A · the low point

| # | Kind | Trigger | Critical? | What happens |
|---|---|---|---|---|
| 5.1 | Beat | chapter start | yes | A cough in Hazelwood, children first. Wren cannot do it alone. |
| 5.2 | Discovery | `ruins_stillroom` (new) | yes | Berit's still-room. A torn page: the badger's. |
| 5.3 | Visit | first forest trip | yes | Wren shows you her check: "Bring me your basket. Every time." (Plant for the poisoning rule.) |
| 5.4 | Beat | the forest, once | yes | **Awe:** far off between the trees, something white and spiral. You do not go closer. ✅ |
| 5.5 | Moment | first remedy | no | Greenstem asks Wren to take him on. She says yes, grumpily. |
| 5.6 | Beat (turn) | the torn page found complete | yes | The page: the badger left after the children's fever, when nobody let them rest. **You were one of those children.** **T.** |
| 5.7 | Beat (low point) | before the Healer's Chest is done | yes | You make every remedy yourself, night and day. You collapse in the still-room. Wren: "You never stop, do you?" (Not the poisoning; this is tiredness, a story beat, no penalty.) |
| 5.8 | Beat | `pet_badger` | yes | **The badger comes home**, sets out the tea set, makes you sit. Tea first. You **ask** him to help (bend 2 ✅: the player gives him his first job card). **W.** Fifth line. |
| 5.9 | Beat (out) | after `pet_badger` | yes | A letter with the Lord's seal. **Escalate.** |

**Frame 5:** "Did you get better?" "Badgers make very slow tea. By the time it was ready, I was."

### Chapter 6: Master Farm · T → A → W, ends G · the bend

| # | Kind | Trigger | Critical? | What happens |
|---|---|---|---|---|
| 6.1 | Beat | chapter start | yes | The Lord's letter: Moonedge prospers, so the lease returns to *a half*, "as before". The old pattern. **T.** |
| 6.2 | Beat | `import_broker` | yes | Lark comes back as the Import Broker: "Barter? Yes!" |
| 6.3 | Beat (awe) | `river_meadow_drain` (💡 data: make it critical) | yes | **Awe:** where the marsh was, white flowers open at dusk. Bells, very softly. Nobody shows himself. 🔒 Mumyo's garden. |
| 6.4 | Moment | Fair deliveries | no | The tables fill; the village works with you. |
| 6.5 | Letter | before the Fair | yes | *We're coming to the Fair.* All of them. The cousin too. |
| 6.6 | Beat (crisis) | `d_fair_cloth` | yes | At the Fair your cousin says, in front of everyone, that you were in the barn that night. Silence. |
| 6.7 | Beat (**the bend**) | right after 6.6 | yes | You stop. You sit down. You tell what happened: the lights, the lantern, the running. ❓ text or a tap (*Sit down* / *Tell*). The cousin: "I saw the lights too. Nobody believed me either." |
| 6.8 | Beat | `farmhouse_sunroom` | yes | Quill brings the Lord's answer: with his numbers in hand, the Lord sets the share at *a tenth, as in the old days*. 💡 |
| 6.9 | Beat | `pet_alpaca` | yes | **The alpaca comes home.** Her alarm call woke everyone that night; nobody was hurt because of her. The rhyme is whole. **W.** |
| 6.10 | Beat (last) | after `pet_alpaca` | yes | The Fair supper. You **sit down** at the long table (the chapter 1 situation, met differently). You set a place for Lark; he has to sit very still for a moment. Lark names the squirrel: "Nutmeg. Obviously." The goat eats the blue ribbon. **G.** |
| 6.11 | Beat (ajar) | after 6.10 | yes | That night you take a bowl of milk to the night garden and set it down. You do not say what you meant to say. Two soft rings. (🔒 The one thing that stays unsaid: the cost the book keeps.) |

**Frame 6 (the end):** The grandchildren are asleep, all but Minena. "Tell me the imp was real." You tell her the truth, and then
✅ *"If you meet a little fellow with bells, tell him I was never angry."* That night she dreams of a melody (*Minena 01*).

---

## Running snags (three or more, the last the biggest)

| Snag | 1st | 2nd | 3rd / payoff |
|---|---|---|---|
| "Do you ever stop?" | the merchant, ch 1 | Wren, ch 5 ("You never stop, do you?") | ch 6: you sit down at the Fair; nobody says it |
| Mumyo's moved things | sticks, ch 1 | the scarecrow's hat, ch 3 · Quill's paper boat, ch 4 | the night garden, ch 6 |
| The goat eats paper | your list, ch 3 | the new list, ch 3 | the Fair ribbon, ch 6 |
| Letters from home | *before the frost* (2) | *stay if you must* (3) · *your cousin may come* (3) | *we're coming to the Fair* (6) |
| The rhyme | line 1 (ch 1) | one line per Helper | whole (ch 6) |
| Rest | Berit's note (ch 2) | the field rests (ch 4) | you rest (ch 5); you sit (ch 6) |

## What this asks of the game 💡

- `pet_tortoise` should require `pond` (water story), and `pet_alpaca` should require `river_meadow_drain` (the night garden is the
  climax and must not be missable). Both raise the pace a little; the explorer must be re-run.
- New chapter-5 nodes: `ruins_stillroom`, the still-room stations, the torn-page discovery, the Healer's Chest, `pet_badger`.
- Beats at "chapter start", "first night", "first forest trip" and "after `pet_x`" need simple triggers (`chapter:<n>`, `step>=1`, `seen:<id>`).
- The Lord's letter (6.1) and his answer (6.8) are story only; they change no numbers (the lease is not a game system). ❓ Or should the
  Fair ribbons be what persuades him?

## Questions for the parent ❓

1. The **low point** in chapter 5 (you collapse from overwork, Wren and the badger make you rest): right, or too close to the poisoning?
2. The **Lord's letter** in chapter 6 (back to *a half*) and his climb-down (*a tenth*): yes, or keep the Lord out of the ending?
3. The **cousin's accusation at the Fair** and her answer ("I saw the lights too"): does that fit, and is the cousin a girl? (I wrote *her*.)
4. The thing left **unsaid** at the night garden, carried to Minena: yes?
5. Chapter 1's **awe** on the first night, with the tune: good, or too early?
