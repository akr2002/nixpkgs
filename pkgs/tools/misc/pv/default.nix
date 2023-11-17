{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "pv";
  version = "1.8.0";

  src = fetchurl {
    url = "https://www.ivarch.com/programs/sources/pv-${version}.tar.gz";
    sha256 = "sha256-XOxPc3gmoO3atHHdO3Wlh70poufPowBo1X8pQ5olH98=";
  };

  meta = {
    homepage = "https://www.ivarch.com/programs/pv.shtml";
    description = "Tool for monitoring the progress of data through a pipeline";
    license = lib.licenses.artistic2;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.all;
  };
}
