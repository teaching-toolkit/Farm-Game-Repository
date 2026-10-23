# Chapter 3: Smallholding — story pieces (English, then German)

Phase 8 (13 Oct 2026). Source of `godot-prototype/data/farm/story/20-chapter-3.json` and the German in `data/i18n/data-de.json`. Second person, `{player}` for the name, German with „ss“. So far only Pieter and the Lord's share (TODO M13); the other chapter 3 pieces come with the story rounds. Triggers are game conditions (`lord_shares>=n`: the Lord's share has fallen due n times, `lord_paid>=n`: n bronze have been paid).

## c3_pieter · visit · The night watchman
*When:* `lord_shares>=1`

Page 1. A lantern swings up the road in the daylight. Under it walks Pieter, the night watchman. He does not look happy.

> Eine Laterne schwankt mitten am Tag die Strasse herauf. Darunter geht Pieter, der Nachtwächter. Er sieht nicht froh aus.

Page 2. “I am sorry, {player}. The Lord wants his share. It is not my idea. I only carry the book.” He shows you a number. “Pay when you can. I will wait at the gate.”

> „Es tut mir leid, {player}. Der Herr will seinen Anteil. Das ist nicht meine Idee. Ich trage nur das Buch.“ Er zeigt dir eine Zahl. „Zahl, wenn du kannst. Ich warte am Tor.“

## c3_pieter_paid · moment · Pieter
*When:* `lord_paid>=1`

Pieter taps his book shut. “Thank you. Most people hide when they see me.” He almost smiles. Then he walks home, whistling a tune he does not know he is whistling.

> Pieter klappt sein Buch zu. „Danke. Die meisten verstecken sich, wenn sie mich sehen.“ Er lächelt fast. Dann geht er heim und pfeift eine Melodie, von der er nicht weiss, dass er sie pfeift.

## c3_k_pieter · bark
*When:* `lord_paid>=1 + chance:0.12`

Far down the road, a lantern waves at you. Pieter. You wave back.

> Weit unten auf der Strasse winkt eine Laterne dir zu. Pieter. Du winkst zurück.

## c3_letter · beat · Stay if you must
*When:* `chapter:3`

Another letter comes from the river barge. Your mother writes: “Stay if you must. Your cousin asks after you.” You read the last line again. To you it sounds like a warning.

> Wieder kommt ein Brief vom Flusskahn. Deine Mutter schreibt: „Bleib, wenn du musst. Deine Cousine fragt nach dir.“ Du liest die letzte Zeile noch einmal. Für dich klingt sie wie eine Warnung.

## c3_miller · bark · The miller on the bridge
*When:* `chapter:3 + chance:0.1`

On the bridge, the miller glares down at the stream. It is still very low. He glares at you, too, just in case.

> Auf der Brücke starrt der Müller böse auf den Bach hinunter. Er ist immer noch sehr niedrig. Dich starrt er auch an, nur für alle Fälle.

## c3_forge · beat · Clang
*When:* `done:forge`

Old Odinson lights the forge and young Bo works the bellows. They show you how to hold the tongs. “Good hands,” says Odinson, which is the most he has said all day. Bo grins at the fire.

> Der alte Odinson zündet die Esse an, und der junge Bo bedient den Blasebalg. Sie zeigen dir, wie man die Zange hält. „Gute Hände“, sagt Odinson, und das ist das Meiste, was er heute gesagt hat. Bo grinst ins Feuer.

## c3_bell · beat · A very small bell
*When:* `done:ruins_windmill`

Page 1. In the old mill, on a rusty nail, hangs a bell. It is far too small for a cow. It is far too small for anything. It sways, just a little, though there is no wind.

> In der alten Mühle hängt an einem rostigen Nagel ein Glöckchen. Es ist viel zu klein für eine Kuh. Es ist viel zu klein für alles. Es schwingt ein wenig, obwohl kein Wind geht.

Page 2. In the dust beneath it you think you see tiny footprints. You look the other way. You are quite sure that you looked the other way.

> Im Staub darunter glaubst du winzige Fussabdrücke zu sehen. Du schaust weg. Du bist ziemlich sicher, dass du weggeschaut hast.

## c3_stream · moment · The stream runs again
*When:* `done:pond`

The stream runs clear again. On the bridge the miller looks down at the water. Then at you. He nods once, a very small nod. That is his whole apology, and you take it.

> Der Bach fliesst wieder klar. Auf der Brücke schaut der Müller auf das Wasser hinunter. Dann zu dir. Er nickt einmal, ein ganz kleines Nicken. Das ist seine ganze Entschuldigung, und du nimmst sie an.

## c3_dance · moment · The harvest dance
*When:* `done:sq_harvest_dance`

You work the cider while the village dances. Mugs float above the heads. One falls, you catch it, and you laugh out loud. Somewhere close by, something goes tink, like a very small bell. You do not look.

> Du schenkst den Most aus, während das Dorf tanzt. Becher schweben über den Köpfen. Einer fällt, du fängst ihn und lachst laut auf. Ganz in der Nähe macht etwas „tink“, wie ein ganz kleines Glöckchen. Du schaust nicht hin.

## c3_goat · beat · The goat comes home
*When:* `done:pet_goat`

Page 1. A goat trots up the path and straight into the brambles nobody could clear. Crunch. Munch. She eats thistles as if they were sweets. You open your mouth to stop her. Then you let her.

> Eine Ziege trabt den Pfad herauf, geradewegs in die Brombeeren, die niemand roden konnte. Knirsch. Mampf. Sie frisst Disteln, als wären es Bonbons. Du öffnest den Mund, um sie aufzuhalten. Dann lässt du sie.

Page 2. The third line of the old rhyme comes back, and you say it with your mouth still open: “Brave goat clears the bramble bed.” The goat looks at your hat. Her eyes are thoughtful.

> Die dritte Zeile des alten Reims fällt dir wieder ein, und du sagst sie mit noch offenem Mund: „Mutige Ziege räumt das Dornenbett.“ Die Ziege schaut auf deinen Hut. Ihre Augen sind nachdenklich.

## c3_goat_out · beat · A scarecrow in your hat
*When:* `seen:c3_goat`

In the morning the scarecrow is wearing your hat. Nobody saw who put it there. Under the hat there is a letter: “Your cousin may come to visit.” You take your hat back. It is still warm.

> Am Morgen trägt die Vogelscheuche deinen Hut. Niemand hat gesehen, wer ihn ihr aufgesetzt hat. Unter dem Hut liegt ein Brief: „Deine Cousine kommt vielleicht zu Besuch.“ Du nimmst deinen Hut zurück. Er ist noch warm.

## c3_frame3 · frame · Back in the room
*When:* `seen:c3_goat_out`

“Were you scared of the cousin?” asks somebody from under a blanket. “More than of any imp,” you say. “What's an imp?” “Shh!” say three children at once. “That comes later!”

> „Hattest du Angst vor der Cousine?“, fragt jemand unter einer Decke. „Mehr als vor jedem Kobold“, sagst du. „Was ist ein Kobold?“ „Psst!“, machen drei Kinder gleichzeitig. „Das kommt später!“
