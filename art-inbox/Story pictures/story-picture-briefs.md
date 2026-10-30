# Story pictures: brief per piece

Generated 14 Oct 2026 from `story/game/texts/ch1.md` … `ch6.md` (English text only; the German is in the same files) and `picture_review.csv` (same folder). Barks are left out: they are speech bubbles and have no picture.

How to read a line: **Now:** the picture(s) in the folder and the review verdict. **GAP:** the piece has no picture yet.

Verdict meanings: KEEP = use as is · KEEP + FIX = use after the small fix in the note · FIX = regenerate or change the text (see the note) · DROP = archive · HOLD / DECIDE = waits for the parent.

---

## c1_frame0 · frame · chapter 1 · Bedtime

*When:* `start`

Page 1. Evening. The room smells of tea. Minena has brought a cup and spilled half of it. The others sit on the floor, on the bed, on your feet.
Page 2. “Tell us about the farm that burned down!” “Again?” you say. “Yes!” “And don't forget the bells,” whispers someone very small. “Shh! That comes later!”
Page 3. You close your eyes. You are not sure you remember it right. But it always begins the same way: with ash.

**Now:**
- `2026-10-12_135132_grandchildren-bedside-eager_6d1a8056.png` · KEEP · Four grandchildren crowd the bed; lamp and stone walls. Nobody in the bed. Right tone.
- `2026-10-12_135228_grandchildren-hush-boy-blurting_3e996ddf.png` · KEEP · Good.
- `2026-10-12_135243_grandchildren-tea-cup-carrying_532fae31.png` · KEEP · Good.

---

## c1_stalk · beat · chapter 1 · The last grain

*When:* `start` · *then:* welcome hints

Page 1. Everything is grey. Ash, mud, black posts where a house once stood. The farm of your family is gone.
Page 2. But look. One green patch in the ash. On it stands one ripe wheat stalk. Every grain has been nibbled off. All but one.
Page 3. You pick up the last grain. Somebody was here. And somebody left it for you.

**Now:**
- `2026-10-12_135108_wheat-stalk-nibbled-closeup_cea49a38.png` · KEEP · One green patch, one stalk. The nibbling is hard to see at this size.
- `2026-10-12_140244_burnt-farm-morning-eye-level_377b17f7.png` · KEEP + FIX · Backlit silhouette from behind with a hat: matches the farmer rule. But it is sunny and green; the text says grey ash and mud.

---

## c1_book · beat · chapter 1 · The book

*When:* `page:k_wheat`

Page 1. The book in the box is old. On the first page, in thin brown ink: “Start small. Small is plenty.”
Page 2. You read it twice. Then, from nowhere, an old tune comes back, and a line of words: “Long ears sow the clover green.”

**Now:**
- `2026-10-12_135319_farm-book-rabbit-sketch-clover_ba713278.png` · KEEP + FIX · Sketch of the rabbit in clover, no children, no legible text. Cream vignette border at the edges; the brief says full-bleed, no white border.

---

## c1_night · beat · chapter 1 · The first night

*When:* `step>=2`

Page 1. The first night. The sky is huge. At the edge of the dark forest, white stones glow, very faintly.
Page 2. Somewhere, a tune. You do not know it. You find you are humming it anyway.

**Now:**
- `2026-10-12_135125_forest-edge-campfire-glowing-stones_349ad72b.png` · KEEP · Wonder, no people. The melody as silver swirls is fine.

---

## c1_bells · discovery · chapter 1 · A little bell

*When:* `done:clear_thistles`

When the last thistle is out, you hear it: a tiny bell, high in the air. Then nothing. Behind you, three sticks lie in a very silly pile. Nothing is missing.

**Now:**
- `2026-10-12_140303_thistle-pile-tower-low-view_78a54339.png` · KEEP · The clue, exactly: stick tower, thistle hat, tiny bell, and Mumyo's tail in the heap, not looking at the viewer.

---

## c1_ledger · discovery · chapter 1 · A burnt page

*When:* `done:ruins_workshop`

Under the black boards you find a page, burnt at the edges. A list of numbers. At the bottom, in red: “The Lord's share.” Every year the red number is bigger. You fold the page small and keep it.

**Now:**
- `2026-10-12_135322_scorched-ledger-page-workshop_18c0a8fb.png` · KEEP + FIX · Page is not burnt at the edges. The red line is a wax seal, not readable text. Numbers look random (12345, 3320000). Make a column that clearly rises, with scorched edges and the red line.

---

## c1_seller · visit · chapter 1 · The seller

*When:* `done:d_porridge`

Page 1. On the village square a seller sniffs the air. “Is that porridge?” You hand her a bowl. She eats it standing up, very fast.
Page 2. “You're from Moonedge, aren't you?” she says. “Good porridge, {player}. I'll tell everyone that somebody is cooking up here again.”

**GAP:** No picture with a person. The porridge picture has no one in it.

---

## c1_board · discovery · chapter 1 · The notice board

*When:* `tap:board`

A notice board, full of little papers. Somebody needs a basket. Somebody has lost a goat. You read every one twice, and keep your hat low.

**Now:**
- `2026-10-12_135332_village-notice-board-hazelwood_e3f0d4e2.png` · KEEP · Sheep and goat notices fit the lost-goat favour. The village looks neat and prosperous; the text says small and tired.

---

## c1_bunny · beat · chapter 1 · The bunny comes home

*When:* `done:pet_bunny`

