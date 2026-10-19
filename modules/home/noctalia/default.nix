{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # Noctalia v5 is not in nixpkgs; the first build compiles from source. To use
  # their Cachix cache, drop `inputs.nixpkgs.follows` on the noctalia input.
  programs.noctalia = {
    enable = true;
    systemd.enable = false; # started from lua/autostart.lua

    settings = import ./settings.nix { inherit config; };
  };

  # The palette has no module option, so it is linked as a raw file.
  xdg.configFile."noctalia/colors.json".source = ./colors.json;
}
