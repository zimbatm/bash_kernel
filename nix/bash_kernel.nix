{ lib
, buildPythonPackage
, pexpect
, ipykernel
}:
buildPythonPackage rec {
  pname = "bash_kernel";
  version = "0.7.1";
  name = "${pname}-${version}";
  format = "flit";

  src = builtins.filterSource (path: type: (builtins.baseNameOf path) != "nix") ../.;

  propagatedBuildInputs = [ ipykernel pexpect ];

  doCheck = false;

  preBuild = ''
    mkdir tmp
    export HOME=$PWD/tmp
  '';

  postInstall = ''
    python -m bash_kernel.install --prefix $out
  '';

  meta = {
    description = "Bash Kernel for Jupyter";
    homepage = "https://github.com/takluyver/bash_kernel";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
}
