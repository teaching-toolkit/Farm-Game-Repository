# Spec: the action budget (moments)

Confirmed by the parent on 14 Nov 2026 (`issues/01-grill-and-spec.md` holds the wording they said yes to).

## What it is

A step holds a fixed number of **moments** (24 to start with). Every chore takes moments: light 1, middle 2, heavy 4. When the
step's moments are used up, no chore can be done until a right first Time Quiz answer moves farm time one step, which gives a
fresh set. Energy is unchanged and separate: energy is what the body can do (Rest refills it), moments are what fits into one step.

## Rules

- A chore's moments stand beside its energy in the chores file. A recipe's moments come from its size (its energy band), not
  from a number per recipe.
- Counting happens only in the actions module: `check` says "no time left" as one more reason, `perform` adds the chore's moments.
  No button, bot or test counts moments itself.
- A chore that takes more moments than are left can still be started if at least one moment is left (the child is never told
  "you have 3, this needs 4"); it uses up the rest.
- Free of moments: looking, cards, the bag, the store, Rest, buying and selling, walks (they cost a question already).
- Each skill rank takes one moment off the middle and heavy chores of its family, never below 1.
- A pet's automated chore (`pets-automation`) uses none of the farmer's moments.
- The step's used moments are one save key, 0 in a new game and in an old save; a step sets it to 0.

## What the child sees

A ring of 12 segments round the clock symbol fills as moments are used (2 moments a segment; green, the last three amber). When it
is full: the clock rocks, every chore button and tile is grey, a tap on one sends a spark to the clock and gives the reason as
`interface-feel/02` does. A right first answer empties the ring with a sweep. No number is shown.

## Seams for testing

- The chores test: for every chore, `check` before and after the moments run out; `perform` adds the right amount; a step resets.
- The bot: when no moments are left it answers the Time Quiz (it never waits or stalls). Its pacing report gets a histogram of
  moments used per step, per chapter, and how many steps ran out.
- The golden runs are recorded anew once with `02`, on purpose.

## Balance

Measured, not guessed. Before the limit the bot does about 11 chores a step in chapter 1. The number of moments per step is set so
the bot runs out in about one step of four and no chapter's hours move by more than 10 %. The number is one line in the rules.
