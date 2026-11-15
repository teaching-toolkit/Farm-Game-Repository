# Chapter 1: Ashes — more pieces

Compressed from the novella on 14 Nov 2026 (`story/08`). German is in `godot-prototype/data/i18n/data-de.json`.

## c1_box · beat · Berit's box
*When:* `seen:c1_stalk + after:c1_stalk:1` · *Priority:* 82 · *Register:* W · *Move:* Introduction

Page 1. In the tent there is a box with your name on the lid, in thin brown ink. Your grandmother Berit left it. Inside are a thin brown book, a small tin pot with a bent handle, a shapeless green hat that smells of her, and a dented bucket. You know the bucket at once, like your own shoe.

Page 2. On top lies a note. “If you are reading this, you went. Good. Do not apologise to the bucket. — B.” You read it three times. Then you put on the hat. It comes down over your eyebrows, and you leave it there.

## c1_letter · letter · A note in the bread
*When:* `seen:c1_box + after:c1_box:3` · *Priority:* 60 · *Register:* W · *Move:* Introduction

Page 1. Your last bread is wrapped in a scrap of sack. A wheel is burnt into the cloth, and the letters WEIR. That is the river town where your family lives now. Folded in the bread is a note in your mother's quick, round writing.

Page 2. “The house is small. The table is long. Come when you're ready. Everyone sends love. (Everyone means everyone. — M.)” You eat the bread standing up, in four bites.

Page 3. Under the note is a drawing by your little sister. A house, a tree, a sun with a face, and a chicken. The chicken is bigger than the house. You pin it inside the tent flap, and you do not look at it again all day.

## c1_fire · moment · The first fire
*When:* `done:campfire` · *Register:* G→W · *Move:* Complication

The first spark sulks. The second one dies of embarrassment. The third one catches, and you lean over it until your eyebrows complain. A fire, in this place. The ash around it glows a little, as if it remembers something.

## c1_thump · moment · In the dark
*When:* `seen:c1_fire + after:c1_fire:2` · *Register:* G→T · *Move:* Omen

You eat your porridge by the fire. Somewhere out in the dark something goes THUMP. THUMP. THUMP. Then a little roll of very fast thumps, like a drum being told off. You bank the fire down, and the thumping stops.

## c1_n_fire · discovery · In the margin
*When:* `page:k_fire` · *Register:* W · *Move:* Notice · *Emoji:* 📝

In the margin, in thin brown ink: “A fire is a guest. Never leave it alone in the house, and never blame the house. — B.”

## c1_first_harvest · moment · One becomes many
*When:* `harvests>=1` · *Register:* W · *Move:* Reward

You cut the stalks and tip the grains into your hand. Count them. One grain went into the ground. Look at them now. You close your fingers round them, carefully, the way you would hold a baby bird.

## c1_first_card · moment · A coin in the pocket of your head
*When:* `cards>=1` · *Register:* G · *Move:* Level-up

You finish the card. Something you did not know is now something you know, and it sits in your head like a coin in a pocket. You pat it.

## c1_weeds · discovery · Weeds
*When:* `tap:patch:weeds` · *Register:* G · *Move:* Arrival

Weeds. Of course. They came back to a burnt field before anything else did, which tells you something about weeds. You pull one. Its root is longer than your arm, and very proud of it.

## c1_n_weeds · discovery · In the margin
*When:* `page:k_weeds` · *Register:* G · *Move:* Notice · *Emoji:* 📝

Next to the weeds, small and slanted: “Weeds are only plants nobody invited. Some of my best friends were weeds. — B.”

## c1_rocks_tap · discovery · Rocks
*When:* `tap:patch:rocks` · *Register:* G · *Move:* Arrival

Rocks. You lift one. Under it is a smaller rock, looking surprised. Under that, another. Whatever lives down there has been collecting rocks for a very long time.

## c1_forest_tap · discovery · The forest edge
*When:* `tap:forest + chapter<2` · *Register:* T · *Move:* Omen

