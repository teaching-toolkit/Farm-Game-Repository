# The Lord's accounts (🔒 architects only)

Slice 07, companion to `dossier.md`. Written 23 Oct 2026; **revision 2 (07b)** the same day after `reviews/07-lord-lease-clock.md` and the manager's rulings at the end of `slices/DECISIONS.md`. Labels: ✅ decided · 💡 proposed (everything new is mine) · ❓ open · 🔒 hidden from the player. **Nothing here is player text.** It fixes one consistent set of books so that the claim, the collection, the Mark, the Count, the engine numbers and every shipped line can be checked against it. Lines marked *sketch* only fix a voice.

**What changed in this file (revision 2).** §1 colour code reworded (ink means "will stand behind in front of you", not "permanent"); the player word "Held" is gone (bible keeps it; the child sees only "carried down"). §2 adds what the number is *for* (the grey barge carries grain). §3 loses the **beasts** reason (one reason now: the Hurst hears the farm is alive) and the **Hold** (the engine has no barter that escapes the coin block). §3 gains the **felt rates** and the cap. §4 gains the Mark's end through a *signed count*. §6 adds Quill's proof with the rested field at the Fair eve. §7 adds the barge's grain. §8 is rewritten against the data (T-F is not a trap; barter is coin-bound; `assumed()` is narrower than "anything with a chimney"). §9 adds the hook-outside paper and Quill's drawer line.

---

## 1. The words a player may and may not meet 💡

| The player may hear | The player may never hear (bible only) |
|---|---|
| the Lord's share; a half; a tenth, a fifth, a third; "the Book"; "the lease"; "the number"; "the Hurst"; **Share Day** (02) | the Count; Greywater; interest; loan; bank; debt to a named person; percentages |
| **grey**: the grey barge, grey wax, grey ink, "a grey letter", "carried down", "downriver" | "the Count's clerk" (say "the grey letters", "the one who writes in grey"); "Held" as a column name |
| the Moonedge Mark ("the thin moon" for the child's ear); "until the farm gives again" | the Roll, arrears, standing order (say "the Book", "the chalk", "the paper on the board") |
| the Table (one line at the bottom: never so much that the table is bare) | "clause"; "Table Clause" as a term; "Rest, Return, Ask" (architect shorthand, never said) |

Colour code, kept everywhere: **red = the Lord** (wax, his coin's rim), **grey = the one above him** (barge sail, ink, wax, the line at the foot of every page), **pencil = what Quill may be wrong about**, **ink = what he will stand behind in front of you** (revision 2: not "permanent"; the pond shows ink *running*, so the point of ink is *signed and witnessed*, never *cannot be erased*). A child follows colours when it cannot follow money.

## 2. The chain, bottom to top 💡

```
 the land -> Pieter (carries the book) -> Quill (counts, drafts) -> the Lord (signs, is afraid)
          -> the grey letters -> the Count (an old man who keeps the river's granaries) -> the winter stores of twelve valleys
```

- **The Count of Greywater** 🔒 (three days beyond Weir; never seen, never named to the player). Old, formal, a widower. He lends against the harvest: each quarter-end a lord sends a sum down the Alder on the grey barge; the sum goes into the granaries that feed Weir, Greywater and the river towns in a hard winter. His rule, taught to every clerk he trains: **a page has three columns, Taken, Held, Given back, and a page that does not balance is a lie.** In a bad winter he opens the doors and writes the loss in the third column. He is not a villain; he is a number that turned out to be bread. **What reaches the player (revision 2):** the grey barge carries *sacks as well as paper* (a bark at the Grey Breath: "a sack is lowered into the grey barge, one more; the children hold their breath"), and the block of **grey salt** at the end reads as "bread said yes". (Optional 💡 for 04: the father carted the grey sacks in Weir; never in text.)
- **The Lord** 🔒. Inherited a manor with the old Lord's debts (a flood took the quay and the mill bridge; the Lord's Mile was built with borrowed money). He is afraid of the **number**, not of the Count: he has never been to Greywater. He reads the **last line** of every grey letter (the sum) and puts the letter in a drawer. **The middle lines of those letters, for three years running, offered him patience.** He never read them. This is the one-sentence irony for the Lord: he is the man who did not open his post. It rhymes with the folded letters in the farmer's drawer, Berit's margins, the Reeve's report and the mother's brackets: *the warning nobody read* (03's through-line), at the top of the chain. **It reaches the player** in one line in Quill's mouth after the ink (dossier E-6.R29): *"He had them all in a drawer. The last line he read. Never the middle."*
- **The Hurst's quarter-sum.** Each quarter the grey letter names a sum. The Lord divides it among the farms by the Book. When Moonedge (the biggest farm: the valley threshed in its barn) stopped paying, the sum did not fall; the shortfall was carried and grew; the Lord covered what he could by the **Mark** (§4) and by climbing the ladder on every other farm.
- **The Reeve (Rudge)** (04). Takes statements the day after the fire and writes a report that names a child; issues the Mark's standing order the month after. **There is no lantern order** (DECISIONS, after 04's review: the lantern hung outside on its hook; the fire began inside). Nothing in this slice depends on one.

## 3. Claim and collection (answers C10) 💡

| | What it is | Where it lives | Who says it |
|---|---|---|---|
| **The claim** | the lease: **a half of all that the land gives** | the tin (`c4_lease`); the Book's first line; the grey letters' sum | Quill ("as before"), the Lord's letter (`c6_lord`), the burnt page's red number |
| **The assumption** | what the Book thinks the land gives: every field, orchard and glasshouse patch, and every producing building in the data (kilns, glass kiln, forge, presses, cheese vat, fermenters, cellars, looms) at a fixed value (engine `assumed()`) | the Rate Book | Pieter; Quill |
| **The collection** | the ladder: a fraction of the assumption, a rung for each step the Hurst *hears the farm is alive*: a tenth, a fifth, a third, then the half (engine `fraction()`: 0.10, 0.20, 0.33, 0.50) | Pieter's book, at each season end | Pieter at the gate |
| **The cap** | **the share is never more than a quarter of what the farm sold that season, but never less than the book's smallest line (200 bronze)** (engine: `due = min(share, max(200, 0.25 x sales))`). Pieter's rule: *the lesser of the book and the till*. | the line at the foot of the lease page, "so the table is not bare"; Pieter reads it; the other collectors never did | Pieter, in chapter 5, as a secret (dossier E-5.R19) |

**The single reason for the rise (revision 2; was "the Book counts beasts").** The shipped `c6_lord` already gives it: *"Your farm prospers."* The Hurst's watchers (Pieter on the Wall, the tollman at the Landing, the chimney-watch from the Hurst's own windows) hear the farm is alive: smoke, bells, a pony on the Square, a cobbled road. The Book climbs a rung when it hears. The engine ties the rung to the pets home; the story ties it to **being heard**, and the first thing the village talks of is a Helper's return, so the two never visibly disagree. **No child lever:** nothing the child chooses (delaying a Helper) is ever rewarded or mentioned; the shipped joy at each return stands untouched; Pieter's apology is plain feeling, never a rule about animals. The bunny's thump at a distant lantern is a gag with no price.

