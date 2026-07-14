# User entrypoint — identity only. All actual configuration lives in
# modules/home, so a second user/host later just writes its own thin
# entrypoint and cherry-picks module imports.
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/home
  ];

  home.username = "ajmerr";
  home.homeDirectory = "/home/ajmerr";
  home.stateVersion = "26.05"; # set once, never bump on upgrades

  programs.home-manager.enable = true;
}
