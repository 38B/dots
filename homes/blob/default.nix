{ self, inputs, lib, ... }:
{
  users.users.blob = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [ "/keystore/blob/id_blob.pub" ];
    hashedPassword =  lib.strings.fileContents /keystore/blob/passhash;
  };
}
