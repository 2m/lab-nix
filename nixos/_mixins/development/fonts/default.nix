{
  pkgs,
  config,
  ...
}:
{
  fonts.packages =
    with pkgs;
    [

    ]
    ++ lib.optionals config.vars.is.workstation [
      nerd-fonts.fira-code
    ];
}
