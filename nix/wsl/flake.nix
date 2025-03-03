{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }: 
  let
    user = "SST055";
    configuration = { config, pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        bc
        file
        gawk
        gcc
        htop
        jq
        toybox
        unzip
        vim
        wget
        zsh

        ffmpeg
        git
        git-lfs
        helix
        mc
        neovim
        python313
        python313Packages.ipykernel
        python313Packages.pip
        python313Packages.virtualenv
        rclone

        nix-ld
      ];

      nix.settings.experimental-features = "nix-command flakes";

      programs.nix-ld.enable = true;
      programs.zsh.enable = true;

      # Set Git commit hash for nixos-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      users.defaultUserShell = pkgs.zsh;
  };
  in {
    nixosConfigurations."wsl" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        configuration
        nixos-wsl.nixosModules.default
        {
          system.stateVersion = "unstable";
          wsl.defaultUser = user;
          wsl.enable = true;
        }
      ];
    };
  };
}
