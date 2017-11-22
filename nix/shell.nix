let
  pkgs = import <nixpkgs> {};

  python3 = pkgs.python3.override {
    packageOverrides = self: super: {
      bash_kernel = super.callPackage ./bash_kernel.nix { };
      pexpect = super.pexpect.overridePythonAttrs(oldAttrs: rec {
        pname = "pexpect";
        version = "4.3.0";
        name = "pexpect-${version}";

        src = super.fetchPypi {
          inherit pname version;
          sha256 = "1nfjmz81gsixv22dywidakm7pff3ly1i4yly950bfp8gz1r0iaq0";
        };

        patches = [(pkgs.fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/pexpect/pexpect/pull/457.patch";
          sha256 = "09a4xib8fxa01snaflw6a0jzvaff8h2svfh4m5069q6cpzp7xjz9";
        })];
      });
    };
  };

  ibash = python3.withPackages (ps: with ps; [
    bash_kernel
    jupyter
  ]);
in
pkgs.stdenv.mkDerivation {
  name = "ibash";
  propagatedNativeBuildInputs = [ ibash ];
}
