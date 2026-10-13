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
