# How story games deliver story (research notes)

Round 4, part 1 (8 Oct 2026). The parent asked not to reinvent the wheel: games that weave story into play already solved most of this.
These are the patterns worth borrowing, with what we take and what we avoid. Our design follows in `../story-delivery.md`.

## 1. Storylets and saliency (quality-based narrative)

**What it is.** Story is cut into self-contained pieces ("storylets") that are not chained to a fixed next piece. Each has conditions.
When the game wants story, it throws out every piece whose conditions fail, then picks the **most salient** of the rest, usually the
most specific one, and prefers pieces seen least recently. A general fallback always exists so nothing comes up empty. Pieces must work
in any valid order. Emily Short has written and collected a lot on this; Yarn Spinner (a common dialogue tool, also used with Godot)
now builds it in.

**We take:** every story piece in a data file with conditions; "most specific wins"; least-recently-seen for repeatable lines; a fallback;
pieces written to make sense in any order the game allows.

## 2. Stardew Valley: preconditions, a "seen" list, restoration as story

**Events** play once and are gated by preconditions: friendship level, time of day, day, season, weather, having seen another event,
having an item, a random chance, and more; each player keeps a list of seen events. The **Community Center** carries the main story
through restoration: you bring "bundles" of things the valley produces; each finished room brings a short cutscene and a visible
change to the town; the scrolls are unreadable until a small quest grants the magic to read them; finishing everything ends in a town
ceremony.

**We take:** a `seen` list and the same kinds of preconditions (built thing, item owned, season, other story seen, chance); **restoring
the farm *is* the story** (each room in Stardew is our ruin or Helper); unreadable things that become readable (our Helpers' sounds you
learn to read; the rhyme coming back line by line); a community payoff at the end (the Harvest Fair).

## 3. Spiritfarer: arcs tied to what you build, a finite goodbye

Each spirit lives on your boat; you build them a home, cook their favourite food and do their requests; when their arc is complete they
leave for good. The emotional payoff is earned by the management play, and every arc ends.

**We take:** our pets already work this way in reverse: you build the comfort item and cook the dish, and the payoff is a **return**, not a
goodbye. Make each return a real scene, and let each Helper's arc *end* (it is home; it has its job).

## 4. Hades: make the player feel noticed

Supergiant built a huge pool of reactive lines so characters comment on what the player just did (the weapon chosen, a boss beaten
again), and the story moves forward a little after every run. Greg Kasavin: it is nice having someone notice a small change about you.
Characters over plot.

**We take:** **reactive one-liners** from villagers and Lark about what you did (your first bread, a full larder, ninety weeds pulled, a
new road). Small, many, rarely repeated. Characters carry the story more than plot does.

## 5. Environmental storytelling: "What happened here?"

Harvey Smith and Matthias Worch (GDC 2010): let the player work out what happened from what is left behind; **pull beats push**; meaning
forms in the gaps; details must serve the premise; **it must be possible to miss some things, or finding them means nothing.** Henry
Jenkins names four kinds of game narrative: *evocative* (draws on stories people know), *enacted* (the player performs the story),
*embedded* (story hidden in objects and places), *emergent* (story arising from play).

**We take:** the ruins and Mumyo's traces are **embedded** story (pull); the bend in chapter 6 is **enacted** (the player taps it); the
fairy-tale feel is **evocative**; the farm the player builds is **emergent**. Optional clues may be missed; the scroll keeps what was found.
**Critical beats must not be missable.**

## 6. Cozy Grove and Wylde Flowers: what goes wrong

- **Cozy Grove** gates its story by real days ("come back tomorrow"). Reviewers found this held the game back and made it easy to drift away.
  → **Never gate story by real time.** Our clock is the Time Quiz, which is play.
- **Wylde Flowers** wraps farming in a mystery about witches and is praised for characters, but its first hours are slow (grow a crop,
  hand it over, wait). → **Front-load wonder:** the first minutes need a hook, a strange thing, and a first payoff.

## 7. For later (Round 4, part 2): pets that follow rules

- **Autonauts** teaches bots with a Scratch-style visual programming language and has them repeat jobs. A good model for "if-then"
  pet jobs a child can set up.
- **Stardew's Junimo huts** harvest crops nearby on their own: the simplest kind of automation (a helper with a range and one job).

## Sources

- Yarn Spinner, [Storylets and saliency: a primer](https://docs.yarnspinner.dev/write-yarn-scripts/advanced-scripting/storylets-and-saliency-a-primer)
- Emily Short, [Survey of storylets-based design](https://emshort.blog/tag/storylets/); [Kreminski on storylets](https://emshort.blog/2019/01/06/kreminski-on-storylets/)
- Stardew Valley Wiki, [Modding: Event data](https://stardewvalleywiki.com/Modding:Event_data); [Community Center](https://stardewvalleywiki.com/Community_Center)
- Game Informer, [Why Spiritfarer is a different kind of sim](https://www.gameinformer.com/preview/2020/07/30/why-spiritfarer-is-a-different-kind-of-sim)
- ScreenHub, [Hades' Greg Kasavin breaks down Supergiant's approach to narrative](https://www.screenhub.com.au/news-article/features/digital/jini-maxwell/hades-greg-kasavin-breaks-down-supergiants-unique-approach-to-narrative-262459); GDC Vault, [Breathing Life into Greek Myth: The Dialogue of Hades](https://gdcvault.com/play/1026975/Breathing-Life-into-Greek-Myth)
- Nieman Storyboard, [Harvey Smith on environmental storytelling](https://niemanstoryboard.org/2011/01/14/harvey-smith-on-environmental-storytelling-and-embedding-narrative/); GDC Vault, [What Happened Here? Environmental Storytelling](https://gdcvault.com/play/1012647/What-Happened-Here-Environmental)
- No Proscenium, [Evocative, enacted, embedded, emergent](https://www.noproscenium.com/evocative-enacted-embedded-emergent-narrative-architectures-for-immersive-storytelling/) (on Jenkins, *Game Design as Narrative Architecture*)
- GameCritics, [Cozy Grove review](https://gamecritics.com/cody-bolster/cozy-grove-review/); Pocket Tactics, [Wylde Flowers review](https://www.pockettactics.com/wylde-flowers/review)
- Steam, [Autonauts](https://store.steampowered.com/app/979120/Autonauts/)
