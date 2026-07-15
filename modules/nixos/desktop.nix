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

  # The hyprland package ships TWO session files: "hyprland.desktop"
  # (Exec=start-hyprland) and "hyprland-uwsm.desktop" (Exec=uwsm start …).
  # Both appear in the greeter. The UWSM one is BROKEN here because we don't
  # set programs.hyprland.withUWSM, so UWSM's `wayland-session-bindpid@.service`
  # user unit isn't installed — `systemctl --user start` fails (status 5), the
  # session dies immediately, and SDDM drops back to a black greeter. (Launching
  # from a TTY runs start-hyprland directly and bypasses UWSM, which is why that
  # always worked.) Pin the greeter's default to the plain, working session.
  # "hyprland" = hyprland.desktop basename. To switch to UWSM instead, enable
  # programs.hyprland.withUWSM and point this at "hyprland-uwsm".
  services.displayManager.defaultSession = "hyprland";
}
