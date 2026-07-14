{ config, lib, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # MANUAL (BIOS): Secure Boot OFF — stock systemd-boot is unsigned.
  # MANUAL (BIOS): UEFI boot mode, not legacy/CSM.
  # MANUAL (BIOS): Above 4G Decoding + Resizable BAR both ON (usually
  #   required together for RTX 50-series init on AM5 boards).

  # Default kernel from nixos-unstable. See README kernel/driver pairing
  # note before swapping to linuxPackages_latest.
  boot.kernelPackages = pkgs.linuxPackages;
}
