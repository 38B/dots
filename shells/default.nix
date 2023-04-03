{ inputs, ... }:
{
  perSystem = { inputs', pkgs, config, ... }:
  {
    devShells.default = pkgs.mkShellNoCC {
      NIX_CONFIG = "experimental-features = nix-command flakes";
      nativeBuildInputs = with pkgs; [ nix home-manager git age gnupg sops ssh-to-pgp ssh-to-age ];
    };
  };
}
