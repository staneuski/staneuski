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
    system = "x86_64-darwin";
    userName = "stasta";

    pkgs = import nixpkgs {
      inherit system;
      hostPlatform = system;
      config.allowUnfree = true;
    };

    configuration = { pkgs, config, ... }: {
      nix.settings.experimental-features = "nix-command flakes";
      nixpkgs.config.allowUnfree = true;
      programs.zsh.enable = true;
      system.configurationRevision = self.rev or self.dirtyRev or null;
    };

    commonPackages = {
      #: nix
      cli = with pkgs; [
        git
        git-lfs
        # mc
        python313
        python313Packages.ipykernel
        python313Packages.pip
        python313Packages.virtualenv
        htop
        # zlib
        zsh
      ];
      gui = with pkgs; [
        logseq
        kitty
        syncthing
        vscode
        zotero
      ];
      fonts = with pkgs; [ nerd-fonts.jetbrains-mono ];

      #: homebrew
      brews = [ "imagemagick" "ffmpeg" "gawk" "wget" ];
      casks = [ "inkscape" "meshlab" "paraview" "vlc" ];
    };
  in {
    darwinConfigurations."${system}" = nix-darwin.lib.darwinSystem {
      system = system;
      modules = [
        configuration
        ./darwin.nix
        nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            enable = true;
            user = userName;
            autoMigrate = true;
          };
        }
        mac-app-util.darwinModules.default
      ];
      specialArgs = {
        userName = userName;
        commonPackages = commonPackages;
      };
    };
  };
}
