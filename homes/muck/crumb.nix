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
    extraLuaConfig = ''
      local opt = vim.opt

      opt.expandtab = true
      opt.shiftwidth = 2
      opt.smartindent = true
      opt.tabstop = 2
      opt.softtabstop = 2
    '';
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



  imports = [ ];
}
