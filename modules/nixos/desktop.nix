{
  config,
  lib,
  pkgs,
  ...
}:

{
  # System half of Hyprland; the user config is in modules/home/hyprland.
  programs.hyprland.enable = true;

  # Runs Hyprland as a systemd user session; provides the "hyprland-uwsm" session.
  programs.hyprland.withUWSM = true;

  xdg.portal.enable = true;

  # Select the sddm-astronaut "cyberpunk" variant by patching the theme's
  # metadata.desktop.
  environment.systemPackages = [
    (pkgs.sddm-astronaut.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        substituteInPlace $out/share/sddm/themes/sddm-astronaut-theme/metadata.desktop \
          --replace-fail "ConfigFile=Themes/astronaut.conf" "ConfigFile=Themes/cyberpunk.conf"
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

  services.displayManager.defaultSession = "hyprland-uwsm";
}
