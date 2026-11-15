# Chapter 3: Smallholding — more pieces (English only)

Compressed from the novella on 14 Nov 2026 (`story/08`). German is in `godot-prototype/data/i18n/data-de.json`.

## c3_dread1 · moment · The air before
*When:* `after:c3_letter:6` · *Register:* T · *Move:* Plant

All day there is a hush in the yard that you cannot explain. The hens go in early. The wind drops. A dog barks once, far off, and nothing answers. It is only an ordinary afternoon, wearing the face of a not-ordinary one.

## c3_k_nibbled · bark
*When:* `season:autumn + chapter>=3 + chapter<4 + chance:0.15`

Your list has a neat, half-moon bite out of it, right through “Fix gate”. You do not have a goat. You write the corner out again, on the back.

## c3_hollow · moment · The bramble wall
*When:* `after:c3_letter:11`

Page 1. Behind the fence at the top of the farm there is a wall of brambles, thick as a hedge and full of thorns like a great many small opinions. You push in a little way with the rake handle.

Page 2. Deep inside is a mossy hollow, the size of something small curled up asleep. On one thorn hangs a scrap of white thread. Or hair. You do not reach for it. You back out carefully and go and do something else.

## c3_dread2 · moment · The list
*When:* `after:c3_letter:16` · *Register:* T→G · *Move:* Complication

The next morning your list is gone. There is only a torn scrap on the nail, and in the mud beneath it a small, sharp, split hoofprint. You do not have a goat. You write the list again, in your head this time, where nobody can eat it.

## c3_rue_egg · scene · Waiting for a goat
*When:* `seen:c3_pieter + after:c3_pieter:2`

Page 1. Pieter is still waiting at your gate, lantern lit. Rue's cart stops in the road. “Can't sell to a house with a lantern at the gate, love. Pay Pieter first.” “I need the seed first,” you say. “To pay him with.”

Page 2. Rue turns the cart sideways, sits on the tail of it and takes an apple out of her eleventh pocket. “I'm good at waiting. I once waited for a goat.” Pieter pretends to read his own book.

Page 3. A hen walks out of the brush and lays an egg in the dust. Everybody looks at the egg. “Well, now,” says Rue. “I could see my way to buying an egg.” Pieter gets paid. Rue sells the seed. The hen walks off, smug.

## c3_share_day · scene · Share Day
*When:* `lord_shares>=2`

Page 1. Share Day comes at the end of the season. First the Hall feeds the whole village from the Pot, so nobody pays on an empty stomach. This time the soup is thin. You could read a notice through it.

Page 2. Every house sets out a stool by the door for Pieter, so the man who comes to take can at least sit. Moonedge has no stool yet. He eats his soup standing at your gate, looking into the bowl as if it were a window.

Page 3. At the bottom of his page, in grey ink, is one line you can read upside down: “carried down.” “Down where?” you say. “Down,” says Pieter. He does not say anything else.

## c3_boy · scene · Lightning
*When:* `after:c3_dread2:4`

A small boy hangs on your gate one afternoon, swinging, watching you dig. “My mum says it was lightning,” he says. “Did she?” you say. The boy swings. You dig. Neither of you says anything else.

## c3_pieter2 · visit · The book
*When:* `lord_shares>=3` · *Register:* G→W · *Move:* Escalation

Page 1. Pieter arrives with his lantern, in daylight, as usual. This time he stops at the gate and checks his book twice, with the face of a man looking for a reason to turn round. There isn't one.

Page 2. “It's the same as last time, {player},” he says, “only more.” He accepts a cup of water and drinks it as though it might be evidence.

Page 3. He says one thing more, to the gatepost. “The chalk marks on the widows' sacks down at the Landing. They're very small, these days. The Lord never said how small a mark has to be.” You cannot thank him out loud, so you do not.

## c3_k_pieter2 · bark
*When:* `lord_shares>=3 + chance:0.12`

A lantern swings, far down the road, in the daylight. You stand up very straight, as if it were someone you knew.

