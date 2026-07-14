# Aggregator for system-level modules. Hosts import this directory;
# individual features each get their own file.
{
  imports = [
    ./boot.nix
    ./networking.nix
    ./audio.nix
    ./nvidia.nix
    ./desktop.nix
  ];

  nixpkgs.config.allowUnfree = true; # NVIDIA driver requires this

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
