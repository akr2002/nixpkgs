# This file was generated by pkgs.mastodon.updateScript.
{ fetchFromGitHub, applyPatches }: let
  src = fetchFromGitHub {
    owner = "mastodon";
    repo = "mastodon";
    rev = "v4.1.5";
    hash = "sha256-1bWrKcw+EQyu7WBujR5sptiUOjbhJvIM76h9jcX24jw=";
  };
in applyPatches {
  inherit src;
  patches = [];
}
