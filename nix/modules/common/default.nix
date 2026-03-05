{
  nixpkgs,
  self,
  inputs,
  ...
}:
{
  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    {
      _module.args.pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
  flake = {
    nixosModules.default =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          #: Common, CLI
          btop
          git
          git-lfs
          gnupg
          nixfmt-tree
          python314
          uutils-coreutils-noprefix
          uutils-diffutils
          uutils-findutils
          uutils-sed
          uv
          zsh
        ];

        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];

        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true;
        users.defaultUserShell = pkgs.zsh;
      };
  };
}
