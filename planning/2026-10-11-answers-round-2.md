# Decision round 2 (2026-10-11): Claude's questions with the parent's answers (kept word for word)

Each round is Claude's question list, with the parent's answers written into it. Kept unchanged as the safety net for
`TODO.md` §2 and `PROJECT-LOG.md` §2.8, where the decisions are summarised.

---


### The two explanations
**Replay after many quiz questions.** When you come back from the Time Quiz, the farm replays what happened step by step: the wheat grows a stage, weeds come back, signs change. If a child answers 8 questions in one go and each step takes about a second, they’d wait 8 seconds before they can play.
* **(my pick)** Cap the whole replay at about 3 seconds. Steps play faster when many questions have passed.
* One step per second no matter how many questions passed.
* A tap skips the replay.

Answer: That's not what I meant with the one question. I meant that when you come back from the quiz you have a moment before the changes start occurring. my impression is that tapping the back to the farm button leads to needing a moment to letting the attention focus on the farm screen again and then after that the changes can occur. they can basically occur more or less simultaneously or maybe some of them can be staggered a bit or explanations can pop up at the bottom or wherever. So coming back to the farm after eight questions makes the same 0.7 seconds pass or the same one second pass as coming back to the farm after one question. So it is capped at exactly one second or maybe even less than that. 

⠀**Upgrade benefits beyond saving energy.** About half of all upgrade effects only make a job cheaper in energy (a sharper knife costs 20% less energy to prepare food). The child never sees that happen. The file progression/upgrade-benefits-ideas.md proposes other kinds of benefit you can see: more output, faster, worth more, keeps longer, a new recipe, visible on the farmer. Since your energy answer makes energy matter more and quality is now on the table (A4 below), the question is the general rule:
* **(my pick)** The first tier of each tool saves energy; later tiers give a visible benefit. If you agree, we go through the 48 affected upgrades together.

Answer: I see. Well, to me it doesn't need to be a blanket rule, but it's a okay starting point as far as I'm concerned. It's okay for me if the first tier often times saves energy, but sometimes it also provides a other benefit like having a better basket improves the capacity for carrying more stuff or depending on what the tool or the building upgrade or or whatever it is. so I'm okay with it as a general rule of thumb but not as a hard rule. 

⠀Tier 1: these reshape a lot
**A1. Does a market trip use up a Time Quiz question, or does time move without one?** You said one trip costs one time unit. Today the strongest rule in the game is “farm time only moves with right answers”. This decides the trip flow and whether that rule survives.
* **(my pick)** Confirming the packed bag opens one Time Quiz question, and answering it is the walk, the same as the forest. The rule survives. --> Yes, this is what I meant. 
* Time jumps forward one step without a question, which breaks the rule.


⠀**A2. How far does the shift to crafts go?** Rope, reed baskets, clay pots and herbs should matter as much as food, and the early game should lean on skills rather than many fields. Today chapter 1 and the whole merchant ladder run on dishes: 18 dish deliveries open 14 merchants, and every pet needs a special dish. This decides whether chapter 1 needs redrawing on paper before anything else.
* **(my pick)** A new chapter-1 flow written on paper first. From then on, merchants and favours accept made goods (a basket, a pot) as well as dishes, so “dishes are the research” becomes “the things you make are the research”. The later chapters get rebalanced gradually.
* Crafts only in chapter 1, and the rest stays as it is.
* A full rebalance of all six chapters at once.

Answer: As far as I'm concerned, we can just add more craft stuff and leave the dishes as they are. or maybe some of the unlocking can be replaced with a very nicely crafted pot or we already have medicine unlocking something so the unlocking mechanisms can stay in place for the most part. Maybe they can be replaced here or there. But my point is that crafted things could expand and what the player creates and sells quite a bit so far. crafted items were mostly for improving energy or making the building of certain things possible, which is fine. I want to keep that, but we could actually let the player create... I don't know, for example, hammers and sell those. So creating a hammer one time in order to unlock the ability to build certain things is fine, but But why not actually put shovels and hammers and baskets and all these things on the list of things that the farmer can sell. Now what I foresee here is that this is going to make the menus very crowded because this is gonna make for a lot of things that can be sold and created. So, we will have to think about a way to make the storage menu easier to navigate in the sense that it's easier to see what you have and the grid to be more efficient. maybe we don't need to have a button next to every item in the storage for example. Maybe the storage can just be a very efficient grid of the things the player has and how many of them and which are about to go bad or something like that. I don't know. maybe need some more thought. 

