{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  bison,
  flex,
  gitUpdater,
  gmp,
  gtk3,
  pkg-config,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpsolve";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "robol";
    repo = "MPSolve";
    rev = "de7ebfc7afc4834a0c9f92a04be7abdf5943d446";
    hash = "sha256-BGXvNxWUbto0yMIpEIxZ9wOYv9w0ev4OgVcniNYIKoU=";
  };

  patches = [
    (fetchpatch {
      name = "include-cmath-in-c++-before-defining-isnan-macro.patch";
      url = "https://github.com/robol/MPSolve/commit/260432c9d1002261f60159d0520af7862d4471ed.patch";
      hash = "sha256-ODWpp966S1SsSN8hf7yuYgJR44GgbLwSxui280WWGmM=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    gmp
    gtk3
    libsForQt5.qtbase
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://numpi.dm.unipi.it/scientific-computing-libraries/mpsolve/";
    description = "Multiprecision Polynomial Solver";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kilianar ];
    mainProgram = "mpsolve";
  };
})
