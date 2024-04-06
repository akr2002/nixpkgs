{ autoreconfHook
, fetchFromGitHub
, lib
, nix-update-script
, openssl
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "gensio";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GmVekTySfSOIWkKLdVuhhtJFQBBBfHBj410jNUfSrkc=";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  configureFlags = [
    "--with-python=no"
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = lib.optionals stdenv.isDarwin [ openssl ];

  meta = with lib; {
    description = "General Stream I/O";
    homepage = "https://sourceforge.net/projects/ser2net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ emantor ];
    mainProgram = "gensiot";
    platforms = platforms.unix;
  };
}