⠀**A3. How does the energy drain work?** You’ve decided that time passing can drain energy and that health and kindness mostly prevent the drain. Open parts:
* **What makes the drain grow?** Options: the number of buildings and animals; the number of patches planted; the chapter. **(my pick)** A mix of how much is running on the farm and how much you carry. --> These are all good candidates. I think your pick makes the most sense so far, but let's keep it flexible for now and lean towards your pick. 
* **How bad can it get?** **(my pick)** At complete neglect, the drain eats at most about a third of what Rest gives. The child should never feel they rest after every two questions. --> No, the drain should be quite substantial at its maximum, so maybe a third of the maximum amount of energy available to the player for every time unit. But that's the maximum drain. I mean, it usually doesn't get that bad. 
* **When does it start?** **(my pick)** In chapter 2, together with the simple face on the farmer, so its cause is always visible. --> ok
* **The happy boost after helping someone:** **(my pick)** it reuses the food bonus system: less drain, or a small gain, for a number of questions. --> If you mean that it shifts the energy per time unit effect For a while then yes, if you have zero drain or gain then afterwards there should be a little bit of gain per time unit for a few time units and if you are at a drain, let's say minus 2 energy for each time unit, then it might shift it to plus one or something like that. But these are just example numbers to get the point across the actual effect. we'll need to be calibrated to whatever else is going on in a given chapter. 
* **The bed** (still open from last time): the bed keeps giving extra energy per Rest answer, and passive rest comes from other things. Or the bed becomes passive rest. --> Well, with the new system, the bed will contribute to the sleep parameter and the sleep parameter parameter is one of a number of parameters that aggregated influences the energy system, the maximum capacity, the energy per rest quiz math question, but also the drain or gain per time unit. 

⠀**A4. Quality of goods.** You want better-made dishes to fetch better prices. The log has an old decision: “Quality stars: no”. This is a bigger change than it looks: every recipe, the store, prices and orders need a quality dimension.
* **(my pick)** Reopen it, simply: two levels, ordinary and fine. Fine comes from better tools, ingredients or skill. It also gives many upgrades their visible benefit. --> Let's do three levels. Level one could be below average. level 2 is average and level 3 is above average. These could have better names but that is the idea of it. Maybe they could have somewhat humorous names. 
* Keep “no quality”. Better prices then come only from favour with merchants and from supply and demand. --> nope, the quality system makes sense

⠀**A5. Which systems are frozen, which work hidden, and which don’t exist yet?** You said it’s mixed and we should go through the categories. A first draft to correct:
| **System** | **Before it’s shown** | **Becomes visible when** |
|:-:|:-:|:-:|
| Item weight and carrying | works, unexplained (the bag simply fills) | the first market trip |
| Energy drain and wellbeing | frozen | chapter 2 (the face appears) |
| Happy boost from helping | works, unexplained | a book explains it |
| Sustainability (forest, water, clay) | frozen | chapter 2–3, through the grandmother’s book |
| Market prices changing | frozen | the first season with market news |
| Merchant favour and trust | works, unexplained | the merchant says so (“for you, a better price”) |
| Forest screen | doesn’t exist | chapter 5 |
### Tier 2: each one shapes a system
**B1. Saving seeds.** Real numbers:
* One wheat ear has about 30–50 grains.
* Medieval fields gave back only about 3–5 grains per grain sown, after losses and what had to be eaten.
* So 5 is both game-friendly and historically honest.

⠀Two refinements:
* **(my pick)** Make it simpler and more accurate: the harvested grain *is* the seed. One item you can plant, mill or cook, unlocked by a knowledge card. No conversion step.
* **Which crops can save seed:** grains, beans and peas easily. Carrots, onions and beets only flower in their second year, so buying carrot seeds in the village is botanically true. That gives you the reason for the first trip for free.
* **Consequence:** wheat seeds will soon never need buying. The Seed Library (heirloom crops giving back their own seed, chapter 5) then keeps only its heirloom role.

