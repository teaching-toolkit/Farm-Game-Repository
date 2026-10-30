# Chapter 1: Ashes — more pieces (English only)

Round 6b, draft 1 (14 Oct 2026). New pieces that fill the long silence of chapter 1 (after step 13 the test bot saw nothing until the bunny at step 244). Existing pieces: `ch1.md`. All 💡 until the parent has read them aloud. Format as in `ch1.md`; extra lines per piece: *Register* (G giggle · W warm · T tense · A awe), *Move* (the Keeper's moves, `../outline/long-game.md` §3). Second person, `{player}` for names, nobody speaks about the farmer in the third person, the Helpers do not talk. Triggers are game conditions (list in `../immersion-triggers.md`). Consistency pass of 14 Oct 2026 applied (`../consistency-fixes.md`). Invented here, to accept or overrule: Berit's margin notes (thin brown ink); the stool left by the track (`c1_trips20`) and the tower of rocks (`c1_tower`), both left without a face; the bookseller at the cart (a man).

## c1_fire · moment · The first fire
*When:* `done:campfire` · *Register:* G→W · *Move:* Complication

The first spark sulks. The second one dies of embarrassment. The third one catches, and you lean over it until your eyebrows complain. A fire, in this place. The ash around it glows a little, as if it remembers something.

## c1_first_harvest · moment · One becomes many
*When:* `harvests>=1` · *Register:* W · *Move:* Reward

You cut the stalks and tip the grains into your hand. Count them. One grain went into the ground. Look at them now. You close your fingers round them, carefully, the way you would hold a baby bird.

## c1_first_card · moment · A coin in the pocket of your head
*When:* `cards>=1` · *Register:* G · *Move:* Level-up

You finish the card. Something you did not know is now something you know, and it sits in your head like a coin in a pocket. You pat it.

## c1_weeds · discovery · Weeds
*When:* `tap:patch:weeds` · *Register:* G · *Move:* Arrival

Weeds. Of course. They came back to a burnt field before anything else did, which tells you something about weeds. You pull one. Its root is longer than your arm, and very proud of it.

## c1_rocks_tap · discovery · Rocks
*When:* `tap:patch:rocks` · *Register:* G · *Move:* Arrival

Rocks. You lift one. Under it is a smaller rock, looking surprised. Under that, another. Whatever lives down there has been collecting rocks for a very long time.

## c1_forest_tap · discovery · The forest edge
*When:* `tap:forest + chapter:1` · *Register:* T · *Move:* Omen

The forest starts where the field gives up. The trees stand close and very still, like people who stopped talking when you walked in. A path goes in between them. You do not. Not today.

## c1_road_tap · discovery · The track
*When:* `tap:road + chapter:1` · *Register:* G · *Move:* Arrival

The road to Hazelwood is mostly mud, with a few rumours of gravel. In the nearest rut lies one boot. Not yours. It looks as if it gave up and sat down.

## c1_market_tap · discovery · The market
*When:* `tap:market` · *Register:* W · *Move:* Arrival

The market is small and loud and smells of onions. The woman at the next stall looks at your hat, and then, carefully, at something else. Nobody says the word Moonedge. Everybody is thinking it.

## c1_bookcart_tap · discovery · The book cart
*When:* `tap:bookcart` · *Register:* G · *Move:* Introduction

The book cart smells of dust and the inside of a hat. The bookseller looks up. “Reading is the one thing you cannot do wrong,” he says, “unless it is upside down.” You check your own book. The right way up. Good.

## c1_first_trip · moment · Down to the village
*When:* `trips>=1` · *Register:* W · *Move:* Consequence

The walk to Hazelwood takes a while, and your boots have opinions about it. A dog barks. A child stares until somebody pulls her away by the sleeve. You buy what you came for, and you say nothing else at all.

## c1_coin · moment · The first coin
*When:* `seen:coins` · *Register:* G · *Move:* Reward

A coin. A real one, small and dented, with a face on it that looks as if it has had a long day. You put it in your pocket. You take it out to check. You put it back.

## c1_bench · moment · A workbench
*When:* `done:workbench` · *Register:* G · *Move:* Level-up

The workbench is three logs, one plank and a great deal of confidence. You set a stone on it. The stone stays. This, you decide, is a very good bench.

## c1_axe · moment · Stone tools
*When:* `done:stone_axe` · *Register:* G→W · *Move:* Level-up

Chip, chip, chip. The flake that comes off is sharp enough to split a hair. Your first axe. It fits your hand as if it had been waiting for one.

## c1_summer · moment · The first summer
*When:* `season:summer + seasons>=1 + chapter:1` · *Register:* W · *Move:* Lull

Summer. The ash has gone green at the edges, a thin soft green, like the fur on something asleep. You walk the field slowly, in case it is a mistake.

## c1_tower · moment · A tower of rocks
*When:* `done:clear_rocks` · *Register:* G→T · *Move:* Omen

You heap the rocks at the edge of the field. By morning the heap is a tower, each stone balanced on the one below, the smallest on top like a hat. Nothing is missing. You look around. Nobody. Only a very small sound, high and bright, like a bell.

## c1_cleared · moment · Soil
*When:* `done:clear_weeds + done:clear_thistles + done:clear_rocks + done:clear_stumps` · *Register:* W · *Move:* Reward

No thistles. No rocks. No stumps. Where the weeds stood there is only soil, brown and soft and a good deal bigger than you expected. It is a field. You say the word out loud, to see how it fits.

## c1_quern · moment · Flour
*When:* `done:quern + has:flour:1` · *Register:* W · *Move:* Reward

The quern grinds with a noise like a cart on a bad road. What comes out is flour. You taste a pinch off your thumb. It tastes of work and, a bit, of somewhere you have been before.

## c1_scarecrow · moment · The stick scarecrow
*When:* `done:scarecrow_1` · *Register:* G · *Move:* Complication

The scarecrow is two sticks and a sack. By noon the crows are holding a meeting on its shoulder. Minutes are taken. Nothing is decided.

## c1_autumn · moment · The first autumn
*When:* `season:autumn + seasons>=2 + chapter:1` · *Register:* W · *Move:* Lull

Autumn. Smoke from the village chimneys drifts over the hill, and for a moment the wind smells like other people's suppers. You stop what you are doing. Then you start again, a little faster.

## c1_coop · moment · An empty coop
*When:* `done:coop_1` · *Register:* W · *Move:* Omen

The coop is finished. Nobody lives in it. You leave the little door open anyway, in case somebody is looking.

## c1_fence · moment · A stick fence
*When:* `done:stick_fence` · *Register:* G→W · *Move:* Level-up

The stick fence wobbles when you look at it. It will not stop anything bigger than an argument. But now there is an inside and an outside, and you are standing on the inside.

## c1_winter · moment · Snow
*When:* `season:winter + seasons>=3 + chapter:1` · *Register:* T · *Move:* Omen

Snow came in the night, without a sound. The green patch is the last green thing for miles. Round it, in the snow: long prints, short prints, three times round. The prints stop at the edge of the forest.

## c1_hunger · moment · Winter porridge
*When:* `season:winter + chapter:1 + after:c1_winter:10` · *Register:* G · *Move:* Complication

It is cold enough for the water bucket to grow a lid. You chip it off and drink the chips. Today's porridge is mostly an excuse to stand near the fire. It is a very good excuse.

## c1_trips10 · moment · The dog
*When:* `trips>=10` · *Register:* W · *Move:* Consequence

Down to Hazelwood again. The dog by the first house has stopped barking and only looks at you now. In dog, this is a welcome.

## c1_spring2 · moment · Spring again
*When:* `season:spring + seasons>=4 + chapter:1` · *Register:* W · *Move:* Lull

Spring again. The ash has a green skin now, and the ground is soft under your boots. The patch is not the only green thing any more. You tread softly, in case it minds.

## c1_well2 · moment · Water
*When:* `done:well_2` · *Register:* W · *Move:* Reward

The spade rings on something hard, and then the hole goes dark and wet. Water. You lower the bucket and drink from your hands. It tastes of stone and cold and, faintly, of morning.

## c1_tom · moment · A bent horseshoe
*When:* `done:sq_cold_shepherd` · *Register:* W · *Move:* Reward

Tom the shepherd boy has stopped shivering. He presses a bent horseshoe into your hand. “Lucky,” he says. “It never worked for me.” You hang it by the door anyway.

## c1_soup · scene · Soup for the village
*When:* `done:d_veg_soup` · *Register:* W · *Move:* Introduction

Page 1. The soup goes down to the square in two pots. People take it without a word, and come back for more without a word. A woman tastes it. “Needs salt,” she says, and takes a second bowl.

Page 2. Behind her, a child whispers, “Is it the burnt farm soup?” The woman does not turn round. “It's soup,” she says. The child has a second bowl too.

## c1_maud · moment · Granny Maud
*When:* `done:sq_lost_goat` · *Register:* W · *Move:* Introduction

The goat is not your goat, which disappoints everyone, the goat included. Granny Maud takes your face in both hands. “Oh, {player},” she says. “Berit all over. Berit's stubborn self.” Her eyes are wet. She blames the goat.

## c1_ella · moment · A brass bell
*When:* `done:sq_miller_basket + seen:c1_bells` · *Register:* G · *Move:* Reward

Ella gives you a brass bell, bright as a button. “For luck,” she whispers, with one eye on the mill. You shake it. Bong. You listen for the other bell, the small high one. This is not that bell.

## c1_hens · moment · The hens arrive
*When:* `done:animal_chicken` · *Register:* G · *Move:* Complication

The hens come out of their basket one at a time, inspect the coop, find three faults, and take over the yard. By evening you are the one being supervised.

## c1_trips20 · moment · A stool
*When:* `trips>=20` · *Register:* W · *Move:* Notice

Somebody has left a stool beside the track, just before the first houses, exactly where you would stop to rest. You do not sit on it. You put your hand on it as you pass.

## c1_egg · moment · The first egg
*When:* `has:egg:1` · *Register:* G · *Move:* Reward

The first egg is still warm. The hen watches you take it with the face of someone who has views about pricing.

## c1_winch · moment · The winch
*When:* `done:well_3` · *Register:* G · *Move:* Level-up

The winch squeals like a pig being asked a hard question. But the bucket comes up full, and you no longer have to climb down for it. You wind it up and down twice, for the pleasure of the noise.

## c1_hutch · moment · A hutch for nobody
*When:* `has:straw_hutch:1` · *Register:* W · *Move:* Omen · *Priority:* 65

You have built a hutch of straw and sticks, round and soft, big enough for something small. You do not know who it is for. You put it beside the green patch, with the door facing the forest.

## c1_bowl · moment · A bowl of greens
*When:* `has:bunny_bowl:1` · *Register:* W→G · *Move:* Omen · *Priority:* 65

A bowl of greens and sliced carrot, set at the edge of the green patch. You walk away, so as not to look like someone who is waiting. You look back four times.

## c1_n_fire · discovery · In the margin
*When:* `page:k_fire` · *Register:* W · *Move:* Notice · *Emoji:* 📝

In the margin, in thin brown ink: “A fire is a guest. Never leave it alone in the house, and never blame the house. — B.”

## c1_n_weeds · discovery · In the margin
*When:* `page:k_weeds` · *Register:* G · *Move:* Notice · *Emoji:* 📝

Next to the weeds, small and slanted: “Weeds are only plants nobody invited. Some of my best friends were weeds. — B.”

## c1_n_ash · discovery · In the margin
*When:* `page:k_ash` · *Register:* W · *Move:* Notice · *Emoji:* 📝

At the bottom of the ash page, in the same brown ink: “Ash feeds the soil. The soil does not hold a grudge. Take notes. — B.”

## c1_n_chickens · discovery · In the margin
*When:* `page:k_chickens` · *Register:* G · *Move:* Notice · *Emoji:* 📝

Across the top of the hen page, written in a hurry: “Do not name the hens. You will name the hens. — B.”

## c1_n_market · discovery · In the margin
*When:* `page:k_market` · *Register:* G · *Move:* Notice · *Emoji:* 📝

Squeezed in beside the prices: “A fair price is one both sides complain about equally. — B.”

## c1_k_spring · bark
*When:* `season:spring + chapter:1 + chance:0.2`

Something small is singing in the new grass. It stops when you listen. It starts again when you don't.

## c1_k_summer · bark
*When:* `season:summer + chapter:1 + chance:0.2`

The air above the field wobbles in the heat like jelly. Somewhere a cricket is making a complaint.

## c1_k_autumn · bark
*When:* `season:autumn + chapter:1 + chance:0.2`

Leaves come down on the field one at a time, as if somebody were counting them.

## c1_k_crow · bark
*When:* `step>=10 + chapter:1 + chance:0.15`

A crow lands on the fence and looks over your work. It makes a small dry sound. You decide it was a review.

## c1_k_tent · bark
*When:* `chapter:1 + step>=3 + chance:0.12`

The tent breathes in and out with the wind. You are getting used to living inside something that breathes.

## c1_k_stars · bark
*When:* `chapter:1 + step>=5 + chance:0.1`

So many stars. Nobody told you there would be so many. Nobody was here to tell you.

## c1_k_wave · bark
*When:* `friends>=3 + chapter:1 + chance:0.2`

Someone in the village waves. Not at you, you think. You wave back anyway.

## c1_k_bell · bark
*When:* `chapter:1 + step>=15 + chance:0.08`

Far off, a bell, much too high for the village. You tilt your head. It is gone.

## c1_k_nibbled · bark
*When:* `has:carrot:1 + chapter:1 + chance:0.25`

Somebody has nibbled the tops off the carrots. Neatly, all in a row, and the roots left alone. A thoughtful thief.

## c1_k_hands · bark
*When:* `step>=20 + chapter:1 + chance:0.12`

Your hands have started to look like someone else's hands. Someone who works.
