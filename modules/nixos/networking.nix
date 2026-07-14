{ config, lib, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # Redistributable firmware blobs — covers the WiFi/BT chipsets that ship
  # in Legion desktops. Harmless if the onboard chipset needs nothing.
  hardware.enableRedistributableFirmware = true;
}
