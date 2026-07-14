# PLACEHOLDER — replace with the output of `nixos-generate-config --root /mnt`
# run from the live installer AFTER partitioning/mounting. It needs real
# by-uuid paths and detected initrd modules; it cannot be hand-written.
# NVIDIA config intentionally does NOT live here (it's modules/nixos/nvidia.nix)
# so it survives a hardware-config regeneration.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # --- REPLACE EVERYTHING BELOW WITH GENERATED OUTPUT ---
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-ME-ROOT-UUID";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE-ME-BOOT-UUID";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault true;
}
