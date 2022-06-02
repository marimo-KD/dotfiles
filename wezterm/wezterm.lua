local wezterm = require'wezterm';

function font_with_fallback(name, params)
  local names = {name, "Symbols Nerd Font", "Noto Color Emoji"}
  return wezterm.font_with_fallback(names, params)
end

return {
  font = font_with_fallback("PlemolJP Console NF Light"),
  font_rules = {
    {
      italic = true,
      font = font_with_fallback("PlemolJP Console NF Light", {italic = true}),
    },
    {
      intensity = "Bold",
      font = font_with_fallback("PlemolJP Console NF Light", {bold = true}),
    },
    {
      italic = true,
      intensity = "Bold",
      font = font_with_fallback("PlemolJP Console NF Light", {bold = true, italic=true}),
    },
    {
      intensity = "Half",
      font = font_with_fallback("PlemolJP Console NF ExtraLight"),
    },
  },
  font_size = 10,
  font_antialias = "Greyscale",
  font_hinting = "Full",
  window_background_opacity = 0.95,
  window_close_confirmation = "NeverPrompt",
  enable_tab_bar = false,
  enable_scroll_bar = false,
  color_scheme = "Gruvbox Dark",
  default_cursor_style = "BlinkingBar",

  use_ime = false,
  scrollback_lines = 700,
}
