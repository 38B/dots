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
    shellAliases = {
      hypr = "Hyprland -c ~/.local/etc/hypr/hyprland.conf";
    };
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
    ];
  };

  programs.git = {
    enable = true;
    userName = "Thirty Eighth and Brunswick";
    userEmail = "86792483+38B@users.noreply.github.com";
  };

  programs.librewolf = {
    enable = true;
    settings = {
      "webgl.disabled" = false;
    };
  };

  imports = [
    ../../modules/home-manager/desktops/hyprland.nix
  ];
}