Page 1. A bunny sits on the one green patch. She sits like someone who has always sat there.
Page 2. Now you understand. The patch stayed green because somebody looked after it. The stalk was nibbled because somebody was hungry. And one grain was left for you.
Page 3. Now the first line of the old rhyme makes sense: “Long ears sow the clover green.” You say it out loud. The bunny's ear twitches.

**Now:**
- `2026-10-12_140258_bunny-wheat-patch-eye-level_e81ca052.png` · KEEP · Strong: she sits on the patch as if she always has, the ruin behind.

---

## c1_bell_out · beat · chapter 1 · Two soft rings

*When:* `seen:c1_bunny + after:c1_bunny:1`

That night, from far away: two soft rings of a very small bell. You sit up in the dark. The bunny is asleep in the clover. So who else is still here?

**Now:**
- `2026-10-12_135340_tent-night-bell-bunny_950566af.png` · KEEP · Strong: bunny asleep, bell hung on a stick, tail glimpsed behind a tree, an owl (an ordinary bird).

---

## c1_frame1 · frame · chapter 1 · Back in the room

*When:* `chapter:1 + season:winter + chance:0.3`

Page 1. Back in the room, the tea has gone cold. “Was there really a bunny?” asks Minena. “There was,” you say. “She was very rude about carrots.”
Page 2. “And the bell? Who rang the bell?” “Shh!” says everybody at once. “That's next time!” You smile. They know this story almost as well as you do. Almost.
## c1_k_seller · bark
“Do you ever stop?” calls a cart driver from the track. You wave. You do not stop.
## c1_k_hens · bark
The hens argue about who laid which egg. Nobody wins.
## c1_k_bucket · bark
The old bucket clanks against the well stones. It sounds almost proud.
## c1_k_grass · bark
Something rustles in the long grass. It stops when you look.
## c1_k_smoke · bark
The wind still smells a little of old smoke.
## c1_k_winter · bark
The tent flaps in the wind. You pull the blanket up to your nose.

**Now:**
- `2026-10-12_135139_grandchildren-bedside-listening-window_524c811a.png` · KEEP · Minena listens at the window. The tail and bell on the sill is the Mumyo hint the premise asks for.
- `2026-10-12_135221_grandchildren-giggling-bunny-ears_e45067b8.png` · KEEP + FIX · Good content, carrot included. Cream margins on the left and right edges; the brief says full-bleed, no white border.

---

## c2_letter · beat · chapter 2 · A letter from home

*When:* `chapter:2`

Page 1. The river barge brings a letter. Mei from the barge nods, hands it over and rows on. The writing is round and quick: your mother's.
Page 2. “Come home before the frost, my love. The house is small, but the table is long. Your cousin asks after you.” You fold the letter very small. The frost is far away. Isn't it?

**Now:**
- `2026-10-12_140325_letter-autumn-frost-eye-level_08f94fe7.png` · FIX · The letter reads "Dear Clara, Lorem ipsum...": placeholder text, and Clara is not a name in the story files. Make it scribble only.

---

## c2_walls · beat · chapter 2 · Crooked walls

*When:* `done:cottage_walls`

The walls of the cottage stand. You built them alone, and it shows. One leans a little to the left. You step back, look at them for a long time, and decide that they are perfect.

**Now:**
- `2026-10-12_140332_log-cottage-walls-eye-level_5f99b069.png` · FIX · Text: one wall leans to the left. Here the walls are square and neat. Add the lean, or change the text. The bunny on the log is a nice extra.

---

## c2_greenstem · visit · chapter 2 · Young Greenstem

*When:* `done:d_stone_soup`

Page 1. A boy waits at your gate with a basket of herbs bigger than his arms. “You're the Moonedge one,” he says. “You used to carry a bucket bigger than you.” You did.
Page 2. “Why is that wall crooked? Does it hurt when you hammer? Did you know sage is good for a cough?” He asks too many questions. You find, to your surprise, that you do not mind.

**Now:**
- `2026-10-12_135408_greenstem-gate-herbs-stone-soup_4224d19c.png` · FIX (major) · Greenstem is drawn as a child of about ten. Canon: he is the farmer's age ("a boy her age"). Regenerate him older. Pose and stone-soup pot are right.

---

## c2_stumps · discovery · chapter 2 · Too many stumps

*When:* `done:ruins_lumber`

So many stumps, for such a small farm. Their tops are clean and flat. Someone cut the forest back, long ago, and nobody planted anything in its place.

**Now:**
- `2026-10-12_140316_tree-stump-slope-eye-level_e6c28211.png` · KEEP · Strong: clean stumps, the burnt wall, village roofs in the distance.

---

## c2_lark · beat · chapter 2 · A visitor on the new road

*When:* `done:road_3`

Page 1. A man walks up the new gravel road as if he had always walked it. He sits on your fence and watches you work. “Lark,” he says. Then he says nothing at all for a while.
Page 2. You stack a crate. He stacks one too, a little crooked. “Probably fine,” he says. It is. Mostly. When you look again, the fence is empty and both crates are still standing.

**Now:**
- `2026-10-12_140309_lark-fence-apple-eye-level_0ae30f16.png` · KEEP · Lark sits on the fence with an apple and a basket, coat in rust-brown, no bells. Matches 'sits on your fence and watches you work'. Replaces the superseded gravel-road original.

---

## c2_barn · beat · chapter 2 · Where the fire began

*When:* `done:ruins_barn`

Page 1. You clear the last black beam from the barn. Then you stop. The burn does not start at the roof, where lightning would strike. It starts low, in the corner where the hay was kept.
Page 2. You sit back on your heels. Lightning does not start low. Something else began this. You do not know what. And you find that you do not want to know. Not yet.

