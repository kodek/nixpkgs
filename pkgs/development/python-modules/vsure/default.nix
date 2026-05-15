{
  lib,
  buildPythonPackage,
  fetchPypi,
  click,
  requests,
}:

buildPythonPackage rec {
  pname = "vsure";
  version = "2.6.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BdUQB7usj1UwMS4AewUtaWWTl1otamCviX2MF/+x9ic=";
  };

  propagatedBuildInputs = [
    click
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "verisure" ];

  meta = {
    description = "Python library for working with verisure devices";
    mainProgram = "vsure";
    homepage = "https://github.com/persandstrom/python-verisure";
    changelog = "https://github.com/persandstrom/python-verisure#version-history";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
