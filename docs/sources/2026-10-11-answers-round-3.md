# Decision round 3 (2026-10-11): Claude's questions with the parent's answers (kept word for word)

Each round is Claude's question list, with the parent's answers written into it. Kept unchanged as the safety net for
`archive/todo-2026-10.md` §2 and `archive/log-2026-10.md` §2.8, where the decisions are summarised.

---

### Settled this round
* **The pause after the Time Quiz:** after “Back to the farm”, always the same short pause (0.7–1 second), however many questions passed. Then the changes happen more or less together, some staggered, with short explanations popping up. --> Exactly. I was thinking that, for example, rain is something that would need to happen Staggered. When the player comes back after four time unit questions and rain occurred in those four-time units then the rain happens first because it's this big global event that draws a lot of the attention and then we see the plants growing this could be simultaneous with other stuff like pests arriving or a traveling merchant coming down the road and the plants growing can be pretty quick. So let's say we have a plant that has four stages of development and you just did four time units then we could have, I don't know, have a second per plant stage or whatever you think makes sense. It can be pretty quick anyway. Also, the energy drain or gain should be something that happens with a animation that draws attention to it maybe the energy bar pulses as it increases or decreases. And there is a floating minus or plus number hovering around the bar that slowly dissolves. But that’s just one idea. Maybe there’s better ways to do this that are more effective for the goal of showing the player what happened in the way that they can also ignore if they are already well acquainted with it.￼￼￼
* **Upgrades:** “first tier saves energy, later tiers do something visible” is a rule of thumb, not a hard rule. --> ok
* **Market trip:** confirming the packed bag opens one Time Quiz question; answering it is the walk. The rule “time only moves with right answers” stays. --> Yes, but we still need to work out how the packing works. if it's something that you do from the storage window, that it's a option that you trigger from there or if it's a window that you open by tapping the sign post that has a sign that points at the market. Right now I am leaning towards tapping on the market, sign on the signpost. And then when there is a traveling merchant tapping on the traveling merchant shows you which items he or she is is open to buying and at some point their capacity is full and they cannot buy anymore. There could of course be an animation here as well of the cart of the travel merchant filling up. and if the player has a cart or a basket or a backpack this could be standing next to the signpost that is pointing to the market all the time. And then when you pack your bag or your cart, The picture gradually fills up so the backpack becomes fuller or the basket fills with generic bag shaped things and the same thing for the cart. It just fills with bags so that it can be reused for any kind of loading.
* **Crafts:** deliveries and unlocks stay as they are, with a craft swapped in here and there. Made things like hammers, shovels and baskets also become things you can sell, so the store needs a rethink. --> yes.
* **Energy drain:** --> yes
  * Its maximum is about a third of the energy bar per question, but it rarely gets that bad.
  * It grows mostly with how much runs on the farm and how much you carry.
  * It starts in chapter 2.
  * Helping someone shifts the per-question rate upwards for a while (e.g. −2 becomes +1).
  * The bed feeds the sleep parameter. The parameters together drive the energy maximum, the energy per right sum and the gain or drain per question.
* **Quality:** three levels (below average, average, above average), with funny names. --> yes
* **Title:** *Hazelwood Harvest*, the same name in German. --> yes

⠀Tier 1: new questions that shape everything else
**1\. How do the body and mind parameters reach the energy numbers?** Today the home sets the energy maximum and the energy per right sum (tent 20/5 … farmhouse 65/9), and beds, pillows and the water bottle add to those directly. Your answer routes everything through the parameters.
* **Home and parameters together:**
  * **(my pick)** The home sets the base numbers. The parameters work like a dial on top (e.g. ×0.7 to ×1.3) and also set the gain or drain per question. --> Let's do it like that for now. We can always reduce how much is base and how much is dial later on
  * The parameters replace the home’s numbers completely.
* **One combined score, or each parameter with its own job?**
  * One wellbeing score drives all three outputs. Simple, but the child can’t tell what does what.
  * **(my pick)** Each parameter mostly drives one thing, and the face on the farmer shows the overall mood:
    * sleep: energy per right sum
    * food and strength: the maximum (strength also carrying)
    * friends, calm and play: gain or drain per question
  * This is easier to understand and teaches more (“sleep helps you recover”). --> Sounds good to me. Let's work with that.  Let's go with your pick.
