{ nixpkgs ? import ./z/etc/lib/nixpkgs.nix
}:
let
  inherit (nixpkgs) pkgs;
  inherit (pkgs) mkYarnPackage yarn2nix;
  inherit (yarn2nix) mkYarnModules;
in {
  fos.serverless.package = mkYarnPackage {
    name = "fos-serverless";
    src = ../.;
    packageJSON = ../package.json;
    yarnLock = ../yarn.lock;
  };
  fos.serverless.modules = mkYarnModules {
    name = "fos-serverless-dependencies";
    packageJSON = ../package.json;
    yarnLock = ../yarn.lock;
  };
}
