{ config, lib, pkgs, ... }:

{
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;       # pipewire-pulse — what `pactl info` talks to
    wireplumber.enable = true;
  };
}
