local wezterm = require "wezterm"
local config = wezterm.config_builder()
config.color_scheme = "Omni (Gogh)"
config.font = wezterm.font_with_fallback { "0xProto Nerd Font", "BIZ UDGothic" }
config.font_size = 14
config.default_cursor_style = "BlinkingBlock"
config.default_prog = { "/opt/homebrew/bin/fish", "-l" }
config.skip_close_confirmation_for_processes_named = { "fish" }
config.hide_tab_bar_if_only_one_tab = true
config.keys = {
  {
    key = "n",
    mods = "CMD",
    action = wezterm.action.SpawnCommandInNewWindow { cwd = wezterm.home_dir },
  },
}
return config
