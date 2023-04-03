{ self, inputs, ... }:
{
  users.users.blob = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [ "/persist/keystore/blob/id_blob.pub" ];
    hashedPassowrd =  lib.strings.fileContents /persist/keystore/blob/passhash;
  };
}
