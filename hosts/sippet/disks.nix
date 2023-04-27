{ config, ... }:
{ 
  fileSystems."/" =
    { device = "sippet-os/ephemeral/slash";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/26A8-0C7E";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    { device = "sippet-os/ephemeral/nix";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "sippet-os/ephemeral/home";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    { device = "sippet-os/eternal/persist";
      fsType = "zfs";
    };

  fileSystems."/keystore" =
    { device = "sippet-os/ephemeral/keystore";
      fsType = "zfs";
    };

  zramSwap = {
    enable = true;
    swapDevices = 1;
  };

}
