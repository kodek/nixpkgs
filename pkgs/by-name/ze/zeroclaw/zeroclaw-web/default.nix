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

  # api-generated.ts is normally produced by `cargo web gen-api` which runs
  # the Rust gateway binary to emit an OpenAPI spec and pipes it through
  # openapi-typescript. Since we can't run the gateway during the web build,
  # provide a minimal stub — the re-exported types are compile-time only and
  # do not affect the runtime bundle.
  preBuild = ''
    cat > src/lib/api-generated.ts << 'STUB'
    export type paths = Record<string, never>;
    export type components = Record<string, never>;
    STUB
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';
})
