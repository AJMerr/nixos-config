# Data-shaped Hyprland config — 1:1 from the hl.config/hl.monitor/hl.env
# blocks of your hyprland.lua. Function-shaped config lives in ./lua/.
{
  monitor = [ ",preferred,auto,auto" ];

  # KNOWN-RISK SHAPE (home-manager#9468): list-valued env has produced bad
  # generated Lua on some HM revisions. If `hyprland --verify-config`
  # complains here, move these two lines to lua/autostart.lua as
  # hl.env("XCURSOR_SIZE", "24") etc.
  env = [
    "XCURSOR_SIZE,24"
    "HYPRCURSOR_SIZE,24"
  ];

  general = {
    gaps_in = 5;
    gaps_out = 20;
    border_size = 2;

    # Nested-table gradient — verify the generated Lua reproduces the
    # { colors = {...}, angle = 45 } table faithfully (same #9468 class of
    # risk as env above). Fallback: move `col` into lua/rules.lua as a raw
    # hl.config({ general = { col = {...} } }) block.
    col = {
      active_border = {
        colors = [ "rgb(122,37,141)" "rgb(223,192,233)" ];
        angle = 45;
      };
      inactive_border = "rgba(595959aa)";
    };

    resize_on_border = false;
    allow_tearing = false; # see hypr wiki on tearing before enabling
    layout = "dwindle";
  };

  decoration = {
    rounding = 10;
    rounding_power = 2;

    active_opacity = 0.8;
    inactive_opacity = 0.6;

    shadow = {
      enabled = true;
      range = 4;
      render_power = 3;
      # NO CLEAN DECLARATIVE EQUIVALENT: your Lua had 0xee1a1a1a, but Nix
      # has no hex integer literals. 3994688026 == 0xee1a1a1a exactly;
      # the generated Lua gets the same number either way. If you'd rather
      # read hex in your repo, move shadow into a lua/ file.
      color = 3994688026;
    };

    blur = {
      enabled = true;
      size = 10;
      passes = 1;
      vibrancy = 0.1696;
    };
  };

  animations = {
    enabled = true;
    # curves + per-leaf animation tuning are hl.curve()/hl.animation()
    # CALLS, not config data -> lua/animations.lua
  };

  dwindle = {
    preserve_split = true;
  };

  master = {
    new_status = "master";
  };

  misc = {
    force_default_wallpaper = 0;
    disable_hyprland_logo = true;
  };

  input = {
    kb_layout = "us";
    kb_variant = "";
    kb_model = "";
    kb_options = "";
    kb_rules = "";

    follow_mouse = 1;
    sensitivity = 0;

    touchpad = {
      natural_scroll = true;
    };
  };
}
