# Nerd Font for Ghostty and Neovim icons. System-wide so the display manager
# can use it too.
{ config, lib, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
