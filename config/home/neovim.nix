{ programs, theme, pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    colorschemes."${theme}".enable = true;

    globals.mapleader = " ";

    options = {
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
      oil.enable = true;
      neo-tree.enable = true;
      lint = {
        enable = true;
        lintersByFt = {
          javascript = [ "eslint" ];
          typescript = [ "eslint" ];
          javascriptreact = [ "eslint" ];
          typescriptreact = [ "eslint" ];
          svelte = [ "eslint" ];
          css = [ "stylelint" ];
          html = [ "stylelint" ];
          json = [ "jsonlint" ];
          yaml = [ "yamllint" ];
          markdown = [ "markdownlint" ];
          graphql = [ "eslint" ];
          lua = [ "luacheck" ];
          python = [ "flake8" ];
        };
      };
      lsp = {
        enable = true;
        servers = {
          tsserver.enable = true;
          lua-ls = {
            enable = true;
            settings.telemetry.enable = false;
          };
          rnix-lsp.enable = true;
        };
      };
      lsp-format.enable = true;
      conform-nvim = {
        enable = true;
        formatOnSave = {
          lspFallback = true;
        };
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
      nvim-cmp = {
        enable = true;
        mapping = {
          "<C-k>" = "cmp.mapping.select_prev_item()";
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<CR>" = ''
            cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            });
          '';
        };
      };
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp-nvim-lua.enable = true;
      cmp-nvim-lsp.enable = true;
      copilot-vim.enable = true;
      lspkind.enable = true;
      treesitter.enable = true;
      tmux-navigator.enable = true;
      lualine = {
        enable = true;
        theme = "${theme}";
      };
      telescope = {
        enable = true;
        extensions = {
          undo.enable = true;
          file_browser.enable = true;
        };
        keymaps = {
          "<C-p>" = {
            action = "find_files";
            desc = "Fuzzy find files in cwd";
          };
          "<leader>fo" = {
            action = "oldfiles";
            desc = "[F]d recently [O]pened files";
          };
          "<leader>fg" = {
            action = "git_files";
            desc = "[F]ind [G]it files";
          };
          "<leader>fw" = {
            action = "live_grep";
            desc = "[F]ind [W]ord";
          };
          "<leader>fs" = {
            action = "grep_string";
            desc = "[F]ind [S]tring";
          };
          "<leader>fd" = {
            action = "diagnostics";
            desc = "[F]ind [D]iagnostics";
          };
          "<C-f>" = "live_grep";
          "<C-b>" = "buffers";
          "<C-h>" = "help_tags";
        };
      };
      git-worktree = {
        enable = true;
        enableTelescope = true;
      };
    };

    keymaps = [
      {
        mode = "i";
        key = "jk";
        action = "<ESC>";
        options.desc = "Exit insert mode with jk";
      }
      {
        mode = "n";
        key = "-";
        action = "<cmd>Oil<CR>";
        options.desc = "Open parent directory";
      }
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<CR>";
        options.desc = "Open lazygit";
      }
      {
        mode = "n";
        key = "<leader>ee";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle file explorer";
      }
      {
        mode = "n";
        key = "<leader>ef";
        action = "<cmd>Neotree reveal<CR>";
        options.desc = "Reveal file in explorer";
      }
    ];

    extraConfigLua = ''
      -- Telescope extra mapping
      vim.keymap.set(
        "n",
        "<leader>gw",
        require("telescope").extensions.git_worktree.git_worktrees,
        { desc = "Open [G]it [W]orktree" }
      )
      vim.keymap.set(
        "n",
        "<leader>gn",
        require("telescope").extensions.git_worktree.create_git_worktree,
        { desc = "[G]it [N]ew Branch" }
      )
      vim.keymap.set(
        "n",
        "<leader>pv",
        require("telescope").extensions.file_browser.file_browser,
        { desc = "Open find browser" }
      )

    '';

    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = vim-dadbod-ui;
        config = ''
          lua vim.g.db_ui_use_nerd_fonts = 1
        '';
      }
      {
        plugin = vim-dadbod-completion;
        config = ''
          
        '';
      }
      {
        plugin = vim-dadbod;
        config = ''
        '';
      }

      {
        plugin = lazygit-nvim;
        config = ''
        '';
      }

    ];
  };
}
