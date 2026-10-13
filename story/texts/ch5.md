# Chapter 5: Healing — story pieces (English, then German)

Phase 11 (13 Oct 2026). Source of `godot-prototype/data/farm/story/25-chapter-5.json` and the German in `data/i18n/data-de.json`. 💡 All of it is a first draft for the parent to review. Second person, `{player}` for the name, German with „ss“. The ladder rows 5.1–5.9 (`story/outline/ladder.md`): the cough, the still-room, Wren's check, the awe in the forest, the first remedy, the torn page, the low point, the badger, the letter. Triggers: `forest_trips>=n`, `forest_poisoned>=n`, `has:<item>:n` and the usual.

## c5_cough · beat · A cough in Hazelwood
*When:* `chapter:5`

Page 1. Down in Hazelwood somebody is coughing. Then somebody else. The children first, as always, and nobody knows what to do.

> Unten in Hazelwood hustet jemand. Dann noch jemand. Die Kinder zuerst, wie immer, und niemand weiss, was man tun soll.

Page 2. Wren the healer comes up the road with a full basket. “I cannot do this alone, {player},” she says. “Berit's old still-room is behind your kitchen. Would you look?”

> Wren, die Heilerin, kommt mit einem vollen Korb die Strasse herauf. „Allein schaffe ich das nicht, {player}“, sagt sie. „Berits alte Destillierstube liegt hinter deiner Küche. Schaust du sie dir an?“

## c5_stillroom · discovery · A torn page
*When:* `done:ruins_stillroom`

Under the last shelf lies a page, torn in two. The top half is in a tidy hand: “Tea first. Always tea first.” The bottom half is missing. Somebody was here before you, and cared.

> Unter dem letzten Regal liegt eine Seite, in der Mitte zerrissen. Die obere Hälfte ist in sauberer Schrift: „Zuerst Tee. Immer zuerst Tee.“ Die untere Hälfte fehlt. Jemand war vor dir hier, und es lag ihm etwas daran.

## c5_wren_check · visit · Wren's rule
*When:* `forest_trips>=1`

Page 1. Wren is waiting at the edge of the forest with her arms folded. “One rule,” she says. “Bring me your basket. Every time. Before you use anything in it.”

> Wren wartet am Waldrand mit verschränkten Armen. „Eine Regel“, sagt sie. „Bring mir deinen Korb. Jedes Mal. Bevor du irgendetwas daraus benutzt.“

Page 2. “Plants have twins, and some twins are poison. I do not care how clever you are. I care that you wake up tomorrow.” She almost smiles. “It costs a little favour. A biscuit will do.”

> „Pflanzen haben Zwillinge, und manche Zwillinge sind Gift. Es ist mir egal, wie klug du bist. Mir ist wichtig, dass du morgen aufwachst.“ Sie lächelt fast. „Es kostet einen kleinen Gefallen. Ein Keks genügt.“

## c5_conch · beat · Something white
*When:* `forest_trips>=3`

Far off between the trees, something white and spiral shines in the green. It does not move. You hold your breath. Then you go back to your basket. Some things are for later.

> Weit weg zwischen den Bäumen leuchtet etwas Weisses, Gewundenes im Grün. Es bewegt sich nicht. Du hältst den Atem an. Dann gehst du zurück zu deinem Korb. Manches ist für später.

## c5_first_tea · moment · A pupil for Wren
*When:* `done:tea_pot`

Greenstem, the boy from the market, stands in the doorway of the still-room and sniffs. “Can I learn this?” Wren grumbles something about boys and mud. Then she says yes.

> Greenstem, der Junge vom Markt, steht in der Tür der Destillierstube und schnuppert. „Darf ich das lernen?“ Wren brummt etwas über Jungs und Matsch. Dann sagt sie ja.

## c5_poison · scene · What were you thinking?
*When:* `forest_poisoned>=1`

Page 1. The ceiling. A blanket. A cup of something bitter. Wren sits by your bed, and she is not smiling. “What were you thinking?” she says. Your purse is gone. Your legs shake.

> Die Decke. Eine Wolldecke. Eine Tasse mit etwas Bitterem. Wren sitzt an deinem Bett, und sie lächelt nicht. „Was hast du dir dabei gedacht?“, sagt sie. Dein Geldbeutel ist weg. Deine Beine zittern.

Page 2. “You are well,” she says. “That is all that matters. Next time, the basket comes to me first.” She puts a hand on your head, very briefly, and goes to stir her pot.

> „Du bist wieder gesund“, sagt sie. „Nur das zählt. Nächstes Mal kommt der Korb zuerst zu mir.“ Sie legt dir kurz die Hand auf den Kopf und geht, ihren Topf umzurühren.

## c5_page · beat · The other half
*When:* `has:healers_chest:1`

The chest is full. In its lid, rolled up, you find the other half of the torn page: “The badger left after the fever, when nobody let the children rest.” You read it twice. You were one of those children.

> Die Truhe ist voll. Im Deckel findest du, zusammengerollt, die andere Hälfte der zerrissenen Seite: „Der Dachs ging nach dem Fieber, als niemand die Kinder ausruhen liess.“ Du liest es zweimal. Du warst eines dieser Kinder.

## c5_collapse · beat · You never stop
*When:* `seen:c5_page + after:c5_page:2`

You make one more tea, and one more, day and night. Then the pot tilts and the floor comes up. Wren finds you on the stone. “You never stop, do you?” she says, and carries you to the bench.

> Du machst noch einen Tee und noch einen, Tag und Nacht. Dann kippt der Topf, und der Boden kommt hoch. Wren findet dich auf dem Stein. „Du hörst nie auf, oder?“, sagt sie und trägt dich zur Bank.

## c5_badger · beat · Tea first
*When:* `done:pet_badger`

Page 1. At the door of the still-room sits a badger, with his back very straight. He looks at the chest. He looks at the tea set. Then he looks at you, and at your hands.

> An der Tür der Destillierstube sitzt ein Dachs mit ganz geradem Rücken. Er sieht die Truhe an. Er sieht das Teeservice an. Dann sieht er dich an, und deine Hände.

Page 2. He sets out two cups. “Tea first,” he seems to say. You sit down. For the first time in a long time, you do nothing at all. The badger pours.

> Er stellt zwei Tassen hin. „Zuerst Tee“, scheint er zu sagen. Du setzt dich. Zum ersten Mal seit langem tust du gar nichts. Der Dachs schenkt ein.

## c5_letter · beat · A letter with a seal
*When:* `seen:c5_badger + after:c5_badger:1`

A boy runs up the road with a letter. The seal is red wax, pressed with a heavy ring. “From the Lord,” he pants. You do not open it yet. The badger looks at it, and then at you, and says nothing.

> Ein Junge rennt die Strasse herauf, einen Brief in der Hand. Das Siegel ist aus rotem Wachs, mit einem schweren Ring gedrückt. „Vom Herrn“, keucht er. Du öffnest ihn noch nicht. Der Dachs sieht ihn an, dann dich, und sagt nichts.