## c3_sheep · moment · A cloud with feet
*When:* `done:animal_sheep` · *Register:* G · *Move:* Arrival

The sheep comes off the cart and stands in the yard looking like a cloud that has lost its way. She is round, and white, and cannot see her own feet. She regards you gravely, as if you were a rather puzzling hat.

## c3_loom · moment · Thread by thread
*When:* `done:hand_loom` · *Register:* W · *Move:* Level-up

The loom clacks. Over, under. Over, under. At first the cloth looks like a lie, a few crooked threads pretending. After an hour it is a hand wide. After two, it is a hand and a thumb. Cloth, you realise, is just patience that learned to hold its shape.

## c3_n_weaving · discovery · In the margin
*When:* `page:k_weaving` · *Register:* W · *Move:* Notice · *Emoji:* 📝

In the margin of the weaving page: “A mistake in the first row is still there in the last one. That is fine. It is how you can tell it is yours.”

## c3_blanket · moment · Wool and weather
*When:* `done:wool_mattress` · *Register:* W · *Move:* Plant · *Priority:* 65

Page 1. Somebody has folded the blanket on the end of your bed with the corners just so. It was not you. You are fairly sure it was not you.

Page 2. There is a faint smell of lavender. You get into bed without thinking about it, which is the best sort of thing to do with a mystery.

## c3_spare_bed · scene · For nobody
*When:* `after:c3_blanket:4`

You make the spare bed with square corners. Then you make it again, squarer. You plump the pillow. You put a candle beside it, and a jug, and a pie, in case somebody is hungry in the night. For nobody. Nobody comes. The goat eats the pie.

## c3_tower · moment · Stone on stone
*When:* `done:windmill_tower` · *Register:* W · *Move:* Plant

Page 1. The tower stands, taller than anything you have made yet, with nothing at the top but a round, empty room full of wind. You climb to the last step. Hazelwood lies small and clear below you, like a map drawn by somebody who loved it.

Page 2. Behind you is the forest, going on and on, and somewhere very far inside it, something white. You do not look at it for long. You have sails to make.

## c3_sails · beat · The wind does the work
*When:* `done:windmill_1` · *Register:* A→W · *Move:* Reward · *Priority:* 90

Page 1. You fix the last sail and step back. For a moment, nothing. Then the whole thing groans, like an old person getting up, and begins to turn. Slowly. Then not slowly.

Page 2. The grinding fills the yard, and the flour begins to fall in a quiet white rope. The wind is working for you. It has never done that before, as far as you know. It was waiting to be asked.

## c3_hat · scene · Salute the sails
*When:* `seen:c3_sails + after:c3_sails:2`

Page 1. Ella from the village mill brings her great-grandfather up the hill in a wheelbarrow to see your new sails. He is very old and very small and has a very large hat. He takes it off and salutes the sails with it.

Page 2. “Put it ON,” says Ella's father, the miller, who has followed them up, glaring. His face is a closed door. He folds his arms and watches your sails for a very long time. Ella smiles at you, very quickly, when he is not looking.

## c3_lark_list · visit · A very good editor
*When:* `seen:c3_sails + after:c3_sails:6`

Page 1. A goat comes home in the middle of your sentence. She is shaggy and grey, with one bent horn and a beard full of burrs, and she is eating your list. “Spit it out.” The goat swallows.

Page 2. Lark is on the other end of the bench, reading the bottom half of your list with his eyebrows up. “Item four. Rest. Eaten. Item nine. Rest. Also eaten.” He looks at the goat with respect. “A very good editor.”

Page 3. “I knew a king who wrote, at the bottom of every list: Go for a walk in the garden.” “Did he ever go?” “He had a very nice garden. I'm told.” The bench is empty. At the bottom of your new list you write: rest.

## c3_scarecrow2 · moment · A bow
*When:* `done:scarecrow_2` · *Register:* G · *Move:* Level-up

The new scarecrow has a bow in its hat. You did not put it there. You check the knot. It is your knot, the kind Berit taught you. Somebody has watched you tie knots. You decide not to ask any questions that might get answered.

