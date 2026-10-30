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
Something a pet gives the farm out of grace, for free, by its own effect (the pet clears weeds, brings water, makes an item). A blessing is not a chore and costs the farmer nothing. The pets are gracious helpers, like small demi-gods, but the game does not call them that.
_Avoid_: duty, job (a job is one of the child's little paid jobs), pet job

**Automated chore**:
A chore of the farmer that a pet does instead, at the farmer's effective cost, as if the farmer had done it. It is a different thing from a blessing. (Not built yet; the name is not final.)

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

**Station**:
Where recipes are made.

**Category**:
The kind of work a cost belongs to (field work, cooking, building); upgrades lower costs per category.

**Helper**:
An optional upgrade that makes something cheaper or better for good. Helpers never leave.

**Gear**:
Items the farmer wears or uses, in eight slots (bed, pillow, bottle, head, feet, hands, back, apron).

**Polish**:
An endless upgrade with diminishing returns.

**Keeper**:
An input that a recipe needs but does not use up.

**Add-on**:
The picture of an upgrade, shown on its place.

**Quality**:
How well a made thing turned out: Lumpy, Proper or Fancy (German: Naja, Tiptop, Picobello!).
_Avoid_: stars

**Woodpile**:
The fuel store for heat stations; stoked by hand.

### Friends and rewards

**Favour**:
An optional job for a neighbour, who becomes a friend.
_Avoid_: side quest

**Postcard**:
A friend's surprise with a lasting bonus; two work at a time.
_Avoid_: gift card

**Perk**:
A cosmetic extra (butterflies, sounds, rainbows), never stronger.

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
