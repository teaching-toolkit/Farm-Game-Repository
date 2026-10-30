# Glossary map

The project has two areas with their own words and decisions.

## Contexts

- [Game](./GLOSSARY.md): the farm game's rules, systems and code (`godot-prototype/`, `docs/design/`); decisions in `docs/adr/`.
- [Story](./story/GLOSSARY.md): the story told through the game, its canon, outline, novella and pieces (`story/`); decisions in `story/docs/adr/`.

## Relationships

- **Story → Game**: the story reaches the game as pieces (data in the game) and as data wishes. Until a data wish is built, the
  game data wins ([ADR-0014](docs/adr/0014-data-wins-until-a-data-wish-is-built.md)).
- **Shared words**: *chapter* means the same in both. A Helper in the story is a pet in the game. The game's *chore*, *goal* and
  *Time Quiz* are the triggers that story pieces wait on.
- **Decisions touching both** go in the root `docs/adr/`.
