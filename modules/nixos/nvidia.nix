{ config, lib, pkgs, ... }:

{
  # RTX 5070 (Blackwell): the OPEN kernel modules are mandatory — the
  # proprietary/closed modules do not support this generation at all.
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Steam/Proton 32-bit titles
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;               # mandatory for Blackwell, not a preference
    modesetting.enable = true; # required for Wayland/Hyprland
    powerManagement.enable = true;
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
