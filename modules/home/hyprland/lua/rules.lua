-- Window rules, input devices, gestures.

hl.window_rule({
  -- Ignore maximize requests from all apps.
  name           = "suppress-maximize-events",
  match          = { class = ".*" },

  suppress_event = "maximize",
})

hl.window_rule({
  -- Fix XWayland drag issues
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

-- Firefox ignores active/inactive opacity
hl.window_rule({
  name    = "firefox-full-opacity",
  match   = { class = "^(firefox)$" },
  opacity = "1.0 override",
})

-- Disabled: 3-finger workspace swipe.
-- hl.gesture({
--   fingers = 3,
--   direction = "horizontal",
--   action = "workspace"
-- })

-- Placeholder: matches no real device.
hl.device({
  name        = "epic-mouse-v1",
  sensitivity = -0.5,
})
