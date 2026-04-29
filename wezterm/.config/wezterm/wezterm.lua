-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Mocha'

config.keys = {
  {
    key = 'r',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ReloadConfiguration,
  },
}

-- window settings
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.75
config.window_padding = {
  left = '20px',
  right = '20px',
  top = '20px',
  bottom = '20px',
}

config.hide_tab_bar_if_only_one_tab = true 

-- font settings
config.font = wezterm.font('JetBrainsMonoNL Nerd Font Propo', { weight = 'Bold', italic = false })
config.font_size = 14.0
config.cell_width = 0.9
config.line_height = 1.0
config.front_end = 'OpenGL'
config.freetype_load_target = 'Light'
config.freetype_render_target = 'HorizontalLcd'

-- and finally, return the configuration to wezterm
return config