**Now:**
- `2026-10-12_135412_burnt-barn-scorch-marks-corner_f695d392.png` · KEEP · Strong: the scorch starts low in the hay corner and the light falls on it. Exactly the clue.

---

## c2_compost · moment · chapter 2 · A tidy pit

*When:* `done:ruins_compost`

Behind the barn is a compost pit, clean and dry, its edges squared with flat stones. Someone cared about this. Scratched on the lid: “Feed the ground and it feeds you. — B.”

**Now:**
- `2026-10-12_135417_compost-corner-empty-note_9167c655.png` · KEEP + FIX · Text: edges squared with flat stones, note scratched on the lid. Picture: wooden frame, paper pinned to a post. Pick one and match.

---

## c2_cottage · moment · chapter 2 · A roof before the frost

*When:* `done:cottage`

A real roof, before the frost. You sit under it while the first rain taps on the tiles. Then you take a sheet of paper and write home: “I'm staying a bit longer.” Your hand shakes only a little.

**Now:**
- `2026-10-12_140337_log-cottage-thatch-eye-level_7dc992bd.png` · KEEP + FIX · Text says rain taps on the tiles; the picture is thatch with light snow. Change the text to thatch.

---

## c2_tortoise · beat · chapter 2 · The tortoise comes home

*When:* `done:pet_tortoise`

Page 1. Something very slow is crossing the yard. A tortoise, moving like a stone that has decided to travel. She goes straight to the pond and sits down where the spring first rose.
Page 2. You sit down beside her and wait. The pond fills a little, then a little more. Nothing is hurried. And the second line of the old rhyme comes back to you: “Slow shell keeps the water clean.”

**Now:**
- `2026-10-12_140344_pond-spring-tortoise-eye-level_edaeaf0a.png` · KEEP · Moss on the shell, a ripple where the spring rises. Good.

---

## c2_hook · beat · chapter 2 · A blackened hook

*When:* `seen:c2_tortoise`

In the new barn frame you find an old iron hook. It is black with soot, and it was made to hold a lantern. “If it was not lightning,” you think, “then what?” You hang the hook back up. Carefully.

**Now:**
- `2026-10-12_140349_barn-frame-lantern-hook-ruin_deb2d0d6.png` · KEEP · Good: new timber frame, black lantern hook. The file name says ruin; the picture is a new frame, which matches the text.

---

## c2_frame2 · frame · chapter 2 · Back in the room

*When:* `seen:c2_hook`

Page 1. Back in the room, somebody has fallen asleep on the floor. “Did you find out who started it?” asks Minena. “Not then,” you say. “I didn't want to.”
Page 2. “And the man on the fence? Was he funny?” “Very.” “Was that good?” “It made him hard to talk to,” you say, and nobody understands. That is all right.

**GAP:** Needed.

---

## c3_pieter · visit · chapter 3 · The night watchman

*When:* `lord_shares>=1`

Page 1. A lantern swings up the road in the daylight. Under it walks Pieter, the night watchman. He does not look happy.
Page 2. “I am sorry, {player}. The Lord wants his share. It is not my idea. I only carry the book.” He shows you a number. “Pay when you can. I will wait at the gate.”

**GAP:** Needed. Pieter is a man with a lantern and a book.

---

## c3_pieter_paid · moment · chapter 3 · Pieter

*When:* `lord_paid>=1 + chance:0.12`

Pieter taps his book shut. “Thank you. Most people hide when they see me.” He almost smiles. Then he walks home, whistling a tune he does not know he is whistling.
## c3_k_pieter · bark
Far down the road, a lantern waves at you. Pieter. You wave back.

**GAP:** Needed. Pieter is a man with a lantern and a book.

---

## c3_letter · beat · chapter 3 · Stay if you must

*When:* `chapter:3`

Another letter comes from the river barge. Your mother writes: “Stay if you must. Your cousin asks after you.” You read the last line again. To you it sounds like a warning.

**GAP:** Needed.

---

## c3_forge · beat · chapter 3 · Clang

*When:* `done:forge`

Old Odinson lights the forge and young Bo works the bellows. They show you how to hold the tongs. “Good hands,” says Odinson, which is the most he has said all day. Bo grins at the fire.

**Now:**
- `2026-10-12_140355_smithy-forge-eye-level_4d271d79.png` · KEEP + FIX · Hands in mitts, tongs, Odinson at the forge. Bo looks about ten; the pick list calls him a teenager.

---

## c3_bell · beat · chapter 3 · A very small bell

*When:* `done:ruins_windmill`

Page 1. In the old mill, on a rusty nail, hangs a bell. It is far too small for a cow. It is far too small for anything. It sways, just a little, though there is no wind.
Page 2. In the dust beneath it you think you see tiny footprints. You look the other way. You are quite sure that you looked the other way.

**Now:**
- `2026-10-12_135500_windmill-ruin-brass-bell_6f6b5072.png` · KEEP · Strong: bell on a beam, tail glimpsed behind the flour sacks, the ruin.

---

## c3_stream · moment · chapter 3 · The stream runs again

*When:* `done:pond`

The stream runs clear again. On the bridge the miller looks down at the water. Then at you. He nods once, a very small nod. That is his whole apology, and you take it.

**Now:**
- `2026-10-12_140447_miller-bridge-clear-stream-nod_573588b2.png` · KEEP + FIX · Good. A water wheel, which fits the lease doc. The stone bridge is a later road tier. See the mill note on the windmill picture.

---

## c3_dance · moment · chapter 3 · The harvest dance

*When:* `done:sq_harvest_dance`

