{
  config,
  lib,
  pkgs,
  ...
}:

{
  # System half of the Hyprland split (user half: modules/home/hyprland). Both required.
  programs.hyprland.enable = true;

  # UWSM wraps Hyprland in a proper systemd user session. Required for the
  # greeter's "hyprland-uwsm" session entry to actually start.
  programs.hyprland.withUWSM = true;

  xdg.portal.enable = true;

  environment.systemPackages = [ pkgs.sddm-astronaut ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [ kdePackages.qtmultimedia ]; # video/audio backgrounds
    theme = "post-apocalyptic_hacker";
  };

  # hyprland-uwsm.desktop, the UWSM-managed session (see withUWSM above).
  services.displayManager.defaultSession = "hyprland-uwsm";
}
