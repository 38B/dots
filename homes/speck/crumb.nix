{ lib, config, pkgs, ... }:
{
  programs.home-manager.enable = true;
  programs.zsh = { 
    enable = true;
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignorePatterns = [ "sudo shutdown *" "exit" ];
      ignoreSpace = true;
      path = "$HOME/.local/share/zsh/zsh_history";
    };
    historySubstringSearch.enable = true;
  };

  xdg = {
    enable = true;
    cacheHome = "/.local/run/";
    configHome = "$HOME/.local/etc/";
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
