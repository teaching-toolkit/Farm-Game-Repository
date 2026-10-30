# Chapter 3: The Share — more pieces (English only)

Round 6b, draft 1 (14 Oct 2026). Chapter 3 had a 138-step drought in the bot run; these fill it. Existing pieces: `ch3.md`. Format as in `more-ch1.md`. Pieter collects the Lord's share; he is kind, tired and sure he is the villain of everyone's day. All 💡 until read aloud. Consistency pass of 14 Oct 2026 applied (`../consistency-fixes.md`). Invented here, to accept or overrule: Pieter's flask, the orchard swing with the badly retied knot, the folded blanket that smells of lavender (`c3_blanket`, moved here from chapter 4: the wool mattress is a chapter 3 node; picked up again in `c6_quilt`). Renamed: `c3_pond_sun` (was `c3_stream_n`; the text is the pond). `c3_north` stays here: a node's chapter number is a design label, the engine's chapter comes from the pets at home (in the bot run the North Field was cleared in chapter 3).

## c3_pieter2 · visit · The book
*When:* `lord_shares>=3` · *Register:* G→W · *Move:* Escalation

Page 1. Pieter arrives with his lantern, in daylight, as usual. This time he stops at the gate and checks his book twice, with the face of a man looking for a reason to turn round. There isn't one.

Page 2. “It's the same as last time, {player},” he says, “only more.” He accepts a cup of water and drinks it as though it might be evidence.

## c3_pieter3 · visit · The flask
*When:* `lord_shares>=6` · *Register:* W · *Move:* Reward

Page 1. “It's a long road,” says Pieter, and sits on your fence without being asked. He sets his lantern down beside him, still lit in broad daylight. Then he takes a flask from his coat and offers it to you, which is not in his book either.

Page 2. It is cold tea, very sweet. You each take a sip. Then he stands, straightens his coat, and becomes a watchman again. “Same time next season.”

## c3_sheep · moment · A cloud with feet
*When:* `done:animal_sheep` · *Register:* G · *Move:* Arrival

The sheep comes off the cart and stands in the yard looking like a cloud that has lost its way. She is round, and white, and cannot see her own feet. She regards you gravely, as if you were a rather puzzling hat.

## c3_cellar · moment · Down the steps
*When:* `done:cellar` · *Register:* W · *Move:* Reward

Page 1. You go down seven steps into the cellar, and the air changes. It is cool and still and smells of earth that has been thinking. Your voice comes back to you a moment late.

Page 2. This is a place for keeping things safe, and it knows it, and it does not mind keeping you safe too.

## c3_loom · moment · Thread by thread
*When:* `done:hand_loom` · *Register:* W · *Move:* Level-up

The loom clacks. Over, under. Over, under. At first the cloth looks like a lie, a few crooked threads pretending. After an hour it is a hand wide. After two, it is a hand and a thumb. Cloth, you realise, is just patience that learned to hold its shape.

## c3_blanket · moment · Wool and weather
*When:* `done:wool_mattress` · *Register:* W · *Move:* Plant · *Priority:* 65

Page 1. Somebody has folded the blanket on the end of your bed with the corners just so. It was not you. You are fairly sure it was not you.

Page 2. There is a faint smell of lavender. You get into bed without thinking about it, which is the best sort of thing to do with a mystery.

## c3_tower · moment · Stone on stone
*When:* `done:windmill_tower` · *Register:* W · *Move:* Plant

The tower stands, taller than anything you have made yet, with nothing at the top. A round, empty room full of wind. You climb to the last step. Hazelwood lies small and clear below you, like a map drawn with great care. Behind you, the forest, and beyond that, more.

## c3_sails · beat · The wind does the work
*When:* `done:windmill_1` · *Register:* A→W · *Move:* Reward · *Priority:* 90

Page 1. You fix the last sail and step back. For a moment, nothing. Then the whole thing groans, like an old person getting up, and begins to turn. Slowly. Then not slowly.

Page 2. The grinding fills the yard, and the flour begins to fall in a quiet white rope. The wind is working for you. It has never done that before, as far as you know. It was waiting to be asked.

## c3_scarecrow2 · moment · A bow
*When:* `done:scarecrow_2` · *Register:* G · *Move:* Level-up

The new scarecrow has a bow in its hat. You did not put it there. You check the knot. It is your knot. You decide not to ask any questions that might get answered.

## c3_iron · moment · Iron
*When:* `done:iron_shovel` · *Register:* W→G · *Move:* Reward

The shovel goes in like a hand into water. No catch, no clunk. You dig a whole row before you notice you have forgotten to be tired. You look at the shovel. The shovel does not look at you. It is only a shovel, and very happy.

## c3_goat_shed · moment · A roof for a goat
*When:* `done:barn_2` · *Register:* G · *Move:* Complication

The bigger barn is finished. A goat walks in, walks out, climbs on the roof, and looks down at you, very pleased with itself. You have built a barn. You have been given a goat roof. It is not the same thing.

