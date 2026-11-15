# The parent's notes of 14 November 2026 (test run)

Kept word for word, as for the earlier notes in this folder. The tag `[#14.N]` means note N below. Every note is a ticket in
`.scratch/` or part of one: the table at the end says which.

## The notes

1. lets start turning the story into staged text pieces and interleave them into the story. We might also need to bring back some of the text pieces from the earlier version because some were cut from the full prose story, as they weren't interesting there. However, things like completing the road, or big, multistep contstructions should get a picture and at least one short paragraph of text everytime.
2. I want to rethink npc characters. how can we make them appear (especially in the village square) and walk around. And sometimes visit the farm. The 3d person that the farmer is, is ok, but looks very generic still. How can we make the 3d farmer look more similar to the style of the rest of the game and how can we make the npcs look similar to that farmer? I wonder if they need to be 3d, since their clothes don't need to change and they don't need so many poses. This was the reason we went for 3d with the farmer so we would be able to be flexible with tne gear, clothes and poses when moving around and not have to generate not pictures everytime.
3. we need a list of stuff that doesn't have it's own picture yet and still needs one. That includes every pop up field like going home, the fire, the work bench, etc. But also stuff that is represented with an emoji right now, that isn't ideal like axel being a gear or mountains being big rocks.
4. right now tapping the raw material seller shows the seeds merchants stuff as well
5. village square should be able to take up the whole screen just like the farm
6. book cart needs to be permanently in the village square
7. I have noticed that stuff that changes visually when the player performs work like clearing the field from weeds, and of course, crops is inherently satisfying. Please check the game for easy wins on adding more things that could be made visually visible. Maybe the stack of sticks and rocks could be next to the basket and later on the building of the storage and we could see it get larger and larger in at some point when there is too much tops over and we get the bouncing off signal. Maybe we could also have sticks and small rocks appear on the actual screen of the farm in random places every now and then in the beginning there's still quite a bit and you can pick them by tapping on them and they go into storage. But these are just a few examples. Please think of a bunch of other things that may be completely out of the box for me. What are easy ones to add visual feedback for completing task tasks, doing action?
8. Traveling merchant needs a different cart than the book cart
9. The workbench should be empty at first when it is built first (right now it still has a hammer on it)
10. A bar for how full the storage is in the pop up window of the storage, similar to that one for the backpack

## What the parent said with them (the same message)

> all of the tickets can be solved by you with a good recommendation. For example, for the action budget, think it through what would be a good balance so that the player gets things done in a given cycle, but at some point does run out of time. Maybe there could be an indicator that wraps around the clock symbol, and of course all the actions get grayed out.

(Said of every ticket in the parent's queue except `waiting-on-parent/05`, `waiting-on-parent/07`, `interface-feel/12` and `story/07`.)

> Regarding the generating of pictures, there will be an extensive list of prompts for pictures, and I want you to try if you can download them one more time. The last few times I needed to download them manually, but I want you to try one more time with the Open Art connector.

> There will be things that you surely need input for. Maybe how the NPC characters are made. So if they actually end up being 3D after all, or if there's a way to make them with 2D pictures, but in a way that looks similar to the updated style of the 3D farmer, or maybe we have to make the 3D farmer 2D after all. I don't know. I'd rather not, but I am open to finding ways to having moving characters in the game in a way that has a good design feel and makes the game feel more fun and interactive. Of course, the NPC characters need to be tappable and react with some custom text. But for now, we can make that text pretty shallow, maybe just something generic that fits the character. We can go into more depth later on, and let's make sure that the modules are built in a deep way that makes putting this in later on easy.

> I'm not sure if the /ask-matt skills are mentioned as something I want to continue to have as a guide for the development and expansion of this project. Maybe it might be good to put it in the README first file.

> make some adequate plans for sub-agents and what instructions they need and which they don't. I want the amount of material they have to read to be only what's necessary [...] I would like you to use Sonnet models [...] their scope is limited, and the deep slice they go to is clearly delimited and has a clear test. And I would like the sub-agents to work in sequence for the most part.

## Where each note went

| Note | Ticket |
|---|---|
| [#14.1] story as staged pieces; big builds get a picture and a paragraph | `story/25` (build pieces, prototype); the novella pieces stay `story/08` |
| [#14.2] NPC figures, the farmer's look | `people/04` (the figures module), `people/05` (look trial), `people/06` (figures on the square), `people/01` (visitors on the farm) |
| [#14.3] list of what still needs a picture | `pictures/14` |
| [#14.4] raw material seller also shows the seeds | `money-market/09` |
| [#14.5] village square on the whole screen | `money-market/10` |
| [#14.6] book cart always on the square | `money-market/11` |
| [#14.7] more visible work | `visible-work/01` (the ideas), `visible-work/02` (piles), `visible-work/03` (sticks and stones lying about) |
| [#14.8] the travelling merchant's own cart | `pictures/15` |
| [#14.9] the workbench starts empty | `interface-feel/16` (the empty picture exists already) |
| [#14.10] a bar for how full the store is | `interface-feel/14` |
| action budget recommendation | `action-budget/01` |
| OpenArt download | `pictures/15` (it works: tried 14 Nov 2026) |
| sub-agent plan | `.scratch/wave-3-plan.md` |

## The parent's answers later the same day

- Action budget (`action-budget/01`): **yes**.
- People (`people/04`): **yes**.
- Pictures (`pictures/15`):

> you can use up to 2000 credits and no need for me to wait and overrule, but you can put alternatives in a folder somewhere so that I can go back later and swap if necessary. Also if you notice that your prompts are not generating the kind of thing you want, adapt your prompting.

> Lastly can you write me a skill of the generating and downloading of openart stuff?

> And give me the questions that are needed for the story. And just to be clear, it's not only big constructions that need a small text piece. It could also be other things. Keep your eyes open for those events.

Where they went: `action-budget/spec.md` and `action-budget/02–05`; `people/04` ready; `pictures/15` ready and the project skill `openart-pictures`; `story/QUESTIONS-FOR-THE-PARENT.md`; `story/25` widened to moment pieces.
