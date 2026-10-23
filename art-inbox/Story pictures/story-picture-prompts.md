# Hazelwood Harvest: story picture prompts

Draft 1, 12 Oct 2026. Based on `story/outline/ladder.md`, `story/story-delivery.md`, the character files and TODO R3. Model: **Nano Banana 2, 1K**.
IDs follow the ladder (`c1_stalk` = chapter 1, beat 1.1). The suggested file name is `story/<id>.png`, which matches the `picture` field in `story-delivery.md` §6.

---

## 1. How to use this

1. **Paste the style block (§2) first, then the scene prompt.** Each scene prompt is written to follow it directly.
2. **Aspect ratio: 1:1**, like the album pictures. If the story box ends up wider, use 4:3 and nothing else in the prompts changes.
3. **Reference images in OpenArt:**
   - **Style:** one album sheet (for example `sheet40-album-3.png`). Add: *"Match the drawing style of the reference image."*
   - **Grandchildren:** upload the Minena and Manjiva pictures as character references and add: *"Keep the children's looks from the character references, but draw them in the cartoon style described, not in the realistic style of the references."* Without that line, Nano Banana tends to copy the painterly realism.
   - **Helpers:** use the game's own animal picture (`pet_bunny.png` and the others) as a reference, so the story bunny matches the map bunny.
4. **One scene per image.** Story pictures carry more detail than album stamps, so 2×2 sheets will lose faces and the Mumyo glimpses. Batch only the simple everyday vignettes (§8) into sheets, if at all.
5. **Check every result for:** a farmer's face or body (reject it), text or letters, a black outline instead of brown, and Mumyo too visible (he should be a find, not the subject).

---

## 2. Style block (paste before every prompt)

> Warm hand-drawn storybook cartoon illustration for a cosy children's farming game. Soft dark-brown ink outlines (not black), flat colours with gentle cel shading and a light paper texture, a cosy earthy palette of honey yellow, moss green, warm browns, brick red and soft sky blue. Friendly rounded characters with rosy cheeks, simple bright eyes and chunky cute proportions. Old-world countryside setting, no modern objects. Eye-level storybook view, full-bleed square illustration, no border, no frame, no text, no letters, no logos.

Night variant (add for night scenes): *"Night scene lit by warm lamplight and cool moonlight, deep blue shadows, still soft and friendly, never scary."*

---

## 3. Rules every prompt follows

- **The farmer is never in a painted picture** (R3). Instead, use one of three options:
  - **Through the farmer's eyes:** the scene as the farmer sees it, people looking at the viewer.
  - **Hands from the camera:** first-person view with hands at the bottom edge. Use this only in a few panels. Put the hands in **brown woven work mitts or long sleeves**, so skin colour and age stay open.
  - **The silhouette:** a small backlit silhouette from behind, wearing a wide straw hat, with the light coming from the front and no visible features.
- **Negative line to add when a person could slip in:** *"Do not show the farmer. No main character in the foreground."*
- **The helpers are animals, just too clever.** They have expressive faces and sensible poses but no clothes and no talking. The badger's spectacles are the only exception (they are real).
- **Mumyo is hidden in a few pictures only** (`★ Mumyo` marks them). He is tiny, half-hidden, seen from the side or back, and never looks at the viewer. He should be a find for sharp-eyed children, not the subject of the picture.
- **The fire is never shown burning.** Ruins are soft and overgrown, not grim. The barn memory (F6b) shows lights and a lantern, not flames.

---

## 4. Cast (paste the relevant lines into a prompt)

**Grandchildren (frame only)**
- **Minena:** a girl of 7 with wild, slightly messy long brown hair, bright hazel eyes, rosy cheeks and a lively, curious face. She wears a **moss-green hooded cloak** over a dark green tunic, a green scarf, dark trousers and brown lace-up boots. She often has a stick or a feather in her hand. *(From your reference picture 2.)*
- **Manjiva ("Nene"):** Minena's little sister, about 4, with straight brown hair, a fringe, big grey-blue eyes and round cheeks. She wears a **brown hood with little pointed animal ears**, an olive-green tunic with a big belt buckle and pocket flaps, dark baggy trousers and brown boots. She looks serious and wide-eyed. *(From your reference picture 1.)*
- 💡 **Two more grandchildren** (my invention, rename or drop as you like): **an older boy of about 10** with freckles, a red knitted cap and a know-it-all grin (the one who blurts out *"Is this the part where…?"*), and **a girl of about 9** with two blonde braids and a mustard-yellow cardigan (the one who hushes him).

