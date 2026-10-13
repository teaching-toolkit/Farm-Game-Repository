# Chapter 1 on paper (D2): the new start

13 Oct 2026, written during phase 7 (the parent is away; everything marked 💡 is a proposal that is easy to change in the data). It follows
the sequence the parent confirmed on 11 Oct (`planning/2026-10-11-answers-round-3.md`, question 5) and the rules decided since: the grain is the seed
(U2), crafts are made again and again to sell (U4), hay is a crop (U1), winter wheat and onions in chapter 1 (U5), no merchant at the farm at the start,
a first trip that carrot seeds force (M6), the travelling merchant who passes by and an axle bought by barter (M7, D2), a first cart (M5).

## The sequence

| # | What the child does | What the game offers | Numbers 💡 |
|---|---|---|---|
| 1 | Reads the book (first card, *Growing wheat*) | the story's stalk and book (story pieces c1_stalk, c1_book); the card unlocks wheat | start: **1 grain**, a tin pot, 3 sticks, 3 stones, 10 ⚡, 4 💧, one cleared patch that holds 1 plant |
| 2 | Plants the grain, answers questions, harvests | **one stalk grows into one plant**: 1 grain sown → **3 grains** back (2 questions to grow) | wheat yields 3 grains + 1 straw per plant; no seed price (the grain is the seed) |
| 3 | Reads the card *Saving seed* | a short card: a grain you keep is a seed; keep some back before you eat or sell | new card `k_seeds` (2 quiz questions), after *Growing wheat* |
| 4 | Clears the thistles and the weeds (more patches), sows more | a few patches of wheat, 1 plant each (more with patch upgrades); water from the pond | patch cap 1 at the start (data) |
| 5 | Builds the campfire, cooks porridge | the first food: 2 grains → 1 porridge; the first coin is still in the village | porridge worth 60 🟤 |
| 6 | Builds the workbench; crafts from what is at hand | **rope** (3 fibre), **wicker basket** (6 sticks, 2 fibre), **clay pot** (2 clay, fired at the fire; clay is dug at the field edge with the shovel); all can be made again and sold | rope 30, basket 180, pot 130 🟤 (a craft can be made again and again) |
| 7 | Wants carrots (the bunny's bowl needs them; there are none anywhere, so the first seed must be bought) | the **signpost**: the farmer packs porridge and crafts and goes: **one question on the way, 3 ⚡** | carrot seeds 30 🟤 each at the village |
| 8 | **The first trip**: sells porridge and crafts, hands over the first order (2 porridge), buys carrot seeds | the village square; the seller says the cart road is the next thing; trust ♥ | the seed seller sells carrots (seeds) and, as a safety net, a sack of grain (45 🟤) |
| 9 | Mends the road (brushwood, potholes) | carts can come: the **travelling merchant** passes the gate now and then | road level 2 |
| 10 | The merchant has an **axle** he will barter | bought by barter with him: **900 🟤 and 2 wicker baskets** (an axle is expensive) | axle value 900 🟤 |
| 11 | Builds the **hand cart** (the first cart) | the bag holds 60 load units instead of 30 | axle + 2 logs + 2 rope + 6 sticks + 8 ⚡ |
| 12 | Grows **hay** (meadow grass) for the hens and the bunny's hutch; sows **winter wheat** in autumn; grows **onions** | the first autumn's season text points to winter wheat; the first winter comes near the end of the chapter | hay yields 2 hay per plant; winter wheat grows slowly in winter, 4 grains per plant |
| 13 | Cooks the Carrot-Clover Bowl, builds the Straw Hutch | **the bunny comes home** (the chapter ends) | as today |

## What is new in the data (phase 7)

- Start with a grain instead of a seed (done); wheat has `seedItem: wheat` and no `seedCost` (done); the village seller sells carrots (seeds) and, for emergencies, grain.
- New items: `wicker_basket`, `clay_pot`, `axle`, `hay`. New recipes: `wicker_basket` (workbench), `dig_clay` (field edge, shovel), `clay_pot` (campfire). Crafts sell at the village and to the travelling merchant.
- New cards: `k_seeds` (saving seed), `k_hay` (meadow grass), `k_winter_wheat`. New crops: `crop_hay`, `crop_winter_wheat` (sown in autumn or winter only: `sowSeasons`).
- The travelling merchant gets a trade list with barter: the axle. A new node `hand_cart` (device, capacity 60).
- The story: the seller's story piece is told on the square, not at a campfire (c1_seller).
- Left for later phases: the fuller seed-saving rules for carrots, onions and beets (they flower in the second year: phase 10), winter kale (phase 10), the Lord's share (phase 8), strength and carrying (phase 9).

## Check

The bot plays the whole of it (`tests/bot.gd`: the first trip, the barter, the cart); the goldens and the pace are re-recorded. The aim: chapter 1 takes about as many questions as before (235 in seed 1), not twice as many.
