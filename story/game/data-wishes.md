# Data wishes (24 Oct 2026)

Game-data or engine changes the story would like. **Nobody has edited any `data/` folder or any code**; this list is for the parent and the game agents. Merged from slices 01 to 07 and the master outline. ✅ means the parent has said yes (the answers of 24 Oct 2026); everything else is 💡. In each row, "story fallback" says what the story does if the wish is never built.

## A. Settled by the parent (to be built by the game agents)

| # | Wish | Why | Story fallback |
|---|---|---|---|
| 1 ✅ | `pet_tortoise` requires `pond` (00-4c) | the tortoise comes home to a pond that was a debt | she sits at the dry edge; E-2.H11 reads the same |
| 2 ✅ | `pet_alpaca` requires `river_meadow_drain` (00-4d) | the night garden is the climax and must not be missable | the telling moves to the barn doorframe (E-6.B25 reads the same) |
| 3 ✅ | badger default name **Silverpaw**; description fixed (00-4b) | the badger has a name | – |
| 4 ✅ | `sq_chapel_roof` renamed "Fix the Hall roof" (no religion, C12) | | – |
| 5 ✅ | "Grandma's Kitchen" renamed "The Kitchen Book" (C18) | Berit's book | – |
| 6 ✅ | mill: one building, a wheel stopped by the silt and a windcap with sails that turn again in chapter 6 (02-21) | settles both shipped pieces | – |
| 7 ✅ | the Fair has no date, "called by full tables"; triggers use `done:d_fair_*` (02-22) | works in any season | – |

## B. Engine and trigger corrections (from the review of slice 07; plain words)

*What this is, for the parent (question 07-44): the story and the game's counting of the Lord's share do not quite agree in six places. None of these is a story question; each is a small fix that the game agents decide.*

| # | Problem in plain words | Wish | Story fallback |
|---|---|---|---|
| 8 | `lord_paid` is the coins paid, not how many times; two village seeds fired at the first payment | re-key to `lord_shares>=n` (done in the story already) | none needed |
| 9 | `c6_lord` (the Lord's letter) can fire before the chapter-5 letter and frame | `seen:c5_frame5` | the order in the master outline assumes the fix |
| 10 | `c6_quill_answer` can come before the Fair and before the bend | `done:farmhouse_sunroom + seen:c6_bend + after:c6_bend:3` | – |
| 11 | `eased` (the tenth after the bend) is set by nothing (F-075) | set `eased` by `seen:c6_quill_answer` | without it the story says "a tenth" but the game does not show it |
| 12 | the quarter-of-the-till cap binds only from chapter 5, so the felt shares are about 6, 19, 25, 25 per cent and the eased tenth feels like a halving | `eased` lowers the cap; verify with the bot | the story uses the cap on purpose (Pieter's mercy) |
| 13 | no "late" term and no "Share Day" term; "unprepared" cannot be tested (no negation) | a `share_day` term; a `lord_late` term | every occasion is a baseline plus an upgrade that can fire late |
| 14 | every barter recipe costs coins, so there is no way to trade without coins (no "Hold") | optional zero-coin barter | no barter in the Lord's thread |
| 15 | the lease can be found as late as chapter 6 | main-path Table carriers (the salt card, Pieter's scene, the tin) | already three carriers |
| 16 | the tea set is consumed by the badger, so `has:tea_set` breaks later seeds | no `has:` on the tea set | R24 re-keyed |
| 17 | the Pay popup could show a Pieter line per rung (a tenth: "I'm sorry"; a half: "I write a quarter") | D-6 of slice 07 | the same lines as a first-Share-Day visit |

## C. Story wishes

| # | Wish | Why |
|---|---|---|
| 18 | the goat's deed tied to `patch:scrub` (bramble bed, one bramble left standing) | E-3.H22, E-4.H28 |
| 19 | a **non-plantable tile** on the North Field | the one bramble |
| 20 | job cards that match the rhyme: bunny sow clover, goat clear scrub, pony carry to market | the Helpers' jobs |
| 21 | a `{pet}` placeholder so the player's chosen pet names appear in text | |
| 22 | idle bubbles per Helper | six small characters |
| 23 | `tap:pets` roll call (seen once) | E-6.H73 |
| 24 | a sound hook for six phrases of the melody, a *tink* and two rings in the garden, no bell at the Fair | the tune; cheapest version is nothing |
| 25 | story boxes accepting 7 and 8 pages, unskippable (the two telling pieces) | the bend and the garden |
| 26 | gatepost picture variants keyed to chapter, not season (a weathered row; one fresh stone; stones in the bucket) | Liv's stones, D11 |
| 27 | `trace` pieces are skipped by the engine; every trace seed also has a text fallback bark | the Mumyo glimpses |
| 28 | `tap:barn` and `tap:patch:marsh` exist as hooks; `weeds>=n` exists | free hooks used |
| 29 | an optional hazelnut crop; optional "The Village Buckets" helper | the village is named for hazelnuts; Bucket Night |
| 30 | a **"Where were we?" recap button** in the scroll (parent's choice B, answer 01-6) | re-anchors the frame |
| 31 | main-path nodes for chapter 5 (`ruins_stillroom`, the Healer's Chest, `pet_badger`) and the page `c5_page` made robust (C16) | the low point |
| 32 | art: nine glimpses, the glowing stones, night variants of the edge, about 11 new scenes for the Helpers; `c1_stalk_p1` | pictures |
| 33 | a free-play favour "A pie for the Hurst" (optional) | E-6.R31 |

## D. Not wishes (checked and dropped)

No engine "Hold" (the story never relies on one). The Hurst's "beasts" lever is withdrawn: the child must have no lever on the Lord's share.
