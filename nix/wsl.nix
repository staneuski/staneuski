{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }: 
  let
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
        python313Packages.virtualenv
        rclone

        nix-ld
      ];

      nix.settings.experimental-features = "nix-command flakes";

      programs.nix-ld.enable = true;
      programs.zsh.enable = true;

      users.defaultUserShell = pkgs.zsh;
  };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        configuration
        nixos-wsl.nixosModules.default
        {
          system.stateVersion = "unstable";
          wsl.defaultUser = "SST055";
          wsl.enable = true;
        }
      ];
    };
  };
}
