{ lib, config, pkgs, hyprland, ... }:
{
  programs.home-manager.enable = true;
  programs.zsh = { 
    enable = true;
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignorePatterns = [ "sudo shutdown *" "exit" ];
      ignoreSpace = true;
      path = "${config.home.homeDirectory}/.local/share/zsh/zsh_history";
    };
    historySubstringSearch.enable = true;
    completionInit = "autoload -U compinit && compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION";
    dotDir = ".local/etc/zsh";
  };

  xdg = {
    enable = true;
    cacheHome = "${config.home.homeDirectory}/.local/run";
    configHome = "${config.home.homeDirectory}/.local/etc";
  };

  home = {
    username = "speck";
    homeDirectory = "/home/speck";
    stateVersion = "23.05";
    packages = with pkgs; [ 
      neofetch
      qutebrowser
    ];
  };

  programs.git = {
    enable = true;
    userName = "Thirty Eighth and Brunswick";
    userEmail = "86792483+38B@users.noreply.github.com";
  };

  services.syncthing.enable = true;

  imports = [
    ../../modules/home-manager/desktops/hypr-minimal
    ../../modules/home-manager/editors/nvim.nix
    ../../modules/home-manager/themeing/gtk.nix
  ];
}
