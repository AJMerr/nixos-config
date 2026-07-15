{ config, lib, pkgs, ... }:

{
  # System-level half of the Hyprland split: installs Hyprland into the
  # system closure, generates the session .desktop file the display manager
  # reads, wires up polkit + portals. The user-level half (your actual
  # config: binds, rules, look-and-feel) is modules/home/hyprland. Both are
  # required; neither replaces the other.
  programs.hyprland.enable = true;

  # Launch Hyprland under UWSM (Universal Wayland Session Manager). UWSM wraps
  # the compositor in a proper systemd user session: it starts
  # graphical-session-pre.target → the compositor → graphical-session.target,
  # imports the environment into the systemd/dbus activation environment, and
  # cleanly tears everything down on logout. withUWSM = true is the piece that
  # was MISSING before: without it the greeter's "hyprland-uwsm.desktop" entry
  # (Exec=uwsm start …) had no UWSM package or `wayland-session-bindpid@.service`
  # user unit behind it, so `systemctl --user start` failed (status 5), the
  # session died on launch, and SDDM fell back to a black greeter. Enabling it
  # installs UWSM + its user units so the UWSM session actually works.
  programs.hyprland.withUWSM = true;

  xdg.portal.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # The hyprland package ships TWO session files: "hyprland.desktop"
  # (Exec=start-hyprland, plain) and "hyprland-uwsm.desktop" (Exec=uwsm start …).
  # With programs.hyprland.withUWSM = true above, the UWSM session is now the
  # correct, fully-managed one — pin the greeter's default to it.
  # "hyprland-uwsm" = hyprland-uwsm.desktop basename. (The plain "hyprland"
  # session still appears in the greeter and still works from a TTY via
  # start-hyprland if you ever need to bypass UWSM.)
  #
  # NOTE: the user-side modules/home/hyprland sets systemd.enable = false so HM
  # doesn't also try to manage the session target — UWSM owns that now.
  services.displayManager.defaultSession = "hyprland-uwsm";
}
