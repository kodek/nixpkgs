{
  buildNpmPackage,
  src,
  version,
  ...
}:
buildNpmPackage (finalAttrs: {
  pname = "zeroclaw-web";
  inherit src version;

  sourceRoot = "${finalAttrs.src.name}/web";

  npmDepsHash = "sha256-DVL9kov8y1Eh3BM2Rpw+KbTDL6/AvT/epknM2X/Gf3E=";

  patches = [ ./add-api-generated-stub.patch ];

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';
})
