{ config, lib, pkgs, ... }:

{
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;

  # EasyEffects reads its settings through dconf.
  programs.dconf.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;

    # Follow the source's sample rate (44.1k/48k families) instead of always
    # resampling to 48k; use the highest-quality resampler otherwise.
    extraConfig.pipewire."99-audiophile" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 ];
        "resample.quality" = 15; # max; default is 4
      };
    };

    # Never suspend ALSA nodes; the power cycle causes audible clicks.
    wireplumber.extraConfig."51-no-suspend" = {
      "monitor.alsa.rules" = [
        {
          matches = [{ "node.name" = "~alsa_(output|input)\\..*"; }];
          actions.update-props."session.suspend-timeout-seconds" = 0;
        }
      ];
    };
  };
}
