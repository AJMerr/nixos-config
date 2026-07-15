# System fonts.
#
# A Nerd Font is required in two places and was previously NOT installed by
# this flake at all (Ghostty's `font-family = "JetBrainsMono Nerd Font"` was
# silently falling back):
#   - the terminal (modules/home/ghostty) asks for JetBrainsMono Nerd Font;
#   - Neovim / LazyVim's UI is icon-heavy and renders as tofu without one.
#
# Installed system-wide (not per-user) so the display manager and every app,
# regardless of session, can resolve the glyphs.
{ config, lib, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
