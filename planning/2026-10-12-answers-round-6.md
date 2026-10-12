# Decision round 6 (2026-10-12): Claude's questions with the parent's answers (kept word for word)

The parent's message in the chat, with Claude's questions as they were quoted in it. Kept unchanged as the safety net for `TODO.md`
and `PROJECT-LOG.md` §2.8.

---

Here you have my answers to the latest round. Please plan the potential restructuring of the godot code for optimal maintenance and development well.

⠀**Open questions**
1. **Do beginners make mistakes when making things,** e.g. a basket comes apart and the materials are lost? I'd say no. In crafting, a beginner's mistake is simply a Lumpy result; losing materials as well would feel harsh across the many crafting steps. Mistakes stay in field and animal work, as you described. --> agreed, it can be explained that the farmer now drops the eggs less often and stuff like that, when a upgrade, training improvements, new knowlegde, etc. reduce the amount of input, time or energy needed for a output.
2. **Which buildings count towards the Lord's share?** I'd count the ones that produce or process: mills, lumbermill, smithy, kiln, press, workshop, and the barn once it holds animals. Each would count by its level. The home, storage, pens and the pet corner wouldn't count. --> yes.
3. **Who is the collector?** I'd make him a villager the Lord forces to do the job, who dislikes it and warms to you over the chapters. That fits the poor, distrustful village, and he'd be one of the first figures to walk onto the farm. --> yup. See if we already have a character in the story, who fits this role (not Quill).
4. **Which crops can be sown in winter?** I'd allow the new winter wheat, onions, and the game's beans counted as broad beans. Everything else shows ❄️ "too cold to sow". --> ok, or maybe add a winter kale/cabbage as well? It should be a variant that grows so slowly and gives little returns that it's not worth planting the rest of the year. Also think about when to introduce which winter crop (which chapter and where in the chain of unlocking stuff).
5. **The architecture study: when, and for what?** I'd do it next, before the design chapters on paper. The borders between parts shape how each system gets described, so doing the paper designs first would mean rewriting them. It would help to know whether a second game is already in mind; its needs would show which parts are worth making reusable. The learnkit/ folder (the maths and quiz system) is already a working example of a reusable part. Natural candidates for the same treatment:
   * the walking avatar and its actions
   * the wellbeing parameters
   * the "one quiz answer = one step of time" clock, plus the replay after it
   * the store and carrying
   * the story pieces
   * the interface parts (tiles, sheets, bars, notifications)
Answer: great. If that doesn't complicate maintaining and expanding, then let's make those reusable.
6. The farm would then be the game built from them. I'd generalise only what a second game would really share. Building a general engine ahead of the second game usually produces the wrong one.
Answer: I was thinking of maybe having a spin off of a other character starting a stone quary / mine / smithy from scratch at the other end of the village. Less story but similar complexity of unlocking and building stuff up as well as energy and time stuff and also books to read, etc.
