{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };
  outputs =
    inputs@{
      nixpkgs,
      flake-parts,
      nix-darwin,
      nix-homebrew,
      nixos-wsl,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-darwin"
        "x86_64-linux"
      ];
      imports = [
        ./modules/common
        ./modules/darwin
        ./modules/linux
      ];
    };
}