**Helpers**
- **Bunny:** small and brown, with one ear that will not stand up and a nose that is never still.
- **Tortoise:** moss on her patterned shell and ancient, calm eyes.
- **Goat:** shaggy white goat, one horn a bit bent, a beard full of burrs and a schemer's eyes.
- **Pony:** chubby hazel-brown pony with a fluffy blond mane she is visibly proud of.
- **Badger:** old and grey-striped, with real round spectacles on his nose.
- **Alpaca:** cream-coloured, with enormous eyelashes and tremendous dignity.

**Others**
- **Mumyo:** a tiny imp no bigger than a hand, with white skin, wild white hair, a long thin tail, tiny dragonfly wings, a black belly and a tiny grey vest hung with little bells.
- **Lark:** a tall, thin, ageless man in a long rust-brown coat with mismatched buttons and too many pockets. He has an amused, sideways look.
- **Young Greenstem:** a lanky village boy of about 15 with a mop of curly hair and a herb-green apron, holding a bunch of herbs and looking eager and full of questions.
- **Master Quill:** a thin, stiff steward with a long nose and a neat grey coat, carrying a thick ledger under his arm and a quill behind his ear.
- **Wren the healer:** a sturdy middle-aged herb woman with greying hair in a bun, a grumpy-kind face, a shawl and a basket of herbs.
- **The miller:** a broad, floury man with bushy eyebrows and folded arms.
- **The cousin:** a young woman of about 19, neat and serious, wearing a town dress.

---

## 5. The frame: grandchildren at your bed

All frame pictures are set in **the same room**, so build it once and reuse it. The room is a cosy farmhouse bedroom at night with stone and timber walls, a patchwork quilt at the bottom edge, a small window with stars, a warm oil lamp on the bedside table, an old leather-bound farm book, and a **dented tin bucket used as a flowerpot**, one of Berit's things. The view is always **from the bed**, looking at the children.

**F0a · `frame_0_ask` (opening):**
> View from an old person's bed, looking out across a patchwork quilt at four grandchildren crowding eagerly around the bedside at night. In front, Minena [cast line], chin on the quilt, eyes shining; beside her Manjiva [cast line], clutching the quilt; behind them an older freckled boy in a red knitted cap and a girl with two blonde braids in a yellow cardigan. They look straight at the viewer, begging for a story they have heard many times. Cosy farmhouse bedroom, oil lamp, starry window, old leather farm book on the bedside table, a dented tin bucket with flowers. Do not show the person in the bed.

**F0b · `frame_0_book` (opening):**
> First-person view from a bed at night: two hands in long knitted sleeves opening an old leather farm book on a patchwork quilt. The first page shows a little drawing of a wheat stalk and a few lines of faded handwriting (unreadable squiggles, no real letters). Four grandchildren lean in at the edges of the picture, a seven-year-old girl in a moss-green hood closest. Warm lamplight.

**F1 · `frame_1` ("Was there really a bunny?" "She was rude about carrots."):**
> Bedroom at night, view from the bed. The grandchildren are giggling; little Manjiva holds two fingers up on her head like bunny ears with a very serious face, and Minena laughs. A carrot-shaped cushion lies on the quilt. Cosy, funny mood.

**F2 · `frame_2` ("Did you find out who started it?" "Not then."):**
> Bedroom at night, view from the bed. The older boy in the red cap leans forward, mouth open, about to blurt something out; the girl with blonde braids claps a hand over his mouth to hush him. Minena watches the viewer closely, curious and a little serious. Manjiva is half asleep against Minena's shoulder.

