{ 
    stdenv,
    lib,
    fetchzip,
    python
}:

stdenv.mkDerivation {
    pname = "dart-macos";
    version = "3.3.4";

    src = fetchFromGitHub {
        owner = "dart-lang";
        repo = "sdk";
        rev = "3.3.4";
        sha256 = "0sikca0nnwrsmcpb24jmh677p9x7hl2pb78y2kflx4q6xsw8gwlm";
    };

    buildInputs = [ python ]
}