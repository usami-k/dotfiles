local wezterm = require 'wezterm'

function get_appearance()
  if wezterm.gui then
      return wezterm.gui.get_appearance()
    end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Gruvbox dark, hard (base16)'
  else
    return 'Gruvbox light, hard (base16)'
  end
end

local config = wezterm.config_builder()
config.color_scheme = scheme_for_appearance(get_appearance())
config.default_prog = {'/opt/homebrew/bin/fish'}
config.skip_close_confirmation_for_processes_named = {'fish'}
config.enable_tab_bar = false
config.use_ime = true
config.font = wezterm.font('0xProto Nerd Font')
config.font_size = 14
return config
