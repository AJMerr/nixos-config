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

  # sddm-astronaut ships one theme dir ("sddm-astronaut-theme") with several
  # selectable variants; the variant is baked into metadata.desktop's
  # ConfigFile= line, so pick "post-apocalyptic_hacker" by patching that here
  # (the upstream installer does the same sed, just against a writable copy).
  environment.systemPackages = [
    (pkgs.sddm-astronaut.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        substituteInPlace $out/share/sddm/themes/sddm-astronaut-theme/metadata.desktop \
          --replace-fail "ConfigFile=Themes/astronaut.conf" "ConfigFile=Themes/post-apocalyptic_hacker.conf"
      '';
    }))
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [ kdePackages.qtmultimedia ]; # video/audio backgrounds
    theme = "sddm-astronaut-theme";
  };

  # hyprland-uwsm.desktop, the UWSM-managed session (see withUWSM above).
  services.displayManager.defaultSession = "hyprland-uwsm";
}
