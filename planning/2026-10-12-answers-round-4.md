# Decision round 4 (2026-10-12): Claude's questions with the parent's answers (kept word for word)

Each round is Claude's question list, with the parent's answers written into it. Kept unchanged as the safety net for
`TODO.md` §2 and `PROJECT-LOG.md` §2.8, where the decisions are summarised.

---

This round closes most of what was open. Five things are left, and the first one matters most. After that I'd stop asking and write everything down (proposal at the end).

## Settled this round

* **Back on the farm after the quiz:** a short pause, then rain first (if it rained), then the plants flick quickly through their in-between stages, together with pests and a merchant coming down the road. The energy change gets its own animation (the bar pulses, a "−4" floats up and fades).
* **Energy:**
  * The home sets the base; the parameters dial it up or down and set the gain or drain per question.
  * Each parameter has its own job: sleep → energy per right sum; food and strength → the maximum; friends, calm and play → gain or drain per question.
  * The maximum drain is about 1.5 sums' worth. Parameters sink slowly, with a warning, and recover a little faster. At zero energy the drain simply stops.
* **The bed:** shown plainly as "+1 ⚡ per right sum" from chapter 1. That it runs through the sleep parameter is never mentioned, so there's no clash.
* **Quality:** mostly predictable, with a small chance of one level up or down; the recipe tile shows what to expect. Crops, dishes, crafts and medicine have it. Below average sells for about 60%, above average for about 150%. Key deliveries ask for at least average, and the badger needs above-average medicine. English names: **Lumpy / Proper / Fancy**.
* **Store:** compact tiles with small text, a row of filters (the categories to start with), no sell buttons.
* **Trip:** pack → confirm → exactly one quiz question → the market square → back home.
* **Seeds:** every unlocked crop's seeds can always be bought, and every crop can also make its own seed.
* **Chapter 1** follows the rough sequence, with your clarifications:
  * Clearing more patches before the village is fine.
  * Carrots: there are none anywhere, so the first seed must be bought.
  * A handful of seeds is cheap; an axle is expensive.
* **The cousin:** a girl.

## Still open

**1. What do coins get spent on, again and again?** This one matters most.
Once seeds come from your own harvest, the seed merchant stops being the regular expense. Without regular spending, coins pile up and selling stops meaning anything. What's left today: books, animals, materials you can't make (iron ore, salt, glass, sand), parts (the axle, wheels, nails), the coin part of buildings, and new crops' first seeds.
* **A.** That list alone, with more parts and materials added to the crafting chains.
* **B.** A, plus recurring services: borrowing a donkey for a trip, paying a helper, repairs.
* **C. (my pick)** A, plus the **Lord's share** as a real payment. The story already has it but keeps it out of the numbers.
  * From chapter 4, when Quill arrives, a small share is due each season.
  * In chapter 6 the Lord's letter asks for "a half" again, and Quill's numbers bring it down to "a tenth".
  * The story's central theme ("more" destroys what "enough" keeps) would then be felt in the coins.
  * **The risk:** a payment the child can't make. **Rule:** it can always be paid in goods instead of coins, and it's never more than one good season's sales.
Answer: I can agree with your recommendations, for the most part. We can extend the reasons for spending by. Making certain products comparatively cheap to buy, at least compared to the time and energy and pro materials that the player would need to invest to make the thing itself. In this case, I can become a better choice to buy certain things, outsource the. Labor and investment. My idea here is that becoming more skills at crafting or cooking. Something will bring down the amount of raw materials that you have to use on the thing as well as the time and the energy. And while it is theoretically possible to become highly adapt at everything, it can make a lot of sense to focus on certain areas, and really become a master there first, outsourcing the other areas.￼ This is a major system element to add in general: honing a skill, tools, buildings etc. can lead to less energy, more carrying capacity, etc. as established, but some upgrades / improvements / learning can lead to less waste regarding input. So for example you don't need as many reeds for the same basket. So while making your own steel from iron ore you buy is technically possible, it takes a lot of knowledge and training (that you only get through many repetitions of crafting the thing or something in a similar category) and upgraded tools that may not make it worth it unless you want to go down the path of focusing on metal stuff. Even if not visible to the player at first, a skill tree in which mastery is somehow measured makes sense, tracking the amount of training. But in a way that doesn't get out of hand. Make sure to invest enough thought into this question to make it well designed in terms of usability that doesn't sacrifice detail unless necessary.
And regarding the payment each season: this arrives in chapter 2 or 3. Until then the farm is under the lords radar. It has been a abandondend ruined burned plot for the last years after all. The more plantable fields you have the more you need to pay, regardles of yield. That would be the kind of logic that would drive farmers to need to extract more and more. And the fraction could increase each chapter, paralleling the origin story. If the player can't pay they are blocked from spending on anything else until they have the necessary amount for paying the lord.

