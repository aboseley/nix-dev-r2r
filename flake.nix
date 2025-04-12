{
  description = "A devShell for https://github.com/sequenceplanner/r2r.git ";

  inputs = {
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/master";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";
    fenix.url = "github:nix-community/fenix";
  };

  outputs = { self, nix-ros-overlay, flake-utils, nixpkgs, fenix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays =
            [ nix-ros-overlay.overlays.default fenix.overlays.default ];
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.colcon
            pkgs.fenix.stable.toolchain
            pkgs.rustPlatform.bindgenHook
            pkgs.pkg-config
            (with pkgs.rosPackages.humble; buildEnv { paths = [ ros-core ]; })
          ];
        };
      });
}
