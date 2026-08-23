{
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      helix
    ];

    sessionVariables = {
      EDITOR = "hx";
    };
  };
}