⠀**B2. The market trip, step by step.**
* **(my pick)** Pack the bag → one Time Quiz question → the market square opens. There you sell what you brought and buy within the room left; unsold goods come home.
* **Trips with an empty bag, just to buy:** allowed. **(my pick)** yes.
* **Do dish deliveries ride in the bag?** You said dishes take room like anything else. **(my pick)** Yes, so a delivery happens on a trip, on the market square.
* **The travelling merchant at your gate:** no trip, no energy cost. **(my pick)** He pays a little less than the market (his cut), so convenience costs something.
* **The cart axle bought by barter with the travelling merchant:** barter already exists in the game for two later merchants. **(my pick)** Use barter early as well.

⠀**B3. Trust in the village.**
* **One trust level or several?** **(my pick)** Each merchant or person has their own trust, plus a village-wide reputation that rises as the farm visibly recovers.
* **What trust changes:** what’s on offer, and the price.
* **Exceptions:** the story files have Granny Maud (the grandmother’s old friend) and young Greenstem as kind from the start. **(my pick)** Keep one or two exceptions; total distrust is bleak for a child.
* **“Helping without expecting anything back”:** favours currently reward you visibly (album picture, luck, a friend, postcards). **(my pick)** Keep the rewards, but make them a surprise rather than something promised on the button.

⠀**B4. Prices and coins.**
* **Which reality to copy?** **(my pick)** Today’s Swiss prices for things the child knows (bread, eggs, milk, a basket), so it’s a real-world skill. Old-world ratios for the rest. Seeds sold by the bag, so tiny prices don’t matter.
* **Gold coins:** 100 bronze = 1 gold, like Rappen and Franken. **(my pick)** Once gold appears, always show both (2 🟡 35 🟤).
* **Season price changes:** market prices change at each season with a short news line. **(my pick)** Costs of goals (buildings, books) never change once shown.

⠀**B5. Sustainability details.**
* **Felling trees at the forest edge** is new: today logs come from the merchant, the woodlot and cut orchard trees. **(my pick)** Make felling the early source of logs. Trees become stumps, stumps become saplings, saplings become trees over a number of questions; over-cutting leaves mostly stumps. It also echoes the family’s old mistake of cutting into the forest edge. It needs tree, stump and sapling art.
* **Stones:** you remembered stones as bought only, but today the forest edge has *Pick stones* and later *Dig out stones*, and frost lifts stones in the fields every winter. **(my pick)** Loose stones at the forest edge slowly run out and don’t come back. Field frost stones stay. Big amounts come from the quarry merchant.
* **Clay:** **(my pick)** the clay pit refills slowly.

⠀Tier 3: smaller
* **The Lord’s climb-down in chapter 6:** because of Quill’s numbers, or because of the Fair ribbons? You said yes without choosing. **(my pick)** Quill’s numbers: the steward who has been counting all along finally speaks.
* **The cousin:** girl or boy? Still open.
* **Free play after chapter 6:** the last frame plays when chapter 6 ends. **(my pick)** Free-play goals still show a short box when they tie up a loose end, without the grandchildren.
* **The chapter 6 bend:** you’ve decided it’s deterministic, like every chapter end. So there’s no tap to choose; I’ll update the outline.
* **Playing:** a party at the farm, music, art, visiting another farm. **(my pick)** A visit works like a market trip: a scene that costs a time unit and energy.
* **Hay and straw, my proposal:**

⠀**Use** **Hay** | **Straw** |
|:-:|:-:|---|
| Animal food | good | poor (filler) |
| Bedding | yes | yes |
| Compost | yes | yes |
| Thatched roof, beehive skeps | no | yes |
| Mulch | no (its seeds bring weeds) | yes |
* **Title,** ***Hazelwood Harvest*****:** a quick check found no game with that name. Only a town festival in Missouri called “Hazelwood Harvestfest” came up (~[flovalleynews.com](https://flovalleynews.com/?p=18124)~); app stores still need checking. For German, keep the English name or translate it (“Haselwald” or similar)? --> nope same name as English, keep the English

⠀Tier 1 matters most here, especially A1 and A2: a new chapter-1 flow on paper depends on them. The computer is linked again, so once you’ve answered, I’ll write all of it into TODO.md, the log and the story files in one go.
