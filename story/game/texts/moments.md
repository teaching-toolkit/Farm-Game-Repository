# Moment pieces

Moment pieces (`story/25`), written 14 Nov 2026. German is in `godot-prototype/data/i18n/data-de.json`.

## m_road_2 · moment · Potholes
*When:* `done:road_2` *Chapter:* 1 *Picture:* merchant_cart_1 *Emoji:* 🛤️
The worst holes are full of stones now. A cart rolls over them and only rattles, like a spoon in a pot. The wheels leave two neat lines in the mud.

## m_road_4 · moment · Cobbles
*When:* `done:road_4` *Chapter:* 3 *Picture:* merchant_cart_2 *Emoji:* 🛣️
The road is made of round stones now, and rain runs off it into the ditch. Your boots click on it. Somebody's wheel goes click-clack-click, and you can hear it coming from far away.

## m_shed · moment · A shelf for everything
*When:* `done:shed` *Chapter:* 2 *Picture:* shed *Emoji:* 🏚️
The log shed has a door that nearly shuts. Inside, every thing has a shelf: logs, carrots, the good rope. The hens look in, decide it is a house, and wait to be let in.

## m_wattle · moment · A basket for a fence
*When:* `done:wattle_fence` *Chapter:* 2 *Picture:* fence_stick *Emoji:* 🧺
Willow sticks go over and under, over and under, until the fence looks like a giant basket. It smells of a wet riverbank. A bug walks along it, looking for a way in.

## m_rain_barrel · moment · Catching the sky
*When:* `done:rain_barrel` *Chapter:* 3 *Picture:* well_3 *Emoji:* 🛢️
A big barrel stands by the well with its mouth open to the sky. The next rain goes plink, plonk, and then a long happy drumming. In the morning there is a small cloud floating in it.

## m_sheep_pen · moment · Room for the woolly ones
*When:* `done:sheep_pen` *Chapter:* 3 *Picture:* barn_2 *Emoji:* 🐑
The new pen has a low roof and a deep bed of straw. It smells like warm bread and wet wool. Even before anyone lives there, it looks like it is waiting for a sleepy sheep.

## m_press · moment · The big screw
*When:* `done:press` *Chapter:* 3 *Picture:* workshop_1 *Emoji:* 🍇
A great wooden screw turns slowly, creak and creak. Out of it comes juice, drip by drip, and a sweet smell fills the yard. Every wasp in the valley suddenly has somewhere to be.

## m_loft · moment · Up the ladder
*When:* `done:cottage_loft` *Chapter:* 3 *Picture:* cottage_loft *Emoji:* 🪜
There is a second room under the roof now, reached by a ladder. The beams are close enough to touch. When rain taps on the tiles, it sounds as if it is tapping on your head.

## m_bookcase · moment · A chair for reading
*When:* `done:library_bookcase` *Chapter:* 3 *Picture:* library_bookcase *Emoji:* 📚
A bookcase stands against the wall, and a chair beside it is just the right size for sitting still. The books lean on each other like sleepy friends. The chair creaks once, politely.

## m_forge_2 · moment · Hotter
*When:* `done:forge_2 + seen:c3_forge` *Chapter:* 4 *Picture:* workshop_2 *Emoji:* 🔥
The new forge glows white instead of orange. You feel its warmth from the gate. Sparks jump up like tiny stars that have forgotten it is daytime.

## m_warehouse · moment · A very big room
*When:* `done:warehouse` *Chapter:* 4 *Picture:* warehouse *Emoji:* 📦
The warehouse is so big that your steps echo. Sacks, boxes and barrels stand in tidy rows, and there is still room left over. A single sparrow flies in and seems very pleased about the ceiling.

## m_workshop_3 · moment · The best bench
*When:* `done:workshop_3` *Chapter:* 4 *Picture:* workshop_3 *Emoji:* 🔨
Every tool hangs on its own hook, and every hook has a small painted outline so it goes back in the right place. The bench is long, smooth and wide. It smells of fresh sawdust and a little of oil.

## m_windmill_2 · moment · Stones that sing
*When:* `done:windmill_2` *Chapter:* 6 *Picture:* windmill_2 *Emoji:* 🌬️
Two big grinding stones now turn inside the mill, and a low hum comes from the floor. The flour comes out soft as snow. You get a white nose just by standing there.

## m_milk · moment · Still warm
*When:* `seen:c2_cow + item:milk>=1` *Chapter:* 2 *Picture:* cows *Emoji:* 🥛
The first milk is in the pail, still warm. It is very white, and it smells of grass and a little of cow. A cat that nobody asked is sitting by the door, looking at the pail.

## m_wool · moment · A cloud, taken off
*When:* `seen:c3_sheep + item:wool>=1` *Chapter:* 3 *Picture:* pets *Emoji:* 🧶
The first wool lies in your arms, soft and a bit greasy, and it smells of rain. The sheep, a lot lighter, trots away as if it just won a race. It looks very surprised at its own legs.

## m_flatbread · moment · Your own bread
*When:* `seen:c1_quern + item:flatbread>=1` *Chapter:* 1 *Picture:* stove_1 *Emoji:* 🫓
The flatbread came from flour you ground yourself. It is a bit lopsided and a bit burnt at one edge. It is also the best thing you have ever smelled.

## m_cheese · moment · Milk, made into more
*When:* `item:fresh_cheese>=1` *Chapter:* 3 *Picture:* market_stall *Emoji:* 🧀
A pale, soft cheese sits on a cloth, and it wobbles when you poke it. Yesterday it was milk. You poke it one more time, to be sure.

## m_pests · moment · Something is eating the leaves
*When:* `pests>=1` *Chapter:* 1 *Picture:* field *Emoji:* 🐛
Small holes appear in the leaves, round as buttons. Somebody has been having supper on your field. You lean close and spot a very full, very green caterpillar, looking guilty.

## m_pests_gone · moment · All quiet
*When:* `seen:m_pests + after:m_pests:4 + pests<1` *Chapter:* 1 *Picture:* field *Emoji:* 🌱
The leaves are whole again, and nothing nibbles. A bird sits on the fence and looks proud, though nobody asked it. New leaves unroll as if nothing happened.

## m_tired · moment · A big yawn
*When:* `energy<2 + step>=3` *Chapter:* 1 *Picture:* tent *Emoji:* 😴
Your arms feel heavy as wet sacks, and the yawn comes all by itself. The tent looks very soft. It is a good day to sit down and let a little rest do its work.

## m_skill · moment · Better than before
*When:* `skill_ranks>=1` *Chapter:* 1 *Picture:* workbench *Emoji:* ⭐
Something that used to be hard is easy now. Your hands know the way before you do. Even the tools look a little impressed.

## m_first_rain · moment · The first rain
*When:* `rain` *Chapter:* 1 *Picture:* field *Emoji:* 🌧️
Drops land on the soil one by one, each leaving a tiny dark spot. Then the whole field drinks. The air smells like a wet stone, and an earthworm comes up to have a look.
