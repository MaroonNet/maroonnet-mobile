# maroonnet-mobile

**MaroonNet Field** — the iOS field application of MaroonNet, an offline, mesh-networked
search-and-rescue command post built on Meshtastic LoRa radios. University of Colorado Denver
senior capstone, Fall 2026 – Spring 2027.

> **Student prototype.** MaroonNet is not certified for life-safety use. Do not rely on it as a
> primary means of locating people.

## What is here

A new SwiftUI app, written from an empty Xcode project. A team member's iPhone pairs over
Bluetooth to a Meshtastic radio; the app connects to that radio, shows the team's positions on
a map, receives messages and information from the commander over the mesh, and keeps a
timestamped log in a shape the MaroonNet mission database can use.

| Path | What it holds | Who to ask |
|---|---|---|
| `MaroonNetField/` | The Xcode project and the app's own code | Diego Alas |
| `MeshtasticProtobufs/` | The Meshtastic message definitions, copied from the reference (arrives with the radio work) | Diego Alas |

The app is **not** a fork of the Meshtastic app. Meshtastic-Apple v2.7.21 is a read-only
reference kept outside this repository; only its radio transport and protobuf package are
copied, file by file, and keep their GPL-3.0 headers. The verbatim copy that lived here before
the 2026-10-29 fresh start is preserved at tag `meshtastic-v2.7.21-base`.

The main MaroonNet repository (command post, databases, modeling) is
[MaroonNet/MaroonNet](https://github.com/MaroonNet/MaroonNet). The repository holds code;
design documents and notes live with their authors and are shared in the team's Discord.
Claude Code reads `CLAUDE.md` for the rules it follows here.

## Working on the repository

1. Branch from an up-to-date `main`. Nobody pushes to `main`.
2. Commit your own work, signed. Claude may draft and explain; a teammate commits.
3. Open a pull request with two or three sentences on what changed. Two teammates approve.
   Squash-merge.

Before your first commit, set up signing once (the ruleset requires signed commits, and GitHub
must be able to tie the commit email to your account):

```bash
git config --global user.name  "Your Name"
git config --global user.email "<your GitHub noreply address, or an email verified on GitHub>"
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub     # ssh-keygen -t ed25519 if you have no key
git config --global commit.gpgsign true
gh ssh-key add ~/.ssh/id_ed25519.pub --type signing --title "<machine> signing"
```

(Or GitHub → Settings → SSH and GPG keys → New SSH key → Key type **Signing Key**.)

Building needs Xcode, an Apple Account on the MaroonNet team (ask Corey Greene for an
invitation) and an iPhone; Bluetooth does not work in the Simulator.

## License

GPL-3.0. See `LICENSE`. Code copied from Meshtastic-Apple is GPL-3.0 and keeps its copyright
notices; the same license keeps MaroonNet compatible with the Meshtastic firmware and libraries.

## Team

Diego Alas, Corey Greene, Elijah Heimsoth and Joshua "JJ" Wagner, advised by Professor David
Ogle, University of Colorado Denver.
