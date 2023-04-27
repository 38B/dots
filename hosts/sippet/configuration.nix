{ lib, config, pkgs, ... }:
{
  imports = [ 
    ./nixos.nix
    ./boot.nix
    ./networking.nix
    ./disks.nix
    ../../homes/blob
  ];

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "sun12x22";
    earlySetup = true;
  };

  services.xserver.enable = false;
  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.systemPackages = with pkgs; [
    # Terminal Tools
    neovim 
    tmux
    # File Tools
    file
    lsof
    which
    xz
    lz4
    zstd
    zip
    unzip
    # Download Tools
    wget
    curl
    rsync
    # Performance Monitors
    acpi
    htop
    iotop
    iftop
    # Crypto Tools
    age
    pinentry
    pinentry-curses
    # Browser
    w3m
  ];

  services.openssh = {
    enable = true;
    settings = {
      # Harden
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      GatewayPorts = "clientspecified";
    };
    # Automatically remove stale sockets
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';

    hostKeys = [{
      path = "/keystore/sippet/id_sippet";
      type = "ed25519";
    }];
  };

  # Passwordless sudo when SSH'ing with keys
  security.pam.enableSSHAgentAuth = true;

  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  documentation.enable = true;
  documentation.nixos.enable = false;
  documentation.man.enable = true;
  documentation.info.enable = false;
  documentation.doc.enable = false;
 
  services.logind.extraConfig = ''
    HandleLidSwitch=ignore
    HandleLidSwitchExternalPower=ignore
  '';

}
