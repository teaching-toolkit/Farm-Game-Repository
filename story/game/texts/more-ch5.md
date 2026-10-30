# Chapter 5: The Still-room — more pieces (English only)

Round 6b, draft 1 (14 Oct 2026). Existing pieces: `ch5.md`. Format as in `more-ch1.md`. This chapter teaches the plant rule: look, ask a grown-up, never taste on a guess. Every piece that touches plants keeps that rule in the voice, never as a lecture. Timing changes for `c5_page` and `c5_collapse` are listed in `../code-issues-story-timing.md`, not applied here. All 💡 until read aloud. Consistency pass of 14 Oct 2026 applied (`../consistency-fixes.md`); `c5_whirligig` moved to chapter 6 (`c6_whirligig`). Invented here, to accept or overrule: the second hand in the foxglove note (“She does.”, ❓ whose hand; the parent decides), the swing in the orchard moving by itself (second page of `c5_petals`), the badger's job card in pictures.

## c5_board · discovery · The board, with a cough
*When:* `chapter:5 + sidequests>=8` · *Register:* T→G · *Move:* Arrival

The notices on the board have changed. Fewer ladders, more spoons. “HONEY FOR A COUGH, ASK AT NUMBER 4.” “IF YOUR CHILD HAS A FEVER, SEND FOR WREN.” Someone has also written, smaller: “and please stop eating things you find.” It seems like good advice, and you take it.

## c5_dry · moment · The drying rack
*When:* `done:drying_rack` · *Register:* W · *Move:* Reward

You hang the first bunch of herbs to dry. In a week the still-room smells like a meadow that has gone indoors. Dried leaves crumble in your fingers, soft as old paper. A thing that was green and loud is now brown and quiet and exactly as useful as before. Perhaps more.

## c5_salve · moment · A jar for a scrape
*When:* `done:salve_pot` · *Register:* W · *Move:* Reward

The salve is thick, yellow-green and smells of the inside of a hedge. You dab a tiny bit on a scratch you have had for days. It stings for one breath, and then it just feels cool. Greenstem, who has been watching from the door, writes something down. Probably it says: “Works.”

## c5_lookalike · discovery · Two of the same
*When:* `page:k_lookalikes` · *Register:* T · *Move:* Notice

You lay two leaves side by side on the table. Same shape, same size, nearly the same green. One makes a good tea. The other would make a very bad day. You taste neither. You wrap them in a cloth and take them to someone who knows.

## c5_n_foxglove · discovery · In the margin
*When:* `page:k_foxglove` · *Register:* T · *Move:* Notice · *Emoji:* 📝

Beside the foxglove, in thick capitals, pressed hard: “LOOK, DON'T TOUCH. I MEAN IT. — B.” Underneath, in another hand, smaller and rounder: “She does.”

## c5_n_grownup · discovery · In the margin
*When:* `page:k_ask_grownup` · *Register:* W · *Move:* Notice · *Emoji:* 📝

“Ask. It is not a failure to ask. The best healer I know asks first.”

## c5_petals · discovery · Petals on the stream
*When:* `forest_trips>=7` · *Register:* A · *Move:* Plant

Page 1. Beside the path a small stream goes by with petals on it. White ones. They are not from any tree you know. You follow them with your eyes until they turn behind a bend, and then you do not follow them any further. There will be time.

Page 2. On your way home, the swing in the orchard is moving, though there is no wind.

## c5_lamp · scene · A lamp for the dark
*When:* `done:sq_lamp_maker` · *Register:* W · *Move:* Plant

Page 1. The lamp-maker pours your oil into a lamp and lights it. The light is round and yellow and steady.

Page 2. “It's for the marsh road,” he says. “There is a very small light out there some nights, and it is no help at all. People shouldn't have to feel their way.” He says it lightly. He has clearly thought about it a great deal.

## c5_tea_set · moment · Two cups
*When:* `has:tea_set:1` · *Register:* W · *Move:* Omen · *Priority:* 65

The tea set came with two cups. Of course it did: it is a set. You pour one, and then, without deciding to, you put the other on the table too. Nobody comes. Nobody needs to. It feels better with two.

## c5_badger_job · moment · A job card
*When:* `seen:c5_badger + after:c5_badger:3` · *Register:* G · *Move:* Complication

Pinned to your door, held on by a thorn, is a card. On it, in careful claw-scratch: a basket, a bunch of leaves, and a cup. Underneath, a very small moon. You look into the dark yard. Two eyes look back, level, patient. You pin the card back up. It seems rude not to.

## c5_k_still · bark
*When:* `done:ruins_stillroom + chance:0.15`

The still-room door sticks, as it always has. You push it with your shoulder, and the smell of old herbs rolls out and says hello.

## c5_k_rain · bark
*When:* `chapter:5 + chance:0.2`

Rain on the roof, steady, in no hurry. The kind that means *stay in and make something warm*.

## c5_k_wren · bark
*When:* `forest_trips>=2 + seen:c5_wren_check + chance:0.15`

You stop to look at a plant, as Wren taught you. You do not pick it. It will keep until she has seen it. It looks almost disappointed.

## c5_k_tea · bark
*When:* `done:tea_pot + chance:0.15`

The kettle clears its throat and begins to sing. Nothing could be more normal.
