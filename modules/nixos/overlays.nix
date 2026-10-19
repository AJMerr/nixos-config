# claude-code comes from its own nixpkgs input so
# `nix flake update nixpkgs-claude` bumps it without moving the rest of the
# system. A separate nixpkgs instance needs its own allowUnfree.
{ inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      claude-code = (import inputs.nixpkgs-claude {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      }).claude-code;
    })
  ];
}