You work the cider while the village dances. Mugs float above the heads. One falls, you catch it, and you laugh out loud. Somewhere close by, something goes tink, like a very small bell. You do not look.

**Now:**
- `2026-10-12_140453_harvest-dance-lanterns-cider_d7ecd74c.png` · KEEP · Strong: mugs floating, the hands catch one. A bell and a tail hidden among the dancers.

---

## c3_goat · beat · chapter 3 · The goat comes home

*When:* `done:pet_goat`

Page 1. A goat trots up the path and straight into the brambles nobody could clear. Crunch. Munch. She eats thistles as if they were sweets. You open your mouth to stop her. Then you let her.
Page 2. The third line of the old rhyme comes back, and you say it with your mouth still open: “Brave goat clears the bramble bed.” The goat looks at your hat. Her eyes are thoughtful.

**Now:**
- `2026-10-12_140506_goat-thistle-field-path_591cf7c5.png` · KEEP + FIX · The goat wears a bell on her collar. The bells are Mumyo's clue; take the collar bell off (also on the alpaca and supper goats).

---

## c3_goat_out · beat · chapter 3 · A scarecrow in your hat

*When:* `seen:c3_goat`

In the morning the scarecrow is wearing your hat. Nobody saw who put it there. Under the hat there is a letter: “Your cousin may come to visit.” You take your hat back. It is still warm.

**Now:**
- `2026-10-12_140459_goat-chewing-list-closeup_a0c1f884.png` · KEEP · Good: shaggy, burrs, the list in her mouth.
- `2026-10-12_140511_scarecrow-straw-hat-tail-bell_23a0c249.png` · KEEP · Mumyo's tail and bell in the hat, half hidden. The crows are ordinary birds.

---

## c3_frame3 · frame · chapter 3 · Back in the room

*When:* `seen:c3_goat_out`

“Were you scared of the cousin?” asks somebody from under a blanket. “More than of any imp,” you say. “What's an imp?” “Shh!” say three children at once. “That comes later!”

**GAP:** Needed.

---

## c4_quill · beat · chapter 4 · Master Quill

*When:* `done:farmhouse_base`

Page 1. A thin man stands at your gate with a ledger under his arm. He does not smile, and he does not look unkind either. He looks like someone who counts. “Master Quill,” he says. “The Lord's steward.”
Page 2. “The old farm smokes again,” he says, and looks at your chimney. “The Lord wishes to know why.” You tell him: because somebody lives here. He writes that down.

**Now:**
- `2026-10-12_140517_quill-gate-foundation-ledger_3063f47f.png` · KEEP · Thin, ledger, horse, stone foundation. Small detail: he has a feather pen; the text says a very sharp pencil.

---

## c4_count · visit · chapter 4 · Quill counts

*When:* `done:farmhouse_walls`

Page 1. Quill counts everything. Cows, sacks, windows, nails. He counts the hens twice, because one moved. Every number goes into his ledger, written with a very sharp pencil.
Page 2. Later you find two ledger pages folded into a paper boat on the pond. Somewhere, a very small bell tinkles. Quill is not amused. You are, a little.

**Now:**
- `2026-10-12_140530_quill-pond-paper-boat_ec5455ae.png` · KEEP · Strong: Quill not amused, the boat on the pond, a tail and a bell in the reeds.

---

## c4_lease · discovery · chapter 4 · The old lease

*When:* `done:ruins_greenhouse`

In a rusty tin under the glasshouse stones lies the old lease: “… a half of all that the land gives.” A half! You take out the burnt page from the workshop and hold it beside it. The red number is the same.

**Now:**
- `2026-10-12_140536_glasshouse-ruin-tin-box-fraction_d2bd9474.png` · KEEP · Strong: the scroll marked 1/2 in the tin. The text says the tin is under the stones; here it is on a bench (minor).

---

## c4_no · beat · chapter 4 · Your first no

*When:* `done:farmhouse`

Page 1. Quill is at the gate again. “The Lord's share,” he says, “as before.” You look at the North Field, resting under clover. “No,” you say. Your voice is smaller than you hoped, but it does not shake.
Page 2. Quill's pencil stops. On the fence, Lark swings his legs. “You've counted the cows,” he tells Quill. “Have you counted the clover? It counts you.” Quill writes that down too, by mistake.

**Now:**
- `2026-10-12_140543_north-field-clover-quill-lark_ae291147.png` · KEEP · Strong: Quill with the ledger, Lark on the fence, the clover field, the new house.

---

## c4_library · moment · chapter 4 · Sorted by weight

*When:* `done:library_room`

You step into the new library room and stop. Somebody has sorted all your books by weight. The heaviest lies at the bottom, the lightest on top. Lark sits on the heaviest, reading the lightest. “Probably fine,” he says.

**Now:**
- `2026-10-12_140549_library-lark-books-by-size_1a0a3b21.png` · KEEP + FIX · Text: Lark sits on the heaviest book, reading the lightest. Picture: he stands holding a heavy book. Minor.

---

## c4_pizza · scene · chapter 4 · Pizza night

*When:* `done:d_pizza`

On the village square the builders eat pizza at long tables under paper lanterns. You sit between Bo and Greenstem. Someone passes you the biggest slice. Tonight, nobody asks whose family you are.

**GAP:** Needed. Builders eating at long tables under paper lanterns.

---

## c4_pony · beat · chapter 4 · The pony comes home

*When:* `done:pet_pony`

Page 1. A pony stands at your gate and poses, one hoof forward. Then she lets you load a sack, a crate and a big order for the village. She walks down the road as if she owns it.
Page 2. On the square, people stop. They look at the pony, then the order, then you. Somebody says your name. Your own name, not your family's. The fourth line comes back: “Strong pony brings the world its bread.”

