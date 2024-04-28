let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    ruby
    # Todo: Replace the dart package with the new one at `dart-nix/`
    dart
    go
    nodejs_21
    yarn
  ];
}