# 12: More random funny in-between messages, each with clear conditions

**What to build:** More short funny messages pop up between the work, like the hens arguing about who laid which egg. Each one has explicit conditions so it never makes no sense. The hens message today fires with one hen (`c1_k_hens` needs only that a chicken was built).

**Blocked by:** None (can start immediately)

**Status:** done

**Milestone:** prototype

- [x] The hens message needs at least two hens
- [x] A batch of new messages is written (English and German), each with the conditions it needs written into its `when`
- [x] Messages that need a count or a "fewer than" use `condition-language` once it exists, or the nearest existing term
- [x] Story test and the data checker pass; the rationing for barks still applies

---

**Feature:** `story` · **Source:** the parent's notes of 23 October 2026 (`docs/sources/2026-10-23-parent-notes-playtest.md`), [#23.10]. Filed 23 October 2026.

The parent's words:

> [#23.10] more random funny messages for in between like the hens argue about who laid which egg, nobody wins, though they need clearer if conditions. I only had one hen and then the message makes no sense

## Result (3 Nov 2026)

Built: the hens bark `c1_k_hens` needs `animals:animal_chicken>=2`. A new condition word `animals:<animal node>` (count of that animal now; `game/farm/systems/animals.gd`, `condition-words.json`) makes counts possible. New barks, each with a chance and a condition that makes its line true (English and German, `story/game/texts/ch1-3.md`, `data-de.json`): one hen alone `c1_k_hen_alone`, eggs piling up `item:egg>=6`, tall weeds `weeds_max>=3`, tired `energy<3`, dry bucket `water<1`, rain `rain`+`not:season:winter`, caterpillar `pests>=1`, bare patches `empty_patches>=2`; chapter 2: bunny with carrots, tortoise in the yard, hen and cow (`animals:animal_cow>=1`+chicken); chapter 3: counting sheep `animals:animal_sheep>=3`. The story test checks that one hen / two hens switch the right bark, and that every bark in the data has a chance and at least one other condition. The rationing (`barkRest` 12 questions) is unchanged. Design: `docs/design/friends-and-story.md`, `docs/design/animals.md`.

Checked: story test 40 checks, condition language test 125 checks, data checker (every condition is known), short golden runs identical.

Play-test: the new barks come at plausible moments (too many or too few?); the funny lines themselves (all marked 💡 as agent's writing in the text files).
