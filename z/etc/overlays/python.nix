self: super:
let
  overridePyPkg = pkg: version: sha256: pkg.overridePythonAttrs (old: rec {
    src = super.fetchPypi {
      pname = old.pname;
      inherit version sha256;
    };
  });
  packageOverrides = self: super: {
    arrow = overridePyPkg super.arrow "0.15.2" "crap";
  };

  python3 = super.python3.override {
    inherit packageOverrides;
    self = python3;
  };

  python = python3;
in {
  inherit python;
  pythonPackages = python3.packages;
  python3Packages = python3.packages;
}
