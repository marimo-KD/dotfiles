{ pkgs, config, ... }:
{
  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = true;
      vimAlias = true;

      lsp = {
        enable = true;

        lspSignature.enable = !config.programs.nvf.autocomplete.blink-cmp.enable;
      };

      debugger = {
        nvim-dap = {
          enable = true;
          ui.enable = true;
        };
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
      };

      visuals = {
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;
        indent-blankline.enable = true;
      };

      statusline.lualine = {
        enable = true;
        theme = "catppuccin";
      };

      theme = {
        enable = true;
        theme = "catppuccin";
        style = "mocha";
        transparent = false;
      };

      autocomplete.blink-cmp.enable = true;

      treesitter.context.enable = true;

      binds = {
        WhichKey.enable = true;
        cheatsheet.enable = true;
      };

      telescope.enable = true;

      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false;
        neogit.enable = true;
      };

      notify = {
        nvim-notify.enable = true;
      };

      utility = {
        motion = {
          leap.enable = true;
        };
        images = {
          image-nvim.enable = true;
        };
      };

      ui = {
        borders.enable = true;
        noice.enable = true;
        colorizer.enable = true;
        fastaction.enable = true;
      };
    };
  };
}
