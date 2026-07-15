{ config, lib, pkgs, ... }:

{
  # Steam must be a SYSTEM module, not a home.packages entry: programs.steam
  # installs an FHS-wrapped Steam (the runtime needs a normal /usr-style
  # filesystem that a plain Nix binary can't provide), plus the udev rules for
  # Steam Controller / gamepad access. Home Manager has no equivalent — the
  # bare `steam` package on its own won't launch reliably on NixOS.
  #
  # 32-bit graphics libraries (Proton and most native titles are 32-bit) come
  # from hardware.graphics.enable32Bit, already set in nvidia.nix — that is the
  # "anything needed to run Steam" piece on the GPU side. allowUnfree (set in
  # default.nix) is required since Steam is unfree.
  programs.steam = {
    enable = true;

    # Open the firewall for Steam features that need inbound connections.
    remotePlay.openFirewall = true;              # Steam Remote Play / streaming
    localNetworkGameTransfers.openFirewall = true; # LAN game/file transfers
  };

  # Gamescope + gamemode: the standard companions for gaming under Wayland.
  # Gamescope gives games their own nested compositor (better fullscreen +
  # scaling than handing them raw Hyprland); gamemode applies CPU/GPU perf
  # tweaks while a game is running. Both are optional but expected alongside
  # Steam, and cost nothing when unused.
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;
}
