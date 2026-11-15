---
name: openart-pictures
description: Use when pictures for the Farm Quiz Game (Hazelwood Harvest) are to be generated in OpenArt and brought into the project - sprite sheets, window pictures, story pictures. Covers the whole run with the OpenArt connector - prompt, reference picture, generate, wait, download, keep every version, pick one, count the credits - and what to do when a prompt does not give what was wanted. Not for cutting a sheet into game sprites (that is the farm-game-content skill's "Pictures" part).
---

# OpenArt pictures: generate, download, pick

Claude does the whole run; the parent does not wait or pick (their word of 14 Nov 2026). Every version that was not picked is kept
so the parent can swap later. The tracker ticket for the run is `pictures/15`; what is needed, with prompts, is `art-inbox/ART_LIST.csv`.

## The settings (the parent's rules)

- Project **"Farm Quiz Game"**, id `P254DNhjwVvUBMudarAn` (check with `openart_project_list` if a call refuses it).
- Model **Nano Banana 2 Lite** (`nano-banana-2-lite`), mode `image2image`, **3 versions** (`imageCount: 3`). It costs 15 credits
  a picture, so 45 a sheet, and gives JPEGs of about 1200 px (the "1K" of the rules; the form has no resolution field).
- **A reference picture for the style, always.** For sprites: the upload "style album",
  `{"type":"image","id":"T6ZpRAmTLrMQLCv775n5","label":"style album","url":"https://cdn.openart.ai/openart-uploads/production/2026-10/create-image/user_2tVDMhrvIgTGkYR5YWpNVuOSq4k/ref_style_album_1791805257206_f8d258e8.png"}`.
  For painted scenes use a painted reference ("farm land" `GpMKDkEQb7QqYUthYISV`, "farm early", "farm late", "village cast",
  "animals"); their addresses are in the `visualReferences` of earlier generations (`openart_creation_list` on the project). A
  picture generated earlier can be a reference the same way: its `id` and `url` from `openart_creation_get`.
- **At most two generations at a time** (a call with `imageCount: 3` is one). Submit, do other work, then fetch.
- **Credits:** the parent set a ceiling of 2000 for the run started 14 Nov 2026. `python3 .claude/skills/openart-pictures/fetch.py spent`
  says what has been used; `openart_account_get` says what is left. Stop and say so before going over.
- A new reference from a local file needs the parent (the upload window `openart_upload_pick`); do not upload by shell.

## The run, step by step

1. **Name the sheet** as the next free `sheetNN-what` (look at `art-inbox/`). Write the prompt to a file in the scratchpad.
2. **Generate:** `openart_generate_image` with model, mode, `projectId` and `params` = `prompt`, `imageCount: 3`, `aspectRatio`
   (1:1 for a 3 × 3 or 4 × 4 sheet, 4:3 for 4 columns × 3 rows, 3:2 for a window picture), `visualReferences`. It returns a
   `historyId` and `PENDING`.
3. **Wait:** `openart_creation_get(historyId)` after about a minute; repeat until `COMPLETED`. The addresses are in
   `resources[].url`. `FAILED` costs nothing: read the reason, change the prompt, submit again.
4. **Download and keep everything:**
   `python3 .claude/skills/openart-pictures/fetch.py get <sheet> --history <id> --credits 45 --prompt-file <file> <url1> <url2> <url3>`
   saves `art-inbox/alternatives/<sheet>/<sheet>-v1.jpg …`, the prompt, a row per file in `art-inbox/openart-runs.csv`, and
   `contact.html` (all versions side by side).
5. **Look at all three** with the Read tool and pick by these, in order: every object asked for is there, in the order asked;
   objects are whole and apart (the cutter splits on white space); the style matches the game (compare with one existing sheet,
   such as `art-inbox/sheet45-items-1.png`); the angle and scale are the same within a set.
6. **Pick:** `python3 .claude/skills/openart-pictures/fetch.py pick <sheet> <version>` copies it to `art-inbox/<sheet>.png` and
   marks it. Swapping later is the same command with another version, then the import again.
7. **Import** as the `farm-game-content` skill says (add the sheet's object names to `godot-prototype/tools/art_sheets.json`,
   `python3 tools/import_art.py sheet ../art-inbox/<sheet>.png <names…>`). The tool needs Pillow, numpy and scipy, which this Mac's
   Python does not have and Homebrew's Python cannot make a venv for: make a throwaway one with the system Python,
   `/usr/bin/python3 -m venv $S/artvenv && $S/artvenv/bin/pip install pillow numpy scipy`, and run the tool with `$S/artvenv/bin/python`.
   Then paste every cut sprite onto a grass-green picture and look at it once (wrong cuts show at a glance), set the rows in `ART_LIST.csv` to done,
   and take a screenshot of a place that uses the pictures.
8. **Say in the log row** which sheets were made and the credits used.

## Writing the prompt

Start every sprite prompt with the style line of `ART_LIST.csv` (its first comment row) and "in exactly the art style of reference
image 1 (use it only for the style)". For window pictures use the window style line (its second comment row). Then:

- Say **how many objects, in how many rows and columns**, and number them row by row. Six to twelve objects a sheet.
- "Plain pure white background", "evenly spaced with wide white space between them, none touching", "no text, no letters, no
  numbers, no labels, no frames, no grid lines".
- For a **set** (a pile in four sizes, a cart in three fill levels): "the same … seen from the same angle, at the same scale",
  and describe each size in a few plain words.
- No farmer, no hands, no people unless the picture is of a person; animals without collar bells.

## When the result is not what was wanted

Change the prompt, do not just run it again. What has been learnt (add to this list):

- **Loose bits become extra objects.** Asking for a stone "about to roll off" gave stones floating beside the pile, which the
  cutter would cut as their own sprites. Ask for every object as "one solid piece: no loose bits, crumbs, sparkles or motion
  lines beside it"; movement is the game's job.
- **One wrong object in a good sheet** (a pile of split logs where sticks were asked): pick the best version, and if no version
  has every object right, generate only the wrong objects again as a small sheet rather than the whole sheet.
- **The model drifts to its own idea of a word** ("sticks" became firewood logs once): name the look, not only the thing
  ("thin brown branches as thick as a finger").
- **A set that does not match itself:** use the best version of the first try as a second reference and say "the same object as
  in reference image 2".
- **Words appear in the picture:** add "signs and labels blank" and name the thing without a word that suggests writing.
- **What worked (14 Nov 2026):** both first sheets were right at the first try with the wording above; "one solid piece, no loose
  bits" removed the floating crumbs completely, and "the same wagon … seen from the same angle" kept a set of three alike.
- **Story pictures come back with a cream paper margin or rounded corners about half the time**, even when the prompt forbids
  it. Do not regenerate for that: trim to the picture (the bounding box of everything that differs from the corner colour, 2 %
  further in, then the largest centred square) and scale back up.
- **Check the reference before sending.** A wrong address in `visualReferences` is not an error: the model just draws from the
  text. Take the address from `art-inbox/openart-runs.csv` (the row of the picked file), never from memory.
- **Look in the default project too** ("Personal Project"): 38 regenerated story pictures of 12 Oct 2026 lay there, never
  downloaded. `art-inbox/Story pictures/regen_history.csv` has the history ids; `openart_creation_get` finds them in any project.
- **Names under the objects** came with two of four sheets on 14 Nov 2026 (a list of twelve named plants or remedies invites
  captions; "jar labels blank" made it worse). Do not regenerate: pick the best version and paint white bands over the caption
  rows of `art-inbox/<sheet>.png` before importing (Pillow, three rectangles). Next time leave out every word about labels on
  the objects themselves and add "no captions under the objects".
- **A shadow that floats free** (under something that hangs) is cut as its own object and shifts every name after it: the
  importer then says "found 10 objects" for 9 names. Put `-` at that place in the name list.
- **In zsh a list of names in a plain variable is one word.** Use an array (`N=(items/a items/b)`, then `$N`), or the importer
  writes one file with spaces in its name.
- **Full painted pictures on one sheet** (album pictures: six square scenes with rounded corners, 3:2, worked at the first
  try): never cut them with `import_art.py sheet`, which makes pale skies see-through. Use
  `tools/import_album_sheet.py <sheet> <names…>` and list the sheet under `albumSheets` in `art_sheets.json`.
- **Portrait stamps** (a head in a circle, peach background) cut cleanly with the normal sheet import; describe each person by
  age, hair, clothes and one thing they carry, and say "all circles the same size".
- Three poor tries in a row on one sheet: stop, note it in `pictures/15`, and go on with the next sheet.

### Window pictures (15 Nov 2026, 41 windows, 630 credits)

- **Faces on objects.** Shelf and storage scenes came back with kawaii smiles on baskets and jars. Add "every object is a plain
  ordinary object with no faces: no eyes, no smiles on baskets, jars or sacks" to every such prompt (one regenerate, then clean).
- **Tiny people outside a window or door.** Interiors with a window or door add small farmers. Add "no people anywhere, not even
  tiny ones outside a window". "No people unless named" alone is not fully obeyed.
- **Diary, notebook and sign pictures:** "wavy lines instead of writing" gave no letters; "blank signboards" still gave a few
  faint squiggles, which is fine.
- **Cream margin and rounded corners** (scroll, storage v2): the importer's trim handles it; do not regenerate. Not yet tested
  whether "zoomed in so the scene fills the picture to its corners" stops it.
- **Unnamed extras** (merchant figures in `broker`, cat and piglets in `ws_bench`) came in: acceptable when friendly and small;
  pictures with a clear mismatch to the window go to the parent's notes (`pictures/09`), not to a second run.
- Cost: a window picture was generated one version at a time, 15 credits each: 42 generations (41 windows plus one regenerate) cost
  630 credits.

### Story pictures (15 Nov 2026, 40 pictures, 600 credits: `story/26`)

- One version at 15 credits is enough for a story picture; one retry in 39 (a note with pseudo-words).
- **Book covers and notes:** "book covers blank, no title, no words"; for notes "rows of plain wavy lines, no letter shapes at all"
  (plain "wavy lines" gave pseudo-words once in six). A title that slips through can be painted out with Pillow; keep the original.
- **The farmer's hands:** "from the camera side a hand in a brown woven mitt" worked 5 of 5 where a pair of hands was needed.
- **Age words:** "middle-aged" gave an old woman. Give a number ("about 45, strong arms").
- The tail "every object is a plain ordinary object with no faces" and "no people anywhere except those named" worked every time.
- About half the pictures come with a cream margin and rounded corners; the **story importer does not trim**, so trim to the
  picture before mapping it in `story_pictures.json`.
- Reuse an old picture when it is already right (`c3_stream` has the old miller-bridge picture with the water wheel).
- `fetch.py get` for a retry appends v2 correctly; do not overwrite `prompt.txt` of the first try with a scratch script.

### Sheets 62-67 and seven story pictures (15 Nov 2026, 360 credits)
- A sheet with long item names invites **captions** under the objects (3 of 3 versions of the gear sheet had them; tools and wearables mostly did not). Number the items, name them in as few words as possible, say "no captions, nothing under the objects but white", and keep one version spare. Painting white over a caption row of the picked version works when no version is clean (keep the original in `alternatives/`).
- Pairs "standing close together" are cut as ONE sprite: ask for space between items, or name each item on its own row.
- 4 x 3 items on a 4:3 sheet comes out well; two-version sheets (`imageCount` 2, 30 credits) are possible when the budget is short.
- An enclosed gap (a cord loop) is not made transparent by the cutter and keeps a little white.
- Story pictures: all 7 came with a cream margin again; trim 3 % before the importer.

### Square tiles and deco (15 Nov 2026, sheets 68-70, 105 credits)
- **Diamond tiles:** "ONE flat diamond-shaped paving slab, exactly twice as wide as deep, a thin slab edge on its two front sides, texture running to the edges so slabs lay side by side" worked at the first try with a good slab as reference image 2 for the shape. The model gives 16 when 12 are asked (a 4 x 4 sheet): ask for 16.
- **Never write "numbered row by row" with "no numbers"**: it prints 1-12 under the objects. Say "in 4 columns and 3 rows" and list the objects in the order of the rows.
- **Rows that touch cut as one object** (importer: "found 15 objects, 16 names", one sprite merged): paint white bands between the rows of the picked sheet before importing (keep the original in `alternatives/`).
- **Tall tiles** (flower beds, lupins) come out taller than a slab: the ground code keeps the slab at the row and lets the flowers stand up over the row above.
- **Deco on a footprint:** "standing on its own flat diamond footprint" gives a white slab under each object; `tools/strip_footprint.py <backup-dir> <pictures>` makes it transparent (shadow kept) and erases its outline; the original goes to the backup folder. Better: leave the footprint out of the prompt ("a small soft shadow, no ground").
- After `import_art.py` new pictures show as holes in the game until `Godot --headless --path . --import` has run (it writes the `.import` files, which are committed).

