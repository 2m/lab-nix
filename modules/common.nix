{ pkgs, ... }:

{
  time.timeZone = "Europe/Vilnius";

  environment.systemPackages = with pkgs; [
    wget
    jq
    bc
    bat
    dua
    btop
    eza
  ];

  programs = {
    fish = {
      enable = true;
      shellAliases = {
        nix-shell = "nix-shell --command fish";
        l = "exa -bghl --sort newest --git";
        la = "l -a";
      };
    };
    git = {
      enable = true;
      config = {
        user.name = "Martynas Mickevičius";
        user.email = "self@2m.lt";

        init.defaultBranch = "main";

        core.editor = "hx";

        alias = {
          st = "status -sb";
          cia = "commit -a -m";
          co = "checkout";
          lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
          lola = "lol --all";
          # rebase interactively all commits from the fork point of the given branch
          rbi = "!sh -c \"git rebase -i `git merge-base $1 HEAD`\" -";
          # same as rbi but also rebase on top of the given branch
          rbo = "!sh -c \"git rebase -i --onto $1 `git merge-base $1 HEAD`\" -";
          # shows branches ordered by latest worked at
          # https://gist.github.com/jroper/4c4415e853ef5696f7e4c135e20e4d17
          br = "for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'";
        };
      };
    };
  };

  users.defaultUserShell = pkgs.fish;

  home-manager.users.root = { ... }: {
    home.stateVersion = "25.11";

    programs.helix = {
      enable = true;
    };
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    download-buffer-size = 524288000; # 500MB
  };

  # speedup system builds
  documentation.man.generateCaches = false;

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];
}
