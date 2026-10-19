{ config, lib, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Steam/Proton 32-bit titles
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;               # RTX 5070 (Blackwell) requires the open modules
    modesetting.enable = true; # required for Wayland
    powerManagement.enable = true;
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
