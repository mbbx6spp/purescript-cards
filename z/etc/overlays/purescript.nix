self: super:
let
  purescriptSrcs = pname: version: {
    darwin = self.fetchurl {
      url = "https://github.com/${pname}/${pname}/releases/download/v${version}/macos.tar.gz";
      sha256 = "04kwjjrriyizpvhs96jgyx21ppyd1ynblk24i5825ywxlw9hja25";
    };
    linux64 = self.fetchurl {
      url = "https://github.com/${pname}/${pname}/releases/download/v${version}/linux64.tar.gz";
      sha256 = "012znrj32aq96qh1g2hscdvhl3flgihhimiz40agk0dykpksblns";
    };
  };
  spagoSrcs = {
    darwin = self.fetchurl {
      url = "https://github.com/spacchetti/spago/releases/download/0.14.0/osx.tar.gz";
      sha256 = "16xdawfq9x75isdsj7ixrs3rq2h4j2wvacpbfhpa2d7s3n1j6lal";
    };
    linux64 = self.fetchurl {
      url = "https://github.com/spacchetti/spago/releases/download/0.14.0/linux.tar.gz";
      sha256 = "0bqpns70ik55wb5vahmrpaz480bm9nhq87iq57aj74w6v52qi3bv";
    };
  };
  spago = let
    patchelf = binPath: libPath: if super.stdenv.isDarwin
    then ""
    else ''
      chmod u+w ${binPath}
      patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath ${libPath} ${binPath}
      chmod u-w ${binPath}
    '';
  in super.stdenv.mkDerivation rec {
    name = "spago";
    version = "0.14.0";
    src = if super.stdenv.isDarwin then spagoSrcs.darwin else spagoSrcs.linux64;
    buildInputs = with super; [ gmp zlib ncurses5 stdenv.cc.cc.lib ];
    libPath = super.lib.makeLibraryPath buildInputs;
    dontStrip = true;
    unpackPhase = ''
      mkdir -p $out/bin
      tar xf $src -C $out/bin

      SPAGO=$out/bin/spago
      ${patchelf "$out/bin/spago" libPath}

      mkdir -p $out/etc/bash_completion.d/
      $SPAGO --bash-completion-script $SPAGO > $out/etc/bash_completion.d/spago-completion.bash
    '';

    dontInstall = true;
  };
in {
  inherit spago;
  purescript = super.purescript.overrideAttrs (oldAttrs: rec {
    pname = "purescript";
    version = "0.13.6";
    src = if self.stdenv.isDarwin
          then (purescriptSrcs pname version).darwin
          else (purescriptSrcs pname version).linux64;
  });
}
