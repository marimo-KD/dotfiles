local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local heirline = require("heirline")

local flavour = 'macchiato'
local palette = require("catppuccin.palettes").get_palette(flavour)
heirline.load_colors(palette)
-- {
--   rosewater = "#f4dbd6",
--   flamingo = "#f0c6c6",
--   pink = "#f5bde6",
--   mauve = "#c6a0f6",
--   red = "#ed8796",
--   maroon = "#ee99a0",
--   peach = "#f5a97f",
--   yellow = "#eed49f",
--   green = "#a6da95",
--   teal = "#8bd5ca",
--   sky = "#91d7e3",
--   sapphire = "#7dc4e4",
--   blue = "#8aadf4",
--   lavender = "#b7bdf8",
--   text = "#cad3f5",
--   subtext1 = "#b8c0e0",
--   subtext0 = "#a5adcb",
--   overlay2 = "#939ab7",
--   overlay1 = "#8087a2",
--   overlay0 = "#6e738d",
--   surface2 = "#5b6078",
--   surface1 = "#494d64",
--   surface0 = "#363a4f",
--   base = "#24273a",
--   mantle = "#1e2030",
--   crust = "#181926",
-- }

local Align = { provider = "%=" }
local Space = { provider = " " }

local ViMode = {
  init = function(self)
      self.mode = vim.fn.mode(1) 
  end,
  static = {
    mode_names = { 
      n = "Nor",
      no = "Nor?",
      nov = "Nor?",
      noV = "Nor?",
      ["no\22"] = "Nor?",
      niI = "NorI",
      niR = "NorR",
      niV = "NorV",
      nt = "Nort",
      v = "vis",
      vs = "viss",
      V = "Vis_",
      Vs = "Viss",
      ["\22"] = "^Vis",
      ["\22s"] = "^Vis",
      s = "Sub",
      S = "Sub_",
      ["\19"] = "^Sub",
      i = "Ins",
      ic = "Insc",
      ix = "Insx",
      R = "Rep",
      Rc = "Repc",
      Rx = "Repx",
      Rv = "Repv",
      Rvc = "Repv",
      Rvx = "Repv",
      c = "Com",
      cv = "Ex",
      r = "...",
      rm = "M",
      ["r?"] = "?",
      ["!"] = "!",
      t = "Term",
    },
    mode_colors = {
      n = "text" ,
      i = "blue",
      v = "peach",
      V =  "peach",
      ["\22"] =  "peach",
      c =  "yellow",
      s =  "red",
      S =  "red",
      ["\19"] =  "red",
      R =  "red",
      r =  "red",
      ["!"] =  "red",
      t =  "green",
    },
  },
  provider = function(self)
    return " %4("..self.mode_names[self.mode].."%)"
  end,
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = self.mode_colors[mode], bold = true, }
  end,
  update = {
    "ModeChanged", -- "skkeleton-mode-changed",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
        vim.cmd("redrawstatus")
    end),
  },
}

local SkkMode = {
  init = function(self)
    if vim.fn["dein#is_sourced"]('skkeleton') == 1 then
      self.mode = vim.fn["skkeleton#mode"]()
    else
      self.mode = ''
    end
  end,
  static = {
    mode_names = {
      hira = " あ",
      kata = " ア",
      hankata = " ｱ",
      zenkaku = " Ａ",
      abbrev = " abbr",
    },
  },
  provider = function(self)
    return self.mode_names[self.mode]
  end,
  hl = { fg = "blue", bold = true },
  update = {
    "User",
    pattern = "skkeleton-mode-changed",
  }
}

vim.opt.showcmdloc = 'statusline'
local ShowCmd = {
    condition = function()
        return vim.o.cmdheight == 0
    end,
    provider = ":%3.5(%S%)",
}

local FileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  hl = {bg = "mantle"}
}

local FileName = {
  provider = function(self)
    local filename = vim.fn.fnamemodify(self.filename, ":.")
    if filename == "" then return "[No Name]" end
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
  hl = { fg = utils.get_highlight("Directory").fg },
}

local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = "[+]",
    hl = { fg = "green" },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "",
    hl = { fg = "yellow" },
  },
}

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end
}

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      return { fg = "pink", bold= true, force=true }
    end
  end,
}

local FileType = {
  provider = function()
    return vim.bo.filetype
  end,
  hl = { fg = utils.get_highlight("Type").fg, bold = true },
}

local FileEncoding = {
  provider = function()
    local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc
    return enc:upper()
  end
}

local FileNameBlock = utils.insert(FileNameBlock,
  -- FileIcon,
  utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
  FileFlags,
  { provider = '%<'} -- this means that the statusline is cut here when there's not enough space
)

local Diagnostics = {
  condition = conditions.has_diagnostics,

  static = {
    error_icon = '',
    warn_icon = '',
    info_icon = '',
    hint_icon = '󰌶',
  },

  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,

  update = { "DiagnosticChanged", "BufEnter" },

  {
    provider = "![",
  },
  {
    provider = function(self)
      return self.errors > 0 and (self.error_icon .. self.errors .. " ")
    end,
    hl = { fg = "red" },
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
    end,
    hl = { fg = "yellow" },
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info .. " ")
    end,
    hl = { fg = "sky" },
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = { fg = "teal" },
  },
  {
    provider = "]",
  },
}

local Git = {
  condition = function(self)
    return vim.fn["gin#component#branch#unicode"]() ~= ""
  end,
  {
    provider = " "
  },
  {
    provider = function(self)
      return vim.fn["gin#component#branch#unicode"]()
    end,
    hl = {bold = true},
  },
  hl = { fg = "flamingo", bg = "mantle" },
  update = {
    "User GinComponentPost", "BufEnter"
  }
}

local Ruler = {
  provider = "%7(%l/%3L%):%2c %P",
  hl = {fg = "flamingo"},
}

local StatusLine = {
  {utils.surround({ "", "" }, "crust", { ViMode, SkkMode, ShowCmd }), hl = {bg = "mantle"}},
  Space,
  Diagnostics,
  Space,
  FileNameBlock,
  Space,
  -- Git,
  Align,
  {utils.surround({ "", "" }, "crust", {FileType, Space, FileEncoding}), hl = {bg = "mantle"}},
  Space,
  {utils.surround({ "", "" }, "crust", Ruler), hl = {bg = "mantle"}},
}


heirline.setup({ statusline = StatusLine })
