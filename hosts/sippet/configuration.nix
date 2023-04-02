{ lib, config, pkgs, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
      ../../homes/blob
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sippet";
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "New_York/America";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "sun12x22";
    earlySetup = true;
  };

  services.xserver.enable = false;
  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.systemPackages = with pkgs; [
    neovim 
    file
    wget
    curl
    btop
    lsof
    tmux
    rsync
    git
    pinentry
    pinentry-curses
    cryptsetup
    gnupg
    which
    tomb
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
      path = "/persist/keystore/sippet/id_sippet";
      type = "ed25519";
    }];
  };

  # Passwordless sudo when SSH'ing with keys
  security.pam.enableSSHAgentAuth = true;

  system.stateVersion = "23.05";
  
  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  networking.hostId = "db27bd4b";
  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [ "elevator=none" "radeon.si_support=0" "amdgpu.si_support=1" ];
  boot.zfs.devNodes = "/dev/disk/by-label/zroot";
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r zroot/ephemeral/slash@blank
  '';

  zramSwap = {
    enable = true;
    swapDevices = 1;
  };

}

