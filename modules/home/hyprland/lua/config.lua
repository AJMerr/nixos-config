-- Data-shaped Hyprland config: monitors, env vars, and the hl.config()
-- variable blocks (general/decoration/dwindle/master/misc/input).
--
-- WHY THIS IS LUA AND NOT NIX `settings`: Hyprland 0.55's Lua API exposes
-- exactly ONE generic config setter, hl.config({...}) — there is no
-- hl.general/hl.decoration/hl.animations/etc. Home Manager's settings->lua
-- generator (this pinned HM rev) emits those per-section calls, which are
-- nil at runtime and abort the whole config. So everything data-shaped is
-- written here by hand against the real API. Canonical reference:
-- `share/hypr/hyprland.lua` in the hyprland package.
-- Animations (enable flag + curves + leaves) live in ./animations.lua.

-- Monitors: https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
  output   = "",
  mode     = "preferred",
  position = "auto",
  scale    = "auto",
})

-- Env: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Variables: https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
  general = {
    gaps_in  = 5,
    gaps_out = 20,
    border_size = 2,

    col = {
      active_border   = { colors = { "rgb(122,37,141)", "rgb(223,192,233)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },

    resize_on_border = false,
    allow_tearing    = false, -- see hypr wiki on tearing before enabling
    layout           = "dwindle",
  },

  decoration = {
    rounding       = 10,
    rounding_power = 2,

    active_opacity   = 0.8,
    inactive_opacity = 0.6,

    shadow = {
      enabled      = true,
      range        = 4,
      render_power = 3,
      color        = 0xee1a1a1a, -- Lua has hex literals; no Nix decimal workaround needed
    },

    blur = {
      enabled  = true,
      size     = 10,
      passes   = 1,
      vibrancy = 0.1696,
    },
  },

  dwindle = {
    preserve_split = true,
  },

  master = {
    new_status = "master",
  },

  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo   = true,
  },

  input = {
    kb_layout  = "us",
    kb_variant = "",
    kb_model   = "",
    kb_options = "",
    kb_rules   = "",

    follow_mouse = 1,
    sensitivity  = 0,

    touchpad = {
      natural_scroll = true,
    },
  },
})
