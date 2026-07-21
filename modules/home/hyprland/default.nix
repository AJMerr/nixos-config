{ config, lib, pkgs, ... }:

{
  # -----------------------------------------------------------------------
  # Hyprland — native HM module, Lua config (Hyprland 0.55+)
  # -----------------------------------------------------------------------
  # ALL config is hand-written Lua in ./lua/*.lua files, pulled in via
  # builtins.readFile (content hashes into the store path, so an edit still
  # triggers a rebuild). Files:
  #   config.lua     -> data-shaped config: hl.monitor, hl.env, and the
  #                     hl.config({...}) variable blocks (general, decoration,
  #                     dwindle, master, misc, input).
  #   animations.lua -> animations enable flag + hl.curve()/hl.animation().
  #   binds.lua      -> hl.bind() + hl.dsp.* dispatchers, workspace for-loop.
  #   rules.lua      -> hl.window_rule()/hl.device()/hl.gesture().
  #   autostart.lua  -> hl.on("hyprland.start", ...) hook.
  #
  # ⚠️ WHY NOT HM's `settings` option: on this HM revision the settings->lua
  # generator emits per-section calls — hl.general{...}, hl.decoration{...},
  # hl.animations{...}, etc. — but Hyprland 0.55's Lua API has NO such
  # functions; the only config setter is hl.config({...}). Those generated
  # calls hit a nil value and Hyprland aborts the ENTIRE config with the red
  # "attempt to call a nil value (field 'animations')" banner. (animations is
  # merely the alphabetically-first section, so it trips first — every other
  # section would fail identically.) The generator also mis-shaped hl.monitor
  # (string, wants a table) and hl.env ("K,V", wants two args). This is the
  # home-manager#9468 class of bug, terminal for our config shapes — hence
  # the hand-written approach. Canonical hl.config reference:
  # `share/hypr/hyprland.lua` in the hyprland package. After a build, run
  # `hyprland --verify-config` to confirm the generated hyprland.lua is clean.
  #
  # ⚠️ VERSION-SENSITIVE: configType = "lua" requires Hyprland >= 0.55.
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # systemd.enable = false because the session runs under UWSM (set in
    # modules/nixos/desktop.nix via programs.hyprland.withUWSM). UWSM already
    # starts graphical-session.target and imports the environment into the
    # systemd/dbus activation environment; leaving HM's own systemd integration
    # on would double-manage the same target and fight UWSM. The two settings
    # are a matched pair — flip both together if you ever move off UWSM.
    systemd.enable = false;
    configType = "lua";

    # No `settings` — see the note above. Everything is in extraLuaFiles.
    extraLuaFiles = {
      "config" = {
        autoLoad = true;
        content = builtins.readFile ./lua/config.lua;
      };
      "autostart" = {
        autoLoad = true;
        content = builtins.readFile ./lua/autostart.lua;
      };
      "binds" = {
        autoLoad = true;
        content = builtins.readFile ./lua/binds.lua;
      };
      "animations" = {
        autoLoad = true;
        content = builtins.readFile ./lua/animations.lua;
      };
      "rules" = {
        autoLoad = true;
        content = builtins.readFile ./lua/rules.lua;
      };
    };
  };

  # Everything your binds and Noctalia widgets shell out to. On CachyOS
  # these were ambient system packages; on NixOS they must be declared or
  # the binds silently do nothing.
  home.packages = with pkgs; [
    kdePackages.dolphin          # SUPER+E file manager
    kdePackages.kio
    kdePackages.kio-extras
    udiskie          # automounts USB drives/Pico on insert (see autostart.lua)
    wofi             # SUPER+R launcher
    grim             # SUPER+SHIFT+S screenshot...
    slurp            # ...region select...
    wl-clipboard     # ...wl-copy, also wl-paste used by Noctalia clipboard cmds
    playerctl        # XF86 media keys
    brightnessctl    # XF86 brightness keys
    pwvucontrol      # Noctalia volume widget middle-click target
  ];
}
