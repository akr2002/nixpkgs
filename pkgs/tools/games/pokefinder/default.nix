{ lib
, stdenv
, copyDesktopItems
, makeDesktopItem
, fetchFromGitHub
, cmake
, qtbase
, qttools
, qtwayland
, imagemagick
, wrapQtAppsHook
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "pokefinder";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "Admiral-Fish";
    repo = "PokeFinder";
    rev = "v${version}";
    sha256 = "fYBeWc9eYLbj4+ku1jwaO5ISL8a7WJnBHJ4qz4W8RHA=";
    fetchSubmodules = true;
    # the repo has identical cmake and CMake folders, causing issues on macOS
    postFetch = if stdenv.isDarwin then ''
    mv $out/cmake $out/cmake.tmp
    mv $out/cmake.tmp $out/CMake
    '' else ''
    rm -rf $out/cmake
    '';
  };

  patches = [ ./set-desktop-file-name.patch ];

  postPatch = ''
    patchShebangs Source/Core/Resources/
  '';

  installPhase = ''
    runHook preInstall
  '' + lib.optionalString (stdenv.isDarwin) ''
    mkdir -p $out/Applications
    cp -R Source/PokeFinder.app $out/Applications
  '' + lib.optionalString (!stdenv.isDarwin) ''
    install -D Source/PokeFinder $out/bin/PokeFinder
    mkdir -p $out/share/pixmaps
    convert "$src/Source/Form/Images/pokefinder.ico[-1]" $out/share/pixmaps/pokefinder.png
  '' + ''
    runHook postInstall
  '';

  nativeBuildInputs = [ cmake wrapQtAppsHook ] ++ lib.optionals (!stdenv.isDarwin) [ copyDesktopItems imagemagick ];

  desktopItems = [
    (makeDesktopItem {
      name = "pokefinder";
      exec = "PokeFinder";
      icon = "pokefinder";
      comment = "Cross platform Pokémon RNG tool";
      desktopName = "PokéFinder";
      categories = [ "Utility" ];
    })
  ];

  buildInputs = [ qtbase qttools ]
    ++ lib.optionals stdenv.isLinux [ qtwayland ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    homepage = "https://github.com/Admiral-Fish/PokeFinder";
    description = "Cross platform Pokémon RNG tool";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ leo60228 ];
  };
}