**F3 · `frame_3` ("Were you scared of the cousin?" "More than of any imp."):** ★ Mumyo
> Bedroom at night, view from the bed. Minena turns her head toward the dark window, listening, one hand raised as if to say "shh, did you hear that?". The other children look at the viewer. Hidden detail: on the outside windowsill, half behind the frame, a tiny white hand-sized imp with a long tail, seen from behind, its little grey bell-vest glinting in the moonlight. Nobody else notices him.

**F4 · `frame_4` ("Was the Lord a villain?" "He was afraid."):**
> Bedroom at night, view from the bed. The children sit in a row on the quilt, more thoughtful now. The older boy holds a toy wooden castle; Minena hugs her knees. The lamp flickers low. A quiet, slightly serious mood, still warm.

**F5 · `frame_5` ("Did you get better?" "Badgers make very slow tea."):**
> Bedroom at night, view from the bed. Minena carefully carries a too-full cup of tea toward the viewer with both hands, tongue out in concentration, while Manjiva follows holding a sugar bowl. The others watch. Steam curls up. Tender and funny.

**F6a · `frame_6_end` ("Tell me the imp was real."):**
> Bedroom late at night, view from the bed. Three grandchildren are asleep in a heap at the foot of the bed under a shared blanket. Only Minena is awake, kneeling close to the viewer with big serious hazel eyes, holding a small white spiral seashell in her hands. The lamp is almost out; moonlight from the window. Hushed, important moment.

**F6b · `frame_6_barn` (the memory: what happened in the barn):** ★ Mumyo
> Soft dreamy memory illustration with faded edges, like a memory in warm sepia and gold. The inside of an old hay barn at dusk: tiny dancing golden lights float above the hay like fireflies, and an old oil lantern hangs on a hook. In the hay, a small round dent where a child has been sitting. High on a beam, a tiny white imp with bells on his vest juggles the little lights, seen from the side. No flames, no people. Magical and a little sad.

**F6c · `frame_6_promise` ("Tell him I was never angry."):** ★ Mumyo
> Night, from a child's bedroom window looking out over a moonlit farm and a dark forest edge with faintly glowing white stones. On the windowsill in the foreground, a small spiral seashell and a single feather. Far off among the trees, a tiny point of light and the suggestion of a little figure with bells. Quiet, hopeful, magical.

---

## 6. Opening story panels (before the first goal, TODO I9)

**P1 · `open_ruins`:**
> A burnt-down farm seven years later, under a grey-gold morning sky: blackened timber frames of a barn and house softened by weeds and wildflowers, a collapsed stone chimney, ash-grey ground. At the very edge of the frame, a small backlit silhouette of a farmer in a wide straw hat with a bundle on their back, seen from behind, no features visible. The forest edge is behind the ruins. Melancholy but hopeful, not scary.

**P2 · `open_tent`:**
> A small canvas tent pitched beside the burnt ruins at sunset, with a dented tin bucket, a tin pot and an old leather book on a blanket in front of it. The light comes from behind the tent. A path leads off toward a distant village with a few chimneys. Lonely but cosy.

---

## 7. Story beats, chapter by chapter

### Chapter 1: Ashes

**c1_stalk (1.1) · the one stalk:**
> Close-up of one small square of green grass in the middle of ash-grey burnt ground. In the centre stands a single ripe golden wheat stalk; every grain has been nibbled off except one at the very top, and tiny nibble marks show. Low morning sun makes it glow. It should feel like a mystery: who nibbled it?

**c1_book (1.2) · Berit's book:**
> First-person view: hands in brown woven work mitts holding open an old leather farm book. On the page are a pencil sketch of a long-eared rabbit among clover and some faded handwriting (unreadable squiggles, no real letters). A pressed clover leaf lies in the fold. Warm daylight.

**c1_night (1.3) · first night, awe:**
> Night at the forest edge seen from beside a small campfire: tall dark trees, and between their roots white stones glowing faintly like moonlight. Fireflies drift. The sky is deep blue and full of stars. A sense of a quiet melody hanging in the air, shown as faint silver swirls drifting from deep in the forest. Awe and wonder, never scary.

