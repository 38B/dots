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
      path = "~/.local/share/zsh/zsh_history";
    };
    historySubstringSearch.enable = true;
  };

  xdg = {
    enable = true;
    cacheHome = "${config.home.homeDirectory}/.local/run";
    configHome = "~/.local/etc";
  };

  home = {
    username = "speck";
    homeDirectory = "/home/speck";
    stateVersion = "23.05";
    packages = with pkgs; [ 
      neofetch
    ];
  };

  imports = [ ];
}
