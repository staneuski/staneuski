{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }: 
  let
    configuration = { config, pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        gcc
        git
        git-lfs
        gnumake
        mc
        nix-ld
        vim
        wget
        zsh
      ];

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
          system.stateVersion = "24.11";
          wsl.defaultUser = "SST055";
          wsl.enable = true;
        }
      ];
    };
  };
}
