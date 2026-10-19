# Host entrypoint: hardware, shared system modules, and machine-specific facts.
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

  # Minimal bootstrap packages; user packages live in modules/home.
  environment.systemPackages = with pkgs; [
    vim
    neovim
    firefox
    git
    pkgs.gh
  ];

  system.stateVersion = "26.05"; # never bump on upgrades
}
