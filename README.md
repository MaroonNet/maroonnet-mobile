# maroonnet-mobile

**MaroonNet Field** — the iOS field application of MaroonNet, an offline, mesh-networked
search-and-rescue command post built on Meshtastic LoRa radios. University of Colorado Denver
senior capstone, Fall 2026 – Spring 2027.

> **Student prototype.** MaroonNet is not certified for life-safety use. Do not rely on it as a
> primary means of locating people.

## What is here

A fork of the Meshtastic iOS app, Meshtastic-Apple **v2.7.21**, which MaroonNet builds on. A team
member's iPhone pairs over Bluetooth to a Meshtastic radio; the app connects to that radio, shows
the team's positions on a map, receives messages and search assignments from the commander over
the mesh, and keeps a timestamped log in a shape the MaroonNet mission database can use.

The team agreed to the fork in November 2026 on the advisor's advice, replacing the 2026-10-29
fresh-start plan. MaroonNet's features are added on top of the Meshtastic app first; features
MaroonNet does not need are trimmed later, one pull request at a time. The unmodified v2.7.21
code is preserved at tag `meshtastic-v2.7.21-base`. The team does not track upstream Meshtastic.

| Path | What it holds | Who to ask |
|---|---|---|
| `Meshtastic/` | The app's code: Meshtastic's, plus MaroonNet's additions | Diego Alas |
| `MeshtasticTests/` | Unit tests | Diego Alas |
| `MeshtasticProtobufs/` | The Meshtastic message definitions as a Swift package | Diego Alas |
| `protobufs/` | Git submodule with Meshtastic's raw `.proto` files | Diego Alas |
| `project.yml` | XcodeGen spec; `Meshtastic.xcodeproj` is generated from it | Diego Alas |

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

## Building

1. After cloning, fetch the submodule once: `git submodule update --init`.
2. Open `Meshtastic.xcworkspace` in Xcode (not the `.xcodeproj`) and let the Swift packages
   resolve; that needs internet.
3. To change targets or build settings, edit `project.yml` and regenerate with the XcodeGen
   version pinned in `.xcodegen-version` (see `CONTRIBUTING.md`). Do not edit the project in
   Xcode's settings screens; regenerating overwrites those changes.

Building needs Xcode and an iPhone; Bluetooth does not work in the Simulator. Ask Diego how to
sign a test build for your own iPhone.

## License

GPL-3.0. See `LICENSE`. The app is a fork of Meshtastic-Apple, which is GPL-3.0, and keeps its
copyright notices; the same license keeps MaroonNet compatible with the Meshtastic firmware and
libraries.

## Team

Diego Alas, Corey Greene, Elijah Heimsoth and Joshua "JJ" Wagner, advised by Professor David
Ogle, University of Colorado Denver.
