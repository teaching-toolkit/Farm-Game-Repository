# Chapter 1: Ashes — story pieces (English, then German)

Round 7, draft 1 (13 Oct 2026). Source of `godot-prototype/data/farm/story/10-chapter-1.json` and the German in `data/i18n/data-de.json`. Second person, `{player}` for the name, no gendered word for the farmer, the Helpers do not talk, German with „ss“. Kinds and rules: `../story-delivery.md`. Triggers are game conditions (`done:<node>`, `tap:<place>`, `page:<card>`, `step>=n`, `seen:<piece>`, `after:<piece>:<questions>`, `chance:<p>`).

## c1_frame0 · frame · Bedtime
*When:* `start`

Page 1. Evening. The room smells of tea. Minena has brought a cup and spilled half of it. The others sit on the floor, on the bed, on your feet.

> Abend. Im Zimmer riecht es nach Tee. Minena hat eine Tasse gebracht und die Hälfte verschüttet. Die anderen sitzen auf dem Boden, auf dem Bett, auf deinen Füssen.

Page 2. “Tell us about the farm that burned down!” “Again?” you say. “Yes!” “And don't forget the bells,” whispers someone very small. “Shh! That comes later!”

> „Erzähl uns von der Farm, die abgebrannt ist!“ „Schon wieder?“, sagst du. „Ja!“ „Und vergiss die Glöckchen nicht“, flüstert jemand ganz Kleines. „Psst! Das kommt später!“

Page 3. You close your eyes. You are not sure you remember it right. But it always begins the same way: with ash.

> Du schliesst die Augen. Du bist nicht sicher, ob du alles richtig weisst. Aber es fängt immer gleich an: mit Asche.

## c1_stalk · beat · The last grain
*When:* `start` · *then:* welcome hints

Page 1. Everything is grey. Ash, mud, black posts where a house once stood. The farm of your family is gone.

> Alles ist grau. Asche, Matsch, schwarze Pfosten, wo einmal ein Haus stand. Der Hof deiner Familie ist weg.

Page 2. But look. One green patch in the ash. On it stands one ripe wheat stalk. Every grain has been nibbled off. All but one.

> Aber schau. Ein grünes Fleckchen in der Asche. Darauf steht ein reifer Weizenhalm. Jedes Korn ist abgeknabbert. Bis auf eins.

Page 3. You pick up the last grain. Somebody was here. And somebody left it for you.

> Du nimmst das letzte Korn in die Hand. Jemand war hier. Und jemand hat es für dich dagelassen.

## c1_book · beat · The book
*When:* `page:k_wheat`

Page 1. The book in the box is old. On the first page, in thin brown ink: “Start small. Small is plenty.”

> Das Buch in der Kiste ist alt. Auf der ersten Seite steht in dünner brauner Tinte: „Fang klein an. Klein ist genug.“

Page 2. You read it twice. Then, from nowhere, an old tune comes back, and a line of words: “Long ears sow the clover green.”

> Du liest es zweimal. Dann kommt von irgendwoher eine alte Melodie zurück, und eine Zeile: „Lange Ohren säen den Klee so grün.“

## c1_night · beat · The first night
*When:* `step>=2`

Page 1. The first night. The sky is huge. At the edge of the dark forest, white stones glow, very faintly.

> Die erste Nacht. Der Himmel ist riesig. Am Rand des dunklen Waldes leuchten weisse Steine, ganz schwach.

Page 2. Somewhere, a tune. You do not know it. You find you are humming it anyway.

> Irgendwo eine Melodie. Du kennst sie nicht. Und doch summst du sie mit.

## c1_bells · discovery · A little bell
*When:* `done:clear_thistles`

When the last thistle is out, you hear it: a tiny bell, high in the air. Then nothing. Behind you, three sticks lie in a very silly pile. Nothing is missing.

> Als die letzte Distel draussen ist, hörst du es: ein winziges Glöckchen, hoch in der Luft. Dann nichts mehr. Hinter dir liegen drei Stöcke in einem sehr komischen Haufen. Es fehlt nichts.

## c1_ledger · discovery · A burnt page
*When:* `done:ruins_workshop`

Under the black boards you find a page, burnt at the edges. A list of numbers. At the bottom, in red: “The Lord's share.” Every year the red number is bigger. You fold the page small and keep it.

> Unter den schwarzen Brettern findest du ein Blatt, an den Rändern verbrannt. Eine Liste mit Zahlen. Ganz unten, in Rot: „Der Anteil des Herrn.“ Jedes Jahr ist die rote Zahl grösser. Du faltest das Blatt klein und behältst es.

## c1_seller · visit · The seller
*When:* `done:d_porridge`