The forest starts where the field gives up. The trees stand close and very still, like people who stopped talking when you walked in. A path goes in between them. You do not. Not today.

## c1_road_tap · discovery · The track
*When:* `tap:road + chapter<2` · *Register:* G · *Move:* Arrival

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

A coin, small and dented, with a face on it that looks as if it has had a very long day. Round the edge it says WEXLEY. “That's the Lord,” says the woman who gave it to you. “He likes to be on things.” You put it in your pocket, take it out to check, and put it back.

## c1_bench · moment · A workbench
*When:* `done:workbench` · *Register:* G · *Move:* Level-up

The workbench is three logs, one plank and a great deal of confidence. You set a stone on it. The stone stays. This, you decide, is a very good bench.

## c1_axe · moment · Stone tools
*When:* `done:stone_axe` · *Register:* G→W · *Move:* Level-up

Chip, chip, chip. The flake that comes off is sharp enough to split a hair. Your first axe. It fits your hand as if it had been waiting for one.

## c1_maud_hat · visit · A goat, and Granny Maud
*When:* `seen:c1_bells + after:c1_bells:2` · *Priority:* 56 · *Register:* G→W · *Move:* Introduction

Page 1. A goat trots up the track, sees your weed pile, and goes straight for it, like somebody who has heard about a party. Behind it comes an old woman with a stick and a lot to say. “You come BACK here, you bearded—” Then she sees your hat.

Page 2. “I'd know that hat on a scarecrow,” she says. “Maud. Granny Maud, they call me, as if I'd be anybody's granny.” She looks at the tent and the bucket for a long time. “She said you'd come.” Then she takes the goat by the beard and goes.

## c1_tower · moment · A tower of rocks
*When:* `done:clear_rocks` · *Register:* G→T · *Move:* Omen

You heap the rocks at the edge of the field. By morning the heap is a tower, each stone balanced on the one below, the smallest on top like a hat. Nothing is missing. You look around. Nobody. Only a very small sound, high and bright, like a bell.

## c1_hearth · moment · The tower comes down
*When:* `seen:c1_tower + after:c1_tower:2` · *Register:* W · *Move:* Omen

You need rocks for a hearth. So you take the tower down, rock by rock, starting with the little one on top, like a hat. You build them into a hearth, flat and solid, a good hearth for a guest. High up, somewhere, the small bright sound goes out, like a candle. The quiet after it is a different quiet. It stays.

## c1_woodpile · moment · The black rectangle
*When:* `done:chopping_block` · *Register:* W→G · *Move:* Notice

Where the barn stood is a black rectangle in the ash, like a bed nobody has made. One doorframe stands by itself, with an empty iron hook. You walk round it, not across. Then you find you have a lot to do about the woodpile. It ends up the tidiest woodpile in the valley. It looks nervous.

## c1_summer · moment · The first summer
*When:* `season:summer + seasons>=1 + chapter<2` · *Register:* W · *Move:* Lull

Summer. The ash has gone green at the edges, a thin soft green, like the fur on something asleep. You walk the field slowly, in case it is a mistake.

## c1_cleared · moment · Soil
*When:* `done:clear_weeds + done:clear_thistles + done:clear_rocks + done:clear_stumps` · *Register:* W · *Move:* Reward

No thistles. No rocks. No stumps. Where the weeds stood there is only soil, brown and soft and a good deal bigger than you expected. It is a field. You say the word out loud, to see how it fits.

## c1_quern · moment · Flour
*When:* `done:quern` · *Register:* W · *Move:* Reward

The quern grinds with a noise like a cart on a bad road. What comes out is flour. You taste a pinch off your thumb. It tastes of work and, a bit, of somewhere you have been before.

## c1_rue · visit · Rue comes back
*When:* `seen:c1_quern + after:c1_quern:2` · *Priority:* 56 · *Register:* G→W · *Move:* Consequence

Page 1. The seller comes back when the road is dry. This time she tells you her name: Rue. She wants a sack of flour for her stall, and pays in coins and in news. “The miller tasted a pinch. He said adequate. Like a man swallowing a bee. From him that's a love letter.”

