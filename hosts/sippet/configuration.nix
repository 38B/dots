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
  networking.networkmanager.unmanaged = [ "wlp3s0" ];

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

  networking.hostId = "3f871983";
  boot.supportedFilesystems = [ "zfs" "ntfs" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [ "elevator=none" "radeon.si_support=0" "amdgpu.si_support=1" ];
  boot.zfs.devNodes = "/dev/disk/by-label/sippet-os";
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r sippet-os/ephemeral/slash@blank
  '';

  zramSwap = {
    enable = true;
    swapDevices = 1;
  };

  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  documentation.enable = true;
  documentation.nixos.enable = false;
  documentation.man.enable = true;
  documentation.info.enable = false;
  documentation.doc.enable = false;

  # Don't wait for network startup
  # https://old.reddit.com/r/NixOS/comments/vdz86j/how_to_remove_boot_dependency_on_network_for_a
  systemd = {
    targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
    services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce []; # Normally ["network-online.target"]
  };

}