* **A clash to fix: the Straw Bed.** It comes in chapter 1, but the sleep parameter only switches on in chapter 2.
  * The bed’s effect works hidden from chapter 1 on. --> I don't think this one actually has to be hidden given that energy per right sum is something that can just be declared the fact that it goes indirectly through a sleep a parameter is not really all that complicated and doesn't need to be mentioned either. You can just declare that a better bed gives you more energy per write some. We don't need to allude to any well-being/health dashboard for this. 
  * **(my pick)** The Straw Bed keeps its direct small bonus until chapter 2, then hands over to the sleep parameter. 

⠀**2. How harsh is the drain over time?** A third of the bar per question is a lot, and it gets harsher later. In the tent (20 energy, 5 per right sum), the maximum drain costs about 1.3 right sums per question just to stay level. In the farmhouse sun room (65 energy, 9 per sum), it’s about 2.4 sums per question. The bar grows faster than what each sum gives.
* **What sets the maximum drain:**
  * A third of the bar, as you said.
  * **(my pick)** About 1.5 sums’ worth of energy, so the strain stays the same across the game. --> ok.
* **How fast it builds and recovers:**
  * **(my pick)** Slowly enough that the child notices and can react: a parameter sinks over many questions, and the face warns before it sinks. Recovery is a little faster than the decline. --> perfect
  * Fast, so consequences are felt quickly.
* **At zero energy:** **(my pick)** the drain just stops. Nothing else happens; there’s no debt. --> yes.

⠀**3. What decides quality, and what is it for?**
* **What decides it:**
  * Fixed: tools, how good the ingredients were, and practice (the game already counts “practice stars” per recipe) give a predictable result.
  * **(my pick)** Mostly fixed, with a small chance to land one level higher or lower. The recipe tile shows what to expect before you make it.
  * Pure chance, with better tools improving the odds.
* **What has quality:** **(my pick)** crops (from soil, weeds and patch level), dishes, crafts and medicine. Raw materials like sticks, stones and clay don’t.
* **What it does besides price:**
  * Below average sells for less (~60%), above average for more (~150%).
  * **(my pick)** Some key deliveries ask for at least average. The badger’s “really good medicine” from the round-4 plan becomes simply “above average”, which solves an old problem.
* **Names (English / German):**
  * **(my pick)** Wonky / Proper / Splendid · Schief / Ordentlich / Prächtig
  * Lumpy / Solid / Fancy · Krumm / Solide / Fein
  * Oops / Good / Wow · Hoppla / Gut / Wow
Answer: I agree with everything in the section 3. As for the names, I like lumpy, proper and fancy. In German the names still need to be general enough that they can both apply to food or two tools. Right now they just applied to tools, sounds weird to apply those words to food.￼￼


⠀**4. The store, now that selling happens through trips.** Selling now works by packing the bag (or loading the merchant’s cart), so the store no longer needs a sell button on every item. With quality, many items will exist in up to three versions, and sellable tools add more.
* **(my pick):**
  * **The store** becomes a compact grid of small tiles: picture, count, a stale badge, and small dots for the quality levels. Tabs by kind: food, crafts and tools, materials, crops. Tapping a tile opens a small panel (eat, compost, feed, pack).
  * **The packing screen** reuses the same grid: tap an item to put one in the bag, with the bag’s fill bar on top.
  * **Tools as sellable things:** the first one you make still unlocks its abilities. After that, the same recipe makes more to sell.
* Alternatives: a list with filters, or keeping sell buttons only for the travelling merchant at the gate.

Answer: yes, but we also need text for each tile. The text can be smaller than usual though. I like the filter idea. Basically we could just have a row of filters, which are mostly the categories, but that gives us more flexibility for changing what can be filtered for in later versions of the game. The way I am envisioning packing right now is that you select things in the storage window and as you do this, the backpack symbol on the top right in the Status bar fills up someway. I’m not sure how to best to do this visually. If there is a pie chart overlaying the backpack? Or if there is a ￼thin bar underneath ￼ the backpack symbol that fills up as you pack more items? And then if you device for carrying things is for you can either tap the backpack I can at the top or the picture on the screen of the cart or the backpack or the basket or whatever and in that window, you can put stuff back because you have a grid of the things that were put in, sorted by how much space they take up in the carrying device.￼￼

