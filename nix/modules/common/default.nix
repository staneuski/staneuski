{
  inputs,
  self,
  ...
}:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ self.overlays.default ];
      };
    };
  flake.commonModule =
    { lib, pkgs, ... }:
    let
      userName = "stasta";

      # Syncthing topology. Device IDs are public keys — safe to commit;
      # key.pem/cert.pem are secret and provisioned via sops per host.
      #
      # `hubs` are always-on servers; every other host is a spoke. Spokes sync
      # only through the hubs (never directly with each other); hubs connect to
      # everyone. `settingsFor host` returns the devices/folders that host should
      # declare — modules/linux feeds it straight into services.syncthing for
      # NixOS hosts; other machines (duke, marrow, ...) are configured via GUI.
      hubs = [
        "marrow"
        "polaris"
      ];
      spokes = [
        "duke"
        "wsl"
      ];

      devices = {
        duke.id = "5WEJTWT-QJY4SNE-6NYCT4B-4WQ7E7J-2NKTL36-54HHSQ2-3XA4H5Z-INFVIQG";
        marrow.id = "UAW7JKS-Z5AMH4C-CCLR545-HVGFEEZ-QXMQJB3-TVIGWXY-PAW5H54-F3OU5QC";
        polaris.id = "JX5O6NU-NP4NMNP-L4FKFZD-I4FS7KX-ZC5T55O-F3UGEFY-VJEGWPF-7STW5AH";
        wsl.id = "VA2YBTD-ANXX2R4-FIC3XH3-YBRVV2D-PGVHY3N-5ZHP3JV-HZOBCMQ-ZJIYRQV";
      };

      # Each folder is shared by everyone; per-host filtering happens below.
      folder = id: name: {
        inherit id;
        path = "/home/${userName}/${name}";
        devices = hubs ++ spokes;
      };
      folders = {
        Developer = folder "tjjrr-xedwq" "Developer";
        Documents = folder "tvhet-4xuvz" "Documents" // {
          versioning = {
            type = "staggered";
            params.maxAge = toString (365 * 24 * 3600); # keep versions up to 1 year
          };
        };
        Files = folder "v64zv-w6bst" "Files";
      };

      # A spoke shares each folder with the hubs only; a hub shares with every
      # other participant. Always includes the host itself so its local device
      # gets labelled with the hostname rather than a stale default.
      settingsFor =
        host:
        let
          isHub = builtins.elem host hubs;
          mine = lib.filterAttrs (_: f: builtins.elem host f.devices) folders;
          peersFor =
            f:
            let
              others = lib.remove host f.devices;
            in
            if isHub then others else builtins.filter (d: builtins.elem d hubs) others;
        in
        {
          devices = lib.filterAttrs (
            n: _: builtins.elem n ([ host ] ++ lib.concatMap peersFor (lib.attrValues mine))
          ) devices;
          # Keep each folder's full definition (path, versioning, ...) and only
          # narrow `devices` to this host's peers.
          folders = lib.mapAttrs (_: f: f // { devices = peersFor f; }) mine;
        };
    in
    {
      _module.args.userName = userName;
      _module.args.syncthing = { inherit devices folders settingsFor; };

      environment.systemPackages = with pkgs; [
        #: Common, CLI
        age
        btop
        claude-code
        git
        git-lfs
        gnupg
        sops
        nixfmt-tree
        python314
        # uutils-coreutils-noprefix
        # uutils-diffutils
        # uutils-findutils
        # uutils-sed
        coreutils
        diffutils
        findutils
        gnused
        uv
        zsh
      ];

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;
    };
}
