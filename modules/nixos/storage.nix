{ pkgs, ... }:

{
  # Automounting (udiskie) and Dolphin's device list use the udisks2 D-Bus API.
  services.udisks2.enable = true;

  # picotool's udev rules grant the active user access to Raspberry Pi Pico
  # USB modes (BOOTSEL, serial). Also provides the `picotool` CLI.
  services.udev.packages = [ pkgs.picotool ];
  environment.systemPackages = [ pkgs.picotool ];
}
