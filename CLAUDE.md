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

A new SwiftUI iOS app, written by the team from an empty Xcode project (2026-10-29 decision).
It is **not** a fork of Meshtastic-Apple. Meshtastic-Apple v2.7.21 (GPL-3.0) is a read-only
reference that lives outside this repository, in each teammate's `~/workspace/reference/`
clone; only the radio transport layer and the protobuf package are copied from it, file by file,
when a step calls for it. Everything else is MaroonNet's own code.

- App: `MaroonNetField` Xcode project at the repository root; display name "MaroonNet Field";
  bundle ID `org.maroonnet.field`; built on Corey Greene's Apple Developer team.
- The verbatim v2.7.21 copy that was here before the fresh start is kept at tag
  `meshtastic-v2.7.21-base`. Nothing is taken from it; the reference clone is the source.
- The team does not track upstream Meshtastic. An upstream change comes in only as a deliberate
  copy in its own pull request, named for what it adds.

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

- GPL-3.0 stays. Every file copied from the reference keeps its copyright header, with one
  comment line added under it: `// Copied from Meshtastic-Apple v2.7.21 (GPL-3.0): <original path>`.
  Code the team writes carries no Meshtastic header.
- Copy only what a step asks for. Do not copy folders "while you are there"; the Meshtastic UI,
  data model, MQTT, TAK, firmware-update, CarPlay, Siri, widget, watch, TV and localization code
  stay out.
- Nobody edits the reference clone, and Claude never copies files into the repository itself.
- The Xcode project file is hand-managed by Xcode (no XcodeGen, no `project.yml`). Open
  `MaroonNetField/MaroonNetField.xcodeproj`.
- Bluetooth does not work in the Simulator; radio work is tested on a phone.
- Teammates new to git or iOS get one step at a time; verify each step before the next.

## Git workflow (enforced by the ruleset on `main`)

- Nobody pushes to `main`. Branch, open a pull request, two of the other three teammates
  approve, squash-merge. Commits are signed with the author's own registered key.
- A pull request description is two or three plain sentences from its author.
