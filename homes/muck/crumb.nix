{ lib, config, pkgs, ... }:
{
  programs.home-manager.enable = true;
  programs.zsh.enable = true;

  home = {
    username = "muck";
    homeDirectory = "/home/muck";
    stateVersion = "23.05";
    packages = with pkgs; [ 
      neofetch
      kmymoney
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
    ];
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
      set -g status-left '#[fg=colour8,bg=colour0]◱ #[fg=colour9,bg=colour0]#I#[fg=colour8,bg=colour0]▹ #[fg=colour9,bg=colour0]#W #[fg=colour8,bg=colour0]░▒#[fg=colour0,bg=colour8]░'
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
