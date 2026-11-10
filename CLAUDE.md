# maroonnet-mobile — instructions for Claude

This repository holds **MaroonNet Field**, the field application of MaroonNet, the University of
Colorado Denver senior capstone (Fall 2026 – Spring 2027): an offline-first search-and-rescue
mission planning and coordination system that moves data between the mission Command Post and
members in the field over mesh-networked Meshtastic LoRa radios.

- Team: Diego Alas, Corey Greene, Elijah Heimsoth, Joshua "JJ" Wagner.
- Advisor: Prof. David Ogle.
- Who to ask about this repository: Diego.

Student prototype; not certified for life-safety use.

## What this repository is

A fork of Meshtastic-Apple **v2.7.21** (GPL-3.0), restored from tag `meshtastic-v2.7.21-base`.
The team agreed to this in November 2026 on the advisor's advice; it replaces the 2026-10-29
fresh-start plan. The plan: keep the Meshtastic app working, add what MaroonNet needs on top of
it, and trim unneeded features only after MaroonNet's own features work.

- App: display name "MaroonNet Field"; bundle ID `org.maroonnet.field`; built on Corey Greene's
  Apple Developer team; iPhone only; minimum iOS 17.5. Radios are assumed to run Meshtastic
  firmware 2.7.x.
- A read-only clone of upstream v2.7.21 lives outside this repository, in each teammate's
  `~/workspace/reference/`, for comparing against the original. Nobody edits it.
- The team does not track upstream Meshtastic. An upstream change comes in only as a deliberate
  cherry-pick in its own pull request, named for what it adds.

## Rules

1. **The team writes the code.** Claude explains, reviews, compares options and drafts when
   asked. A draft is a draft until a teammate has read it, understood it and committed it
   under their own name.
2. **Claude never performs repo altering git commands.** Do not run: `add`, `commit`, `push`,
   `rebase`, `merge`, `cherry-pick`, `reset`, `tag`, `stash` or `config`, and do not create,
   review or merge pull requests. When a teammate asks for help with git, print the exact
   commands and let them run the commands themselves. `git status`, `diff`, `log`, `show`,
   `fetch` and `pull` are fine. `.claude/settings.json` enforces this; do not work around it.
3. **Claude makes no decisions.** Give options and trade-offs; do not present a choice as
   settled. The team decides in its meetings and records its own decisions.
4. **The repository holds code.** Design documents, notes and research live with their
   authors and are shared in Discord. Teammates may add a document here themselves; Claude
   does not write or propose documentation, templates, roadmaps or placeholder files for the
   repository.
5. **Never commit secrets.** No API keys, `.env` files, radio channel keys (PSKs), or real
   position data of any person in the repository. The app may use them at runtime; they
   just never go in a commit.
6. **Keep responses concise and to the point.** Code and diffs over prose. Explanations should
   avoid being overly verbose, the user can always ask for further explanation. Absolutely NO
   emojis.

## Working in this code base

- GPL-3.0 stays. Keep `LICENSE` and the copyright notice at the top of every Meshtastic file
  that stays. Code the team writes carries no Meshtastic header.
- Add before you remove. Meshtastic features stay until MaroonNet's features work. Each later
  removal is its own pull request that says what was removed and why in two sentences.
- Out of scope for the capstone: the Watch, TV and Widgets targets; Mac Catalyst and iPad; the
  CarPlay, Siri, NFC, critical-alert, WeatherKit, associated-domain, communication-notification
  and custom-protocol entitlements. They are removed; do not extend them or add them back.
- MaroonNet's own code lives in `Meshtastic/MaroonNet/`. Where a Meshtastic file has to change,
  mark the change with a `// MaroonNet:` comment so it is easy to find and keep.
- Signing: the committed `Config/Signing.xcconfig` holds the team and bundle ID. Each developer
  signs local test builds with their own Personal Team in a git-ignored
  `Config/Signing.local.xcconfig`; never commit that file. Corey uploads TestFlight builds.
- `Meshtastic.xcodeproj` is generated from `project.yml` by XcodeGen (version pinned in
  `.xcodegen-version`; see `CONTRIBUTING.md`) and is committed. Change `project.yml`,
  regenerate, commit both; never hand-edit the project file. Open `Meshtastic.xcworkspace`.
- `protobufs/` is a git submodule (`git submodule update --init` after a fresh clone).
- This is the only instruction file for AI assistants here; Meshtastic's own Claude, Copilot
  and spec-kit files were left out on purpose.
- Bluetooth does not work in the Simulator; radio work is tested on a phone.
- Teammates new to git or iOS get one step at a time; verify each step before the next.

## Git workflow (enforced by the ruleset on `main`)

- Nobody pushes to `main`. Branch, open a pull request, two of the other three teammates
  approve, squash-merge. Commits are signed with the author's own registered key.
- A pull request description is two or three plain sentences from its author.
