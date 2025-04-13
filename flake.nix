{
  description = "Rust + bindgen + ROS devShell using fenix and nix-ros-overlay";

  inputs = {
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    fenix.url = "github:nix-community/fenix";
  };

  outputs = { self, nixpkgs, flake-utils, fenix, nix-ros-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [
          nix-ros-overlay.overlays.default
        ];

        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rustToolchain = fenix.packages.${system}.stable.toolchain;

        rosPackages = pkgs.rosPackages.humble;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            rustToolchain
            pkgs.clang
            pkgs.llvmPackages.libclang
            pkgs.pkg-config
            pkgs.colcon
            rosPackages.ros-core
            pkgs.rustPlatform.bindgenHook
          ];
        };
      });
}
