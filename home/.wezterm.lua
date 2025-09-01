local wezterm = require "wezterm"

local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return "Light"
end

local function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "OneHalfDark"
  else
    return "OneHalfLight"
  end
end

local config = wezterm.config_builder()
config.color_scheme = scheme_for_appearance(get_appearance())
config.font = wezterm.font_with_fallback { "0xProto Nerd Font", "BIZ UDGothic" }
config.font_size = 14
config.default_cursor_style = "BlinkingBlock"
config.default_prog = { "/opt/homebrew/bin/fish", "-l" }
config.skip_close_confirmation_for_processes_named = { "fish" }
config.quit_when_all_windows_are_closed = false
config.hide_tab_bar_if_only_one_tab = true
config.initial_cols = 88
config.initial_rows = 40
config.keys = {
  {
    key = "n",
    mods = "CMD",
    action = wezterm.action.SpawnCommandInNewWindow { cwd = wezterm.home_dir },
  },
}
return config
