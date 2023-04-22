{ lib, config, pkgs, ...}:
{
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [ "elevator=none" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" "ntfs" ];
  boot.zfs.devNodes = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b444a494a69d2-part3";
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r zroot/ephemeral/slash@blank
  '';
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "zroot/ephemeral/slash";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0BBD-D5CF";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    { device = "zroot/ephemeral/nix";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "zroot/ephemeral/home";
      fsType = "zfs";
    };
    
  fileSystems."/home/speck/Desktop" =
    { device = "zroot/eternal/desktops/speck";
      fsType = "zfs";
    };

  fileSystems."/home/muck/Desktop" =
    { device = "zroot/eternal/desktops/muck";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    { device = "zroot/eternal/persist";
      fsType = "zfs";
      neededForBoot = true;
    };

  zramSwap = {
    enable = true;
    swapDevices = 1;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  powerManagement.cpuFreqGovernor = "powersave";

  hardware.opengl.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    libvdpau-va-gl
    intel-media-driver
  ];

  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };

  services.thermald.enable = true;  
}