## c3_north · discovery · North of the fence
*When:* `done:north_field_clear` · *Register:* W · *Move:* Arrival

Beyond the old fence the land goes on. You had not looked. Long grass, a leaning post, a bird you do not know, doing something with a twig. There is room here for more than you thought, and it has been standing here the whole time, waiting for someone to notice.

## c3_maud_goat · scene · A clue
*When:* `done:sq_lost_goat + chapter:3` · *Register:* G→W · *Move:* Reward

Page 1. Granny Maud's goat sits in your yard looking pleased with itself. “She keeps coming here,” says Maud, with the air of someone solving a crime. “Do you suppose it's a clue?” You do not, and say so.

Page 2. Maud nods sadly. “It is, though.” She pats your arm, takes the rope, and leads the goat home. The goat looks back twice.

## c3_baby · scene · A small blanket
*When:* `done:sq_baby_blanket` · *Register:* W · *Move:* Reward

The blanket is very small. You had not thought how small. The baby grips a corner of it in one fist, and does not let go, and goes to sleep in the middle of what it was doing. You would not mind being that sure about something.

## c3_dread1 · moment · The air before
*When:* `after:c3_letter:6` · *Register:* T · *Move:* Plant

All day there is a hush in the yard that you cannot explain. The hens go in early. The wind drops. A dog barks once, far off, and nothing answers. It is only an ordinary afternoon, wearing the face of a not-ordinary one.

## c3_dread2 · moment · The list
*When:* `after:c3_letter:16` · *Register:* T→G · *Move:* Complication

You find yourself counting. Things you have. Things you owe. Things in the barn. The numbers do not add up to anything alarming. You count again anyway. Then a hen walks across the paper, and you have to start over, and it somehow feels better.

## c3_pond_sun · moment · Bright water
*When:* `done:pond + season:summer` · *Register:* W · *Move:* Reward

The sun is on the pond, and the pond is giving it back. Dragonflies write quick, blue letters on the air. You sit with your feet in the water and think about nothing. Nothing is very good for you.

## c3_n_wind · discovery · In the margin
*When:* `page:k_wind` · *Register:* W · *Move:* Notice · *Emoji:* 📝

Beside the wind page: “Stand in it for a minute before you build. It will tell you which way it likes.”

## c3_n_ferment · discovery · In the margin
*When:* `page:k_ferment` · *Register:* G · *Move:* Notice · *Emoji:* 📝

Fermenting. In the margin: “If it smells like a goat, it is wrong. If it smells like the Goat, it is perfect.” You are not sure which goat is meant.

## c3_n_weaving · discovery · In the margin
*When:* `page:k_weaving` · *Register:* W · *Move:* Notice · *Emoji:* 📝

“A mistake in the first row is still in the last one. That is fine. It is how you can tell it is yours.”

## c3_n_pests · discovery · In the margin
*When:* `page:k_pests` · *Register:* T→G · *Move:* Notice · *Emoji:* 📝

Next to the pests: “Everything eats something. Do not take it personally. Do take the slugs somewhere else.”

## c3_n_irrigation · discovery · In the margin
*When:* `page:k_irrigation` · *Register:* W · *Move:* Notice · *Emoji:* 📝

“Water goes where you show it, and then where it likes. Both are fine.”

## c3_board · discovery · The board, again
*When:* `chapter:3 + sidequests>=3` · *Register:* G · *Move:* Arrival

The board in the square has a new notice, in a very firm hand: “WELCOME BACK. WE HAD OUR DOUBTS.” It is not signed. Under it someone has drawn a small goat. You are not sure what it means. You take it as a compliment.

## c3_k_wind · bark
*When:* `done:windmill_1 + chance:0.15`

The sails slow, creak, and stop, like someone who has forgotten the next word. Then the wind comes back, and they carry on.

## c3_k_pieter2 · bark
*When:* `lord_shares>=3 + chance:0.12`

A lantern swings, far down the road, in the daylight. You stand up very straight, as if it were someone you knew.

## c3_k_nibbled · bark
*When:* `season:autumn + chapter:3 + chance:0.15`

Your list has been nibbled at one corner. You have no goat. You frown at the list. The list does not explain itself.

## c3_k_forge · bark
*When:* `done:forge + chance:0.15`

Somewhere down the road, a hammer rings, and stops, and rings again. Somebody is making something. It is a good sound to live next to.

## c3_k_summer · bark
*When:* `season:summer + chapter:3 + chance:0.2`

The air is thick and gold. Everything is humming, even the stones.

## c3_swing · moment · Something in the orchard
*When:* `done:orchard` · *Register:* W→T · *Move:* Plant

Page 1. Among the old trees you find a rope hanging from the thickest branch. A plank, worn smooth. Somebody once sat here. The knot at the top has been retied, and not well, and not long ago.

Page 2. You test the swing with one hand. It holds. You do not know who retied it. You do not sit down. Not yet.
