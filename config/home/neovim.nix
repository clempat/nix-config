{programs, theme, ...}:
{
  programs.nixvim = {
    enable = true;
    colorschemes."${theme}".enable = true;

    options= {
      nu = true;
      relativenumber = true;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      swapfile = false;
      backup = false;
      undofile = true;
      hlsearch = false;
      incsearch = true;
      scrolloff = 8;
      signcolumn = "yes";
      updatetime = 50;
      colorcolumn = "80";
      cursorline = false;
      termguicolors = true;
      winblend = 0;
      wildoptions = "pum";
      pumblend = 30;
      background = "dark";
      splitbelow = true;
      timeoutlen = 500;
    };

    plugins = {
      conform-nvim= {
        enable = true;
        formatOnSave = {};
        formattersByFt = {
          javascript = [ "prettier" ];
          typescript = [ "prettier" ];
          javascriptreact = [ "prettier" ];
          typescriptreact = [ "prettier" ];
          svelte = [ "prettier" ];
          css = [ "prettier" ];
          html = [ "prettier" ];
          json = [ "prettier" ];
          yaml = [ "prettier" ];
          markdown = [ "prettier" ];
          graphql = [ "prettier" ];
          lua = [ "stylua" ];
          python = [ "isort" "black" ];
        };
      };
      nvim-autopairs = {
        enable = true;
        checkTs = true;
        tsConfig = {
          lua = "string";
          javascript = "template_string";
          java = false;
        };
      };
      nvim-colorizer.enable = true;
      comment-nvim.enable = true;
      nvim-cmp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp-nvim-lua.enable = true;
      cmp-nvim-lsp.enable = true;
      copilot-vim.enable = true;
      lspkind.enable = true;
      treesitter.enable = true;
      lualine = {
        enable = true;
        theme = "${theme}";
      };
      telescope = {
        enable = true;
        keymaps = {
          "<C-p>" = "find_files";
          "<C-f>" = "live_grep";
          "<C-b>" = "buffers";
          "<C-h>" = "help_tags";
        };
      };
    };

    keymaps = [
    {
      mode = "i";
      key = "jk";
      action = "<ESC>";
      options.desc = "Exit insert mode with jk";
    }
    ];

    extraConfigLua = ''

    '';
  };
}
