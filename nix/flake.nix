{
  description = "Unified Darwin and WSL system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    #: Darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin"; # LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    mac-app-util.url = "github:hraban/mac-app-util";

    #: WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      nix-homebrew,
      mac-app-util,
      nixos-wsl,
      ...
    }:
    let
      userName = "stasta";

      pkgsFor =
        system:
        import nixpkgs {
          system = system;
          config.allowUnfree = true;
          hostPlatform = system;
        };
      toPkgs = pkgs: names: map (name: pkgs.${name}) names;

      configuration =
        { pkgs, config, ... }:
        {
          nix.settings.experimental-features = "nix-command flakes";
          nixpkgs.config.allowUnfree = true;
          programs.zsh.enable = true;
          system.configurationRevision = self.rev or self.dirtyRev or null;
        };

      commonPackages = pkgs: {
        #: nix
        cli = with pkgs; [
          git
          git-lfs
          htop
          # mc
          nixfmt-tree
          python313Full
          python313Packages.ipykernel
          python313Packages.pip
          python313Packages.virtualenv
          zsh
        ];
        gui = with pkgs; [
          kitty
          logseq
          # paraview
          syncthing
          vscode
          zotero
        ];
        fonts = with pkgs; [ nerd-fonts.jetbrains-mono ];

        #: homebrew
        brews = [
          "imagemagick"
          "ffmpeg"
          "gawk"
          "wget"
        ];
        casks = [
          "inkscape"
          "meshlab"
          "vlc"
        ];
      };
    in
    {
      darwinConfigurations."x86_64-darwin" = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          configuration
          ./darwin.nix
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = userName;
              autoMigrate = true;
            };
          }
          mac-app-util.darwinModules.default
        ];
        specialArgs = {
          pkgs = pkgsFor "x86_64-darwin";
          userName = userName;
          commonPackages = commonPackages (pkgsFor "x86_64-darwin");
        };
      };
      formatter.x86_64-darwin = nixpkgs.legacyPackages.x86_64-darwin.nixfmt-tree;

      nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          configuration
          ./wsl.nix
          nixos-wsl.nixosModules.default
        ];
        specialArgs = {
          pkgs = pkgsFor "x86_64-linux";
          userName = userName;
          commonPackages = commonPackages (pkgsFor "x86_64-linux");
          toPkgs = toPkgs;
        };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
