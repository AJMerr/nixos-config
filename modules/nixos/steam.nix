{ config, lib, pkgs, ... }:

{
  # Must be a system module: provides the FHS-wrapped Steam and gamepad udev rules.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.gamescope.enable = true; # nested compositor for games
  programs.gamemode.enable = true;  # CPU/GPU performance mode while gaming
}