**Now:**
- `2026-10-12_140557_pony-cart-village-square_7a121ad6.png` · KEEP · Good: pony and laden cart; villagers turn to look.

---

## c4_quill_out · beat · chapter 4 · Quill rides home

*When:* `seen:c4_pony`

Quill rides back to the manor with his ledger full. At the gate he stops. “The farm gives back more than it takes,” he says, as if it were a question. “The Lord will want to know.” Then he goes, and you cannot tell what he meant.

**Now:**
- `2026-10-12_140604_quill-rides-away-manor_3f44bc6c.png` · KEEP · Good: the manor on the hill, the farm behind.

---

## c4_frame4 · frame · chapter 4 · Back in the room

*When:* `seen:c4_quill_out`

Page 1. “Was the Lord a villain?” asks Minena. You think about it for a long time. “He was afraid,” you say. “That's worse, sometimes.”
Page 2. Nobody says anything. Then the smallest one whispers, “Afraid of what?” “Of a number,” you say. “Now go to sleep.” They do not. Not yet.

**Now:**
- `2026-10-12_135236_grandchildren-thoughtful-row-quilt_0e3215c1.png` · KEEP · Thoughtful mood fits the line about the Lord being afraid.

---

## c5_cough · beat · chapter 5 · A cough in Hazelwood

*When:* `chapter:5`

Page 1. Down in Hazelwood somebody is coughing. Then somebody else. The children first, as always, and nobody knows what to do.
Page 2. Wren the healer comes up the road with a full basket. “I cannot do this alone, {player},” she says. “Berit's old still-room is behind your kitchen. Would you look?”

**Now:**
- `2026-10-12_140621_village-street-autumn-sick-child_acb408cf.png` · KEEP · Good: a sick child with his mother, Wren with a basket of herbs.

---

## c5_stillroom · discovery · chapter 5 · A torn page

*When:* `done:ruins_stillroom`

Under the last shelf lies a page, torn in two. The top half is in a tidy hand: “Tea first. Always tea first.” The bottom half is missing. Somebody was here before you, and cared.

**Now:**
- `2026-10-12_140624_herb-house-ruin-torn-page_c4441b38.png` · KEEP + FIX · Text: a torn page lies on the floor under the last shelf. Picture: an open book on a stone bench. Change to the torn page on the floor.

---

## c5_wren_check · visit · chapter 5 · Wren's rule

*When:* `forest_trips>=1`

Page 1. Wren is waiting at the edge of the forest with her arms folded. “One rule,” she says. “Bring me your basket. Every time. Before you use anything in it.”
Page 2. “Plants have twins, and some twins are poison. I do not care how clever you are. I care that you wake up tomorrow.” She almost smiles. “It costs a little favour. A biscuit will do.”

**GAP:** Needed.

---

## c5_conch · beat · chapter 5 · Something white

*When:* `forest_trips>=3`

Far off between the trees, something white and spiral shines in the green. It does not move. You hold your breath. Then you go back to your basket. Some things are for later.

**Now:**
- `2026-10-12_140628_moonstone-forest-conch-shell_6f951c9f.png` · FIX (major) · The conch is huge, close and glowing. Text: far off between the trees, and it does not move. Redo it small and distant. Also has a white border.

---

## c5_first_tea · moment · chapter 5 · A pupil for Wren

*When:* `done:tea_pot`

Greenstem, the boy from the market, stands in the doorway of the still-room and sniffs. “Can I learn this?” Wren grumbles something about boys and mud. Then she says yes.

**GAP:** Needed.

---

## c5_poison · scene · chapter 5 · What were you thinking?

*When:* `forest_poisoned>=1`

Page 1. The ceiling. A blanket. A cup of something bitter. Wren sits by your bed, and she is not smiling. “What were you thinking?” she says. Your purse is gone. Your legs shake.
Page 2. “You are well,” she says. “That is all that matters. Next time, the basket comes to me first.” She puts a hand on your head, very briefly, and goes to stir her pot.

**Now:**
- `2026-10-12_140641_still-room-floor-wren-kneeling_082f4d20.png` · KEEP · Wren angry, spilled herbs and jars. Fits the poisoning beat. Harsh, but inside the parent's one exception.

---

## c5_page · beat · chapter 5 · The other half

*When:* `has:healers_chest:1`

The chest is full. In its lid, rolled up, you find the other half of the torn page: “The badger left after the fever, when nobody let the children rest.” You read it twice. You were one of those children.

**Now:**
- `2026-10-12_140633_torn-page-fitted-book-sketches_761694b7.png` · KEEP · Strong: badger sketch with spectacles, three children asleep under the moon. Says it without words.

---

## c5_collapse · beat · chapter 5 · You never stop

*When:* `seen:c5_page + after:c5_page:2`

You make one more tea, and one more, day and night. Then the pot tilts and the floor comes up. Wren finds you on the stone. “You never stop, do you?” she says, and carries you to the bench.

**GAP:** Needed.

---

## c5_badger · beat · chapter 5 · Tea first

*When:* `done:pet_badger`

Page 1. At the door of the still-room sits a badger, with his back very straight. He looks at the chest. He looks at the tea set. Then he looks at you, and at your hands.
Page 2. He sets out two cups. “Tea first,” he seems to say. You sit down. For the first time in a long time, you do nothing at all. The badger pours.

**Now:**
- `2026-10-12_135157_badger-tea-kitchen-hearth_8bd6622d.png` · KEEP + FIX · Good: round spectacles, the empty chair, the pouring. Setting is a kitchen by a hearth; the text has him at the still-room door.

