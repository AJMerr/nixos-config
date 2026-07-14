# nixos-config

NixOS + Home Manager monorepo for `legion-tower-5`.
Layout modeled on Misterio77/nix-starter-configs (standard) — hosts and
users are thin entrypoints; everything real lives in `modules/`.

```
.
├── flake.nix                      # inputs (nixos-unstable, HM, noctalia) + host wiring
├── hosts/
│   └── legion-tower-5/
│       ├── default.nix             # hostname, user, stateVersion, module imports
│       └── hardware-configuration.nix  # PLACEHOLDER — replace with generated
├── home/
│   └── austin/
│       └── default.nix             # user identity only; imports modules/home
└── modules/
    ├── nixos/                      # system-level, one file per feature
    │   ├── default.nix             # aggregator + allowUnfree + flakes
    │   ├── boot.nix                # systemd-boot (+ BIOS manual steps)
    │   ├── networking.nix          # NetworkManager + firmware
    │   ├── audio.nix               # PipeWire/pipewire-pulse/WirePlumber
    │   ├── nvidia.nix              # RTX 5070: open modules, modesetting
    │   └── desktop.nix             # programs.hyprland (system half), SDDM, portals
    └── home/                       # user-level, one directory per feature
        ├── default.nix
        ├── hyprland/
        │   ├── default.nix         # HM module wiring: configType, extraLuaFiles, packages
        │   ├── settings.nix        # data-shaped config (was your hl.config blocks)
        │   └── lua/                # real .lua files, readFile'd into extraLuaFiles
        │       ├── autostart.lua   # hyprland.start hook (terminal + noctalia)
        │       ├── binds.lua       # all your keybinds, verbatim (incl. workspace loop)
        │       ├── animations.lua  # your curves + per-leaf animation calls, verbatim
        │       └── rules.lua       # your window rules + device config, verbatim
        └── noctalia/
            ├── default.nix         # programs.noctalia wiring + v4→v5 flags
            ├── settings.nix        # machine-converted from your settings.json
            └── colors.json         # your palette — raw-file escape hatch (see below)
```

Adding a feature = new file/dir under `modules/{nixos,home}` + one import
line in the corresponding `default.nix`. Adding a host = new
`hosts/<name>/` + one entry in `flake.nix`. Nothing accretes into
entrypoint files.

## Deliberate deviations from your dotfiles (each flagged in-file)

| What | Where | Why |
|---|---|---|
| `qs -c noctalia-shell` → `noctalia` | `hyprland/lua/autostart.lua` | v4 → v5 binary rename; repo pins v5 per your spec |
| `/home/ajmerr/...` → `${config.home.homeDirectory}/...` | `noctalia/settings.nix` (avatar, wallpaper dir) | username is `austin` on this machine |
| `0xee1a1a1a` → `3994688026` | `hyprland/settings.nix` shadow color | Nix has no hex literals; identical value |
| `colors.json` via `xdg.configFile` | `noctalia/default.nix` | no `programs.noctalia` option for it — the one raw-file escape hatch |

Left alone but worth a look: `appLauncher.terminalCommand = "xterm -e"`
(xterm isn't installed by this config — probably want `ghostty -e`).

## Noctalia flags

- **v5 is beta and not in nixpkgs.** First build compiles from source, or
  use their Cachix cache — which requires deleting
  `inputs.nixpkgs.follows` from the noctalia input in `flake.nix`
  (following changes the hash → cache miss).
- **Your settings are v4-schema.** Converted 1:1; v5 may have
  renamed/moved keys, and a Nix-managed file can't be migrated in place by
  Noctalia's settings migrator. Diff against
  https://docs.noctalia.dev/v5/configuration/ on first launch.
  `programs.noctalia.settings` also accepts a plain file path — useful for
  bisecting module problems vs. schema problems.
- Prefer nixpkgs-cached v4 instead? That's `pkgs.noctalia-shell` + pinning
  an older noctalia flake rev for its module — a small diff, ask for it.

## Version-sensitive checks before first build

| Check | Why | How |
|---|---|---|
| Hyprland ≥ 0.55 | `configType = "lua"` | `nix eval nixpkgs#hyprland.version` |
| Home Manager 26.05+ | when HM Lua support landed | HM input is unpinned-latest; fine unless you pin back |
| NVIDIA driver ≥ 580 | Blackwell minimum | `nix eval nixpkgs#linuxPackages.nvidiaPackages.stable.version` |
| home-manager#9468 | settings→lua generator bugs (list `env`, nested tables) | `hyprland --verify-config` after build; relocate broken options into `lua/` files |

## Manual steps outside this repo

**BIOS:** Secure Boot OFF (systemd-boot unsigned) · UEFI mode, no CSM ·
Above 4G Decoding ON · Resizable BAR ON · USB boot for installer.

**Install:** partition (GPT; FAT32 ESP ~512M–1G at `/boot`; root ext4/btrfs;
decide swap/zram) → mount → `nixos-generate-config --root /mnt` → replace
`hosts/legion-tower-5/hardware-configuration.nix` with the generated file →
`nixos-install --flake .#legion-tower-5` → password, reboot.

## First-boot verification

- [ ] `nmcli device wifi list` + connect
- [ ] `pactl info` → `PulseAudio (on PipeWire …)`
- [ ] `wpctl status` shows sinks/sources
- [ ] `nvidia-smi` reports the 5070
- [ ] `echo $XDG_SESSION_TYPE` → `wayland`; `hyprctl monitors` returns display
- [ ] `hyprland --verify-config` clean (the #9468 check)
- [ ] Ghostty + Noctalia bar appear on session start (autostart hook fired)
- [ ] Binds spot-check: SUPER+R (wofi), SUPER+E (dolphin), SUPER+SHIFT+S (screenshot), SUPER+S (scratchpad)
