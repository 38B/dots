{ lib, config, pkgs, ... }:
{
  programs.home-manager.enable = true;
  programs.zsh = { 
    enable = true;
    setOptions = [
      "HIST_EXPIRE_DUPS_FIRST"
      "HIST_VERIFY"
    ];
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
