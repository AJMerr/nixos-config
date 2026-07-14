{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # ⚠️ v4 -> v5 FLAG: your dotfiles are from Noctalia v4 (JSON settings,
  # `qs -c noctalia-shell` launch). This repo pins v5 from Noctalia's flake
  # per your original spec (homeModules.default). Three consequences:
  #   1. Launch command changed: `noctalia` (wired in
  #      modules/home/hyprland/lua/autostart.lua).
  #   2. settings.nix keys are translated 1:1 from your v4 JSON — see the
  #      schema flag at the top of that file.
  #   3. v5 is beta + not in nixpkgs: first build compiles from source, or
  #      use their Cachix cache (requires dropping the nixpkgs follows in
  #      flake.nix). If you'd rather stay on nixpkgs-cached v4 for now,
  #      that's `pkgs.noctalia-shell` + a pinned older flake rev for the
  #      module — say the word and I'll cut that variant.
  programs.noctalia = {
    enable = true;
    # Launched via the Hyprland hyprland.start hook, not a user service —
    # per Noctalia's compositor docs, and it keeps launch ordering inside
    # the compositor lifecycle.
    systemd.enable = false;

    settings = import ./settings.nix { inherit config; };
  };

  # ESCAPE HATCH (flagged as requested): your custom palette (the m* color
  # JSON) has no exposed option on the programs.noctalia module, so it's
  # the one thing here managed as a raw file link. Note: if this file is
  # actually derived state that Noctalia regenerates from
  # colorSchemes.predefinedScheme = "Noctalia (legacy)", the link is
  # harmless but redundant — delete it if Noctalia fights the read-only
  # symlink on scheme changes.
  xdg.configFile."noctalia/colors.json".source = ./colors.json;
}
