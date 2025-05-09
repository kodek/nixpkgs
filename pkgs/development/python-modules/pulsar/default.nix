{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  cmake,
  pkg-config,
  libpulsar,
  pybind11,
  certifi,
}:

buildPythonPackage rec {
  pname = "pulsar";
  version = "3.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "pulsar-client-python";
    tag = "v${version}";
    hash = "sha256-KdPLp0BmZnobU4F6tuMj2DY/ya4QHeGcM/eEAivoXNI=";
  };

  disabled = pythonOlder "3.7";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libpulsar
    pybind11
  ];

  preBuild = ''
    make -j$NIX_BUILD_CORES
    make install
    cd ..
  '';

  propagatedBuildInputs = [ certifi ];

  # Requires to setup a cluster
  doCheck = false;

  pythonImportsCheck = [ "pulsar" ];

  meta = with lib; {
    description = "Apache Pulsar Python client library";
    homepage = "https://pulsar.apache.org/docs/next/client-libraries-python/";
    changelog = "https://github.com/apache/pulsar-client-python/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ gaelreyrol ];
  };
}