---

## c5_letter · beat · chapter 5 · A letter with a seal

*When:* `seen:c5_badger + after:c5_badger:1`

A boy runs up the road with a letter. The seal is red wax, pressed with a heavy ring. “From the Lord,” he pants. You do not open it yet. The badger looks at it, and then at you, and says nothing.

**Now:**
- `2026-10-12_140646_letter-red-seal-stag-cold-tea_169b263b.png` · KEEP · Good: wax seal, cold tea. The stag on the seal is new and not in canon.

---

## c5_frame5 · frame · chapter 5 · Back in the room

*When:* `seen:c5_letter`

“Did you get better?” asks Minena. “Badgers make very slow tea,” you say. “By the time it was ready, I was.” Somebody laughs. Somebody yawns. Somebody asks if badgers have teapots.

**GAP:** The badger-tea picture could serve, but it is the in-game piece.

---

## c6_free_family · moment · chapter 6 · The long table

*When:* `done:sq_free_family`

Your cousin pushes the pie across the table and looks at her plate. “I should have said it differently, that day.” “Yes,” you say. Then you pass the bread, and that is how it is mended.

**GAP:** Needed.

---

## c6_free_quill · moment · chapter 6 · Quill counts

*When:* `done:sq_free_quill`

Quill counts every basket twice. “A tenth,” he says, and writes it with a small flourish. “The Lord will like the numbers. I like them better.” He looks at your fields as if they were a poem.

**GAP:** Needed. Quill with the ledger, not amused: the steward again.

---

## c6_free_greenstem · moment · chapter 6 · Two healers

*When:* `done:sq_free_greenstem`

Greenstem takes the chest in both arms. “Wren says I may carry it to the village myself.” Wren, behind him, folds her arms and does not say a word. Her eyes say a lot.

**GAP:** Needed.

---

## c6_free_miller · moment · chapter 6 · The sails turn

*When:* `done:sq_free_miller`

The miller pours your flour into his hopper. The sails creak, then turn, slowly, as they did before the fire. “Hear that?” he says. “That is Hazelwood having bread again.”

**Now:**
- `2026-10-12_141034_windmill-new-white-sails_389c3679.png` · KEEP + DECIDE (mill) · The ch6 text has sails. The ch3 bridge picture and the lease doc have a water wheel. Pick one mill type and make every picture match.

---

## c6_free_lark · moment · chapter 6 · Nutmeg

*When:* `done:sq_free_lark`

Lark holds out the cake. The squirrel takes it with both hands. “Nutmeg,” Lark announces. “Obviously.” The squirrel does not look as if it has any other opinion. You laugh until the fence shakes.

**GAP:** Needed. Squirrel allowed; magpie not.

---

## c6_free_garden · moment · chapter 6 · For the night garden

*When:* `done:sq_free_garden`

You set the bowl down at the edge of the garden. You open your mouth. You close it again. Far off, very softly, a very small bell rings twice. You nod, and walk home in the dark, and you are not afraid.

**Now:**
- `2026-10-12_140832_flower-garden-milk-bowl-bells_8330d0a7.png` · KEEP · Strong: the milk bowl, two small bells, glowing flowers, no Mumyo.

---

## c6_lord · beat · chapter 6 · The Lord's letter

*When:* `chapter:6`

A rider brings a letter with a red seal. Your farm prospers, it says, so the share goes back to a half, “as before.” You read it twice. Inside you, an old pattern sits up and stretches.

**GAP:** The letter-red-seal picture could serve, but it is used for c5_letter.

---

## c6_broker · beat · chapter 6 · The Import Broker

*When:* `done:import_broker`

A new trader unpacks his cart on the square. He has a hat, a tune and a very familiar face. “Barter?” he says. “Yes!” He winks. You decide to stop wondering who he looks like.

**Now:**
- `2026-10-12_140718_lark-market-stand-exotic-goods_dd0ea4ee.png` · FIX · Text: "He has a hat." Picture: no hat. Add the hat (the wink). The parrot and telescope are not in canon: cut or keep.

---

## c6_garden · beat · chapter 6 · White flowers at dusk

*When:* `done:river_meadow_drain`

Where the marsh was, white flowers open at dusk. Hundreds of them, glowing softly. Somewhere in the dark, very quietly, bells. Nobody comes out to meet you. You stand there a long time and do not say a word.

**Now:**
- `2026-10-12_140723_marsh-night-flowers-fireflies_bc9b458d.png` · KEEP · Strong: no Mumyo, bells on the reeds, fireflies.

---

## c6_fair_letter · beat · chapter 6 · We're coming to the Fair

*When:* `done:d_fair_cheese`

A last letter from the river barge: “We're coming to the Fair. All of us. Even your cousin.” You put it in your pocket and keep touching it all day.

**Now:**
- `2026-10-12_140736_cottage-window-letter-five-figures_af9e2e1f.png` · KEEP · Good: family drawing on the letter, the farm through the window. The knife and glasses on the sill are unexplained props.

---

## c6_fair_tables · moment · chapter 6 · The tables fill

*When:* `seen:c6_fair_letter`

The tables at the Fair fill up. Everybody brought something: Pieter a lantern cake, Greenstem a basket of mint, the miller, with a face like thunder, a sack of flour. The whole village works with you.

**Now:**
- `2026-10-12_140731_harvest-fair-tables-greenstem_db28fba1.png` · FIX · Greenstem drawn as a child again. Regenerate him older. The rest of the Fair scene is good.

---

