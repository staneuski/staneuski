{
  self,
  inputs,
  withSystem,
  ...
}:
{
  flake = {
    nixosModules.systemPackages =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          #: formulae, CLI
          imagemagick
          ffmpeg
          gawk
          wget

          #: linux, CLI
          bc
          file
          gcc
          gnumake
          openfoam
          pigz
          toybox
          unzip
          vim
          zlib
        ];

        environment.interactiveShellInit = ''
          source ${pkgs.openfoam}/etc/profile.d/foam${pkgs.openfoam.version}.sh
        '';
      };

    nixosModules.system =
      { pkgs, ... }:
      {
        programs.nix-ld.enable = true;
        time.timeZone = "Europe/Helsinki";
        users.defaultUserShell = pkgs.zsh;
      };

    nixosModules.syncthing =
      {
        config,
        userName,
        syncthing,
        ...
      }:
      let
        # This host's syncthing view, derived by name == its system hostname.
        inherit (syncthing.settingsFor config.networking.hostName) devices folders;
      in
      {
        sops = {
          defaultSopsFile = ../../secrets/syncthing.yaml;
          # Host age key used to decrypt at activation; create it before rebuild.
          age.keyFile = "/var/lib/sops-nix/key.txt";
          secrets = {
            "syncthing/key".owner = userName;
            "syncthing/cert".owner = userName;
          };
        };

        services.syncthing = {
          enable = true;
          user = userName;
          dataDir = "/home/${userName}";
          configDir = "/home/${userName}/.config/syncthing";
          # Make the Nix config the source of truth for devices/folders.
          overrideDevices = true;
          overrideFolders = true;
          # Private key material from sops -> pins this host's device ID.
          key = config.sops.secrets."syncthing/key".path;
          cert = config.sops.secrets."syncthing/cert".path;
          settings = {
            inherit devices folders;
            gui.address = "127.0.0.1:8384";
            options.relaysEnabled = false;
            options.urAccepted = -1; # decline anonymous usage reporting
          };
        };
      };

    nixosConfigurations.wsl = withSystem "x86_64-linux" (
      { pkgs, ... }:
      inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { nixpkgs.pkgs = pkgs; }
          self.commonModule
          self.nixosModules.systemPackages
          self.nixosModules.system
          self.nixosModules.syncthing
          inputs.nixos-wsl.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          (
            { userName, ... }:
            {
              # Single source of truth for this host's name: drives the system
              # hostname and, via config.networking.hostName, syncthing's device
              # name + which folders/peers this host derives in nixosModules.syncthing.
              networking.hostName = "wsl";
              system.stateVersion = "26.05";
              wsl.defaultUser = userName;
              wsl.enable = true;
            }
          )
        ];
      }
    );
  };
}
