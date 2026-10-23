# Handoff: Farm Quiz Game (Hazelwood Harvest), story pictures

> Paste this at the start of a new chat, with the **Farm game** folder connected (or attached). You are picking up an in-progress job.
> The review is done. Do not redo it and do not re-litigate the decisions marked ✅. Read this, then do the FIRST STEP, then the rest.

## PROJECT

An educational farming game for the parent's child (8 years old), played on an iPad held upright. Godot 4.7 (GDScript), also built for the
browser. The parent is the designer: they test on the iPad, pick the pictures and decide the design questions. The game is called
**Hazelwood Harvest** (German: the same). Phase now: the **story pictures** (the pictures for the story boxes: frames at the bedside, story
beats, discoveries, moments and letters).

Current job, as the parent asked it: (1) move the superseded pictures into an archive folder, (2) generate the new art that the review asks for,
(3) get every story piece its right picture, (4) work out how to do this well. **Think about the best way to do it; the plan is yours to propose.**

## STATUS ON 14 OCT 2026

- ✅ Done in the workspace: the picture review of the 95 current pictures (verdict and note for each), the story-picture briefs (text and
  pictures for each piece), the picture canon (what a picture may and may not show). All four are attached with this handoff.
- ✅ The parent's squirrel decision is applied: the squirrel may sit on Lark's shoulder at the Fair supper.
- ✅ **Saved into the Mac folder on 14 Oct**, after the bridge came back: the four files, and the log and to-do entries (see LOG ENTRIES).
- ⏳ **Not done:** the 13 superseded pictures are **not moved** (nothing has been moved or deleted); no new art has been generated; the story
  data (`godot-prototype/data/farm/story/*.json`) has **no `picture` fields** yet (checked: 0 of 6 files).
- ℹ️ **The folder holds two things this handoff first missed:** a parent-side plan from 12 Oct, `story-picture-prompts.md` (with its own
  style block and its own ids), and a `references/` folder of OpenArt reference images. See ARTIFACTS and OPEN THREADS 9–10.

## FIRST STEP (steps 1 and 2 were done on 14 Oct; check them, then do 3 and 4)

1. Check that `art-inbox/Story pictures/` on the Mac holds `HANDOFF-story-pictures.md`, `picture_review.csv`, `story-picture-briefs.md` and
   `canon-for-pictures.md`. If not, copy the four attached files there.
2. Apply the PENDING LOG ENTRIES (below): `TODO.md` (§15 I11 and §5 R3), `PROJECT-LOG.md` §1, `story/book-file.md`, `story/story-delivery.md`.
3. Move the 13 superseded originals (list below) into an archive folder. **Move, do not delete**: the folder has no delete permission on the
   Mac, and the parent asked to be asked before anything is deleted.
4. Send the parent the open questions (OPEN THREADS, numbered 1–8) as one short message, then continue with the work the answers allow.

## METHOD / WORKING STYLE

- Start with `claude-skills/farm-game-session/SKILL.md` (what to read, the log rule). For pictures and the content side read
  `claude-skills/farm-game-content/SKILL.md`, section "Pictures". For story work read `story/README.md` first.
- **Standing rule:** update `TODO.md`, `PROJECT-LOG.md` and the story files as you work, not at the end.
- Labels in the story files: ✅ decided by the parent (do not change without asking) · 💡 proposed · ❓ open · 🔒 hidden from the player.
- Talk to the parent in plain, friendly English; no flattery; be direct when something is weak; suggest the fix.
- German: use "ss", never "ß". Story texts are short (2–4 sentences) and in second person (`{player}`).
- **Mac (linked computer):** no git write commands (`commit`, `add`, `stash`, `checkout`, `pull`, `reset`). Read-only git is fine with
  `git --no-optional-locks`. The parent commits; give them the commit message.
- **Do not download from OpenArt yourself** (`cdn.openart.ai` is blocked). The parent downloads the chosen files into `art-inbox/` by hand.
- Do not handle passwords or tokens. Ask before deleting anything; moving is fine.