## c6_crisis · beat · chapter 6 · At the Fair

*When:* `done:d_fair_cloth`

The Fair is bright and loud. Then your cousin stands up in front of everyone. “You were in the barn that night,” she says. “I saw you run out, crying about lights.” The whole square goes quiet.

**Now:**
- `2026-10-12_140748_fair-cousin-pointing-crowd_83d991ab.png` · KEEP · Strong: the cousin is a girl, pointing, the crowd turns.

---

## c6_bend · beat · chapter 6 · Sit down

*When:* `seen:c6_crisis`

Page 1. You want to run. Instead you sit down on the nearest bench. Your hands are cold. Then you tell it: the lights in the dark, the lantern on the hook, the running, the shouting that nobody believed.
Page 2. It is very quiet. Then your cousin sits down beside you. “I saw the lights too,” she says. “Nobody believed me either.” Somebody passes you a cup. Somebody passes her one, too.

**Now:**
- `2026-10-12_140759_fair-cousin-softening-bench_d02edc0b.png` · FIX · Text: the cousin sits down beside you. Picture: she stands with two adults, and the bench is bare. Redo with her sitting.
- `2026-10-12_135257_hay-barn-dusk-golden-lights_f4398d93.png` · HOLD · Barn at dusk: a lantern on a post by the hay, dancing lights, a white tail with bells in the rafters. Strong for the truth, but it shows the cause before the bend. Use at the bend or later. Cream vignette border.

---

## c6_quill_answer · beat · chapter 6 · The Lord's answer

*When:* `done:farmhouse_sunroom`

Quill rides up with a new paper and, for the first time, a small smile. “With my numbers in hand, the Lord sets the share at a tenth, as in the old days.” He tips his hat. “They were very good numbers.”

**Now:**
- `2026-10-12_140806_sunroom-quill-fraction-one-tenth_6f0c1f90.png` · KEEP + FIX · Text: for the first time, a small smile. Picture: Quill is serious. Minor.

---

## c6_alpaca · beat · chapter 6 · The alpaca comes home

*When:* `done:pet_alpaca`

Page 1. An alpaca stands at the gate, very tall and very polite. She lifts her head and hums one long, strange note, the note that woke the whole farm that night. Nobody was hurt because of her.
Page 2. She spits, politely, on principle. The last line of the rhyme comes back, whole: “Soft alpaca guards all things.” You say all of it, from the very first line. Your voice does not wobble.

**Now:**
- `2026-10-12_140816_alpaca-farm-gate-sunset_22fe29d2.png` · KEEP · Good: all the Helpers together, alpaca tall and polite. Goat collar bell (see above).

---

## c6_supper · beat · chapter 6 · The Fair supper

*When:* `seen:c6_alpaca`

Page 1. The long table, the lanterns, the whole village. You sit down at last, and nobody needs you to stand. You set a place for Lark without a word. He has to sit very still for a moment.
Page 2. The goat eats the blue ribbon. Somebody starts to sing. You know the tune. You sing it, too.

**Now:**
- `2026-10-12_140826_fair-supper-table-lark-moved_c48c0602.png` · FIX · Greenstem drawn as a child again: regenerate him at the farmer's age. The goat's bell (the collar bell) should go, as on the other animals. The squirrel on Lark's shoulder is allowed (parent, 14 Oct 2026): keep it.

---

## c6_ajar · beat · chapter 6 · The edge of the night garden

*When:* `seen:c6_supper`

That night you walk to the edge of the dark garden. You came to say something. You stand there a long time. Somewhere in the white flowers a tiny bell moves, and is still. You go home. It is not time yet.

**Now:**
- `2026-10-12_140832_flower-garden-milk-bowl-bells_8330d0a7.png` · KEEP · Strong: the milk bowl, two small bells, glowing flowers, no Mumyo.

---

## c6_frame6 · frame · chapter 6 · The end of the story

*When:* `seen:c6_ajar`

Page 1. The grandchildren are asleep, all but Minena. “Tell me the imp was real,” she whispers. You tell her the truth, all of it, quietly, the way it happened.
Page 2. “If you ever meet a little fellow with bells,” you say, “tell him I was never angry.” Minena nods, very seriously. That night she dreams of a melody, and in the morning she hums it.

**Now:**
- `2026-10-12_135251_grandchildren-asleep-minena-awake_d9adcd02.png` · KEEP + DECIDE · Right scene. Minena holds a white spiral shell (looks like the conch). No text puts it there; the premise keeps the conch for Minena's own story. Keep as foreshadowing or remove.

---

## Pictures not tied to one piece

These are layout, world or leftover pictures, or frames the review named without an id. Check them against the piece they were meant for before use.

