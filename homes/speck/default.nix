{ self, inputs, lib, ... }:
{
  users.users.speck = {
    isNormalUser = true;
    uid = 1111;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keyFiles = [ "/persist/keystore/speck/id_speck.pub" ];
    hashedPassword =  lib.strings.fileContents /persist/keystore/speck/passhash;
    shell = pkgs.zsh;
  };
}
