{ config, lib, pkgs, ... }:

{
  # -----------------------------------------------------------------------
  # Hyprland — native HM module, Lua config (Hyprland 0.55+)
  # -----------------------------------------------------------------------
  # The split, and why:
  #   settings.nix  -> everything in your hyprland.lua that was pure data
  #                    (the hl.config({...}) blocks, hl.monitor, hl.env).
  #                    HM's generator turns each top-level attr into the
  #                    corresponding declaration in the generated
  #                    hyprland.lua; nested attrsets become nested Lua
  #                    tables; a list under one key emits one declaration
  #                    per element.
  #   lua/*.lua     -> everything that is genuinely Lua and cannot be
  #                    expressed as data: hl.on() hooks, hl.bind() with
  #                    hl.dsp.* dispatcher calls, the workspace for-loop,
  #                    hl.curve()/hl.animation() calls, hl.window_rule()
  #                    and hl.device() calls. Stored as real .lua files
  #                    (editor highlighting, hyprland --verify-config
  #                    testable) and pulled in declaratively via
  #                    builtins.readFile — content still hashes into the
  #                    store path, so a .lua edit still triggers a rebuild
  #                    like any other config change.
  #
  # ⚠️ VERSION-SENSITIVE: configType = "lua" requires Hyprland >= 0.55 AND
  # Home Manager 26.05+ (when Lua support landed). Also see
  # home-manager#9468 — the settings->lua generator has produced invalid
  # Lua for some option shapes (list-valued env especially). After first
  # build, run `hyprland --verify-config`; if a settings-generated line is
  # broken, relocate that option into one of the lua/ files.
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    configType = "lua";

    settings = import ./settings.nix;

    extraLuaFiles = {
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
    ghostty          # $terminal (works on real hardware; VMware GPU limits only)
    dolphin          # SUPER+E file manager
    wofi             # SUPER+R launcher
    grim             # SUPER+SHIFT+S screenshot...
    slurp            # ...region select...
    wl-clipboard     # ...wl-copy, also wl-paste used by Noctalia clipboard cmds
    playerctl        # XF86 media keys
    brightnessctl    # XF86 brightness keys
    pwvucontrol      # Noctalia volume widget middle-click target
  ];
}