- `2026-10-12_135302_child-window-night-shell-feather_31a525d7.png` · No piece yet; only fits the end of the frame (the farm lives on) · HOLD · Night view of the finished farm through a window, with a conch and a feather on the sill. Same conch question as above.
- `2026-10-12_135213_farm-book-wheat-page-bed_28a07dcf.png` · Book (grandchildren are in it, so it reads as a frame) · KEEP (as frame) · Wheat sketch, scribble handwriting, nothing legible. For the in-game book beat, use the rabbit-sketch picture (no children).
- `2026-10-12_135120_thistle-grab-first-person_85c8ee2a.png` · Ch1: clear the thistles (first-person hands) · KEEP + FIX · Hands in mitts, good. But it shows several dug beds, a fence and a sign; chapter 1 is one patch. Use the thistle-pile picture for the bell beat, or accept a more worked farm here.
- `2026-10-12_140250_tent-ruins-sunset-eye-level_e4550547.png` · Ch1: camp at the ruins (no piece yet) · KEEP · Establishing shot: tent, ruin, road, village roofs.
- `2026-10-12_135328_merchant-campfire-porridge_ce3f861c.png` · Ch1: the seller (text: a woman, on the village square) · DROP · Male merchant with a cart at a campfire on a track. Contradicts the ch1 text (she, square) and the decision that ch1 has no merchant at the campfire. Replace with the campfire-porridge picture.
- `2026-10-12_140933_campfire-porridge-tent-dusk_b25bde1e.png` · Ch1: the seller's porridge at camp (no people) · KEEP · Quiet, no people. Use this in place of the merchant. Treated as the restart of the merchant picture (same subject).
- `2026-10-12_140710_kitchen-table-half-letter-animals_6ebbfb3f.png` · No piece · DROP · The Helpers sit round a table with a half-sheet, reacting like people. No text supports it, and it breaks 'the Helpers do not talk' and their animal nature.
- `2026-10-12_140901_field-stone-pile-lizard_eb1b37fc.png` · World (no piece) · KEEP · Ordinary farm work, hands in mitts, no people.
- `2026-10-12_140905_tree-stump-roots-robin_99748187.png` · World (no piece) · KEEP · Stump with axe and spade; a robin. Ordinary.
- `2026-10-12_140911_wheat-sprout-closeup-water-drop_b25f2b7c.png` · World (no piece) · KEEP · Quiet first sprout. Could mark a turning point.
- `2026-10-12_140917_wheat-bundle-evening-bunny_a9914d07.png` · World (no piece) · KEEP · Hands hold wheat; the bunny (a Helper) waits. Fits the bunny.
- `2026-10-12_140922_stone-well-looking-down_5f621d76.png` · World (no piece) · KEEP · Ordinary.
- `2026-10-12_140927_forest-track-brushwood-frog_eebaed7f.png` · World (no piece) · KEEP + FIX · Cream/white border at the edges; the brief says none.
- `2026-10-12_140941_workbench-knife-basket_78e41d4b.png` · World (no piece) · KEEP · Ordinary crafting.
- `2026-10-12_140948_hens-new-coop_cdf75ffa.png` · World (no piece) · KEEP · Ordinary.
- `2026-10-12_140952_scarecrow-crows-wheat-field_854168ec.png` · World (no piece) · KEEP · Crows are ordinary birds.
- `2026-10-12_140957_compost-bin-steaming_d35f2209.png` · World (no piece) · KEEP · Ordinary.
- `2026-10-12_141002_new-red-barn-dirt-road_37559a0a.png` · World (no piece) · KEEP · Ordinary; matches the red-barn look.
- `2026-10-12_141007_cows-pasture-gate_7e6bfd81.png` · World (no piece) · KEEP · Ordinary.
- `2026-10-12_141011_bee-skeps-wildflowers_c42bb2d2.png` · World (no piece) · KEEP · Ordinary.
- `2026-10-12_141016_market-stall-hazelwood-carrots_7222be3f.png` · World (no piece) · KEEP · Village market texture.
- `2026-10-12_141023_pond-hollow-digging-tortoise_6366d176.png` · World (no piece) · KEEP · The tortoise by the dug spring: matches 'sits on the exact spot where the spring rose'.
- `2026-10-12_141039_sheep-pen-wool-tuft_67043606.png` · World (no piece) · KEEP · Ordinary.
- `2026-10-12_141044_hand-loom-striped-cloth_6db9c28d.png` · World (no piece) · KEEP · Ordinary.
- `2026-10-12_141049_orchard-clearing-ladder-basket_a2351019.png` · World (no piece) · KEEP · Ordinary.
- `2026-10-12_141053_greenhouse-seedlings-sunlight_54b18104.png` · World (no piece) · KEEP · Ordinary.
- `2026-10-12_141059_clover-field-bee-low-view_54fd0b72.png` · World (no piece) · KEEP · Ordinary; the tent and shed at the edge fit.
- `2026-10-12_141105_river-meadow-animals-noon_57952782.png` · World (no piece) · KEEP · Horse, cow, goat by the river. The white flowers should not be read as the night garden.
- `2026-10-12_141109_farm-first-snow-eye-level_8c1ebb9f.png` · World (no piece; winter) · KEEP · Good winter state.
- `2026-10-12_140856_weed-pulling-first-person_3c022297.png` · World (no piece) · KEEP · Hands, worm, weeds. Ordinary.
- `2026-10-12_135719_burnt-farm-dirt-road-view_4c83302b.png` · Layout: the burnt farm from the road (establishing) · KEEP (establishing) · Not tied to a beat. The basket and dented bucket match the box in the story.
- `2026-10-12_135726_burnt-farm-hill-view-framed_7f955b97.png` · Layout: the burnt farm from the hill (establishing) · KEEP (establishing) · Not tied to a beat.
- `2026-10-12_135733_burnt-farm-clearing-eye-level_96984551.png` · Layout: the burnt clearing (establishing) · KEEP (establishing) · The woven basket and dented bucket match the box in the story.
- `2026-10-12_135739_flourishing-farm-cobbled-road-view_327d29e3.png` · Layout: the farm at the end · KEEP (end state) · For the end of the story or free play. Windmill with sails: see mill note.
- `2026-10-12_135746_flourishing-farm-hill-view-framed_bb42bd96.png` · Layout: the farm at the end · KEEP (end state) · As above.
- `2026-10-12_135751_flourishing-farm-garden-path-view_03c20f09.png` · Layout: the farm at the end · KEEP (end state) · As above.