**c1_sticks (1.4, clear_thistles) · the silly pile:** ★ Mumyo
> A freshly cleared patch of earth with pulled thistles lying in a heap. In the middle, three sticks are balanced in a ridiculous, wobbly tower with a thistle flower stuck on top like a hat. Behind a thistle heap at the edge, only a thin white tail tip and a tiny glint of a bell are visible. Funny and slightly mysterious.

**c1_ledger (1.5, ruins_workshop) · the burnt ledger page:**
> Close-up of a scorched, half-burnt ledger page lying among ash and charred planks inside a collapsed workshop. It shows columns of numbers growing bigger and bigger (simple scribbled tally marks and numbers, no words), with a wax seal at the corner. Sunlight falls through the broken roof beams onto it.

**c1_merchant (1.6, d_porridge) · the travelling merchant:**
> Through the farmer's eyes: a jolly, round travelling merchant with a big moustache and a patched cloak sits on a log by a small campfire, holding a steaming wooden bowl of porridge with both hands and looking at the viewer with surprised recognition. His little cart with a pony stands behind him on a muddy track. Evening light.

**c1_board (1.7) · the notice board:**
> A wooden village notice board at the edge of Hazelwood, covered in pinned paper notes, little drawings and ribbons (no readable text). Villagers chat in the blurred background. Seen from slightly further away than feels comfortable, as if the viewer is too shy to come closer.

**c1_bunny (1.9, pet_bunny) · the bunny comes home ★ big beat:**
> The small green patch in the burnt ground, now with young wheat sprouts. A small brown bunny with one floppy ear sits proudly in the middle of it, looking straight at the viewer with a "took you long enough" expression, a nibbled grain stuck to her whiskers. Golden evening light, warm and triumphant.

**c1_bells (1.10) · two rings in the night:** ★ Mumyo
> The tent at night from the outside, glowing softly from a lamp inside. The bunny sleeps curled up by the entrance. On the tent's guy rope hangs a tiny bell no bigger than a fingernail, still swinging. Musical note swirls drift up. Deep in the shadows by a bush there is a tiny pale shape, almost invisible.

### Chapter 2: Homestead

**c2_letter (2.1) · a letter from your mother:**
> First-person view: hands in work mitts holding an unfolded letter with neat handwriting (unreadable squiggles, no real letters). In the background, autumn leaves are falling over a half-cleared farm and the first frost glitters on the grass. Slight urgency.

**c2_walls (2.2, cottage_walls) · crooked walls:**
> Small log cottage walls standing alone on the farm, clearly built by one inexperienced person: logs a bit crooked, one corner sagging, a gap stuffed with moss. Sunny day; the bunny sits on a log looking doubtful. It should be charming and funny, a proud first effort.

**c2_greenstem (2.3, d_stone_soup) · Greenstem at the gate:**
> Through the farmer's eyes: Young Greenstem [cast line] leaning over a rickety stick gate, grinning, pointing at the viewer with a bunch of herbs as if he has just recognised someone. A pot of stone soup steams on a stone nearby. Bright day, friendly.

**c2_stumps (2.4, ruins_lumber) · too many stumps:**
> Wide view of the slope between the farm and the forest edge, covered in dozens of old tree stumps, far too many for such a small farm. Only a few trees remain at the top. Weeds and saplings between the stumps. Grey-blue sky, thoughtful mood.

**c2_lark (2.5, road_3) · Lark on the fence:**
> Through the farmer's eyes: Lark [cast line] sitting on a wooden fence beside a fresh gravel road as if he had always been there, legs crossed, eating an apple, an amused sideways smile. One coat pocket bulges oddly. Bright afternoon, a slightly magical feel.

**c2_scorch (2.6, ruins_barn) · the scorch began low ★ turn:**
> Inside the ruins of a burnt barn: an old timber wall where the scorch marks clearly start low down in one corner, spreading upward like a dark fan, while the roof beams above are hardly burnt. A ray of light falls exactly onto the corner. Old hay remains on the ground. Serious, investigative mood, not frightening.

