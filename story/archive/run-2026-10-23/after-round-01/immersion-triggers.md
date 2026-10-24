# Immersion triggers: where a bit of text lands

Round 6b, draft 1 (14 Oct 2026). 💡 Text in `texts/more-ch1.md … more-ch6.md` (English only); data in `staging/`; German and wiring are the next step (see TODO I15). Consistency pass of 14 Oct 2026 applied (`consistency-fixes.md`); every count below was recounted from the converted JSON afterwards, by trigger text, one row per piece (the six gift omens overlap with Builds by two: `c3_blanket`, `c6_quilt`).

## 1. The kinds

| Kind | Trigger type | Count | Why it works |
|---|---|---|---|
| **Firsts** | `harvests>=1`, `cards>=1`, `seen:coins`, `trips>=1`, `trips>=10`, `trips>=20`, `has:egg:1`, `done:campfire` | 8 | the DM's "you do this for the first time" |
| **Taps** | `tap:patch:weeds`, `tap:forest`, `tap:road`, `tap:market` | 6 | rewards curiosity; the world answers when poked |
| **Builds** | `done:<node>` for buildings, tools and animals (not favours) | 44 (51 with barks) | every new thing lands with one odd sensory detail |
| **Seasons** | `season:x + chapter:n` | 8 (17 with barks) | the farm changes and the text notices |
| **People and favours** | `done:sq_*` | 22 (24 with two barks) | each favour closes with a scene, not a number |
| **Pet and gift omens** | `has:<gift>:1` (priority 65) | 6 | a gift item gets a small omen |
| **Margin notes** | `page:k_*` (Berit) | 25 | reading a card brings Berit's thin brown ink |
| **Chapter boards** | `chapter:n + sidequests>=k` | 5 | the notice board as a quiet weather report |
| **Barks** | `chance:p` plus a state (0.12–0.2, never repeat-locked) | 32 | ambient texture between events |
| **Dread / tension** | `after:c3_letter:n` | 2 | the air before the Lord's share |

Total new pieces: **166** (69 moments, 39 discoveries, 32 barks, 17 scenes, 4 visits, 3 beats, 2 letters) (ch1 51, ch2 29, ch3 29, ch4 19, ch5 14, ch6 24). Eight pieces have bespoke triggers that fit no row (`seen:`, `after:`, `forest_trips`, `has:honey`).

## 2. Measured effect (instrumented bot, seed 1)

Longest silence between story pieces, in steps (30 steps = one season); "after" is the final run after the consistency pass (seed 1, same figures as the first draft run):

| Chapter | before | after |
|---|---|---|
| 1 | 231 | 12 |
| 2 | not measured | 10 |
| 3 | 138 | 14 |
| 4 | not measured | 13 |
| 5 | 43 | 13 |
| 6 | not measured | 15 |

Longest silence between non-bark pieces in the same run: ch1 36, ch2 25, ch3 37, ch4 53, ch5 13, ch6 28.

The bot does not tap, read cards or play optional favours: 41 of the 166 did not fire in the final headless run (6 taps, 25 margin notes, 10 pieces tied to optional favours, a gift or a bark chance; list in `consistency-fixes.md`). They are tested by hand (see "What to try" in the PROJECT-LOG entry).

## 3. Triggers the engine cannot read yet (design wishes; see `code-issues-story-timing.md`)

First pest, first rain, first frost on the crops, first night, first time energy runs out, the first failed quiz answer, the first time a stranger is turned away at the market, a season turning with a particular crop in the ground. Each is a perfect DM moment and each needs a new term in `conditions.gd` or `game.gd`.
