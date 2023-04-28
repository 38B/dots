{ lib, config, pkgs, ... }:
{
  imports = [ 
    ./nixos.nix
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

  boot = {
    kernelModules = [ "kvm-amd" "r8169" ];
    blacklistedKernelModules = [ "rtw88_8822ce" "btusb" ]; 
    kernelParams = [ "elevator=none" "radeon.si_support=0" "amdgpu.si_support=1" ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "ahci" "usb_storage" "uas" "sd_mod" ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          hostKeys = [ /keystore/sippet/id_sippet_init ];
          authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmo4gVcs6I/wmpjURsZNVo63/nRfdp80rZv4wxg8Y2y" ];
          port = 2223;
        };
        udhcpc.extraArgs = [ "-t 10" ];
      };
      kernelModules = [ "amdgpu" "r8169" ];
      postDeviceCommands = lib.mkAfter ''
        zfs rollback -r sippet-os/ephemeral/slash@blank
      '';
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "zfs" "ntfs" ];
    zfs.devNodes = "/dev/disk/by-label/sippet-os";
  }; 

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
