{
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      eza
    ];
  };

  programs = {
    fish = {
      enable = true;
      shellAliases = {
        nix-shell = "nix-shell --command fish";
        l = "eza -bghl --sort newest --git";
        la = "l -a";
      };
      shellInit = ''
        export GPG_TTY="$(tty)"
      '';
    };
  };
}
