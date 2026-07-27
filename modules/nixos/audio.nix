{ config, lib, pkgs, ... }:

{
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;

  # Required for EasyEffects (modules/home/easyeffects) — its daemon reads
  # its settings via GSettings/dconf, which does nothing without this.
  programs.dconf.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;       # pipewire-pulse — what `pactl info` talks to
    wireplumber.enable = true;

    # High-fidelity/lossless: let the graph clock follow whatever rate the
    # source material actually is (44.1kHz-family vs 48kHz-family) instead
    # of always resampling everything down to 48kHz, and use the
    # highest-quality resampler for the cases where a rate switch still
    # isn't possible (e.g. two apps at different rates mixed together).
    extraConfig.pipewire."99-audiophile" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [ 44100 48000 88200 96000 176400 192000 ];
        "resample.quality" = 15; # max quality; pipewire's default is 4
      };
    };

    # Don't let ALSA nodes suspend after their idle timeout — the
    # power-down/power-up cycle on the next sample causes an audible
    # click/pop, and matters most once the DAC (arriving Wed) becomes the
    # active output device.
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
