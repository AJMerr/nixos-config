{ config, lib, pkgs, ... }:

{
  # System-level half of the Hyprland split: installs Hyprland into the
  # system closure, generates the session .desktop file the display manager
  # reads, wires up polkit + portals. The user-level half (your actual
  # config: binds, rules, look-and-feel) is modules/home/hyprland. Both are
  # required; neither replaces the other.
  programs.hyprland.enable = true;

  xdg.portal.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
}