⠀Tier 2: a step down
**5\. A new chapter 1 on paper, before anything is built.** Saving seed from grain, crafts before fields, no merchant at the start and a first reason to visit the village all change the opening. **(my pick)** I write the new chapter-1 sequence on paper next, starting from this rough order:
| **Step** | **What happens** |
|:-:|:-:|
| 1 | One stalk grows into one plant |
| 2 | A card about saving seed: the grain is the seed |
| 3 | A few patches of wheat, porridge |
| 4 | Crafts from what’s at hand: fibre rope, reed or wicker baskets, the first clay |
| 5 | The farmer avoids the village until something forces a trip: carrot seeds (carrots only flower in their second year, and the bunny’s dish needs them) |
| 6 | First trip: sell crafts and porridge, buy carrot seeds |
| 7 | The travelling merchant passes by; barter for an axle; the first cart |
| 8 | The bunny comes home |
Yes, or change the order?

Answer: yes to the sequence, but I want to clarify a few things. Crafts before fields doesn’t mean that the player can’t get rid of the weeds and stumps and rocks in a few more patches before getting the carrot seeds. And the reason for going to the village for carrot scenes is because there’s just no carrot seeds available. None are flowering in the second year because there aren’t no carts at all. And the way that we are designing flowering plants like carrots, and onions right now, gives the option to leave them in the ground to flower instead of harvesting them from the get-go. But that requires a initial plant, which a player does not have. So you do need to buy at least one first seed. And here we also need to make sure that the prices make sense. Buying a handful of seeds is not that expensive I assume. Buying an axle is probably quite expensive though. So given that the player can make their own seeds, and buying seeds is mostly for getting started with a new crop, ￼that will change what regular spending in the market will be about.￼￼

**6\. The trip flow.** **(my pick)** Pack → confirm (energy is taken) → exactly one quiz question → the market square opens straight away (not the farm) → sell, buy, deliver → back home with the usual short pause. Should the quiz allow just that one question on a trip, or let the child keep answering? I’d say one.
—> yes

**7\. The pause after the quiz, one detail.** If several growth stages passed, should the wheat jump straight to its final stage, or flick quickly through the stages in between? **(my pick)** Jump. Also, the explanations at the bottom are the natural place to show the energy change (“3 questions: −4 ⚡, you were tired”), so the drain is never invisible.
—> I want the plants to quickly flick through the stages in between not jumped to the final stage. That way we have a impression of the growing happening. Basically, when the player comes back to the farm after doing the time questions we see aimed version of sped up time.￼

### Taken as accepted unless you object
* **The hidden/frozen/visible table** from last round. Earlier you placed sustainability after the grandmother’s book note in chapter 2–3; the table matches that.
* **Seeds:** the grain is the seed. Seed-saving works for grains, beans and peas; carrots, onions and beets are bought. The Seed Library keeps only heirlooms. —> almost, seeds for every crop category that is unlocked can be bought at any time, but carrots, onions, beets, and other crops that don’t automatically turn into seeds can still be made into seeds by yourself by doing stuff like leaving them in the ground for a few more time units to let them flower or whatever. So self sustainability is possible for every crop.￼
* **Trips:** empty-bag trips allowed; deliveries ride in the bag; the merchant at the gate pays a little less; early barter.
* **Trust:** each person has their own, plus a village reputation. Granny Maud and Greenstem are kind from the start. Favour rewards come as surprises.
* **Prices:** today’s Swiss prices for familiar goods, old-world ratios for the rest. 100 bronze = 1 gold, both shown once gold appears. Building and book prices never change once shown.
* **Forest and quarry:** trees, stumps, saplings and regrowth at the forest edge; loose stones there run out, frost stones in the fields stay; the clay pit refills slowly.
* **The Lord:** his climb-down comes through Quill’s numbers.
* **After the story:** free-play boxes tie up loose ends without the grandchildren. The chapter 6 bend triggers automatically, like every chapter end.
* **Visits and play:** a visit to another farm works like a market trip.
* **Hay and straw:** the table as proposed.
Yes, to all of these except for the one that I commented on.￼

⠀Still open from before: is the cousin a girl or a boy?
—> I did saythat a girl is the default for now.￼