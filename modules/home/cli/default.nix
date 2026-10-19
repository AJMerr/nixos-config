# User CLI tooling — general-purpose command-line programs that should
# always be on this user's PATH, independent of the desktop session.
{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    claude-code   # Anthropic's Claude Code CLI — version comes from the
                  # dedicated `nixpkgs-claude` input, see
                  # modules/nixos/overlays.nix
    spotatui      # standalone terminal Spotify client
  ];
}
