# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A NixOS + Home Manager flake for a single machine (host `nixos`, user `ajmerr`).
Layout follows Misterio77/nix-starter-configs (standard): `hosts/` and `home/`
are thin identity-only entrypoints; all real configuration lives in `modules/`.
Target hardware is a Lenovo Legion tower with an RTX 5070 (Blackwell) on Wayland/Hyprland.

## Commands

There is no test suite or app to run — the "build" is realizing the system config.

```bash
nixos-rebuild build  --flake .#nixos   # evaluate + build, no activation (safe dry check)
nixos-rebuild switch  --flake .#nixos  # build + activate now (needs sudo)
nixos-rebuild test    --flake .#nixos  # activate without adding a boot entry
nix flake check                        # evaluate flake outputs
nix fmt                                # format (if a formatter is wired; otherwise nixpkgs-fmt/alejandra)
nix flake update                       # refresh flake.lock inputs

hyprland --verify-config               # validate generated Hyprland Lua after a rebuild (see #9468 note below)
```

The host attribute is `nixos` (`nixosConfigurations.nixos` in `flake.nix`), so
every `--flake .#nixos`. On a fresh install, `hosts/nixos/hardware-configuration.nix`
must be replaced with the output of `nixos-generate-config` before the first build.

## Architecture

Two parallel module trees, each with an aggregator `default.nix` that only imports:

- **`modules/nixos/`** — system scope. `default.nix` imports one file per feature
  (`boot`, `networking`, `audio`, `nvidia`, `desktop`, `fonts`) and sets `allowUnfree` +
  flakes. `hosts/nixos/default.nix` imports this tree and adds only machine-specific
  facts (hostname, user account, `stateVersion`, hardware config).
- **`modules/home/`** — user scope. `default.nix` imports one *directory* per feature
  (`hyprland`, `noctalia`, `ghostty`, `cli`, `neovim`). `home/ajmerr/default.nix`
  imports this tree and sets only identity (`username`, `homeDirectory`, `stateVersion`).

**Adding a feature** = new file/dir under the right tree + one import line in that
tree's `default.nix`. Nothing accumulates in the entrypoint files.

**System/user split for Hyprland is intentional and both halves are required:**
`modules/nixos/desktop.nix` provides `programs.hyprland.enable` (system closure,
session `.desktop`, portals, SDDM); `modules/home/hyprland/` provides the actual
user config. Removing either breaks the session.

### The Hyprland Lua config (the one non-obvious pattern)

`modules/home/hyprland/` uses `configType = "lua"`. **All** config is hand-written
`.lua` in `lua/*.lua`, pulled in via `builtins.readFile` into `extraLuaFiles` (so
edits still hash into the store path → trigger a rebuild, while staying
editor-highlightable and `hyprland --verify-config`-testable). Split by concern:
`config.lua` (data: `hl.monitor`/`hl.env`/`hl.config` blocks), `animations.lua`
(enable flag + curves + leaves), `binds.lua`, `rules.lua`, `autostart.lua`.

**Do NOT reintroduce HM's `settings` option.** On the pinned HM revision its
`settings`→lua generator emits per-section calls (`hl.general{...}`,
`hl.decoration{...}`, `hl.animations{...}`, …), but Hyprland 0.55's Lua API has
no such functions — the only config setter is `hl.config({...})`. The generated
calls hit a nil value and Hyprland aborts the whole config with a red
`attempt to call a nil value (field 'animations')` banner (animations is just
alphabetically first; every section fails the same way). Canonical `hl.config`
reference: `share/hypr/hyprland.lua` in the hyprland package. Editing config =
edit the relevant `lua/` file, keeping data as `hl.config({...})`.

### Noctalia (status bar/shell) — version-sensitive

Pinned to **v5** from Noctalia's own flake input (`inputs.noctalia.homeModules.default`),
not nixpkgs. Consequences to keep in mind when editing `modules/home/noctalia/`:

- v5 is beta and not in nixpkgs — the first build compiles from source. Using
  their Cachix cache requires dropping `inputs.nixpkgs.follows` on the noctalia
  input in `flake.nix` (following changes the hash → cache miss).
- `settings.nix` was translated 1:1 from v4-schema JSON; v5 may have renamed keys.
  A Nix-managed settings file can't be migrated in place by Noctalia's migrator —
  diff against https://docs.noctalia.dev/v5/configuration/ when touching it.
- `colors.json` is linked raw via `xdg.configFile` — the one escape hatch, because
  the palette has no `programs.noctalia` option.
- Launched from the Hyprland `hyprland.start` hook (`lua/autostart.lua`), not a
  systemd user service (`systemd.enable = false`).

### Neovim (LazyVim) — Mason is disabled, Nix provides the tools

`modules/home/neovim/` is a LazyVim setup. lazy.nvim still manages *plugins*
(pure Lua, cloned into `~/.local/share/nvim` at runtime — fine on NixOS), but
**Mason is force-disabled** in `nvim/lua/plugins/nix.lua`: Mason-installed
LSP/formatter/DAP binaries are dynamically linked against FHS paths that don't
exist here and crash. Every server, formatter, compiler and language toolchain
comes from Nix instead — the `home.packages` list in `default.nix` — and with
`mason-lspconfig` gone LazyVim starts each server straight from `$PATH`. **These
two are a matched pair:** add a `lazyvim.plugins.extras.lang.*` import in
`nvim/lua/config/lazy.lua` and you must add its server/formatter to
`home.packages`, or it silently won't start. HTML/CSS have no LazyVim extra —
they're wired by hand in `nvim/lua/plugins/lsp.lua`.

The config is symlinked in per-file (`init.lua` + the `lua/` tree), **not** as a
single `~/.config/nvim` symlink — deliberately, so the directory stays writable
for lazy.nvim's `lazy-lock.json`. Editing config = edit under `nvim/`, rebuild
(same edit-then-rebuild loop as the Hyprland Lua). A Nerd Font
(`modules/nixos/fonts.nix`) is required for the icons.

## Gotchas

- **README.md** documents the same host `nixos` / user `ajmerr` as the flake, plus
  the design rationale, version flags, and manual install/BIOS steps — worth reading
  before changing module structure.
- **Nix has no hex literals** — colors are decimal (e.g. Hyprland shadow color is
  `3994688026`, not `0xee1a1a1a`).
- **`stateVersion` (`26.05`)** is set once at install and never bumped on upgrades,
  in both `hosts/nixos/default.nix` and `home/ajmerr/default.nix`.
- Binds/widgets shell out to packages that were ambient on the old distro but must
  be declared here (`home.packages` in `modules/home/hyprland/default.nix`) or they
  silently no-op.
- **NVIDIA Blackwell (RTX 5070)** needs driver ≥ 580 and open kernel modules — see
  `modules/nixos/nvidia.nix`.

## In-file documentation

Every module carries a header comment explaining *why* it exists and flagging
version sensitivities and deliberate deviations from the source dotfiles. Read the
relevant module's comments before changing it — they capture decisions not visible
in the code itself.