Page 2. She searches four pockets and finds a twist of salt. “Oh, and a carter in Weir asked if I'd seen you. Big man. Sad eyes. No name. Look for the bucket, he said. I said you were busy. Was that right?” “Yes,” you say. “That was right.” Then you make three more sacks of flour, very fast.

## c1_maud_bucket · visit · The bucket on the post
*When:* `seen:c1_summer + after:c1_summer:8` · *Priority:* 56 · *Register:* W→T · *Move:* Notice

Page 1. Granny Maud comes up the hill with a goat on a rope and a bucket. She fills it at the stream and sets it on the burnt gatepost, beside a row of small grey stones. “It stays there till morning,” she says. “Every year. Don't touch it.” Your field is dry. You leave it alone.

Page 2. In the morning the bucket is empty. Nobody says who drank it. “We came with buckets, that night,” says Maud, looking at the black place where the barn was. “The whole village, hand to hand, up the hill. Too late.” You do not ask any more.

## c1_autumn · moment · The first autumn
*When:* `season:autumn + seasons>=2 + chapter<2` · *Register:* W · *Move:* Lull

Autumn. Smoke from the village chimneys drifts over the hill, and for a moment the wind smells like other people's suppers. You stop what you are doing. Then you start again, a little faster.

## c1_scarecrow · moment · The stick scarecrow
*When:* `done:scarecrow_1` · *Register:* G · *Move:* Complication

The scarecrow is two sticks and a sack. By noon the crows are holding a meeting on its shoulder. Minutes are taken. Nothing is decided.

## c1_well2 · beat · The old well
*When:* `done:well_2` · *Register:* W · *Move:* Reward

Page 1. Your spade rings on stone. Not one stone: a curve of them, fitted together. A ring. It is the old well, dry since before the fire. One stone has a notch worn smooth, just the right height for a small child on a crate.

Page 2. You were that child. You stood on that crate. You dig, down and down, until the hole goes dark, and then wet. You drink from your two hands. It tastes of stone, and cold, and very faintly of morning.

## c1_twins · visit · Lotte and Linus
*When:* `done:sq_twins_porridge` · *Register:* G · *Move:* Introduction

Page 1. Two children come up the track, very hungry and very brave, in that order. They dare each other to touch the burnt gatepost, run away screaming, and come back. “Lotte,” says the girl. “Linus,” says the boy. “We're twins.” “I'm older.” “By eleven minutes!” “Eleven minutes is a lot of minutes.”

Page 2. “There's a ghost up here,” says Linus. “It's a cat,” says Lotte. “The farm used to ring by itself, at night. Ring ring ring. That's a cat.” “Cats don't ring!” “Some cats ring.” They eat their porridge against the gatepost, arguing, and go home with porridge on their chins.

## c1_tom · visit · Tom at the fence
*When:* `done:sq_cold_shepherd` · *Register:* W · *Move:* Reward

Page 1. Tom the shepherd boy stands at your fence with nine sheep round his legs, shivering. He looks at your fire the way a dog looks at a sausage. “The sheep don't like it in there,” he says. “And neither do I.” So you pass a burning log over the fence with the tongs.

Page 2. Tom holds it out and warms his hands. The sheep crowd round. The log smokes, and everybody coughs. “Tom,” says Tom. “{player},” you say. “I know,” says Tom, and goes red. He presses a bent horseshoe into your hand. “Lucky. It never worked for me.”

## c1_pot · scene · The big Pot
*When:* `done:d_veg_soup` · *Priority:* 58 · *Register:* W · *Move:* Introduction

Page 1. In the middle of the square stands the village Pot, big and black, on three legs. A round woman called Maribel Kettle keeps it, and she has laughed at no joke about her name. “Sit,” she says. “Eat. Taste before you talk. That's the rule at this pot.” Then: “Whose are you, then?”

Page 2. You tell her. For one breath the whole Pot goes quiet, and the spoons stop. Then Maribel passes you the salt. You sit on an upturned bucket for one whole minute.

