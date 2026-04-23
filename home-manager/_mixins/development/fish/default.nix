{
  ...
}:
{
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        nix-shell = "nix-shell --command fish";
        l = "exa -bghl --sort newest --git";
        la = "l -a";
      };
    };
  };
}