## LOCKED DECISIONS ✅ (the picture canon, full detail in `canon-for-pictures.md`)

- **The farmer is never painted.** Only a hand reaching from the camera, a backlit silhouette from behind in a farmer's hat, or the view through
  the farmer's eyes. (R3, [#S5], [#S6])
- **Mumyo is traces only** in the main story. At most half-hidden in a picture, never looking at the viewer; Fenna never sees him after the fire.
  (`characters/mumyo.md`)
- **The Helpers do not talk.** (`story/story-delivery.md` §5)
- **No church, chapel or religion.** The bell belongs to the village hall. (`world/hazelwood.md`)
- **Greenstem is the farmer's age.** (`characters/hazelwood-people.md`)
- **The cousin is a girl. Wren is a woman.** The Lord is offstage ("a name on a seal").
- **The Import Broker is Lark in a hat**, a wink that is never said. (`book-file.md`, 6.2)
- **The squirrel may sit on Lark's shoulder at the Fair supper** (14 Oct 2026). Its naming ("Nutmeg, obviously") stays in the free-play piece
  `sq_free_lark`. The magpie may not cross into the shell. (`book-file.md` line 62)
- **Take the newer version** of each picture that was remade after the restart: the 13 pairs below. The older versions are superseded.

## PROPOSED BY THE REVIEW, NOT YET CONFIRMED 💡

- **Full-bleed:** the picture fills its frame; no white or cream border, no vignette fading to paper. (The brief used for the review.)
- **No visible collar bells on animals.** Mumyo's bells are the clue. The goat on the thistle field, the alpaca at the gate and the goat at the
  Fair supper all wear one now.
- **Dropped:** the kitchen-table picture (Helpers sitting round a table reacting like people) and the merchant picture (see question 1).
- **Two pictures on hold:** the night window with shell and feather (no piece yet) and the hay-barn dusk (shows the cause before the bend).

## REJECTED PATHS (do not re-propose)

- The male merchant with a cart at a campfire: contradicts the ch1 text (a woman, on the village square).
- Helpers at a table reacting like people: breaks "the Helpers do not talk".
- A glowing conch close up in the forest: the text says small, far off and still.
- The "Dear Clara, Lorem ipsum…" letter: placeholder text, and Clara is no name in the story.
- A stag on the Lord's seal: not in canon (unless the parent accepts it).

## THE REVIEW IN NUMBERS (`picture_review.csv`)

95 current pictures: 59 KEEP · 15 KEEP + FIX (small) · 6 FIX · 2 FIX (major) · 2 DROP · 2 HOLD · 2 KEEP + DECIDE (mill, frame-6 shell) ·
7 establishing, end-state or frame (KEEP). Plus 15 gap rows: story pieces that have no picture yet.