Page 3. A tall woman leans over and drops a smooth grey river stone in your lap. “The Soup Stone,” she says. “Whoever has it brings the next pot. So nobody's pot is the only pot.” The stone is warm from her pocket.

## c1_soup · scene · Soup for the village
*When:* `done:d_veg_soup` · *Register:* W · *Move:* Introduction

Page 1. The soup goes down to the square in two pots. People take it without a word, and come back for more without a word. A woman tastes it. “Needs salt,” she says, and takes a second bowl.

Page 2. Behind her, a child whispers, “Is it the burnt farm soup?” The woman does not turn round. “It's soup,” she says. The child has a second bowl too.

## c1_maud · visit · Berit all over
*When:* `done:sq_lost_goat` · *Register:* W · *Move:* Introduction

Page 1. The goat is not your goat, which disappoints everyone, the goat included. Granny Maud takes your face in both hands. “Oh, {player},” she says. “Berit all over. Berit's stubborn self.” Her eyes go wet. “That goat kicks up dust.” There is no dust.

Page 2. “She raised you on that hill,” says Maud. “She wrote and told me she was sending you back. I wrote, Berit, you cannot send a person. She wrote back: Watch me.” Maud wipes her eyes and glares at the goat. “Don't tell her I said. Well. You can't now, can you.”

## c1_ella · moment · A brass bell
*When:* `done:sq_miller_basket + seen:c1_bells` · *Register:* G · *Move:* Reward

Ella gives you a brass bell, bright as a button. “For luck,” she whispers, with one eye on the mill. You shake it. Bong. You listen for the other bell, the small high one. This is not that bell.

## c1_winter · moment · Snow
*When:* `season:winter + seasons>=3 + chapter<2` · *Register:* T · *Move:* Omen

Snow came in the night, without a sound. The green patch is the last green thing for miles. Round it, in the snow: long prints, short prints, three times round. The prints stop at the edge of the forest.

## c1_hunger · moment · Winter porridge
*When:* `season:winter + chapter<2 + after:c1_winter:10` · *Register:* G · *Move:* Complication

It is cold enough for the water bucket to grow a lid. You chip it off and drink the chips. Today's porridge is mostly an excuse to stand near the fire. It is a very good excuse.

## c1_lark · visit · Supper on the fence
*When:* `season:winter + seasons>=3 + seen:c1_winter + after:c1_winter:4` · *Priority:* 70 · *Register:* G→A · *Move:* Omen

Page 1. It is Longnight, the longest night. Down in the valley the lights of Hazelwood go out, one by one, until only the Hall glows. Nobody has asked you, so you mend the fence by lantern, very loudly. “Is this seat taken?” says somebody.

Page 2. A tall man is sitting on your fence. His coat has a great many buttons, and none of them match. He walks the top rail eating porridge, and spills a lump in the snow. “I meant to do that,” he says. “It's a style.” “Sit down and eat it properly,” you say, and he does, neat as a boy at school.

Page 3. “Who are you?” “Lark. It's the one I came in. You had a blue mitten up here once. Only the one.” You turn to ask how he knows. The fence is empty, with a scraped bowl on the post, and the lights of Hazelwood come back on. You finish your porridge sitting on the fence. Only because your legs are tired.

## c1_coop · moment · An empty coop
*When:* `done:coop_1` · *Register:* W · *Move:* Omen

The coop is finished. Nobody lives in it. You leave the little door open anyway, in case somebody is looking.

## c1_lantern · moment · A lantern on the road
*When:* `seen:c1_coop + after:c1_coop:3` · *Priority:* 55 · *Register:* T · *Move:* Omen

One night a lantern comes along the road below, slowly. It stops at the bottom of your track, as if it is wondering whether your smoke is a fire. You do not move a muscle until it moves on. A tired voice floats up: “Dry night.” Afterwards your hands shake, and you sit on them until they stop.

## c1_fence · moment · A stick fence
*When:* `done:stick_fence` · *Register:* G→W · *Move:* Level-up