**c2_compost (2.7, ruins_compost) · Rest the field. Rest yourself.:**
> An old wooden compost corner, completely empty, clean and dry, with cracked earth. A small scrap of paper with faded handwriting (unreadable) is pinned to a post with a thorn. A single weed grows in the corner.

**c2_roof (2.8, cottage) · a real roof before the frost:**
> The finished cottage with a fresh golden thatched roof, smoke rising from the chimney, a warm glowing window, the first snowflakes falling over the farm at dusk. A wreath of dried wheat hangs on the door. Cosy and triumphant.

**c2_tortoise (2.9, pet_tortoise) · the tortoise comes home ★ big beat:**
> A freshly dug pond, still half empty, with water slowly bubbling up from a spring in the middle. An ancient tortoise with a mossy shell sits calmly at the edge, exactly above the spring, eyes half closed. Reflections, dragonflies, reeds. Patient and peaceful.

**c2_hook (2.10) · the lantern hook:**
> Close-up of a new barn frame of fresh pale timber; in its middle, an old blackened iron lantern hook kept from the ruin, sharply in focus. Evening light. A question hangs in the air.

### Chapter 3: Smallholding

**c3_miller (3.2) · the miller glares:**
> Through the farmer's eyes: the miller [cast line] standing on a stone bridge over a low, muddy stream, arms folded, frowning at the viewer. His mill wheel behind him barely turns. Overcast day.

**c3_forge (3.3, forge) · clang:**
> A new smithy with a stone chimney and a glowing forge. Old Odinson, a white-bearded smith with huge arms, nods approvingly at the viewer, and young Bo, an apprentice boy with a sooty face, holds up a glowing horseshoe with tongs. First-person hands in leather gloves hold a hammer at the bottom edge. Sparks fly, warm orange light.

**c3_millbell (3.4, ruins_windmill) · the bell too small for any cow ★ turn:** ★ Mumyo
> Inside an old ruined mill: dusty light beams, broken millstones, cobwebs. On a rusty nail in a beam hangs a tiny bell far too small for any cow, catching the light. Behind a sack of old flour, a tiny white imp with a long tail and a bell-vest peeks out, seen from the side and looking at the bell, not at the viewer. He is easy to miss.

**c3_stream (3.5) · the stream runs clear:**
> The same stone bridge, now over a clear sparkling stream; the mill wheel turns happily. The miller stands there with his arms no longer folded and gives a single stiff nod to the viewer. Sunny day.

**c3_dance (3.6, sq_harvest_dance) · the dance:** ★ Mumyo
> The village harvest dance in the evening: lanterns in apple trees, bunting, villagers dancing, a fiddler. In the foreground, a cider table where wooden mugs float a little in the air for a moment; one is falling and a pair of hands in long sleeves at the bottom edge catches it. Under the table, one tiny bell glints. Joyful and magical.

**c3_goat_list (3.7) · the goat eats the list:**
> Close-up of a shaggy white goat with a bent horn and burrs in its beard, chewing a sheet of paper with total innocence, half of the list hanging out of its mouth. A pencil lies on the ground. Funny.

**c3_goat (3.8, pet_goat) · the goat comes home ★ big beat:**
> A field overgrown with tall, spiky thistles that nobody could clear. In the middle, the goat happily munches her way through them, leaving a perfect cleared path behind her and looking at the viewer with her mouth full and a smug expression. Sunny afternoon.

**c3_hat (3.9) · the scarecrow wears your hat:** ★ Mumyo
> A stick scarecrow in a field at dusk, wearing a wide straw hat that is clearly too nice for it. A tiny white tail curls out from under the hat brim. Crows sit on the fence, unimpressed. Funny, mysterious.

### Chapter 4: Village Trade

**c4_quill (4.1, farmhouse_base) · Quill at the gate:**
> Through the farmer's eyes: Master Quill [cast line] standing very upright at the farm gate beside a new stone foundation, ledger open, looking at the viewer over his long nose. A fine black horse waits behind him. Cool morning light, a slightly tense mood.

