{ config, lib, pkgs, ... }:

{
  # -----------------------------------------------------------------------
  # Ghostty — native programs.ghostty HM module
  # -----------------------------------------------------------------------
  # `settings` here serializes to ~/.config/ghostty/config as plain
  # `key = value` lines — Ghostty's own config format. Repeated-key options
  # (keybind, font-feature, etc.) are written as Nix lists and emit one
  # line per element, same rule as the Hyprland module.
  programs.ghostty = {
    enable = true;

    # Shell integration wires in cursor shapes, prompt jumping, sudo
    # wrapping etc. Enable the one(s) matching your actual shell:
    enableBashIntegration = true;
    # enableZshIntegration = true;
    # enableFishIntegration = true;

    settings = {
      # --- placeholder values; replace with your actual ghostty config ---
      font-family = "DejaVu Sans Mono"; # matches your Noctalia fontFixed
      font-size = 11;

      # You run active_opacity 0.8 in Hyprland — if you ALSO set
      # background-opacity here they multiply and the terminal goes
      # muddier than you expect. Pick one layer to own transparency.
      # background-opacity = 0.9;

      window-decoration = false; # tiling WM; Hyprland draws the borders

      # keybind = [
      #   "ctrl+shift+t=new_tab"
      #   "ctrl+shift+enter=new_split:right"
      # ];
    };

    # If you have a custom theme file, the module also exposes `themes`:
    # themes.my-theme = { background = "1c1822"; foreground = "e9e4f0"; ... };
    # then: settings.theme = "my-theme";
  };
}