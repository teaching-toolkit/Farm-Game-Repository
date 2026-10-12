# Decision round 5 (2026-10-12): Claude's questions with the parent's answers (kept word for word)

Each round is Claude's question list, with the parent's answers written into it. Kept unchanged as the safety net for
`TODO.md` §2 and `PROJECT-LOG.md` §2.8, where the decisions are summarised.

---

**The open questions** (the first one is the big one):

1. **Skills and mastery.** My design:
   - About 8 families of making: cooking, baking, preserving, fibre and weaving, woodwork, pottery and glass, smithing, healing. Every batch counts for its family, so "something similar" trains it too, and the child follows 8 things, not 100.
   - Five ranks: Beginner → Handy → Skilled → Expert → Master.
   - A rank needs a number of batches (e.g. 10/30/80/200) and, from Skilled on, something the game already has: a card, then a tool tier, then a building. That stops a child from grinding cheap recipes to Master.
   - One visible effect per rank, the same in every family:
     - Handy: less energy.
     - Skilled: one less of the main input (6 reeds → 5).
     - Expert: better quality chances.
     - Master: faster, and one less of the main input again.
   - Hidden until the first rank-up, which gets a small celebration.
   - No fading and no limit on how many families reach Master; time and energy limit it naturally.
   - It replaces today's practice stars.
   - **Pricing rule:** a thing's market price sits between what it costs a beginner to make it and what it costs a master. Then buying pays for a beginner and making pays for a master.
   - **Questions:** should field and animal work have skills too? I'd say no; tools and upgrades already cover those. Is the rest right as described?
Answer: How about these skill families: planting/harvesting, animal tending, cooking/baking, fibre and weaving, woodwork/construction, pottery and glass, smithing, healing/preserving? I would say stuff like animal tending and field work could benefit from training as well. E.g. if you're a beginner you will drop eggs more often, pull the wrong plants out, etc. But yeah, I am aware the buildings, tools and books already cover a lot here. So the training doesn't need to makes as much difference as it does for the other categories. I think in some cases the savings on input material should be more substantial, e.g. for construction or crafting. And lets have that change for every rank, though somewhat diminishing returns may make sense. Also, the master class should also increase the chances for quality further. Actually let's have each rank increase the chances for higher quality a bit,.

2. **The Lord's share.**
   - **How it's counted:** a fixed amount per cleared patch, based on what the Lord assumes a patch should give. Every cleared patch counts, even one resting under clover. That's exactly the pressure that drove the family.
   - **Who collects before Quill arrives in chapter 4:** a collector who walks to the gate at each change of season. He's a natural use of the planned villager visits. Alternatively, a notice on the gate and you pay in the village.
   - **What's blocked while unpaid:** anything bought with coins. Selling, making, farming, trips and barter stay possible, so the child is never stuck.
   - **How big:** never more than about a quarter of a typical season's sales at the planned pace.
Answer: perfect. A person from the village comes by at the end of the season. Also, buildings should count towards the owed share. A lumber mill, wind mill, etc.

3. **A wrong first try in the Time Quiz:** I'd show the right answer with its one-line explanation and move to the next question. A market trip then waits until one question is answered right first time.
Answer: the player still needs to try answers till they find the right one and then they get the explanation, but it doesn't move time forward. Only correct on the first try moves it forward 1 unit.

4. **The empty bottom bar:** once the Time Quiz clock and the next goal move up, I'd remove the bottom bar and let the map grow by that height.
Answer: yes!

5. **Winter:**
   - Outdoors, only a few hardy crops can be sown: winter wheat, onions, broad beans. Every other crop shows ❄️ "too cold: try the greenhouse".
   - Crops already in the ground grow at a quarter of their speed. That gives the greenhouse and the glass cloches a real job.
Answer: if the greenhouse already exists that is. I like the quarter speed. So, buying winter wheat seeds needs to be a new thing. Good idea.

6. **Seasonal looks:** one visual effect over all map pictures would put snow caps on every roof, tree and fence top, mute the colours in winter, and turn green to gold in autumn. New pictures would only be needed for bare trees in winter.
Answer: perfect

7. **Two answers from last round are still missing:**
   - **German quality names:** I'd use *Naja / Ordentlich / Picobello*.
   - **The return animation's order:** pause, rain, then plants growing together with weeds, pests and an arriving merchant, then the energy number last. Any tap jumps to the end.
Answer: Let's do "Naja, tiptop, picobello!". And yes to the animation stuff.

8. **Splitting the two big scripts** (proposed in another chat on 11 October): I'd do it before the big systems are built, because every new system would otherwise grow those two files further.
Answer: sounds good. And I want to do some general thinking about how to streamline the files, game engine, etc. in a way that makes it easy to maintain and further develop this project. If it goes well I will want to reuse a lot of elements for other games with a avatar walking around a screen with background parameters, sim style health stuff, etc.