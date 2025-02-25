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
        git
        git-lfs
        gnumake
        helix
        jq
        mc
        neovim
        nix-ld
        python3
        rclone
        toybox
        unzip
        vim
        virtualenv
        wget
        zsh
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
