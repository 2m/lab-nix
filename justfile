
switch host system:
    ssh root@{{host}} -t 'nixos-rebuild switch --flake /etc/nixos#{{system}}'

repl host system:
    ssh root@{{host}} -t 'nixos-rebuild repl --flake /etc/nixos#{{system}}'

build package:
    nix-build -E 'with import <nixpkgs> {}; callPackage ./{{package}}.nix {}'

wip host system:
    git ciaa
    git push {{system}} --force
    just switch {{host}} {{system}}

cleanup host:
    ssh root@{{host}} -t 'nix-collect-garbage -d'

dev-prep:
    nix profile add github:nixos/nixpkgs#nixd
    nix profile add github:nixos/nixpkgs#nixfmt
    nix profile add github:ryantm/agenix

encrypt secret:
    cd secrets; env EDITOR=hx agenix -e {{secret}}.age
