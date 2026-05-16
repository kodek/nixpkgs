{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dblab";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "danvergara";
    repo = "dblab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0tkIDWAub+wfoJ760m1kU7XYnGNner/zLtCod6UPF60=";
  };

  vendorHash = "sha256-B5wyERNUkJIrKjKET9HX3F43CFW6aBtzAarkAuhxw9o=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  # some tests require network access
  doCheck = false;

  meta = {
    description = "Database client every command line junkie deserves";
    longDescription = ''
      Fast and lightweight interactive terminal-based UI application
      for PostgreSQL, MySQL, SQLite, Oracle, and SQL Server.
    '';
    homepage = "https://github.com/danvergara/dblab";
    changelog = "https://github.com/danvergara/dblab/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "dblab";
  };
})
