{ config, lib, pkgs, ... }:

{
  # Runs as a background user service. Needs programs.dconf (modules/nixos/audio.nix).
  # Presets are created in the GUI and persist in ~/.config/easyeffects.
  services.easyeffects.enable = true;
}