**The ladder is the same four steps the old farm climbed** (slice 01's sacks: one in ten, one in five, one in three, one in two): the old farm climbed it in years, the new one in chapters; both end on the claim. The half is not a new demand; it is the top of the stairs.

**The felt rates (revision 2; the data's own tuning note, verify with the bot).** From `53-lord.json`: the share is about **6 %** of a season's sales in chapter 3 and about **19 %** in chapter 4. A fraction doubling gave a 3.2-fold rise, so the assumption outgrows sales; at 0.33 and 0.50 the share exceeds a quarter, so **the cap, not the fraction, sets what the child pays in chapters 5 and 6: about a quarter of the till**. So: the child feels roughly 6, 19, 25, 25 per cent. The third and the half are real on paper and in the Book (the difference is "carried down"), not in the child's wallet. Two consequences the story uses:

1. **Pieter's mercy belongs to chapter 5**, where the cap starts to bind: he writes the quarter of the till and nothing more, and the Hurst must not know. In chapter 3 the book's figure *is* what he takes, so he claims no discount there.
2. **What the half costs is not the child's coin but Pieter's post**: the difference between the Book's half and the quarter he collects goes in the grey line, and a grey clerk will one day ask why. (Dossier E-6.R32.) The eased tenth is relief that feels like a cloak taken off (about a halving), not a restoration; with data wish D-9 (`eased` also lowers the cap) it would be larger.

**Lateness has no engine consequence beyond what the game does** (revision 2: no "Hold"). The code blocks **buying with coins** while something is owed (seeds, items, and the 82 coin-cost nodes, since every barter recipe also costs coins); selling, making from stock, farming and trips go on. Nothing is seized, nobody is scolded. The story therefore says only what the game does: *the Lord's share first: pay Pieter at the gate*; traders wait; Rue waits and eats an apple. The warm face of lateness is **other people being patient**, not a fictional barter.

**Two seasons and no more.** The engine caps arrears at two seasons' due. Story: Pieter says the Book has no page for a third.

## 4. The Moonedge Mark (answers the manager's ruling) 💡

- **What it is.** A chalk **thin moon** (a crescent: the edge of the moon, so the name finds its picture) on every loaf, sack and crossing in the valley "for the farm that burnt". Chalked by whoever holds the counter (Appleby, Tally at the Weigh House). It costs the village a small payment with each mark. Bible: a **standing order** issued by Reeve Rudge in the month after the fire: *the Mark stands until the farm gives again.*
- **Where the money goes.** Into the **arrears column**: the claim (a half of the Rate Book's figure) for every quarter since the fire, plus a yearly "for lost use of the land". The Mark pays *that*, not the farm's current share.
- **Why it is a fixed grievance, not a meter (ruling kept).** The farm's present payments go **on account** (this season's column). The arrears column is a **sum carried forward**, copied each year. A payment on account does not touch it. A child who asks "why doesn't my paying lower the chalk?" is asking the right question (Greenstem: "The Hurst has two books.").
- **The end clause is the clue.** The order says *until the farm gives again.* The farmer reads it (E-2.R03) and thinks: *I give.* Nothing happens, because **the farm is not yet on the Roll**: from chapter 3 Pieter collects "on account". A farm goes back on the Roll only when **a steward signs a count**. Quill's signed count (chapter 6, witnessed at the Fair) puts Moonedge back; the order lapses by its own words.
- **Why the village wipes first (keeps slice 02's E-6.L04).** After the bend the village will no longer chalk "for the farm that burnt" now that the farm that burnt is a child. They wipe on their own word, *before* any paper, and risk the Hurst. Quill arrives the next morning: "You are two hours early. I would have made you wait. I am glad you didn't." The Mark's end is **both**: a village act (emotional, the cost) and a signed count (legal, the cause).
- **Why Quill's numbers show the arrears were never real (child version: the shrinking sack).** Take a half of what a field gives and next year it gives less; take a half of less and it gives less again; the Book writes the *old* big number as owed. The owed grows while the given shrinks. Quill draws it as sacks: the same four fractions as the burnt page, and beside them the heap that is left.

## 5. The columns 💡 (revision 2: two words for the child)

| Column | Colour | Who writes it | What the child sees and hears |
|---|---|---|---|
| **Taken** (the Book's figure) | red ink | the Hurst | ch1, the burnt page (sacks) |
| **Carried down** (the bible's "Held": what arrived; what the till shows) | a **grey line at the foot of each page** | Pieter, the grey letters | ch3, Pieter's book |
| **Given back** (compost, clover, a tree, a plate at the table) | pencil, then ink | Quill, and only Quill | ch4 (pencil, glimpsed at the boat), ch6 (ink, in public) |

The burnt page in chapter 1 was burnt along the edge that held another column. The third column is the **Bargain as arithmetic**: *the people take only what the land can give back.* It is also the Count's own form, which Quill learned as a boy clerk lent to the Hurst. The old Lord's clerks dropped it because a page with two columns shows bigger numbers.

## 6. What Quill counts in chapter 6 (his proof) 💡

1. the resting field's harvest against the worked field's (rested soil grows faster; the game's rotation rule); **only if the child rested the field**, so the line is a hope the scene allows, never a claim the game must make true (review M-notes: placed at the Fair eve, folded into E-6.R12);
2. the manure and compost returned (the muck rule);
3. the saplings in the stump rows (the nature cycle);
4. the **plates**: every name at every Fair table, asked before counted (E-6.R27).

His argument, in one sentence for the Lord: *a farm that gives back more than it takes will pay for twenty years; a farm taken at a half will pay for five.* He does not say it; he draws it.

## 7. The Hurst ladder: the Lord's fear shown in the world 💡

The Lord never appears, so his fear shows as **things the Hurst stops doing**, one per chapter, as barks. It is the old slide seen from the top, a mirror clock: the farm climbs the ladder up, the Hurst climbs it down.

| Ch | What the village notices | Bark sketch |
|---|---|---|
| 1 | baseline: the tall chimney smokes in all weathers; a gong for dinner | – |
| 2 | the dinner gong rings once, not twice | "The gong at the Hurst rang once today. Nobody says anything." |
| 3 | the hounds are quiet | "No hounds bark at the Hurst Gate. You catch yourself listening for them." |
| 3 (autumn) | the grey barge: a **sack** goes aboard | "A sack goes down into the grey barge. Then another. Nobody breathes." |
| 4 | the Lord's Mile has met a puddle (E-4.R19) | "There is a puddle on the Lord's Mile. People stand round it like a visitor." |
| 5 | the rider who brings the seal wears a boy's hat; no carriage horse | "The boy with the letter runs. The Hurst has no horse to spare." |
| 6 | the chimney is cold on a Tuesday | "For the first time you can remember, the Hurst chimney is not smoking." |
| after | gong twice; chimney smokes; the Lord asks for pie | – |

## 8. Numbers the story must not contradict (read-only: `53-lord.json`, `lord.gd`, `trade.gd`, `pace.gd` as audited by the reviewer) 

| Item | Value | Story use |
|---|---|---|
| start | engine chapter >= 3 | first lantern at the gate |
| fraction by engine chapter | 3: 0.10 · 4: 0.20 · 5: 0.33 · 6: 0.50; `chapter()` stops at 6, so `chapter:6` stays true in free play | the ladder; never said as a percent in text |
| eased | 0.10 (`easedFraction`), set when `G.story.seen("c6_quill_answer")` is wired: **not wired** (F-075) | "a tenth, as in the old days" |
| assumed | patches (field 420, orchard 630, glasshouse 630) + the producing nodes whose station category is mill, kiln, smith, wood, process, textile, craft, level x 420. **It does not count** the farmhouse, sun room, windmill building, greenhouse building, barns, roads, wells, the tea hearth (cat `cook`), stoves or ovens | Quill's pressure names only things that count: the **glass kiln**, the **cheese vat**, presses, looms, orchard patches. Never promise "the farmhouse is now charged" (M4) |
| cap | `due = min(share, max(200, 0.25 x sales))`: a quarter of the till **above 200 bronze**; below that the cap is 200 | Pieter's rule, with the floor in mind |
| arrears cap | `min(owed + due, 2 x due)`; a quiet season can *shrink* arrears (M6, harmless) | "the Book has no page for a third" |
| due | at every season end (30 steps) | Share Day |
| while owed | `blocks_coins()`: **nothing can be bought with coins**; `buy_seeds` and `buy_item` refuse with "The Lord's share first: pay Pieter at the gate"; 82 of 467 nodes cost coins, so building stops too; selling, making from stock, farming and trips go on. **Barter is coin-bound** (`barter_gate` runs through `pace.pay`; the only barter recipes, `culture_1`, `import_broker`, the gate merchant's axle, all cost coins) | the story says what the game says: pay the man first |
| counters | `lord_owed` (bronze now owed; true only from season end to payment, so a child who pays at once sees it for a few steps), `lord_paid` (**bronze paid in all, a sum, not a count**), `lord_shares` (seasons charged) | re-key anything that counts payments to `lord_shares` |
| tuning | share about 6 % of sales in ch3, about 19 % in ch4; cap binds from ch5 (near-certain by the note's own arithmetic) | felt rates 6 / 19 / 25 / 25 |
| share counts | ch3 about 1 to 7, ch4 8 to 14, ch5 15 to 16 (two season ends), ch6 17 to 21 | checked by the reviewer (M10) |

## 9. The Count's one reply, and the Lord's paper 🔒

- **Grey salt.** When Quill's three-column count reaches the grey clerk, the next grey barge ties up at the Landing and **takes nothing**. A single block of grey salt is left on the quay. No note. The village, which has held its breath at every quarter-end, breathes out; the children lick the block. Player reading: *someone downriver said yes* (and the barge carried grain before; the salt is bread's word). Berit's margin on the salt card (dossier E-3.R41) has already told the player what salt means on a table.
- **The hook-outside paper (revision 2, DECISIONS).** With the tenth, Quill's paper has a second sheet in the Lord's own crooked hand and seal: **"Hook outside, hay inside. For every barn in the valley. —W."** It is Berit's rule, the village's rite (02), adopted as law. It blames no one, it is the Lord's repentance that is not a speech, and it holds whatever 04 finally says about how the flame reached the hay (the lantern hung outside; the order never existed).
