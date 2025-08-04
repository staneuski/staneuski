{
  description = "Unified Darwin and WSL system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    #: Darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin"; # LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    mac-app-util.url = "github:hraban/mac-app-util";

    #: WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, nix-homebrew, mac-app-util, nixos-wsl, ... }:
  let
    user = "stasta";
    systems = {
      wsl = "x86_64-linux";
      darwin = "x86_64-darwin";
    };

    pkgsFor = name: import nixpkgs {
      system = systems.${name};
      config.allowUnfree = true;
    };

    commonPackages = pkgs: with pkgs; [
      git
      git-lfs
      mc
      python313
      python313Packages.ipykernel
      python313Packages.pip
      python313Packages.virtualenv
      htop
      zsh
    ];

    commonSettings = {
      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh.enable = true;

      # Set Git commit hash for Nix version
      system.configurationRevision = self.rev or self.dirtyRev or null;
    };
  in {
    darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
      system = systems.darwin;
      modules = [
        commonSettings
        ./darwin.nix
        nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            enable = true;
            user = user;
            autoMigrate = true;
          };
        }
        mac-app-util.darwinModules.default
      ];
      specialArgs = {
        pkgs = pkgsFor "darwin";
        commonPackages = commonPackages (import nixpkgs {
          system = systems.darwin;
          config.allowUnfree = true;
        });
      };
    };

    nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      system = systems.wsl;
      modules = [
        commonSettings
        ./wsl.nix
        nixos-wsl.nixosModules.default
        {
          nixpkgs.config.allowUnfree = true;
        }
      ];
      specialArgs = {
        commonPackages = commonPackages (import nixpkgs {
          system = systems.wsl;
          config.allowUnfree = true;
        });
      };
    };
  };
}
