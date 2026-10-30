# Knowledge: cards, books and the library

Part of the game's design ([index](README.md)). It describes the game as built; **(planned)** = decided, not built; **(idea)** = not decided. Where this and the data disagree, the data wins.

### 4.2 Knowledge: cards, books and the library

What the farm can do is learned. **67 knowledge cards** in **12 books**, one idea per card (*A safe little fire*, *Twisting
rope from fibres*, *Why bread rises*, *Smelting iron*, *Mixing colours* …). A card unlocks the things it describes (the
campfire, rope, the oven …), gives a lasting boost (✨, e.g. fuel −5 %), or both.

**Learning a card:**
1. Own its **book** (bought from the book cart, which comes with the travelling merchant).
2. Have **discovered** the thing it is about, if it names one (hold iron ore once before *Smelting iron*).
3. **Read** it: the card's page (2–4 sentences, reading level of class 2–3, can be read aloud) stays open while the reading
   takes a few Time Quiz questions; a bigger library reads faster.
4. Take its **quiz**: 2 new questions about the card plus up to 3 review questions, one from each of up to 3 earlier cards
   it builds on (weakest and longest-unseen first). Wrong answers grey out with a one-line "why" and can be retried; a
   missed review never blocks learning.

Learned cards come back as **reviews in the Time Quiz** (Leitner boxes 1–4: due after 12 / 40 / 100 / 250 questions or 1 /
3 / 7 / 21 days, whichever comes first). Only first-try answers move a card up.

**The library** grows from a box in the tent to a room:

| Level | Holds | Reading | Needs |
|---|---|---|---|
| 📦 Book box in the tent | 2 books | — | start (*The Little Farm Book* is in it) |
| 📚 Bookshelf | 5 | 10 % faster | 5 cards learned, Carpenter's Bench |
| 🪑 Bookcase & reading chair | 11 | 20 % faster | 15 cards |
| 🏛️ Library room | 14 (all) | 30 % faster, +½ ⚡ per Rest answer | 30 cards, Farmhouse |

**The books** (chapter, price): *The Little Farm Book* (1, free) · *Village Crafts* (1, 15) · *Grandma's Kitchen* (2, 25) ·
*Animals & Bees* (2, 30) · *Soil & Seasons* (2, 40) · *The Smith's Book* (3, 150) · *From Fleece to Fabric* (3, 125) · *Cellar
& Larder* (3, 150) · *Fire, Glass & Steel* (4, 125) · *Orchard & Oils* (4, 100) · *Colours of the Earth* (6, 175) · *The Master
Farmer* (6, 250) · *Body and Mind* (2, 20) · *The Healer's Herbal* (5, 150). Which card opens what is in the data (node type `knowledge`, field `unlocks`) and in the explorer.

Knowledge is paid for with coins (books), time (reading) and **the child showing the knowledge** in the quiz — there is no
second currency.