## c3_iron · moment · Iron
*When:* `done:iron_shovel` · *Register:* W→G · *Move:* Reward

The shovel goes in like a hand into water. No catch, no clunk. You dig a whole row before you notice you have forgotten to be tired. You look at the shovel. The shovel does not look at you. It is only a shovel, and very happy.

## c3_cellar · moment · Down the steps
*When:* `done:cellar` · *Register:* W · *Move:* Reward

Page 1. You go down seven steps into the cellar, and the air changes. It is cool and still and smells of earth that has been thinking. Your voice comes back to you a moment late.

Page 2. This is a place for keeping things safe, and it knows it, and it does not mind keeping you safe too.

## c3_ninth_loaf · scene · The ninth loaf
*When:* `done:oven_2 + chapter>=3 + chapter<4`

Page 1. On market day the village buys eight loaves, and the ninth sits. Your loaves are good, so people buy yours. The ninth is Mistress Appleby's. “She's saving for a new hearth,” says Anna from the bakery, looking at the floor.

Page 2. So every second week you give up your market corner and sell to the children of the Nest, for less. They get bread with honey. Appleby's loaf sells. She cannot say thank you, because that would mean she had noticed. But there is an extra bun in your basket.

## c3_baby · scene · A small blanket
*When:* `done:sq_baby_blanket` · *Register:* W · *Move:* Reward

The blanket is very small. You had not thought how small. The baby grips a corner of it in one fist, and does not let go, and goes to sleep in the middle of what it was doing. You would not mind being that sure about something.

## c3_swing · moment · Something in the orchard
*When:* `done:orchard` · *Register:* W→T · *Move:* Plant

Page 1. Among the old trees you find a rope hanging from the thickest branch. A plank, worn smooth. Somebody once sat here. The knot at the top has been retied, and not well, and not long ago.

Page 2. You test the swing with one hand. It holds. You do not know who retied it. You do not sit down. Not yet.

## c3_maud_goat · scene · A clue
*When:* `done:sq_lost_goat + chapter>=3 + chapter<4` · *Register:* G→W · *Move:* Reward

Page 1. Granny Maud's goat sits in your yard looking pleased with itself. “She keeps coming here,” says Maud, with the air of someone solving a crime. “Do you suppose it's a clue?” You do not, and say so.

Page 2. Maud nods sadly. “It is, though.” She pats your arm, takes the rope, and leads the goat home. The goat looks back twice.

## c3_board · discovery · The board, again
*When:* `chapter>=3 + chapter<4 + sidequests>=3` · *Register:* G · *Move:* Arrival

Page 1. The board in the square has a new notice, in a very firm hand: “WELCOME BACK. WE HAD OUR DOUBTS.” It is not signed. Under it somebody has drawn a small goat.

Page 2. Beside it, the lost green glove is still pinned up, left hand, still waiting. You do not know what the goat means. You take the notice as a compliment.

## c3_dance_rosa · scene · Hum that again
*When:* `seen:c3_dance + after:c3_dance:1`

Page 1. You are the last one left, stacking mugs, so the big blue Late Mug is yours. You drink it slowly on the edge of the stage, humming. Rosa the fiddler freezes, her fiddle half in its case. “Hum that again.”

Page 2. “I'm not humming,” you say. “You were. That. Hum it again.” You put down the mugs and leave, rather quickly. All the way down the lane, Rosa plays the tune on her fiddle, Gertrude. Badly. Over and over. Never quite getting to the end.

## c3_barge · scene · The grey barge
*When:* `seen:c3_dance_rosa + after:c3_dance_rosa:3`

Page 1. One autumn day the whole village stands silent on the Landing Steps, looking down the river. Round the bend comes a long, low barge, painted grey, even the ropes, with no name on its side. It sits very heavy in the water.

Page 2. The Lord's share is on it: all of Hazelwood's chalk marks, carried down the river to somewhere else. The children have been told to hold their breath until it has gone past. They try. They fail, one after another, with little pops, like corks.

