-- Autostart — hyprland.start hook (Hyprland 0.55+; replaces exec-once)
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

local terminal = "ghostty"

hl.on("hyprland.start", function()
  hl.exec_cmd(terminal)
  -- v5 launch command. Your old config used `qs -c noctalia-shell`, which
  -- is the v4/Quickshell invocation — v5 ships a native `noctalia` binary.
  hl.exec_cmd("noctalia")
end)
