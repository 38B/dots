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
