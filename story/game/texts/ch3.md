# Chapter 3: Smallholding — story pieces (English, then German)

Phase 8 (13 Oct 2026). Source of `godot-prototype/data/farm/story/20-chapter-3.json` and the German in `data/i18n/data-de.json`. Second person, `{player}` for the name, German with „ss“. Chapter 3 pieces were compressed from the novella on 14 Nov 2026 (`story/08`): rewritten here are c3_letter, c3_forge, c3_bell, c3_stream, c3_pieter_paid, c3_goat_out. Triggers are game conditions (`lord_shares>=n`: the Lord's share has fallen due n times, `lord_paid>=n`: n bronze have been paid).

## c3_pieter · visit · The night watchman
*When:* `lord_shares>=1`

Page 1. A lantern swings up the road in the daylight. Under it walks Pieter, the night watchman. He does not look happy.

> Eine Laterne schwankt mitten am Tag die Strasse herauf. Darunter geht Pieter, der Nachtwächter. Er sieht nicht froh aus.

Page 2. “I am sorry, {player}. The Lord wants his share. It is not my idea. I only carry the book.” He shows you a number. “Pay when you can. I will wait at the gate.”

> „Es tut mir leid, {player}. Der Herr will seinen Anteil. Das ist nicht meine Idee. Ich trage nur das Buch.“ Er zeigt dir eine Zahl. „Zahl, wenn du kannst. Ich warte am Tor.“

## c3_pieter_paid · moment · Pieter
*When:* `lord_paid>=1`

Page 1. You bring a big pot to the Hall: leeks and beans and your own bread. The soup in the Pot goes thick, and the whole village goes quiet, tasting. At your gate, when Pieter comes, there is a stool you made yourself. Three legs. It wobbles only slightly.

> Du bringst einen grossen Topf in die Halle: Lauch und Bohnen und dein eigenes Brot. Die Suppe im Dorftopf wird dick, und das ganze Dorf wird still und schmeckt. An deinem Tor steht, als Pieter kommt, ein Hocker, den du selbst gebaut hast. Drei Beine. Er wackelt nur ein bisschen.

Page 2. “Sit,” you say. “After you,” says Pieter. “It's for you.” “I couldn't sit while you're standing.” Then the bunny hops up onto the stool and sits in the middle, ears flat. So you both eat on the ground, with the bunny above you on her throne.

> „Setz dich“, sagst du. „Nach dir“, sagt Pieter. „Er ist für dich.“ „Ich könnte nicht sitzen, während du stehst.“ Da hüpft das Häschen auf den Hocker und setzt sich in die Mitte, die Ohren flach. Also esst ihr beide auf dem Boden, und das Häschen thront über euch.

Page 3. Sitting down, Pieter looks much older. He eats every drop. Then he taps his book shut. “Thank you. Most people hide when they see me coming.” He almost smiles. Then he walks home, whistling a tune he does not know he is whistling.

> Im Sitzen sieht Pieter viel älter aus. Er isst jeden Tropfen. Dann klappt er sein Buch zu. „Danke. Die meisten verstecken sich, wenn sie mich kommen sehen.“ Er lächelt fast. Dann geht er heim und pfeift eine Melodie, von der er nicht weiss, dass er sie pfeift.

## c3_k_pieter · bark
*When:* `lord_paid>=1 + chance:0.12`

Far down the road, a lantern waves at you. Pieter. You wave back.

> Weit unten auf der Strasse winkt eine Laterne dir zu. Pieter. Du winkst zurück.

## c3_letter · beat · Stay if you must
*When:* `chapter:3`

Page 1. Another letter comes from the river barge. Your mother writes: “Stay if you must. Your cousin asks after you.” You read the last line again.

> Wieder kommt ein Brief vom Flusskahn. Deine Mutter schreibt: „Bleib, wenn du musst. Deine Cousine fragt nach dir.“ Du liest die letzte Zeile noch einmal.

Page 2. Your cousin. Liv. Four years older, thin and sharp, always watching, with eyes that missed nothing, ever. Liv was always in the loft, looking out of the little window. To anyone else it would sound like a kind line. To you it sounds like a warning.

> Deine Cousine. Liv. Vier Jahre älter, dünn und scharf, immer beobachtend, mit Augen, die nie etwas übersahen. Liv sass immer oben auf dem Dachboden und schaute aus dem kleinen Fenster. Für jeden anderen wäre das ein freundlicher Satz. Für dich klingt er wie eine Warnung.

## c3_miller · bark · The miller on the bridge
*When:* `chapter:3 + chance:0.1`

On the bridge, the miller glares down at the stream. It is still very low. He glares at you, too, just in case.

> Auf der Brücke starrt der Müller böse auf den Bach hinunter. Er ist immer noch sehr niedrig. Dich starrt er auch an, nur für alle Fälle.

## c3_forge · beat · Clang
*When:* `done:forge`

Page 1. Old Odinson lights the forge and young Bo works the bellows. They show you how to hold the tongs. “Good hands,” says Odinson, which is the most he has said all day. Bo grins at the fire.

> Der alte Odinson zündet die Esse an, und der junge Bo bedient den Blasebalg. Sie zeigen dir, wie man die Zange hält. „Gute Hände“, sagt Odinson, und das ist das Meiste, was er heute gesagt hat. Bo grinst ins Feuer.

Page 2. When Odinson is out of earshot, Bo says, “I carried a bucket that night, in the line. I was little.” He hammers a nail. “Somebody gave me theirs. Bigger than mine. It was empty.” He looks at you, then at the nail. “Yeah.”

> Als Odinson ausser Hörweite ist, sagt Bo: „Ich habe in jener Nacht einen Eimer getragen, in der Kette. Ich war klein.“ Er hämmert einen Nagel. „Jemand hat mir den eigenen Eimer gegeben. Grösser als meiner. Er war leer.“ Er schaut dich an, dann den Nagel. „Ja.“

## c3_bell · beat · A very small bell
*When:* `done:ruins_windmill`

Page 1. In the old mill, on a rusty nail, hangs a bell. It is far too small for a cow. It is far too small for anything. It sways, just a little, though there is no wind.

> In der alten Mühle hängt an einem rostigen Nagel ein Glöckchen. Es ist viel zu klein für eine Kuh. Es ist viel zu klein für alles. Es schwingt ein wenig, obwohl kein Wind geht.

Page 2. In the dust beneath it you think you see tiny footprints. You look the other way. You are quite sure that you looked the other way.

> Im Staub darunter glaubst du winzige Fussabdrücke zu sehen. Du schaust weg. Du bist ziemlich sicher, dass du weggeschaut hast.

Page 3. On the plaster is a charcoal drawing: a child with a bucket nearly as big as the child, holding hands with something the size of a thumb. You do not remember drawing it. You find you are humming, and you go out very fast.

> Auf dem Verputz ist eine Kohlezeichnung: ein Kind mit einem Eimer, fast so gross wie das Kind selbst, hält Händchen mit etwas, das so klein ist wie ein Daumen. Du erinnerst dich nicht, sie gemalt zu haben. Du merkst, dass du summst, und gehst ganz schnell hinaus.

## c3_stream · moment · The stream runs again
*When:* `done:pond`

Page 1. The stream runs clear again, all the way down to Hazelwood. On the bridge by his mill the miller looks down. The water is high and quick and brown, and his old wheel is going round, creaking and splashing. He looks at you. He nods once, a very small nod. That is his whole apology, and you take it.

> Der Bach fliesst wieder klar, den ganzen Weg bis nach Hazelwood. Auf der Brücke bei seiner Mühle schaut der Müller hinunter. Das Wasser ist hoch und schnell und braun, und sein altes Mühlrad dreht sich, knarrend und platschend. Er schaut dich an. Er nickt einmal, ein ganz kleines Nicken. Das ist seine ganze Entschuldigung, und du nimmst sie an.

Page 2. “Thank you,” says the miller, fast, glaring hard at the stream. “Now I owe the Hurst a penny a sack again.” You laugh out loud on the bridge. Then you stop. A penny a sack. Every good thing you do down here, the Lord takes a piece of.

> „Danke“, sagt der Müller, schnell, und starrt grimmig auf den Bach. „Jetzt schulde ich dem Hurst wieder einen Penny pro Sack.“ Du lachst laut auf der Brücke. Dann hörst du auf. Ein Penny pro Sack. Von allem Guten, das du hier unten tust, nimmt der Gutsherr ein Stück.

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

Page 1. In the morning the scarecrow is wearing your green hat, high up, out of reach of goats, at a very jaunty angle. Nobody saw who put it there.

> Am Morgen trägt die Vogelscheuche deinen grünen Hut, ganz oben, ausser Reichweite von Ziegen, keck schräg. Niemand hat gesehen, wer ihn ihr aufgesetzt hat.

Page 2. Tucked into the band is a letter from Mei. “Your cousin asked me three times whether she might come up to your gate. I told her to ask you herself. She said she was asking.” You take your hat back. It is still warm.

> Im Hutband steckt ein Brief von Mei. „Deine Cousine hat mich dreimal gefragt, ob sie zu deinem Tor hinaufkommen darf. Ich habe gesagt, sie soll dich selbst fragen. Sie sagte, das tue sie gerade.“ Du nimmst deinen Hut zurück. Er ist noch warm.

## c3_frame3 · frame · Back in the room
*When:* `seen:c3_goat_out`

“Were you scared of the cousin?” asks somebody from under a blanket. “More than of any imp,” you say. “What's an imp?” “Shh!” say three children at once. “That comes later!”

> „Hattest du Angst vor der Cousine?“, fragt jemand unter einer Decke. „Mehr als vor jedem Kobold“, sagst du. „Was ist ein Kobold?“ „Psst!“, machen drei Kinder gleichzeitig. „Das kommt später!“

## c3_k_count_sheep · bark
*When:* `animals:animal_sheep>=3 + chance:0.2` · added 3 Nov 2026 (`story/12`) 💡

You try to count the sheep. They keep swapping places. You get three, then five, then you nearly fall asleep.

> Du versuchst, die Schafe zu zählen. Sie tauschen dauernd die Plätze. Du kommst auf drei, dann auf fünf, und dann schläfst du fast ein.
