{ config, lib, pkgs, ... }:

{
  # Obsidian — no HM `programs.obsidian` module exists, so this is just the
  # package on PATH. Unfree (Obsidian End User Agreement); allowUnfree is set
  # in modules/nixos/default.nix.
  home.packages = with pkgs; [
    obsidian
  ];
}
