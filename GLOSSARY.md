# Hazelwood Harvest (the Farm Quiz Game)

The farm game for an eight-year-old: its rules and systems (the story has its own glossary, see `GLOSSARY-MAP.md`). This glossary holds the words of the farm rules: what the farmer does, what it costs, and how the game checks it. It grows as terms are settled in design sessions (`/grill-with-docs`).

## Language

### The farmer's work

**Chore**:
Something the farmer can do on the farm that has a cost and an effect, such as planting, harvesting, weeding, clearing snow, baking, making a basket or going to the village.
_Avoid_: action (too close to act), task (a to-do item of the project), errand (the energy multiplier of the village trip), deed

**Act**:
The farmer's animation that plays while a chore happens (walking to a patch, swinging the axe). An act has no rules.
_Avoid_: action

**Blessing**:
Something a pet gives the farm out of grace, for free, by its own effect (the pet clears weeds, brings water, makes an item). A blessing is not a chore and costs the farmer nothing. The pets are gracious helpers, like small demi-gods, but the game does not call them that. German: "Segen". In the code: `G.pets.blessings_of`; the data `entries` of `rules/54-pets.json` lists a pet's blessings and chores. Only the save keys keep the old name `job` (`pets.job`, `pets.second.job`, `pets.last.job`), so that old saves load.
_Avoid_: duty, job (a job is one of the child's little paid jobs), pet job

**Automated chore**:
A chore of the farmer that a pet does instead, at the farmer's effective cost (energy, water, items) but using none of the farmer's moments, as if the farmer had done it. It is a different thing from a blessing. The word is for the builders; the child's text says "Helps with" (German "Hilft bei"). Built (`pets-automation/02`-`04`): a pet's rule is a blessing or an automated chore; from level 3 the chore has the WHEN card ⚡ "My energy ≥ n" (default a third of the bar). Specified in `.scratch/pets-automation/spec.md`.

### What a chore takes, and whether it can run

**Base cost**:
What a chore takes before skills, tools and the season change it, as written in the data.

**Effective cost**:
What a chore takes right now, after skills, tools, season and buffs. It is the cost drawn on the chore's button and the cost that perform takes.
_Avoid_: expected cost (the recipe tile's "Expect" means the grade), quote

**Requirement**:
One thing that must hold before a chore can run, such as enough energy or water, an item, the right season, a patch clear of snow, or the Lord's share paid. An unmet requirement is the reason a button is grey.

**Check**:
The read-only question "what would this chore cost now, and can I do it?". Its answer is the effective cost and the requirements. A check changes nothing.

**Perform**:
Doing the chore, by the farmer or, later, for the farmer by a pet. It spends the effective cost, applies the effect and the follow-ups, and returns a report.

**Pay function**:
The one way coins leave the purse (`G.lord.pay_coins`). It is refused while the Lord's share is owed (reason `lord`) or when the purse is short (reason `coins`), makes the coins fly to the payee, and is not applied to the payment of the share itself. Shops, goals, buildings and animals all use it.

**Report**:
What perform returns: whether the chore was done, which requirement failed if not, what was spent and what was gained.

### Money

**Price**:
The coins the market pays or charges for an item. It is not the cost of a chore.
_Avoid_: cost (for market money)

### Learning and time

**Time Quiz**:
The general-knowledge questions that are the farm's clock: each right first answer moves farm time one step.
_Avoid_: quiz (alone), the clock

**Question** (as a unit of time):
One right first Time Quiz answer, the step by which farm time moves.
_Avoid_: turn, tick

**Walk**:
Going somewhere that costs one Time Quiz question: to the village and back, into and out of the forest, a visit. A right first answer
gets the farmer there; the place itself shows where they are.
_Avoid_: trip question, travel question

**Purpose**:
What a Time Quiz question is answered for: farm time, or one of the walks. Each purpose names what happens after a right first answer.
_Avoid_: mode, kind

**Rest**:
Mental-arithmetic sums that give the farmer energy.
_Avoid_: training (the old name)

**Sum**:
One Rest exercise.

**Pack**:
A set of Time Quiz questions on one topic, chosen by the parent.

**Card**:
One idea of farm knowledge, learned by reading and a short quiz; it unlocks something, boosts something, or both.

**Learning kit**:
The reusable part of the game that holds the learning record, the sums, the quiz engine and the timer.

**Learning record**:
One child's progress on every sum and question.

### Story and progression

**Chapter**:
One of six stages of the game, each ending with a new pet.

**Goal**:
A story step in the quest book.

**Node**:
Anything in the data that can be unlocked or built (a building, upgrade, tool, card, goal).

**Place**:
A spot on the map that nodes belong to.
_Avoid_: slot

### Making and improving

**Small stone / Big rock**:
Two different materials (items `stone` and `boulder`). A small stone is light and comes out of the soil and off the ground; it is for tools, fire rings and small things. A big rock is heavy (it weighs what a log does) and comes from the shovel and from old ruins; roads, walls, wells, ovens and big buildings are made of it.
_Avoid_: rock for the small one, stone for the big one (the tool "Rock" is a hammer)

**Shelf**:
The room one kind of thing has in the store, in load units (`storageLoad`). Every kind has its own shelf of the same size; how many fit is the shelf divided by what one weighs. It is not the bag (the bag holds a trip's load, all kinds together).

**Station**:
Where recipes are made.

**Category**:
The kind of work a cost belongs to (field work, cooking, building); upgrades lower costs per category.

**Build**:
Paying for a node that is a building, a station, a helper or the clearing of ruins (`rules/48-skills.json` `builds`); a tool, gear, a patch, a delivery or a card is not one. A paid build, or each paid step of one, counts a batch for woodwork and construction, and that skill's rank lowers what the next build uses up and its energy, never its coins (`G.skills.family_of_build`, priced in `G.pace.node_cost`). A build is not a chore of `G.actions`: nodes are priced by `pace.node_cost` and paid by `progression.unlock`.

**Helper**:
An optional upgrade that makes something cheaper or better for good. Helpers never leave.

**Gear**:
Items the farmer wears or uses, in eight slots (bed, pillow, bottle, head, feet, hands, back, apron).

**Polish**:
An endless upgrade with diminishing returns.

**Fence stage**:
How good the fence round a pen of chickens, cows or sheep is: broken (every pen starts so; the pen gives about 10 % less), mended (the first upgrade: normal), sturdy and painted (the second, which replaces the first: a small bonus). The bees have no fence. The same numbers for every pen (`fence` in `rules/10-farming.json`).

**Keeper**:
An input that a recipe needs but does not use up.

**Add-on**:
The picture of an upgrade, shown on its place.

**Quality**:
How well a made thing turned out: Lumpy, Proper or Fancy (German: Naja, Tiptop, Picobello!).
_Avoid_: stars

**Woodpile**:
The fuel store for heat stations; stoked by hand.

**Condition**:
One short line in the data that says *when* something happens or shows (a story piece, an interface element, a golden acorn, a perk): `chapter>=2`, `item:carrot>=3`, `not:done:barn`. It compares a condition word with a number (at least, or fewer than), or asks a yes-or-no word; `not:` turns it round. A list of conditions holds when all of them hold.
_Avoid_: trigger (an event that just happened), requirement (what a node needs before it can be unlocked)

**Condition word**:
One word a condition may use (`coins`, `pests`, `forest_trips`, `season:winter`, `item:<item>`). Each word belongs to the system that owns what it reads. A word nobody owns is an error in the data checker.
_Avoid_: counter, term (the old code's two names for the same idea)

**Trigger**:
A chore that just happened, which a luck event or a little job reacts to (`"on": "weed"`: right after a weeding). A trigger is an event; a condition is a state that holds or not.
_Avoid_: when (in the data, `when` is always a condition)

### Friends and rewards

**Favour**:
An optional job for a neighbour, who becomes a friend.
_Avoid_: side quest

**Postcard**:
A friend's surprise with a lasting bonus; two work at a time.
_Avoid_: gift card

**Perk**:
A cosmetic extra (butterflies, sounds, rainbows), never stronger.

### The screen

**Interruption**:
Something that arrives on its own and wants the screen: a celebration of something new, a postcard, a story box, a bark, a note after a pop-up closes. A screen the child opens herself (Time Quiz, Rest, a card, a sheet, a menu) is not an interruption, and neither are the animations of the farm catching up.
_Avoid_: pop-up (any centred window, also the ones the child opens), notification (only the short notes)

**Quiet**:
The moment when no screen the child opened is in the way of an interruption and no other interruption is showing, so the next one in line may come. What counts as "in the way" depends on the kind: a celebration may come over an open sheet, a story box waits for it to close.
_Avoid_: idle

**Village square**:
The screen the farmer is on while in the village: a scene of the square instead of the farm, with stalls to tap. Selling, buying, barter and handing over orders happen only here (or with the merchant at the gate). It is reached by a trip and left by the walk home.
_Avoid_: market window, market screen (the market is the place on the farm where a trip starts)

**Square ground**:
The diamond tiles the village square's floor is laid with (cobbles, pavement, soil, grass, flower beds), all the way up to the top of the screen. It is a map of letters in the data, so any part can be changed without code. One kind of tile has one or more pictures; which one a tile gets never changes between visits.
_Avoid_: sky, background (the square has no sky)

**Stall**:
One thing to tap on the village square: the stall that buys what is in the bag, the seed merchant, the traders' cart, the cart for the orders, the notice board, the sign for the walk home. The window below the scene shows the stall that was tapped.
_Avoid_: tab, shop

**Person**:
Somebody in the game who is not the farmer: a seller at a stall, a villager. A person is data (`rules/58-people.json`): a name, a look, three lines, where they are and when. `G.people.line(id)` alone decides what a tapped person says.
_Avoid_: NPC, character (the story's word)

**Figure**:
A person as seen in a scene: it stands or strolls, and when tapped it turns to the farmer, waves and says a line in a speech bubble. Scenes ask the figures part (`ui/figures.gd`) by the person's id and never know how a figure is drawn.
_Avoid_: sprite, avatar (the farmer's own figure)

**Farmer's look**:
What the child chose on the "make your farmer" screen at the start of a farm (`people/02`): skin, hair (style and colour), shirt, trousers and hat, from the lists in `data/avatar.json` "options". It is kept in the farm save under `look` (only once chosen; no key means the default look) and read through `G.people.farmer_look()`. The screen has no words, no name and no photo, and nothing says boy or girl. It is called a look (never "avatar" or "character") in the code and the text.
_Avoid_: avatar, character

**Moment**:
The unit of how much fits into one step of farm time. A step holds a fixed number (18, plus a few more in the later chapters); a chore takes 0 (free), 1, 2 or 4 of them; when they are used up no chore can be done until a right first Time Quiz answer moves time on. Separate from energy (what the body can do). The child sees it only as the ring round the clock, never as a number.
_Avoid_: action points, time units, minutes

**Pile**:
The heap of one bulky thing (sticks, small stones, big rocks) beside the store; its size shows how much is stored.

**Loose thing**:
A stick or small stone lying about on the farm that a tap picks up (the chore `pick_loose`).
_Avoid_: litter, debris

**Worn path**:
The ground that turns to trodden earth where the farmer walks most (`G.trodden`, `visible-work/08`): a count of walks per cell of the walking grid, capped, fading a little each season; it only changes how the ground looks.
_Avoid_: road (the village road is the story's, not worn in)

### Pacing and tools of the project

**Pace**:
The farm's output per question, used by dynamic difficulty.

**Flex**:
The factor that fits a new goal's cost to the pace.

**Explorer**:
The parent's browser view of the data and of the playthrough simulation.

**Bot**:
The automated test player that plays the whole game.

**Golden run**:
A recorded bot run with a fixed seed; a refactor must leave it identical.
