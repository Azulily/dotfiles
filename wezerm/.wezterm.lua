-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 30
line_height = 1.0
config.font = wezterm.font_with_fallback({
{family="Caskaydia Cove NF",weight="Regular"},
})


-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 2000 }
config.keys = {
  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain'},
  },

}
-- or, changing the font size and color scheme.
config.font_size = 14
config.color_scheme = 'Tomorrow Night'
config.window_background_opacity = 0.85
--config.window_background_blur = 80
config.window_decorations = "RESIZE"
config.show_new_tab_button_in_tab_bar = false
config.debug_key_events = true
-- Finally, return the configuration to wezterm:
return config
