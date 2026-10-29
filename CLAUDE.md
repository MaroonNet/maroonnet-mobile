# maroonnet-mobile — instructions for Claude

This is the field application of MaroonNet, the University of Colorado Denver senior capstone
(Fall 2026 – Spring 2027): an offline, mesh-networked search-and-rescue command post built on
Meshtastic LoRa radios. Team: Diego Alas, Corey Greene, Elijah Heimsoth, Joshua "JJ" Wagner.
Advisor: Prof. David Ogle. Student prototype; not certified for life-safety use.

The code base is Meshtastic-Apple **v2.7.21** (GPL-3.0), copied in verbatim on 2026-10-27 and
being whittled down to what MaroonNet needs. Who to ask: Diego. The team does not track upstream;
an upstream change comes in only as a deliberate cherry-pick in its own pull request.

Claude Code loads this file for every teammate. It is the only instruction file in this
repository; Meshtastic's own Claude and Copilot files were removed on purpose.

## Rules

1. **The team writes the code.** Claude explains, reviews, compares options and drafts when
   asked. A draft is a draft until a teammate has read it, understood it and committed it
   under their own name.
2. **Claude never changes the repository.** Do not run `git add`, `commit`, `push`, `rebase`,
   `merge`, `cherry-pick`, `reset`, `tag`, `stash` or `config`, and do not create, review or
   merge pull requests. When a teammate asks for help with git, print the exact commands and
   let them run the commands themselves. `git status`, `diff`, `log`, `show`, `fetch` and
   `pull` are fine. `.claude/settings.json` enforces this; do not work around it.
3. **Claude makes no decisions.** Give options and trade-offs; do not present a choice as
   settled. The team decides in its meetings and records its own decisions.
4. **The repository holds code.** Design documents, notes and research live with their
   authors and are shared in Discord. Teammates may add a document here themselves; Claude
   does not write or propose documentation, templates, roadmaps or placeholder files.
5. **No secrets, ever.** No API keys, `.env` files, radio channel keys (PSKs), or real
   position data of any person.
6. **Keep answers short.** Code and diffs over prose. No emoji.

## Working in this code base

- GPL-3.0 stays: keep `LICENSE` and the copyright notice at the top of every file that stays.
- Trimming is the main work. Prefer removing a whole target, feature or folder in one pull
  request over scattered edits, and say what was removed and why in two sentences.
- `Meshtastic.xcodeproj` is generated from `project.yml` by XcodeGen (version pinned in
  `.xcodegen-version`) and is committed. Change `project.yml`, regenerate, commit both; never
  hand-edit the project file. Open `Meshtastic.xcworkspace`.
- `protobufs/` is a git submodule (`git submodule update --init` after a fresh clone).

## Git workflow (enforced by the ruleset on `main`)

- Nobody pushes to `main`. Branch, open a pull request, two of the other three teammates
  approve, squash-merge. Commits are signed with the author's own registered key.
- A pull request description is two or three plain sentences from its author.
