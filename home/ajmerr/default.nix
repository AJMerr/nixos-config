# User entrypoint: identity only. Configuration lives in modules/home.
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/home
  ];

  home.username = "ajmerr";
  home.homeDirectory = "/home/ajmerr";
  home.stateVersion = "26.05"; # never bump on upgrades

  programs.home-manager.enable = true;
}
