{
  pkgs,
  lib,
  config,
  ...
}:
{
  home = {
    packages = with pkgs; [
      helix
    ];
  };

  programs = {
    git = {
      enable = true;
      settings = {
        user.name = "Martynas Mickevičius";
        user.email = "self@2m.lt";

        init.defaultBranch = "main";

        core.editor = "hx";

        tag.sort = "version:refname";
        diff = {
          algorithm = "histogram";
          colorMoved = "plain";
          mnemonicPrefix = true;
          renames = true;
        };

        push.autoSetupRemote = true;

        fetch = {
          prune = true;
          pruneTags = true;
          all = true;
        };

        merge.conflictstyle = "zdiff3";

        alias = {
          st = "status -sb";
          cia = "commit -a -m";
          ciaa = "commit -a --amend";
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
      }
      // lib.attrsets.optionalAttrs config.vars.is.workstation {
        # only enable gpg commit signing on workstation as gpg keys are only there
        user.signingkey = "CBA412CC";
        commit.gpgsign = true;
      };
    };
  };
}
