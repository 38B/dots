{ self, inputs, lib, ... }:
{
  users.users.muck = {
    isNormalUser = true;
    uid = 1337;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keyFiles = [ "/persist/keystore/muck/id_muck.pub" ];
    hashedPassword =  lib.strings.fileContents /persist/keystore/muck/passhash;
  };
}