**2. Packing: four details.**

* **Does packing take things out of the store?**
  * **(my pick)** No. Packed items stay in the store, marked as packed (a small 🎒 on the tile). You can unpack any time for free, and you can still eat them until you leave.
  * Packing moves them into the bag, out of the store.
* **How do you pack from a tile?** **(my pick)** Tap a tile and a small panel opens with actions (eat, compost, feed) and **"🎒 + 1 / + all"**.
* **The fill indicator on the bag icon:** a thin bar under the icon, or a pie over it? **(my pick)** The thin bar, because the energy and water bars already work that way. The numbers ("8 of 12") show in the bag window.
* **The top bar is getting full.** Planned so far: coins, water, energy, the season bar, then 🎒 bag, 📜 story scroll (it was going to replace the 🎒 pantry, which now becomes the bag), the wellbeing face, 📖 quest book, 🖼️ album and ⚙️ settings. That's six icons on an upright iPad.
  * **(my pick)** Put the face **at the end of the energy bar**, since wellbeing drives energy; tapping it opens the dashboard. That saves an icon and shows the connection.
  * Or a separate icon. I'd check the layout with a screenshot before building either way.
Answer: I looked at the top bar and there's plenty of space. I'm actually thinking of moving the time quizz button up there as well, hanging the green circle the watchface is right on the bottom of the bar in the right corner. The next goal text can take up the whole width and height between the energy bar and the backpack icon. When the face / health icon appears later on, it will accomodate to that. The cheat button and the +100 button are removed permanently from the bar now. In the grown up settings one can enable or disable a setting that puts them floating below the bar in the top left corner. It is +50 bronze coins though. Also add a cheat button for skipping the knowledge quiz for any knowledge card that is pending a quiz. 
Also, as of right now, when you are in the time quiz you can tap as long as you want till you get the right answer by chance and that still progresses the time. You need to get the right answer on the first try to progress time by one unit. Also make sure the repetition of the knowldege card that was not answered correctly comes back right after the next one. E.g. continent number wrong --> where does milk come from correct --> continent number card comes back. 
Further UI todo: the notifications should behave like notifications on a phone, stacking from above below the top bar and as the player you can swipe them away if they don't leave fast enough for you.

**3. How long does a carrot take to make its own seed?**
In reality, carrots, onions and beets only flower in their second year: they must stay in the ground through a winter. You said "a few more time units".
* **(my pick)** Realistic: a plant left to seed must go through one winter, then gives a lot of seed in spring. It's a lovely lesson about seasons, and since seeds can always be bought, the wait never blocks anything. Meanwhile the patch grows nothing else: a real trade-off.
* Simplified: a fixed number of questions (say 6–10) in any season.
Answer: Yes, your pick is wonderful. Also, flowering and whatever other seed making techniques are out there need to be earned through knowledge cards. And the seasons need the trees and the grass to look visibly different. Winter shouldn't just be snow all the time, but muted colors and snow falls like rain and then stays once it has fallen. You need to clear the patches from snow if you want to plant. Think of a cheap way to visually cover the building roofs with snow, without having to create a new picture for each one. And we might tighten what crops are available in winter. Maybe some just take forever to ripen. And there is a text that appears at the beginning of each season explaining this stuff.

**4. Quality names in German.** They must fit food and tools alike:

* **(my pick)** **Naja / Ordentlich / Picobello**. "Picobello" is playful and works for porridge and hammers.
* Mau / Gut / Prima
* Hoppla / Ordentlich / Fein

**5. The return animation, in order.** Here's a proposed timing:
|  Time |  What plays |
|---|---|
|  0–0.7 s |  Pause |
|  about 1 s |  Rain, if it rained (shown once even if it rained twice) |
|  together |  Plants flick through their stages at about 0.3 s each, weeds appear, pests come, a merchant starts walking in |
|  last |  The energy bar pulses with the floating number; short explanations appear at the bottom |
* **(my pick)** It **never blocks the child**: any tap jumps straight to the finished state. That's what makes it easy to ignore once the child knows it.

## After this round
I'd write it all down instead of asking more:
* the decisions into the log,
* `TODO.md` rebuilt around them,
* a new design-document chapter, marked as planned, for each system: energy and wellbeing, trips and packing, quality, seeds, money, sustainability.

Then I draft chapter 1 on paper. That draft will bring up the real numbers (how many seeds, what an axle costs, how heavy a basket is) much better than more questions now. Shall I go ahead once you've answered these five?