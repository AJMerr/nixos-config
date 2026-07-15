# Host entrypoint: hardware + shared system modules + host-specific facts.
# Everything reusable lives in modules/nixos — this file is only what makes
# THIS machine this machine.
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  networking.hostName = "nixos";

  users.users.ajmerr = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
  };

  # First-boot system packages. Per-user/desktop packages live in
  # modules/home — this list stays small on purpose.
  environment.systemPackages = with pkgs; [
    vim
    neovim
    firefox
    git
    pkgs.gh
  ];

  system.stateVersion = "26.05"; # set once at install, never bump on upgrades
}
