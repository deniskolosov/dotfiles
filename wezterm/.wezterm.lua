local wezterm = require 'wezterm'
local config = {}
config.font = wezterm.font 'JetBrains Mono'
config.color_scheme = 'Catppuccin'
config.font_size = 18.0
config.enable_tab_bar = false

-- Disable header if needed.
config.window_decorations = "RESIZE"

config.window_background_opacity = 0.8
config.macos_window_background_blur = 22
return config
