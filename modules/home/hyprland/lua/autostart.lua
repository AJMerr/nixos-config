-- Autostart (hyprland.start hook, Hyprland 0.55+).
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

local terminal = "ghostty"

hl.on("hyprland.start", function()
  hl.exec_cmd(terminal)
  hl.exec_cmd("noctalia")
  hl.exec_cmd("udiskie --notify") -- automount; needs services.udisks2
end)