**c4_boat (4.2, farmhouse_walls) · the paper boat:** ★ Mumyo
> Master Quill stands at the edge of the farm pond, horrified, staring at a perfect little paper boat folded from two ledger pages floating away across the water. Behind a reed, a tiny white tail tip flicks away. Funny.

**c4_lease (4.3, ruins_greenhouse) · the old lease:**
> Inside the overgrown ruins of an old glasshouse: broken panes, ivy, sunlight. An old dented tin box lies open on a potting bench, holding a rolled document with a red wax seal and a big hand-drawn "½" symbol (the only symbol allowed, no words). Dust motes float.

**c4_no (4.4, farmhouse) · your first no ★ turn:**
> The North Field resting under clover and wildflowers, with bees and butterflies. In the foreground stands Master Quill with his ledger, pen frozen mid-air, surprised. Lark sits on the fence nearby, grinning. A new brick farmhouse stands in the background. Sunny, quietly triumphant.

**c4_library (4.5, library_room) · Lark sorts by weight:**
> A new cosy library room in the farmhouse. Lark [cast line] is arranging books on the shelves in a ridiculous order, from a huge heavy tome to a tiny booklet, weighing two books in his hands with great seriousness. Warm window light.

**c4_pony (4.7, pet_pony) · the pony comes home ★ big beat:**
> The chubby pony with a fluffy blond mane trots proudly into the Hazelwood village square pulling a cart piled with sacks, baskets and crates of farm produce. Villagers turn, smile and point; children run alongside. Sunny, celebratory.

**c4_out (4.8) · Quill rides away:**
> Evening: Master Quill riding away down the paved road toward a distant manor house on a hill, his ledger under his arm. Long shadows. The farm is in the foreground. An uneasy, open-ended mood.

### Chapter 5: Healing

**c5_cough (5.1) · a cough in Hazelwood:**
> A Hazelwood street in grey autumn weather: a few shutters closed, a mother wrapping a scarf around a coughing child, Wren the healer [cast line] hurrying past with an almost empty basket. Worried but gentle mood.

**c5_stillroom (5.2, ruins_stillroom) · Berit's still-room:**
> The ruin of a small herb house: hanging bunches of dried herbs, dusty bottles, a cracked mortar and pestle on a table. In the middle, an old book with a torn-out page, the torn edge clearly visible. Golden light through a broken window.

**c5_shell (5.4) · something white and spiral:**
> Deep in the Moonstone Forest: huge mossy trees and white glowing stones. Far off between the trunks, half-hidden, a giant white spiral conch shell taller than a house, half sunk in the moss and glowing softly. Light beams fall through the canopy. Awe, mystery, quiet.

**c5_page (5.6) · the torn page ★ turn:**
> First-person view: hands in long sleeves holding a torn book page fitted back into its gap. On the page are a small sketch of a badger and a sketch of tired children in a field at night under a moon (pencil drawings, no words). Lamplight; a serious mood.

**c5_low (5.7) · you collapse in the still-room ★ low point:**
> Low view from the floor of a herb still-room: tipped-over basket, scattered herbs and bottles, a candle burned low. Wren the healer kneels close to the viewer, worried and grumpy at the same time, one hand reaching down. Dim, quiet, tender. Not scary.

**c5_badger (5.8, pet_badger) · the badger comes home ★ big beat:**
> A cosy kitchen corner: the old grey badger with real round spectacles carefully sets out a tea set on a small table, pouring tea from a very large teapot. An empty chair is pulled out for the viewer. Steam, warm light, a feeling of "sit down first".

**c5_seal (5.9) · the Lord's seal:**
> Close-up of a folded letter lying on a kitchen table, closed with a big red wax seal showing a stern stag's head. A cup of tea beside it has gone cold. A feeling of escalation.

### Chapter 6: Master Farm

**c6_letter (6.1) · back to a half:**
> The same letter now opened on the table, showing only the big hand-drawn "½" symbol (no words). The bunny, tortoise, goat, pony and badger crowd round the table, all staring at it with offended faces. Funny and tense at once.

