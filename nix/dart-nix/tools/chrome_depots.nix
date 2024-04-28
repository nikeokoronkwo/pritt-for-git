{ 
    stdenv,
    lib,
    fetchFromGitHub,
    python,
    pkgs
}:

stdenv.mkDerivation {
    pname = "chrome-depot-tools";
    version = "3.3.4";
}