Page 1. On the village square a seller sniffs the air. “Is that porridge?” You hand her a bowl. She eats it standing up, very fast.

> Auf dem Dorfplatz schnuppert eine Händlerin in der Luft. „Ist das Porridge?“ Du reichst ihr eine Schüssel. Sie isst im Stehen, ganz schnell.

Page 2. “You're from Moonedge, aren't you?” she says. “Good porridge, {player}. I'll tell everyone that somebody is cooking up here again.”

> „Du bist doch von Moonedge, oder?“, sagt sie. „Gutes Porridge, {player}. Ich erzähle allen, dass hier oben wieder jemand kocht.“

## c1_board · discovery · The notice board
*When:* `tap:board`

A notice board, full of little papers. Somebody needs a basket. Somebody has lost a goat. You read every one twice, and keep your hat low.

> Eine Anschlagtafel voller kleiner Zettel. Jemand braucht einen Korb. Jemand hat eine Ziege verloren. Du liest jeden zweimal und ziehst den Hut tief ins Gesicht.

## c1_bunny · beat · The bunny comes home
*When:* `done:pet_bunny`

Page 1. A bunny sits on the one green patch. She sits like someone who has always sat there.

> Ein Häschen sitzt auf dem einen grünen Beet. Es sitzt da, als hätte es dort schon immer gesessen.

Page 2. Now you understand. The patch stayed green because somebody looked after it. The stalk was nibbled because somebody was hungry. And one grain was left for you.

> Jetzt verstehst du es. Das Beet ist grün geblieben, weil jemand sich darum gekümmert hat. Der Halm war abgeknabbert, weil jemand Hunger hatte. Und ein Korn blieb für dich übrig.

Page 3. Now the first line of the old rhyme makes sense: “Long ears sow the clover green.” You say it out loud. The bunny's ear twitches.

> Jetzt ergibt die erste Zeile des alten Reims einen Sinn: „Lange Ohren säen den Klee so grün.“ Du sagst sie laut. Das Ohr des Häschens zuckt.

## c1_bell_out · beat · Two soft rings
*When:* `seen:c1_bunny + after:c1_bunny:1`

That night, from far away: two soft rings of a very small bell. You sit up in the dark. The bunny is asleep in the clover. So who else is still here?

> In der Nacht, von weit weg: zwei leise Töne eines ganz kleinen Glöckchens. Du setzt dich im Dunkeln auf. Das Häschen schläft im Klee. Wer ist denn sonst noch hier?

## c1_frame1 · frame · Back in the room
*When:* `seen:c1_bell_out`

Page 1. Back in the room, the tea has gone cold. “Was there really a bunny?” asks Minena. “There was,” you say. “She was very rude about carrots.”

> Zurück im Zimmer ist der Tee kalt geworden. „Gab es wirklich ein Häschen?“, fragt Minena. „Ja“, sagst du. „Es war sehr frech, wenn es um Karotten ging.“

Page 2. “And the bell? Who rang the bell?” “Shh!” says everybody at once. “That's next time!” You smile. They know this story almost as well as you do. Almost.

> „Und die Glocke? Wer hat die Glocke geläutet?“ „Psst!“, rufen alle auf einmal. „Das kommt beim nächsten Mal!“ Du lächelst. Sie kennen die Geschichte fast so gut wie du. Fast.

## c1_k_seller · bark
*When:* `done:d_porridge + step>=8 + chance:0.25`

“Do you ever stop?” calls a cart driver from the track. You wave. You do not stop.

> „Hörst du eigentlich nie auf?“, ruft ein Fuhrmann vom Weg. Du winkst. Du hörst nicht auf.

## c1_k_hens · bark
*When:* `done:animal_chicken + chance:0.2`

The hens argue about who laid which egg. Nobody wins.

> Die Hühner streiten, wer welches Ei gelegt hat. Niemand gewinnt.

## c1_k_bucket · bark
*When:* `step>=4 + chance:0.15`

The old bucket clanks against the well stones. It sounds almost proud.

> Der alte Eimer klappert an den Brunnensteinen. Es klingt fast stolz.

## c1_k_grass · bark
*When:* `chapter:1 + step>=6 + chance:0.2`

Something rustles in the long grass. It stops when you look.

> Im hohen Gras raschelt etwas. Es hört auf, sobald du hinschaust.

## c1_k_smoke · bark
*When:* `step>=3 + chance:0.15`

The wind still smells a little of old smoke.

> Der Wind riecht immer noch ein bisschen nach altem Rauch.

## c1_k_winter · bark
*When:* `chapter:1 + season:winter + chance:0.3`

The tent flaps in the wind. You pull the blanket up to your nose.

> Das Zelt flattert im Wind. Du ziehst die Decke bis zur Nase.