The stick fence wobbles when you look at it. It will not stop anything bigger than an argument. But now there is an inside and an outside, and you are standing on the inside.

## c1_spring2 · moment · Spring again
*When:* `season:spring + seasons>=4 + chapter<2` · *Register:* W · *Move:* Lull

Spring again. The ash has a green skin now, and the ground is soft under your boots. The patch is not the only green thing any more. You tread softly, in case it minds.

## c1_hens · moment · The hens arrive
*When:* `done:animal_chicken` · *Register:* G · *Move:* Complication

The hens come out of their basket one at a time, inspect the coop, find three faults, and take over the yard. By evening you are the one being supervised.

## c1_egg · moment · The first egg
*When:* `seen:c1_hens + after:c1_hens:2` · *Register:* G · *Move:* Reward

The first egg is still warm. The hen watches you take it with the face of someone who has views about pricing.

## c1_trips10 · moment · The dog
*When:* `trips>=10` · *Register:* W · *Move:* Consequence

Down to Hazelwood again. The dog by the first house has stopped barking and only looks at you now. In dog, this is a welcome.

## c1_trips20 · moment · A stool
*When:* `trips>=20` · *Register:* W · *Move:* Notice

Somebody has left a stool beside the track, just before the first houses, exactly where you would stop to rest. You do not sit on it. You put your hand on it as you pass.

## c1_winch · moment · The winch
*When:* `done:well_3` · *Register:* G · *Move:* Level-up

The winch squeals like a pig being asked a hard question. But the bucket comes up full, and you no longer have to climb down for it. You wind it up and down twice, for the pleasure of the noise.

## c1_hutch · moment · A hutch for nobody
*When:* `seen:c1_winch + after:c1_winch:2` · *Register:* W · *Move:* Omen · *Priority:* 65

You have built a hutch of straw and sticks, round and soft, big enough for something small. You do not know who it is for. You put it beside the green patch, with the door facing the forest.

## c1_bowl · moment · A bowl of greens
*When:* `seen:c1_hutch + after:c1_hutch:2` · *Register:* W→G · *Move:* Omen · *Priority:* 65

A bowl of greens and sliced carrot, set at the edge of the green patch. You walk away, so as not to look like someone who is waiting. You look back four times.

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
*When:* `season:spring + chapter<2 + chance:0.2`

Something small is singing in the new grass. It stops when you listen. It starts again when you don't.

## c1_k_summer · bark
*When:* `season:summer + chapter<2 + chance:0.2`

The air above the field wobbles in the heat like jelly. Somewhere a cricket is making a complaint.

## c1_k_autumn · bark
*When:* `season:autumn + chapter<2 + chance:0.2`

Leaves come down on the field one at a time, as if somebody were counting them.

## c1_k_crow · bark
*When:* `step>=10 + chapter<2 + chance:0.15`

A crow lands on the fence and looks over your work. It makes a small dry sound. You decide it was a review.

## c1_k_tent · bark
*When:* `chapter<2 + step>=3 + chance:0.12`

The tent breathes in and out with the wind. You are getting used to living inside something that breathes.

## c1_k_stars · bark
*When:* `chapter<2 + step>=5 + chance:0.1`

So many stars. Nobody told you there would be so many. Nobody was here to tell you.

## c1_k_wave · bark
*When:* `friends>=3 + chapter<2 + chance:0.2`

Someone in the village waves. Not at you, you think. You wave back anyway.

## c1_k_bell · bark
*When:* `chapter<2 + step>=15 + chance:0.08`

Far off, a bell, much too high for the village. You tilt your head. It is gone.

## c1_k_nibbled · bark
*When:* `done:crop_carrot + chapter<2 + chance:0.25`

Somebody has nibbled the tops off the carrots. Neatly, all in a row, and the roots left alone. A thoughtful thief.

## c1_k_hands · bark
*When:* `step>=20 + chapter<2 + chance:0.12`

Your hands have started to look like someone else's hands. Someone who works.
