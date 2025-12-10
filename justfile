
build:
    ssh root@lab.2m.lt -t 'nixos-rebuild switch --flake /etc/nixos#lab-hb'

repl:
    ssh root@lab.2m.lt -t 'nixos-rebuild repl --flake /etc/nixos#lab-hb'

wip:
    git ciaa
    git push lab-hb --force
    just build

cleanup:
    ssh root@lab.2m.lt -t 'nix-collect-garbage -d'

dev-prep:
    nix profile add github:nixos/nixpkgs#nixd
    nix profile add github:nixos/nixpkgs#nixfmt
    nix profile add github:ryantm/agenix

encrypt secret:
    cd secrets; env EDITOR=hx agenix -e {{secret}}.age
