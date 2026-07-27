{ config, lib, pkgs, ... }:

{
  # EasyEffects — on-the-fly PipeWire EQ/effects, run as a background user
  # service so it's always inserted into the graph and ready to tweak
  # (headphone EQ for the Edition XVs, etc.) without manually launching the
  # app first. Needs `programs.dconf.enable` at the system level
  # (modules/nixos/audio.nix) — its settings are GSettings-backed.
  #
  # No preset is declared here: presets/EQ curves are created and saved from
  # the EasyEffects GUI itself and persist in ~/.config/easyeffects across
  # rebuilds, since nothing here manages that state.
  services.easyeffects.enable = true;
}