Columns: `file` (the picture's name), `story_piece` (the piece id in brackets, e.g. `(c2_lark)`), `verdict`, `note`. Gap rows have
`(no picture)` in the file column.

**The fixes (verdicts FIX, FIX (major) and KEEP + FIX; the first seven are the core of the job):**

| Picture (slug) | Piece | Verdict | Problem | Cheapest route (the parent chooses) |
|---|---|---|---|---|
| greenstem-gate-herbs-stone-soup | c2_greenstem | FIX (major) | Greenstem drawn as a child | Regenerate, adult |
| moonstone-forest-conch-shell | c5_conch | FIX (major) | Conch huge and close; text says small, far off, still; white border | Regenerate small and far |
| harvest-fair-tables-greenstem | c6_fair_tables | FIX | Greenstem drawn as a child | Regenerate, adult |
| fair-supper-table-lark-moved | c6_supper | FIX | Greenstem as a child; collar bell on the goat (the squirrel stays) | Regenerate, adult, no bell |
| letter-autumn-frost-eye-level | c2_letter | FIX | "Dear Clara, Lorem ipsum" | Regenerate: scribble only |
| lark-market-stand-exotic-goods | c6_broker | FIX | No hat (text: "He has a hat") | Regenerate with the hat |
| fair-cousin-softening-bench | c6_bend | FIX | Cousin stands with two adults; text says she sits beside you | Regenerate, seated |
| log-cottage-walls-eye-level | c2_walls | FIX | Walls square; text says one wall leans | Change the text, or regenerate with the lean |
| thistle-grab-first-person | (no piece id, ch1 clear the thistles) | KEEP + FIX | Several beds, a fence, a sign; text says one patch | Regenerate, or accept |
| burnt-farm-morning-eye-level | c1_stalk p.1 | Sunny and green; text says grey ash and mud | Regenerate |
| scorched-ledger-page-workshop | c1_ledger | Edges not scorched; red line is a seal; numbers look random | Regenerate |
| herb-house-ruin-torn-page | c5_stillroom | Open book on a bench; text says torn page on the floor | Regenerate |
| goat-thistle-field-path | c3_goat | Collar bell | Regenerate without bell |
| log-cottage-thatch-eye-level | c2_cottage | Thatch and snow; text says rain on tiles | Change the text to thatch (cheapest) |
| compost-corner-empty-note | c2_compost | Wooden frame and paper on a post; text says flat stones and a note on the lid | Change the text, or regenerate |
| library-lark-books-by-size | c4_library | Lark stands holding a heavy book; text says he sits on the heaviest | Change the text, or regenerate |
| sunroom-quill-fraction-one-tenth | c6_quill_answer | Quill serious; text says a small smile | Change the picture (minor) |
| badger-tea-kitchen-hearth | c5_badger | Kitchen; text has him at the still-room door | Change the text, or regenerate |
| smithy-forge-eye-level | c3_forge | Bo looks about ten; the pick list says a teenager | Decide his age, then regenerate if needed |
| grandchildren-giggling-bunny-ears | c1_frame1 | Cream edges | Re-crop or regenerate (border) |
| farm-book-rabbit-sketch-clover | c1_book | Cream vignette | Re-crop or regenerate (border) |
| forest-track-brushwood-frog | (world) | Cream or white edges | Re-crop or regenerate (border) |

Check the exact notes per picture in `picture_review.csv`; they are the source.

**Gaps (story pieces with no picture yet)**, with the piece id: c1_seller (a woman on the square; no person in the porridge picture), c2_frame2,
c3_pieter and c3_pieter_paid (the night watchman, with lantern and book), c3_letter (the barge letter, "Stay if you must"), c3_frame3, c4_pizza
(builders at long tables under paper lanterns), c5_wren_check, c5_first_tea, c5_collapse, c5_frame5, c6_free_family, c6_free_quill, c6_free_greenstem,
c6_free_lark, c6_lord (a letter with a red seal; the seal must not carry the stag). `story-picture-briefs.md` has each piece's text.

## MILL: THE OPEN CONTRADICTION

- Windmill with sails: the ch3 bell ruin (`windmill-ruin-brass-bell`), the ch6 sails (`windmill-new-white-sails`), the three end-of-story views.
- Water wheel: the ch3 stream picture (`miller-bridge-clear-stream-nod`) and the lease document (`world/lease-and-collapse.md`).
- The review recommends the **windmill** (five pictures already show it). Then: redo the miller-bridge picture and change the water-wheel
  wording in the lease document. ❓ Parent decides.

## THE 13 SUPERSEDED PICTURES (move to the archive; the newer version stays)

These are the first batch, made before the restart (13:51–13:55 on 12 Oct). The newer version (made after the restart) is the one in the
review. Full names are in the folder `openart outputs/`:

| Superseded (move) | Replaced by (keep, in the review) |
|---|---|
| `2026-10-12_135116_bunny-wheat-patch-proud_3e91242f.png` | `…_bunny-wheat-patch-eye-level…` |
| `2026-10-12_135143_thistle-pile-wobbly-stick-tower_26810a05.png` | `…_thistle-pile-tower-low-view…` |
| `2026-10-12_135150_lark-fence-apple-gravel-road_2e978b9b.png` | `…_lark-fence-apple-eye-level_0ae30f16.png` |
| `2026-10-12_135201_stump-slope-farm-clearing_f0f42304.png` | `…_tree-stump-slope-eye-level…` |
| `2026-10-12_135308_burnt-farm-seven-years-morning_4ef5f3a2.png` | `…_burnt-farm-morning-eye-level…` |
| `2026-10-12_135312_tent-burnt-ruins-sunset_2fad74be.png` | `…_tent-ruins-sunset-eye-level…` |
| `2026-10-12_135352_letter-autumn-frost-farm_cb1c0390.png` | `…_letter-autumn-frost-eye-level…` |
| `2026-10-12_135401_log-cottage-walls-crooked_22f1e2eb.png` | `…_log-cottage-walls-eye-level…` |
| `2026-10-12_135422_log-cottage-thatch-first-snowflakes_67802851.png` | `…_log-cottage-thatch-eye-level…` |
| `2026-10-12_135430_pond-spring-tortoise_8937fc2a.png` | `…_pond-spring-tortoise-eye-level…` |
| `2026-10-12_135435_barn-frame-lantern-hook_5254e9c4.png` | `…_barn-frame-lantern-hook-ruin…` |
| `2026-10-12_135455_smithy-odinson-bo-horseshoe_e0ef10b5.png` | `…_smithy-forge-eye-level…` |
| `2026-10-12_135449_miller-bridge-muddy-stream_74773819.png` | `…_miller-bridge-clear-stream-nod…` |

The exact newer names (with their hash) are in the `file` column of `picture_review.csv`; match on the slug, not on the timestamp.

**Candidate, pending question 1:** `2026-10-12_135328_merchant-campfire-porridge_ce3f861c.png` (13:53, batch 1; replaced by
`…_campfire-porridge-tent-dusk_b25bde1e.png`, 14:09). It is not in the 13 above.

Suggested archive home: `art-rejected/` if it exists (check first, see Not verified), else a new `archive/story-pictures-superseded-2026-10-14/`.
Move the files; keep their names.

## ARTIFACTS

| Artifact | State | What it is / what to know |
|---|---|---|
| `art-inbox/Story pictures/openart outputs/` | on the Mac; 108 PNGs; 95 current | Originals total **179 MB** (about 1.5–1.7 MB per PNG). Too large for the web build (see W2 in `TODO.md`: GitHub refuses files over 100 MB). Pictures for the game need compressing (size and format are for the new agent to propose). |
| same folder, `README.md` | on the Mac | Every picture with its creation time, model, references and full prompt. Long (about 1,500 lines). |
| same folder, `openart_metadata.csv` | on the Mac | One row per picture: `new_filename`, `created_local`, `prompt`, `reference_labels`. Use it to rebuild prompts. |
| same folder, `rename_map.csv` | on the Mac | Earlier renames. |
| `art-inbox/Story pictures/story-picture-prompts.md` | on the Mac; parent-side plan, **Draft 1, 12 Oct 2026** (33 KB) | Style block (§2), rules (§3), cast (§4), the frame and the seven chapters of beats (§5, §7), everyday moments (§8, the `ev_` ids), order of work (§9): 90 pictures planned, three versions each. Written before the ch2–6 texts (13 Oct), so its ids do not all match the story ids. Its character rules agree with `canon-for-pictures.md` (farmer never in the picture, Mumyo hidden, the badger's spectacles real). |
| `art-inbox/Story pictures/references/` | on the Mac; 15 files, about 20 MB | OpenArt reference images: the style album (`ref_style_album.png`, `ref_style_people.png`), the farm (`farm land.png`, `ref_farm_early_ch1.png`, `ref_farm_late_ch5.png`), the animals (`ref_helpers_animals.png`), Mumyo (`ref_mumyo.png`), and the grandchildren as **realistic** photos (`ref_minena_realistic.jpg`, `ref_manjiva_realistic.jpg`; the prompts say to keep their looks but not their realism). Six unnamed `openart-image_…` files are there too; their use is not known. |
| `picture_review.csv` | written in the workspace; attached | 110 rows: 95 pictures and 15 gap rows. Columns as above. |
| `story-picture-briefs.md` | written in the workspace; attached | Per piece (54 with a picture, 16 without): the English text, the pictures now and their verdicts. Plus a list of pictures not tied to a piece (layout, world). |
| `canon-for-pictures.md` | written in the workspace; attached | The picture canon with sources and a 7-point checklist for any new or changed picture. |
| `story/texts/ch1.md` … `ch6.md` | on the Mac; the source | Every story piece, English and German. The briefs file copies the English. |
| `story/book-file.md`, `story/characters/*.md`, `story/world/*.md` | on the Mac; the canon | Read these for any doubt about a character or a place. |
| `godot-prototype/data/farm/story/*.json` | on the Mac | One entry per piece. **No `picture` field exists yet.** The format is `"picture": "story/<piece-id>.png"` (`story/story-delivery.md` §6). |
| `art-inbox/ART_LIST.csv` | on the Mac | **Has no story-picture rows** (checked 14 Oct). The review asks for story prompt rules here (R3). |
| `godot-prototype/tools/import_art.py`, `tools/art_sheets.json`, `tools/art_list.py` | on the Mac; not read this session | The import path (content skill, "Pictures"): `python3 tools/import_art.py` with `sheet`, `one` or `tile`. Story pictures are single scenes, not sheets, so check whether `one` covers them. |

**Checked on the Mac on 14 Oct:**
- The archive home exists: `archive/art-rejected/` (already holds rejected sprites).
- The import tool (`godot-prototype/tools/import_art.py`) has no mode for full-bleed scenes. `one` cuts an object out of a **white** background,
  makes the background transparent and trims it. A story picture is a full-bleed scene, so it would be damaged. A new mode (or a separate
  script) is needed for story pictures. Decide this before any import.
- No story piece has a `picture` field yet (0 of the six `story/*.json` files).

**Not checked:** whether any story picture is already in the game (no sign so far).

## OPEN THREADS (ask the parent; numbered so they can answer in one line)

1. **Merchant pair.** `merchant-campfire-porridge` (13:53) and `campfire-porridge-tent-dusk` (14:09) show the same subject; the second is the
   restart. The merchant one is **not** among the 13 pairs, so both are still in the 95. Recommendation: archive the merchant one too (that makes
   14 superseded). Confirm?
2. **Mill:** windmill or water wheel? (See MILL.) Recommendation: windmill.
3. **The frame-6 conch** in Minena's hands (`grandchildren-asleep-minena-awake`). Recommendation: remove it; the conch belongs to the forest piece.
4. **Text or picture for the cheap fixes:** cottage roof (thatch vs tiles), crooked walls, the compost pit, the library, Quill's smile, the badger's
   tea setting. Recommendation: change the text where the picture is good.
5. **Full-bleed as a rule:** confirm, so the new art and the crops follow it.
6. **Collar bells:** confirm that animals have no visible bells in story pictures.
7. **OpenArt model:** the picture README says "Nano Banana 2, 1K, 1:1"; the parent's rule (`00-READ-ME-FIRST.md` §4.6) says "Nano Banana 2 Lite at 1K". Which one for story pictures?
8. **Holds and the archive:** the two holds (night window with shell; hay-barn dusk). The archive home is `archive/art-rejected/` (it exists); confirm it.
9. **Style block:** the picture README's painterly block (used for the 108) or the parent's newer block in `story-picture-prompts.md` §2 ("Warm hand-drawn storybook cartoon … soft dark-brown ink outlines … flat colours with gentle cel shading")? The two differ in look. The parent's plan is newer; the review was done against the painterly ones. Recommendation: the parent's block, and regenerate the must-fix pictures in it, so the set matches.
10. **Ids:** `story-picture-prompts.md` (12 Oct) plans its own ids (`c2_roof`, `c2_scorch`, `c3_millbell`, `c3_hat`, `c6_share`, `c6_family`, …). The story texts of 13 Oct (`story/texts/ch*.md`) use other ids. Map them piece by piece before generating; the briefs file uses the text ids.

## WHAT THE NEW AGENT SHOULD WORK OUT (goals, not steps)

- **Goals:** every story piece has its right picture (the gaps); no superseded picture is in the working set; the must-fix pictures are regenerated
  or their text is changed; the pictures for the game are small enough for the web build.
- **Constraints:** the parent downloads the OpenArt files; the parent picks the winners; nothing is deleted; no git writes on the Mac; each new
  picture is checked against `canon-for-pictures.md` §9 before the parent sees it.
- **Things worth thinking about (not a fixed plan):** group regenerations by shared subject (Greenstem appears in three pictures, the bells in
  three) so one reference set serves them; the OpenArt rule is "only about two generations run at a time", so plan the batches; story pictures
  are single scenes, so the sprite-sheet "three versions per sheet" rule does not fit as it is: decide how many versions per scene; record each
  new prompt and result in the same style as `openart_metadata.csv`.
- **Two style blocks exist; decide which (OPEN THREADS 9).** The 108 pictures in `openart outputs/` were made with this painterly block from the
  picture README: "Hand-painted storybook illustration for a cozy farming
  game, in the same world and colours as the reference pictures but a little more painterly: soft painterly shading with gentle brush texture and
  soft light gradients, warm earthy colours with olive greens and warm browns, clean dark-brown outline". The references are OpenArt-side labels
  (`farm early`, `style album`, `animals`, `village cast`, `Minena and Manjiva`, `badger`, `farm land`, `farm late`); the parent manages them.

## LOG ENTRIES (applied on 14 Oct 2026; kept here for reference)

**`PROJECT-LOG.md` §1, new row at the bottom of the table:**

> | **Story pictures review** (14 Oct 2026) | Review of the 95 current story pictures (after the restart: the newer version of 13 pairs taken, 13 older versions set aside, not moved). Per-picture verdicts in `art-inbox/Story pictures/picture_review.csv`; piece briefs and the picture canon beside it; handoff in the same folder. Parent's squirrel decision: the squirrel may sit at the Fair supper. Nothing moved, deleted or generated yet. |

**`story/book-file.md`, session log (after the 13 Oct 2026 entry):**

> - **14 Oct 2026, pictures (parent):** ✅ the squirrel may sit on Lark's shoulder at the Fair supper (picture); its naming stays in `sq_free_lark`. This lifts the "not part of the supper (6.10)" note for the picture only. Story pictures reviewed: see `art-inbox/Story pictures/picture_review.csv` and `canon-for-pictures.md`. Open: mill type, the frame-6 conch, the merchant pair.

**`TODO.md` §15, I11:** change to "I11. Story pictures follow R3. ⏳ Reviewed 14 Oct 2026; see the handoff in `art-inbox/Story pictures/`. Open: the must-fix list, 16 pieces without a picture, the mill type, the archive move, the new art." Add the date in "Last updated" at the top.

**`story/story-delivery.md` §5 (writing rules), add:**

> - ✅ **Picture rules (R3, [#S5], [#S6]):** the farmer is never painted (a hand from the camera, or a backlit silhouette from behind in a farmer's hat). Canon for the pictures: `art-inbox/Story pictures/canon-for-pictures.md`.

## NEXT STEP

Steps 1 and 2 are done. Next: step 3 (move the 13 superseded pictures into a subfolder of `archive/art-rejected/`; the move needs no answer
from the parent), then step 4 (send the numbered questions). Before any generation, decide the style block (question 9) and map the ids (question 10). Everything that depends on an answer waits for it: the merchant pair, the mill, the
frame-6 conch and the cheap text fixes.


## UPDATE 14 Oct 2026 (second session): parent's answers and progress

**Answers ✅:** (1) merchant picture archived too (14 in `archive-superseded-2026-10-14/`, inside this folder). (2) Windmill is the mill; the miller has his own
mill on another farm, so the water-wheel bridge picture STAYS, no change to the lease doc. (3) Frame-6 conch removed (regenerate). (4) Cheap fixes
(roof, walls, compost, library, Quill's smile, badger tea) are done by regenerating with the existing picture as reference, not by changing the text.
(5) Full-bleed is the rule. (6) No visible collar bells on animals. (7) Model: Nano Banana 2 Lite (15 credits, 1K, 1:1). (8) Two holds stay on hold.
(9) Style: the parent's cartoon block (`style-block.txt`, from `story-picture-prompts.md` section 2). (10) Ids: map to the text ids (see `regen_queue.csv`).

**Files:** `regen_queue.csv` (37 pictures: 21 fixes, 16 gaps; columns order, piece_id, kind, old_slug, refs, scene, status, new_files),
`style-block.txt`, `fullbleed-crops/` (3 border pictures cropped, originals untouched).

**Method:** OpenArt image2image, Lite, 1:1, 2 versions per scene. Reference 1 = the old picture (its cdn_url and item_id are in `openart outputs/openart_metadata.csv`),
reference 2 = `ref_style_album.png` (already uploaded to OpenArt). Gaps use the style album and `ref_style_people.png` (+ animals / Minena / Manjiva).
Prompt = style block + "Match the drawing style of reference image 2" + scene. Status in the queue: test pictures 1 (Greenstem) and 2 (conch) submitted.

**Old-id to text-id map (12 Oct plan to story texts):** frame_0_ask=c1_frame0, frame_1=c1_frame1, frame_2=c2_frame2, frame_3=c3_frame3, frame_4=c4_frame4,
frame_5=c5_frame5, frame_6_end=c6_frame6, frame_6_barn and frame_6_promise=on hold; open_ruins=c1_stalk p.1; c1_sticks=c1_bells; c1_merchant=c1_seller (now a woman
on the square); c1_bells(12 Oct)=c1_bell_out; c2_scorch=c2_barn; c2_roof=c2_cottage; c3_millbell=c3_bell; c3_hat and c3_goat_list=c3_goat_out; c4_boat=c4_count;
c4_out=c4_quill_out; c5_shell=c5_conch; c5_low=c5_poison; c5_seal=c5_letter; c6_share=c6_quill_answer; c6_tables=c6_fair_tables; c6_family=c6_fair_letter;
c6_accuse=c6_crisis; c6_milk=c6_ajar; c6_letter (Helpers at table)=dropped; c3_miller=no text piece (c3_stream covers it). Same id elsewhere: c1_stalk, c1_book, c1_night,
c1_ledger, c1_board, c1_bunny, c2_letter, c2_walls, c2_greenstem, c2_stumps, c2_lark, c2_compost, c2_tortoise, c2_hook, c3_forge, c3_stream, c3_dance, c3_goat, c4_quill,
c4_lease, c4_no, c4_library, c4_pony, c5_cough, c5_stillroom, c5_page, c5_badger, c6_broker, c6_garden, c6_bend, c6_alpaca, c6_supper.

**Open for the parent:** the Lord's seal on `c5_letter` shows a stag (not canon): accept the stag, or regenerate that picture too? (`c6_lord` is made without a stag.)
Small text-only items left as they are: Quill's feather pen vs "pencil" (c4_quill), the lease tin on a bench (c4_lease).
**Still to do after the pictures are chosen:** compress to a web-friendly size/format, a full-bleed import mode (new script, not `import_art.py one`), add `picture`
fields to `story/*.json`, add story rows to `ART_LIST.csv`. These live in the Farm game folder, which is not connected in this session.
