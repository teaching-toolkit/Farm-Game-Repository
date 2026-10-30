# Chapter 4: The Lease — more pieces (English only)

Round 6b, draft 1 (14 Oct 2026). Existing pieces: `ch4.md`. Format as in `more-ch1.md`. Master Quill is the Lord's steward; the chapter is about a number and a person behind it. All 💡 until read aloud. Invented here: the receipt Pieter hands over, the tiny light over the marsh (from `hazelwood-people.md`), Mei admiring the pickles like an examiner and handing over one letter (its words are not read). Consistency pass of 14 Oct 2026 applied (`../consistency-fixes.md`); `c4_blanket` moved to chapter 3 (`c3_blanket`).

## c4_pieter4 · visit · The same lantern
*When:* `lord_shares>=9` · *Register:* W · *Move:* Escalation

Page 1. Pieter comes up the road with his lantern swinging and his book under his arm, and for the first time he does not open it at the gate. He just stands there.

Page 2. “I wanted to say, {player},” he says, and stops. “It's heavy. I know. I'm the one who carries it.” You nod. It is the nicest thing anyone has said all week.

## c4_receipt · beat · A piece of paper
*When:* `lord_shares>=11` · *Register:* W→T · *Move:* Reward

Pieter gives you a receipt. You have never had one. It says what you paid and what it was for, and in one corner, in tiny letters: “Thank you.” Somebody took the trouble. You hope it was Pieter. You fold it small and keep it with the burnt page.

## c4_glass · moment · Sand and fire
*When:* `done:glass_kiln` · *Register:* A · *Move:* Reward

Page 1. Sand goes in. You wait. Something comes out that you can see through, and it is the same sand, only now it lets the light walk straight in and out.

Page 2. You hold the first bottle up. The yard turns upside down inside it, small and green and tipped, and for a moment it is the whole world.

## c4_greenhouse · moment · A room made of weather
*When:* `done:greenhouse` · *Register:* W · *Move:* Reward

You step in and shut the door, and the weather stays outside like a dog that has been told. Warm air. Wet air. Green air. Rows of leaves reach for the glass. The first tomato has chosen to be here, whatever the season outside, and you take your hat off to it.

## c4_scarecrow3 · moment · A flower in the buttonhole
*When:* `done:scarecrow_3` · *Register:* G→W · *Move:* Level-up

The third scarecrow has a flower. Just one. Where it came from, no one will say. It is not a scarecrow flower. It is a real one, a little yellow, put there on purpose, by someone who thought the scarecrow looked lonely.

## c4_window · scene · A school window
*When:* `done:sq_school_window` · *Register:* W→G · *Move:* Plant · *Priority:* 70

Page 1. The new window goes into the school wall, and the children press their noses to it at once. “You can see everything,” says one. “You can see the pig,” says another.

Page 2. They do not seem to mind that the pig is the only thing to see. Later, the teacher stays behind and cleans the pane with her sleeve, though it is already clean.

## c4_wedding · scene · A tall cake
*When:* `done:sq_wedding_cake` · *Register:* W→G · *Move:* Reward

Page 1. The cake leans a little, in the middle, where the berry cake meets the apple pie. Nobody mentions it. The couple cut it together, and the knife goes in with a small, soft sound.

Page 2. Everyone cheers as if they had been waiting all day. You stand at the back with a plate and a crumb on your nose. It is your cake they are cheering. Nobody tells you about the crumb.

## c4_watch · scene · A tiny light
*When:* `done:sq_night_watch` · *Register:* T→A · *Move:* Plant

Page 1. Pieter holds your new lantern up on the town wall and looks out over the marsh. “There's a light out there,” he says. “Some nights. Very small. It doesn't move like a lantern.”

Page 2. He rubs his eyes. “I'm paid to notice, you see. I'm not paid to say.” He says it anyway, and then walks off whistling, so you will not ask.

## c4_mei · letter · The barge
*When:* `done:sq_long_voyage` · *Register:* W · *Move:* Reward

Page 1. Captain Mei holds the jar of pickles up to the light and nods, as if it had passed an exam. “For the long voyage,” she says.

Page 2. Then she sets a letter on your table. “Your mother. She asked me to hand it over myself.” She does not stay for tea. She does stay for a very long look at the letter.

## c4_birthday · moment · The bucket
*When:* `season:spring + chapter:4` · *Register:* W · *Move:* Echo · *Priority:* 60

Page 1. It was spring when you came here with a bucket and a plan and no idea. You look around. The plan has changed.

Page 2. The bucket is still by the door. You give its rim a pat, the way you would pat a horse that has done a good day's work, and go out to see what the day wants.

## c4_n_steel · discovery · In the margin
*When:* `page:k_steel` · *Register:* W · *Move:* Notice · *Emoji:* 📝

“Steel is iron that has been through something.” A little drawing of a hammer. It looks pleased.

## c4_n_glass · discovery · In the margin
*When:* `page:k_glass` · *Register:* W · *Move:* Notice · *Emoji:* 📝

“I once held a bottle up to the sun and cried for no reason. Do not be surprised.”

## c4_n_mulch · discovery · In the margin
*When:* `page:k_mulch` · *Register:* G · *Move:* Notice · *Emoji:* 📝

Mulch. Written beside it: “A blanket for dirt. Yes, dirt gets cold. Do not argue.”

## c4_n_masonry · discovery · In the margin
*When:* `page:k_masonry` · *Register:* W · *Move:* Notice · *Emoji:* 📝

“A wall is only many small decisions in the same direction.”

## c4_board · discovery · The board in the square
*When:* `chapter:4 + sidequests>=6` · *Register:* G · *Move:* Arrival

The board is so full now that notices have started to climb on each other. One of them, near the top, simply says “WHOEVER IS DOING ALL THIS, PLEASE DON'T STOP.” Near the bottom, the lost glove is still pinned there. You straighten the notice. You leave the glove.

## c4_k_winter · bark
*When:* `season:winter + chapter:4 + done:greenhouse + chance:0.2`

Frost on the glass in the greenhouse, ferns drawn in white. You could swear they are better than the ones on the plants.

## c4_k_lease · bark
*When:* `chapter:4 + seen:c4_lease + chance:0.12`

The lease is in the drawer. You do not open the drawer. You know it is there, which is nearly as bad.

## c4_k_pony · bark
*When:* `done:pet_pony + chance:0.15`

The pony puts her whole head over the fence and breathes on you, once, as if checking you are still warm.

## c4_k_school · bark
*When:* `done:sq_school_window + chance:0.15`

Children's voices, down the lane. Someone is singing the wrong words to a right tune, very loudly.