Page 3. A child's hand takes your hand. You do not see whose. It just holds on until the grey barge has gone round the next bend and the river is empty. Now you know where the share goes. Down.

## c3_chain · scene · The Chain
*When:* `seen:c3_barge + after:c3_barge:3`

Page 1. Years ago, on the night Moonedge burned, the village passed buckets hand to hand from the stream to the barn. They did not save it. But they tried. This summer the children want to play Chain again, and half the village comes up your hill with buckets.

Page 2. Ansel rings the Hall bell: five fast, which means fire, then one slow, which means all's well. You are handed the last bucket, at the end of the Chain. You have always carried the last bucket.

Page 3. You stand there, holding it. Then you turn round and pass it on. Somebody takes it. The Chain goes on without you, and you stand with your empty hands, and do not know what to do with them.

## c3_goat_shed · moment · A roof for a goat
*When:* `done:barn_2` · *Register:* G · *Move:* Complication

Page 1. The bigger barn is finished. Granny Maud's goat walks in, walks out, climbs up the side and stands on the roof, looking down at you, very pleased. You have built a barn. You have been given a goat roof. It is not the same thing.

Page 2. You set four buckets of water at the corners of the barn, full. Then eight at the farmhouse. Just in case. The goat drinks out of one. The tortoise sits in one. A hen lays an egg in one.

## c3_circle · scene · One tortoise wide
*When:* `seen:c3_goat_shed + after:c3_goat_shed:2`

Page 1. One evening, when everyone is going in for the night, the tortoise sits at the gate. The bunny comes and presses herself against the shell. Inside a circle exactly one tortoise wide, nothing hurries. Nothing worries. Nothing thumps.

Page 2. Outside it, the wind blows and the trees creak and something rustles in the hedge. THUMP, goes the bunny, as soon as she steps out of the circle. She steps back in. Nothing.

## c3_north · discovery · North of the fence
*When:* `done:north_field_clear` · *Register:* W · *Move:* Arrival

Page 1. Beyond the old fence the land goes on. You had not looked, you were so busy with your own fields. Long grass. A leaning post. A bird you do not know, doing something complicated with a twig.

Page 2. There is room here for more than you thought. It has been standing here the whole time, waiting for somebody to notice. And there is the bramble wall, in the way of all of it.

## c3_pond_sun · moment · Bright water
*When:* `done:pond + season:summer` · *Register:* W · *Move:* Reward

The sun is on the pond, and the pond is giving it back. Dragonflies write quick, blue letters on the air. You sit with your feet in the water and think about nothing. Nothing is very good for you.

## c3_n_wind · discovery · In the margin
*When:* `page:k_wind` · *Register:* W · *Move:* Notice · *Emoji:* 📝

Beside the wind page: “Stand in it for a minute before you build. It will tell you which way it likes.”

## c3_n_ferment · discovery · In the margin
*When:* `page:k_ferment` · *Register:* G · *Move:* Notice · *Emoji:* 📝

Fermenting. In the margin: “If it smells like a goat, it is wrong. If it smells like the Goat, it is perfect.” You are not sure which goat is meant.

## c3_n_pests · discovery · In the margin
*When:* `page:k_pests` · *Register:* T→G · *Move:* Notice · *Emoji:* 📝

Next to the pests: “Everything eats something. Do not take it personally. Do take the slugs somewhere else.”

## c3_n_irrigation · discovery · In the margin
*When:* `page:k_irrigation` · *Register:* W · *Move:* Notice · *Emoji:* 📝

“Water goes where you show it, and then where it likes. Both are fine.”

## c3_k_wind · bark
*When:* `done:windmill_1 + chance:0.15`

The sails slow, creak, and stop, like someone who has forgotten the next word. Then the wind comes back, and they carry on.

## c3_k_forge · bark
*When:* `done:forge + chance:0.15`

Somewhere down the road, a hammer rings, and stops, and rings again. Somebody is making something. It is a good sound to live next to.

## c3_k_summer · bark
*When:* `season:summer + chapter>=3 + chapter<4 + chance:0.2`

The air is thick and gold. Everything is humming, even the stones.
