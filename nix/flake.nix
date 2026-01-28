{
  description = "Unified macOS and NixOS (inc. WSL) system flake (WIP)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      nix-homebrew,
      nixos-wsl,
      ...
    }:
    let
      userName = "stasta";

      mkConfig =
        system: hostname: modules:
        let
          isDarwin = builtins.match ".*(darwin)$" system != null;

          libSystem = if isDarwin then nix-darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
          systemModule = if isDarwin then ./modules/darwin else ./modules/linux;
        in
        {
          "${hostname}" = libSystem {
            inherit system;
            specialArgs = inputs // {
              info = {
                inherit system userName;
              };
            };
            modules = modules ++ [
              systemModule
            ];
          };
        };
    in
    {
      darwinConfigurations = (
        mkConfig "x86_64-darwin" "duke" [
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              autoMigrate = true;
              enable = true;
              enableRosetta = false;
              user = userName;
            };
          }
        ]
      );

      nixosConfigurations = (
        mkConfig "x86_64-linux" "wsl" [
          nixos-wsl.nixosModules.default
          {
            wsl.defaultUser = userName;
            wsl.enable = true;
          }
        ]
      );
    };
}
