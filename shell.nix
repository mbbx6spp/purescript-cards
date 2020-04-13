{ nixpkgs ? import ./z/etc/lib/nixpkgs.nix
}: let
  inherit (nixpkgs) pkgs;
  inherit (pkgs) yarn purescript nodejs-12_x mkShell awscli aws-sam-cli entr spago;
  root = builtins.toPath ./..;
in mkShell {
  buildInputs = [
    (yarn.override { nodejs = nodejs-12_x; })
    nodejs-12_x
    awscli
    aws-sam-cli
    purescript
    entr
    spago
  ];

  shellHook = ''
    export PATH="$(yarn bin):$PATH"
    echo "$(node --version | sed 's/^v//g')" > .nvmrc

    if [ -d "${root}/node_modules" ]; then
      rm -rf "${root}/node_modules"
    else if [ -L "${root}/node_modules" ]; then
      rm -f "${root}/node_modules"
    fi
  '';
}
