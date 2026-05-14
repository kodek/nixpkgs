{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "enturclient";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hfurubotten";
    repo = "enturclient";
    rev = "v${version}";
    hash = "sha256-83ui1BYqiRr+IwaJeXNppMnOTQCF9uJD5Kus93CDsUA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  pythonRelaxDeps = [
    "async_timeout"
  ];

  pythonImportsCheck = [ "enturclient" ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  unittestFlagsArray = [
    "tests/dto/"
  ];

  meta = {
    description = "Python library for interacting with the Entur.org API";
    homepage = "https://github.com/hfurubotten/enturclient";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
