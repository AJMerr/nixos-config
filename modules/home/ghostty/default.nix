{ config, lib, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
      theme = "Catppuccin Mocha";

      # Hyprland already applies window opacity; setting it here too would multiply.
      # background-opacity = 0.9;

      window-decoration = false;
    };
  };
}