**c6_broker (6.2, import_broker) · Lark as the Import Broker:**
> Through the farmer's eyes: Lark [cast line] behind a market stand stacked with strange exotic goods (spice jars, rolled carpets, a stuffed parrot, a telescope), arms spread wide in enthusiastic welcome. Colourful and funny.

**c6_garden (6.3, river_meadow_drain) · the night garden ★ awe:** ★ Mumyo
> Dusk at a former marsh by a river: hundreds of white night-blooming flowers opening at once and glowing softly in the blue light. Fireflies, mist over the water. No one is in sight; deep among the flowers, a few tiny bells hang on grass stems. Magical, tender, very quiet.

**c6_tables (6.4) · the Fair tables fill:**
> The Hazelwood Harvest Fair on the village square: long tables filling with pies, cheeses, jars of preserves and folded coloured cloth, villagers carrying more, bunting and ribbons, Greenstem and Wren arranging a herb table. Bright, busy and happy.

**c6_family (6.5) · we're coming to the Fair:**
> A letter lying on a windowsill with a little hand-drawn picture on it: five small stick figures and a cart (no words). Through the window, a farm decorated for the Fair. Nervous excitement.

**c6_accuse (6.6, d_fair_cloth) · the cousin speaks ★ crisis:**
> Through the farmer's eyes, at the Fair: the cousin [cast line] standing in the middle of the crowd, pointing at the viewer. The villagers have stopped and turned; a fiddler lowers his bow; a pie is held frozen mid-air. Behind the cousin stand worried parents. Tense silence, but still a gentle drawing style.

**c6_bend (6.7) · you sit down and tell ★ the bend:**
> The same Fair, a moment later: the view has dropped lower, as if the viewer has sat down on a bench. The villagers lean in, listening quietly. The cousin has come closer, her face softening, eyes wet. The bunny sits close against the bottom edge. Late golden light. Quiet, brave and warm.

**c6_share (6.8, farmhouse_sunroom) · a tenth, as in the old days:**
> A bright new sunroom full of plants. Master Quill, stiff as ever but with the tiniest smile, holds up a new document with a big "1/10" symbol (no other text). Sunlight floods the room.

**c6_alpaca (6.9, pet_alpaca) · the alpaca comes home ★ big beat:**
> A cream-coloured alpaca with enormous eyelashes walks with tremendous dignity through the farm gate at sunset, head high. Behind her, the bunny, tortoise, goat, pony and badger wait in a welcoming row. Triumphant and moving.

**c6_supper (6.10) · the Fair supper ★ the ending:**
> Through the farmer's eyes, seated at a long Fair supper table under lanterns and bunting: villagers, the family, Greenstem, Wren and Master Quill eat and laugh together. Lark sits very still with his hands folded, looking oddly moved. A squirrel sits on his shoulder. At the end of the table, the goat is chewing a blue prize ribbon. Warm, golden and joyful.

**c6_milk (6.11) · a bowl of milk at the night garden:** ★ Mumyo
> Night at the glowing white flower garden by the river. In the foreground, a small clay bowl of milk set down on a flat stone; moonlight on the milk's surface. Deep among the flowers, two tiny bells glint. No one is visible. Ajar, tender, unresolved.

---

## 8. Everyday moments (Discoveries, first-tap problems, small wins)

These are smaller vignettes for the routine goals. They work well as **first-person hand panels**, which keep the farmer out and make the work feel like yours. Prompt shape: *"First-person view, hands in brown woven work mitts …"*

