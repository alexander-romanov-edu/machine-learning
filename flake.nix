{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux"];
    ucimlrepo = ps: ps.callPackage ./pkgs/ucimplrepo.nix {};
    systemDependent = flake-utils.lib.eachSystem systems (system: let
      pkgs = import nixpkgs {
        inherit system;
      };

      pythonEnv =
        pkgs.python3.withPackages
        (pyPkgs:
          with pyPkgs; [
            jupyter
            ipywidgets
            ipython
            ipympl
            imageio
            numpy
            scipy
            pandas
            scikit-learn
            seaborn
            statsmodels
            matplotlib
            black
            autopep8
            numba
            av
            torch
            sympy
          ] ++ [(ucimlrepo pyPkgs)]);

      envPackages = with pkgs; [
        pythonEnv
        bashInteractive
        coreutils
        nodePackages.pyright
        ffmpeg
      ];

      jupyterRunScript = pkgs.writeShellScriptBin "jupyter-run" ''
        ${pythonEnv}/bin/jupyter lab --no-browser --ip 0.0.0.0
      '';
    in {
      packages = {
        inherit jupyterRunScript;
        ucimplrepo = ucimlrepo pkgs.python3Packages;
      };

      apps.default = {
        type = "app";
        program = "${jupyterRunScript}/bin/jupyter-run";
      };

      devShells.default = pkgs.mkShell {
        packages = envPackages;
      };
    });
  in
    systemDependent;
}


