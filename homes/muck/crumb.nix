{ lib, config, pkgs, ... }:
{
  programs.home-manager.enable = true;

  home = {
    username = "muck";
    homeDirectory = "/home/muck";
    stateVersion = "23.05";
    packages = with pkgs; [ 
      neofetch
      kmymoney
      godot
      luakit
    ];
  };

  programs.zsh = { 
    enable = true;
    setOptions = [
      "HIST_EXPIRE_DUPS_FIRST"
    ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraLuaConfig = ''
      local opt = vim.opt

      opt.expandtab = true
      opt.shiftwidth = 2
      opt.smartindent = true
      opt.tabstop = 2
      opt.softtabstop = 2

      require("lazy").setup({
        { "folke/which-key.nvim", 
           config = function()
             vim.o.timeout = true
             vim.o.timeoutlen = 300
             require("which-key").setup({
               -- your configuration comes here
               -- or leave it empty to use the default settings
               -- refer to the configuration section below
             })
           end,
        },
        { "akinsho/toggleterm.nvim",
          version = "*",
          config = function()
            require("toggleterm").setup({
              open_mapping = [[<c-\>]],
            })
          end,
        },
        { "nvim-neo-tree/neo-tree.nvim",
          branch = "v2.x",
          requires = { 
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
          },
          config = function()
            vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
            require("neo-tree").setup({
              close_if_last_window = false,
              vim.api.nvim_set_keymap( "n", "<C-n>", "<cmd> NeoTreeFocusToggle <CR>", {}),
              vim.api.nvim_set_keymap( "n", "<leader>e", "<cmd> NeoTreeFocus <CR>", {}),
              filesystem = {
                hijack_netrw_behavior = "open_current",
              },
            })
          end,
	      },
        { "jackMort/ChatGPT.nvim",
           event = "VeryLazy",
           config = function()
             require("chatgpt").setup({
               yank_register = "+",
               edit_with_instructions = {
                 diff = false,
                 keymaps = {
                   accept = "<C-y>",
                   toggle_diff = "<C-d>",
                   toggle_settings = "<C-o>",
                   cycle_windows = "<Tab>",
                   use_output_as_input = "<C-i>",
                 },
               },
               chat = {
                 welcome_message = WELCOME_MESSAGE,
                 loading_text = "Loading, please wait ...",
                 question_sign = "", -- 🙂
                 answer_sign = "ﮧ", -- 🤖
                 max_line_length = 120,
                 sessions_window = {
                   border = {
                     style = "rounded",
                     text = {
                       top = " Sessions ",
                     },
                   },
                   win_options = {
                     winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                   },
                 },
                 keymaps = {
                   close = { "<C-c>" },
                   yank_last = "<C-y>",
                   yank_last_code = "<C-k>",
                   scroll_up = "<C-u>",
                   scroll_down = "<C-d>",
                   toggle_settings = "<C-o>",
                   new_session = "<C-n>",
                   cycle_windows = "<Tab>",
                   select_session = "<Space>",
                   rename_session = "r",
                   delete_session = "d",
                 },
               },
               popup_layout = {
                 relative = "editor",
                 position = "50%",
                 size = {
                   height = "80%",
                   width = "80%",
                 },
               },
               popup_window = {
                 filetype = "chatgpt",
                 border = {
                   highlight = "FloatBorder",
                   style = "rounded",
                   text = {
                     top = " ChatGPT ",
                   },
                 },
                 win_options = {
                   winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                 },
               },
               popup_input = {
                 prompt = "  ",
                 border = {
                   highlight = "FloatBorder",
                   style = "rounded",
                   text = {
                     top_align = "center",
                     top = " Prompt ",
                   },
                 },
                 win_options = {
                   winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                 },
                 submit = "<C-m>",
               },
               settings_window = {
                 border = {
                   style = "rounded",
                   text = {
                     top = " Settings ",
                   },
                 },
                 win_options = {
                   winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
                 },
               },
               openai_params = {
                 model = "gpt-3.5-turbo",
                 frequency_penalty = 0,
                 presence_penalty = 0,
                 max_tokens = 300,
                 temperature = 0,
                 top_p = 1,
                 n = 1,
               },
               openai_edit_params = {
                 model = "code-davinci-edit-001",
                 temperature = 0,
                 top_p = 1,
                 n = 1,
               },
               actions_paths = {},
               predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
             })
           end,
           dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim"
           },
        },
        { "nvim-telescope/telescope.nvim",
          tag = "0.1.1",
          dependencies = { "nvim-lua/plenary.nvim" }
        },
      })
    '';
    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      lazy-nvim
      toggleterm-nvim
      which-key-nvim
      neo-tree-nvim
      nvim-web-devicons
      nui-nvim
      ChatGPT-nvim
    ];
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "monospace:size=12";
	pad = "12x12";
      };
      colors = {
        alpha = "1.0";
        foreground = "78796f";
        background = "373b43";
        regular0 = "373b43";
        bright0 = "373b43";
        regular1 = "fdcd39";
        bright1 = "fdcd39";
        regular2 = "fbfd59";
        bright2 = "fbfd59";
        regular3 = "deac40";
        bright3 = "deac40";
        regular4 = "afb171";
        bright4 = "afb171";
        regular5 = "b387e7";
        bright5 = "b387e7";
        regular6 = "63e860";
        bright6 = "63e860";
        regular7 = "efdecb";
        bright7 = "efdecb";
      };
    };
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    aggressiveResize = true;
    escapeTime = 0;
    prefix = "`";
    keyMode = "vi";
    extraConfig = ''
      # vi bindings for pane resizing
      bind -r H resize-pane -L 2
      bind -r J resize-pane -D 2
      bind -r K resize-pane -U 2
      bind -r L resize-pane -R 2
      set -g status-style 'bg=colour8 fg=colour0 dim'
      set -g status-left-length 30
      set -g status-justify centre
      set -g status-left '#[fg=colour8,bg=colour0]◱ #[fg=colour9,bg=colour0]#I/#{last_window_index}#[fg=colour8,bg=colour0]▹ #[fg=colour9,bg=colour0]#W #[fg=colour8,bg=colour0]░▒#[fg=colour0,bg=colour8]░'
      set -g status-right-length "100"
      set -g status-right '░▒#[fg=colour8,bg=colour0]░  %a %B %-d, %Y'
      set -g pane-border-style 'fg=colour3 bg=colour0'
      set -g pane-active-border-style 'bg=colour0 fg=colour9'
      set -g window-status-format ""
      set -g window-status-separator ""
      setw -g window-status-current-style ""
      setw -g window-status-current-format ""
      setw -g monitor-activity on
      set -g visual-activity on
      tmux_conf_theme_window_status_format='#I #W#{?window_bell_flag,🔔,}#{?window_zoomed_flag,🔍,}'
    '';
  };

  programs.broot.enable = true;

}
