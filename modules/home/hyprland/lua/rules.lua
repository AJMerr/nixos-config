-- Window rules, per-device input, gestures — verbatim from your config.
-- hl.window_rule()/hl.device()/hl.gesture() are calls -> live here, not
-- in the Nix settings attrset.

hl.window_rule({
  -- Ignore maximize requests from all apps.
  name           = "suppress-maximize-events",
  match          = { class = ".*" },

  suppress_event = "maximize",
})

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name     = "fix-xwayland-drags",
  match    = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },

  no_focus = true,
})

hl.window_rule({
  -- Hyprland-run window placement
  name  = "move-hyprland-run",
  match = { class = "hyprland-run" },

  move  = "20 monitor_h-120",
  float = true,
})

-- Force Firefox to render at full opacity regardless of active/inactive opacity
hl.window_rule({
  name    = "firefox-full-opacity",
  match   = { class = "^(firefox)$" },
  opacity = "1.0 override",
})

-- 3-finger workspace swipe gesture was commented out (disabled) in your old
-- config, so it's left disabled here too. Uncomment to enable:
-- hl.gesture({
--   fingers = 3,
--   direction = "horizontal",
--   action = "workspace"
-- })

-- Example per-device config (placeholder device name from the default
-- config, carried over from your old config — does not match any real device)
hl.device({
  name        = "epic-mouse-v1",
  sensitivity = -0.5,
})
