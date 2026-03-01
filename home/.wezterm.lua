local wezterm = require "wezterm"
local config = wezterm.config_builder()
config.default_prog = { "/opt/homebrew/bin/fish", "-l" }
config.skip_close_confirmation_for_processes_named = { "fish" }
config.default_cursor_style = "BlinkingBlock"
config.color_scheme = "Operator Mono Dark"
config.font = wezterm.font_with_fallback { "0xProto Nerd Font", "BIZ UDGothic" }
config.font_size = 14
config.initial_cols = 92
config.initial_rows = 46
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.keys = {
  {
    key = "n",
    mods = "CMD",
    action = wezterm.action.SpawnCommandInNewWindow { cwd = wezterm.home_dir },
  },
}
return config
