{ lib, stdenv, fetchFromGitHub
, cmake, wrapGAppsHook
, libX11, libzip, glfw, libpng, xorg, gnome
}:

stdenv.mkDerivation rec {
  pname = "tev";
  version = "1.26";

  src = fetchFromGitHub {
    owner = "Tom94";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-6acFt0fyL0yStUwreGggJ+7Zi+0Fqburj/ytmf+Oi4w=";
  };

  nativeBuildInputs = [ cmake wrapGAppsHook ];
  buildInputs = [ libX11 libzip glfw libpng ]
    ++ (with xorg; [ libXrandr libXinerama libXcursor libXi libXxf86vm libXext ]);

  dontWrapGApps = true; # We also need zenity (see below)

  cmakeFlags = [
    "-DTEV_DEPLOY=1" # Only relevant not to append "dev" to the version
  ];

  postInstall = ''
    wrapProgram $out/bin/tev \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH ":" "${gnome.zenity}/bin"
  '';

  meta = with lib; {
    description = "A high dynamic range (HDR) image comparison tool";
    longDescription = ''
      A high dynamic range (HDR) image comparison tool for graphics people. tev
      allows viewing images through various tonemapping operators and inspecting
      the values of individual pixels. Often, it is important to find exact
      differences between pairs of images. For this purpose, tev allows rapidly
      switching between opened images and visualizing various error metrics (L1,
      L2, and relative versions thereof). To avoid clutter, opened images and
      their layers can be filtered by keywords.
      While the predominantly supported file format is OpenEXR certain other
      types of images can also be loaded.
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/Tom94/tev/releases/tag/v${version}";
    license = licenses.bsd3;
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # needs apple frameworks + SDK fix? see #205247
    maintainers = with maintainers; [ ];
  };
}
