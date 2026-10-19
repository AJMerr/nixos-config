# General CLI tools, always on PATH.
{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    claude-code   # version pinned via `nixpkgs-claude`, see modules/nixos/overlays.nix
    spotatui
  ];
}