| ID | Trigger | Prompt (after the style block) |
|---|---|---|
| `ev_clear_patch` | land_start / first patch | First-person view: hands in work mitts pulling a big weed out of dark crumbly soil, roots dangling, a cleared square of earth beside it, a worm wriggling. Morning light. |
| `ev_thistles` | clear_thistles | First-person view: hands in thick mitts grabbing a huge prickly purple thistle, a wooden stick hoe leaning nearby, thistle fluff drifting in the air. |
| `ev_rocks` | clear_rocks | A wheelbarrow-sized pile of grey field stones beside a freshly cleared patch; a hand in a work mitt places one more stone on top. A lizard suns itself on the pile. |
| `ev_stumps` | clear_stumps | An old tree stump half dug out, its big roots exposed, a stone hand axe and a wooden shovel leaning against it. A robin sits on top. |
| `ev_sprout` | first crop planted | Extreme close-up of the first tiny green wheat sprout pushing through the soil, a single drop of water on its leaf, a watering scoop's spout at the edge. Hopeful. |
| `ev_harvest` | first harvest | First-person view: hands holding a small bundle of golden wheat stalks against the evening sky, the bunny looking up hopefully. |
| `ev_well` | well_2 | Looking down into a freshly dug stone-lined well, a wooden bucket on a rope, a circle of sky and the reflection of clouds on dark water. |
| `ev_brushwood` | road_1b | A muddy track with bundles of brushwood laid across the worst puddles, a cart's wheel ruts, a frog sitting on a branch. |
| `ev_campfire` | campfire | A small stone-ringed campfire with a tin pot of porridge bubbling on a tripod at dusk, the tent behind it. |
| `ev_workbench` | workbench | A rough wooden workbench under an open sky with a stone knife, rope and a half-made basket on it, wood shavings on the ground. |
| `ev_chickens` | animal_chicken | Three plump hens stepping curiously out of a new little wooden coop, one already pecking at the viewer's boot at the bottom edge. |
| `ev_scarecrow` | scarecrow_1 | A rickety stick scarecrow in a patched shirt, crows perched on its arms looking unimpressed. |
| `ev_compost` | compost_bin | A new wooden compost bin filled with straw, vegetable peelings and leaves, a little steam rising on a cool morning. |
| `ev_barn` | barn_1 | A new red timber barn standing on the spot of the old ruin, fresh wood, doors open, swallows flying in. |
| `ev_cows` | animal_cow | Two brown-and-white cows walking into a fresh pasture, one sniffing curiously at the viewer. |
| `ev_bees` | animal_bees | Straw bee skeps on a wooden bench among wildflowers, bees humming in and out. |
| `ev_stall` | market_stall | A small wooden market stall at the edge of Hazelwood with baskets of carrots and onions and a striped awning; a villager stops to look. |
| `ev_pond` | pond | A muddy hollow being dug out with a shovel at the edge; the first water seeping in, and the tortoise watching. |
| `ev_windmill` | windmill_1 | A new stone windmill with four big white sails turning against a blue sky, sacks of flour at its door. |
| `ev_sheep` | animal_sheep | Fluffy sheep in a new pen, one with a tuft of wool stuck on the fence. |
| `ev_loom` | hand_loom | A hand loom by a window with a half-woven striped cloth and balls of wool in a basket. |
| `ev_orchard` | orchard | An old overgrown orchard being cleared: brambles cut back, gnarled apple trees with a few red apples, a ladder against one. |
| `ev_greenhouse` | greenhouse | A sparkling new greenhouse with seedlings in clay pots and condensation on the glass. |
| `ev_north_field` | north_field | A wide field at rest under purple clover, a bee landing in the foreground. |
| `ev_meadow` | river_meadow | A green river meadow at noon with grazing animals, the white night flowers closed for the day among the grass. |
| `ev_frost` | first winter | The farm under its first snow, with smoke from the cottage chimney and animal tracks in the snow. |

---

## 9. Order of work

1. **Test the style first** with four pictures: `frame_0_ask`, `c1_stalk`, `c1_bunny` and `ev_thistles`. If they sit well next to the album pictures and the frame children look like Minena and Manjiva, go on.
2. Make the **frame pictures** next, since they reuse the same room and children (consistency is easiest in one session).
3. Then chapter 1 and 2 beats, then the rest in order.
4. Make the everyday moments last, or batch them 2×2 if credits are tight.

**Count:** 10 frame, 2 opening panels, 52 beats and 26 everyday moments make **90 pictures**. At three versions each that is a lot of credits. The beats marked ★ big beat plus the frame (about 20) are the core; the rest can follow later.
