# Hazelwood Harvest (the Farm Quiz Game)

The farming game for an eight-year-old. This glossary holds the words of the farm rules: what the farmer does, what it costs, and how the game checks it. It grows as terms are settled in design sessions (`/grill-with-docs`).

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

**Report**:
What perform returns: whether the chore was done, which requirement failed if not, what was spent and what was gained.

### Money

**Price**:
The coins the market pays or charges for an item. It is not the cost of a chore.
_Avoid_: cost (for market money)
