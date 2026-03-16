{ pkgs, ... }:

{
  imports = [

  ];

  determinateNix = {
    enable = true;
    customSettings = {
      experimental-features = "nix-command flakes";
      extra-experimental-features = "parallel-eval";
      lazy-trees = true;
      eval-cores = 0; # Enable parallel evaluation across all cores

      # Increase download parallelism for faster substitution
      max-substitution-jobs = 64;
      http-connections = 128;
      connect-timeout = 10;

      warn-dirty = false;
    };
  };

  system = {
    primaryUser = "martynas";
    stateVersion = 6;

    defaults.finder.ShowPathbar = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  # This will allow to use nix-darwin with Determinate. Some nix-darwin
  # functionality that relies on managing the Nix installation, like the
  # `nix.*` options to adjust Nix settings or configure a Linux builder,
  # will be unavailable.
  nix.enable = false;

  services = {
    yabai = {
      enable = true;
      enableScriptingAddition = true;
      config = {
        window_gap = 2;
        window_shadow = "off";

        layout = "bsp";
        auto_balance = "off";
        window_placement = "second_child";
        split_ratio = 0.5;

        mouse_follows_focus = "off";
        focus_follows_mouse = "autofocus";

        mouse_modifier = "ctrl";
        mouse_action1 = "resize";
        mouse_action2 = "move";

        padding = 5;

        window_opacity = "on";
        active_window_opacity = "1.0";
        normal_window_opacity = "1.0";
      };
    };
    skhd = {
      enable = true;
      skhdConfig = ''
        ctrl - return : open -n -a ${pkgs.alacritty}/Applications/Alacritty.app

        # open project
        ctrl - p : ls ~/projects/ | ${pkgs.choose-gui}/bin/choose | xargs -I % echo ~/projects/% | xargs ${pkgs.zed-editor}/bin/zeditor

        # copy gpg passphrase to clipboard
        ctrl - g : fish -c "op read op://gpg/carla/notesPlain | pbcopy"

        ctrl - v : yabai -m window --insert south
        ctrl - b : yabai -m window --insert east

        # numpad and number row
        ctrl - 0x53 : yabai -m space --focus 1
        ctrl - 0x54 : yabai -m space --focus 2
        ctrl - 0x55 : yabai -m space --focus 3
        ctrl - 0x56 : yabai -m space --focus 4
        ctrl - 0x57 : yabai -m space --focus 5
        ctrl - 0x58 : yabai -m space --focus 6
        ctrl - 0x59 : yabai -m space --focus 7
        ctrl - 0x5B : yabai -m space --focus 8
        ctrl - 0x5C : yabai -m space --focus 9
        ctrl - 0x52 : yabai -m space --focus 10

        # numpad
        ctrl + shift - 0x53 : yabai -m window --space 1
        ctrl + shift - 0x54 : yabai -m window --space 2
        ctrl + shift - 0x55 : yabai -m window --space 3
        ctrl + shift - 0x56 : yabai -m window --space 4
        ctrl + shift - 0x57 : yabai -m window --space 5
        ctrl + shift - 0x58 : yabai -m window --space 6
        ctrl + shift - 0x59 : yabai -m window --space 7
        ctrl + shift - 0x5B : yabai -m window --space 8
        ctrl + shift - 0x5C : yabai -m window --space 9
        ctrl + shift - 0x52 : yabai -m window --space 10

        # number row + shift have different opcodes
        ctrl + shift - 0x12 : yabai -m window --space 1
        ctrl + shift - 0x13 : yabai -m window --space 2
        ctrl + shift - 0x14 : yabai -m window --space 3
        ctrl + shift - 0x15 : yabai -m window --space 4
        ctrl + shift - 0x17 : yabai -m window --space 5
        ctrl + shift - 0x16 : yabai -m window --space 6
        ctrl + shift - 0x1A : yabai -m window --space 7
        ctrl + shift - 0x1C : yabai -m window --space 8
        ctrl + shift - 0x19 : yabai -m window --space 9
        ctrl + shift - 0x1D : yabai -m window --space 10

        # use '-' key for accessing space 11 which is on separate monitor
        ctrl - 0x1B : yabai -m space --focus 11
        ctrl + shift - 0x1B : yabai -m window --space 11
      '';
    };
  };

  users.users.martynas.home = "/Users/martynas";

  home-manager = {
    users.martynas = { pkgs, ... }: {
      imports = [
        ../home-manager
      ];

      programs = {
        alacritty = {
          enable = true;
          settings = {
            general.import = with pkgs; [ alacritty-theme.gruvbox_dark ];
            terminal = {
              shell = {
                program = ''${pkgs.fish}/bin/fish'';
              };
            };
            font = {
              size = 13;
              normal = {
                family = "FiraCode Nerd Font";
              };
            };
            window = {
              decorations = "none";
              padding = {
                x = 2;
                y = 2;
              };
            };
            selection = {
              save_to_clipboard = false;
              semantic_escape_chars = ",│`|:\"' ()[]{}<>";
            };
            keyboard = {
              bindings = [
                {
                  action = "Paste";
                  key = "V";
                  mods = "Command|Shift";
                }
                {
                  action = "Copy";
                  key = "C";
                  mods = "Command|Shift";
                }
                {
                  chars = builtins.fromJSON '' "\u0001" '';
                  key = "A";
                  mods = "Command";
                }
                {
                  chars = builtins.fromJSON '' "\u0003" '';
                  key = "C";
                  mods = "Command";
                }
                {
                  chars = builtins.fromJSON '' "\u0004" '';
                  key = "D";
                  mods = "Command";
                }
                {
                  chars = builtins.fromJSON '' "\u0005" '';
                  key = "E";
                  mods = "Command";
                }
                {
                  chars = builtins.fromJSON '' "\u0015" '';
                  key = "U";
                  mods = "Command";
                }
                {
                  chars = builtins.fromJSON '' "\u0017" '';
                  key = "W";
                  mods = "Command";
                }
              ];
            };
          };
        };
      };

      home = {
        packages = with pkgs; [
          metals
        ];

        username = "martynas";
        homeDirectory = "/Users/martynas";
        # The state version is required and should stay at the version you originally installed.
        stateVersion = "25.11";
      };
    };

    backupFileExtension = "before-home-manager";
  };
}

