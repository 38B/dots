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
    completionInit = "compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION";
    dotDir = "${config.home.homeDirectory}/.local/etc/zsh";
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

  options.wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      bind = $mainMod, Q, exec, foot,
    '';
  };

  imports = [ ];
}
