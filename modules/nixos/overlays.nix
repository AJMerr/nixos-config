# Package overlays.
#
# claude-code — pinned to its own nixpkgs input (`nixpkgs-claude`) instead of
# the system nixpkgs. The CLI ships a release most days, and the nix-packaged
# build has its own auto-updater disabled, so the only way to change versions
# here is to move a flake input. Giving it a separate input means
#
#     nix flake update nixpkgs-claude
#
# bumps the CLI by itself, without dragging the rest of the system — notably
# the version-sensitive Hyprland Lua config and the Noctalia v5 pin — forward
# just to get a newer Claude Code.
#
# Done as an overlay rather than referencing the input's package directly in
# modules/home/cli so that `pkgs.claude-code` stays the single call site. Note
# the explicit allowUnfree: this is a *second* nixpkgs instance with a fresh
# config, so the `nixpkgs.config.allowUnfree` in default.nix does not reach it,
# and claude-code is unfree.
{ inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      claude-code = (import inputs.nixpkgs-claude {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      }).claude-code;
    })
  ];
}
