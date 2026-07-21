# Removable-media plumbing. Hyprland (unlike Plasma/GNOME) ships none of
# this by default, so USB drives (and the Pico in BOOTSEL mass-storage mode)
# never get auto-mounted, and Dolphin's Places panel has no device list to
# populate.
{ pkgs, ... }:

{
  # Backs both the automounter (home/hyprland runs udiskie) and Dolphin's
  # Places panel "Devices" section, which enumerates over the udisks2 D-Bus
  # API rather than raw /dev scanning.
  services.udisks2.enable = true;

  # picotool ships udev rules for the Raspberry Pi Pico's USB IDs (BOOTSEL
  # mass-storage mode, and the CDC-ACM serial modes used by MicroPython/
  # CircuitPython/stdio-USB firmware). Rules are tagged "uaccess", so
  # systemd-logind ACLs grant the active seat user access directly — no
  # group membership needed. Also gives you the `picotool` CLI for
  # inspecting/flashing UF2s.
  services.udev.packages = [ pkgs.picotool ];
  environment.systemPackages = [ pkgs.picotool ];
}
