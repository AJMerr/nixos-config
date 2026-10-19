{ config, lib, pkgs, ... }:

{
  # Hyprland >= 0.55, configured in hand-written Lua (./lua/*.lua).
  # Do not use HM's `settings` option: its generated per-section calls
  # (hl.general{...}, etc.) don't exist in Hyprland's Lua API, which only has
  # hl.config({...}). Validate with `hyprland --verify-config`.
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false; # UWSM manages the systemd session (modules/nixos/desktop.nix)
    configType = "lua";

    extraLuaFiles = {
      "config" = {
        autoLoad = true;
        content = builtins.readFile ./lua/config.lua;
      };
      "autostart" = {
        autoLoad = true;
        content = builtins.readFile ./lua/autostart.lua;
      };
      "binds" = {
        autoLoad = true;
        content = builtins.readFile ./lua/binds.lua;
      };
      "animations" = {
        autoLoad = true;
        content = builtins.readFile ./lua/animations.lua;
      };
      "rules" = {
        autoLoad = true;
        content = builtins.readFile ./lua/rules.lua;
      };
    };
  };

  # Tools the keybinds and Noctalia widgets shell out to.
  home.packages = with pkgs; [
    kdePackages.dolphin          # SUPER+E file manager
    kdePackages.kio
    kdePackages.kio-extras
    udiskie          # automounts removable drives
    wofi
    grim             # screenshot (SUPER+SHIFT+S)
    slurp            # region select
    wl-clipboard     # clipboard; also used by Noctalia
    playerctl        # XF86 media keys
    brightnessctl    # XF86 brightness keys
    pwvucontrol      # Noctalia volume widget
  ];
}
