{fetchPypi, buildPythonPackage, setuptools,
pandas, certifi, ...}: buildPythonPackage rec {
  pname = "ucimlrepo";
  version = "0.0.7";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TP8/noFDZ91glW2pmazkcxlyN7n85MB+mmied7T/tZo=";
  };
  build-system = [setuptools];
  dependencies = [pandas certifi];
}
