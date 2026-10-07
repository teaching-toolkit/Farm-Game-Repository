# Sound inbox

Sounds and music waiting to go into the game, like `art-inbox/` for pictures. Nothing here is used until
`python3 tools/import_sounds.py` (in `godot-prototype/`) copies it into `godot-prototype/assets/sounds/`.

**Only open licences**: CC0 (no credit needed) or CC-BY (credit needed). Every folder or file needs a line in
`SOURCES.json` (who made it, the licence, the web page); the tool skips anything without one, and the credits page in
⚙️ Settings is made from it.

## 1. Sound effects — four free packs by Kenney (CC0)

Download each zip from its page and unzip it here, keeping the folder name:

| Folder here | Page |
|---|---|
| `kenney_interface-sounds/` | https://kenney.nl/assets/interface-sounds |
| `kenney_rpg-audio/` | https://kenney.nl/assets/rpg-audio |
| `kenney_impact-sounds/` | https://kenney.nl/assets/impact-sounds |
| `kenney_music-jingles/` | https://kenney.nl/assets/music-jingles |

`godot-prototype/data/sounds.json` says which file of which pack is used for what ("from"). The file names there are what
these packs are expected to contain; if the tool reports a sound as missing, look in the pack for a similar file and fix
the pattern in `sounds.json`.

## 2. Animals, water and the perk extras — single sounds (CC0)

Save these into the folders below with these names (any of .ogg / .wav / .mp3), and add a `SOURCES.json` line for each
file (or folder) — `"path": "animals/chicken.ogg"`, `"author"`, `"licence"`, `"source"` (the page).
A good place for CC0 single sounds is BigSoundBank (https://bigsoundbank.com).

| Save as | What |
|---|---|
| `animals/chicken.ogg` | hens clucking (short) |
| `animals/cow.ogg` | a cow mooing |
| `animals/sheep.ogg` | sheep baaing |
| `animals/goat.ogg` | a goat bleating |
| `animals/horse.ogg` | a pony / horse neighing or snorting |
| `animals/bees.ogg` | bees buzzing (a few seconds) |
| `animals/cat.ogg` | a cat meowing or purring |
| `animals/birds.ogg` | birdsong (a few seconds) |
| `water/splash.ogg` | water poured or a bucket splash |
| `extras/thunder.ogg` | a short thunder crack (lightning perk) |
| `extras/party.ogg` | a party popper (harvest party perk) |
| `extras/wind.ogg` | a soft gust of wind (season breeze perk) |

## 3. Music — six loops (CC0 or CC-BY)

Save them as `music/farm_spring.ogg`, `music/farm_summer.ogg`, `music/farm_autumn.ogg`, `music/farm_winter.ogg`,
`music/quiz.ogg`, `music/rest.ogg` (calm, no singing; the farm ones cheerful). Ideas to listen to first:

- **Zane Little — cozy farm music** (OpenGameArt, CC0): https://opengameart.org (search "Zane Little cozy farm").
- **Kevin MacLeod** (incompetech.com, **CC-BY 4.0**, credit needed): for example *Carefree* or *Fluffing a Duck* (farm),
  *Wallpaper* (Time Quiz), *Meditation Impromptu 01* or *Gymnopedie No 1* (Rest).
- OpenGameArt's "cozy" / "farm" music in general (filter by licence CC0 or CC-BY).

## Then

```bash
cd godot-prototype
python3 tools/import_sounds.py           # copies, names and credits the files; lists what is still missing
$G --headless --path . --import          # Godot imports the new sound files
```

A cloud session can do the downloads itself only if its network allows `kenney.nl`, `opengameart.org`,
`bigsoundbank.com` and `incompetech.com` (environment settings → Network access → Allowed domains).
