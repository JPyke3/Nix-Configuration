{config, ...}: let
  snowflake = builtins.fetchurl rec {
    name = "Logo-${sha256}.svg";
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg";
    sha256 = "14mbpw8jv1w2c5wvfvj8clmjw0fi956bq5xf9s2q3my14far0as8";
  };
  inherit (config) x;
in
  with config.colorScheme.colors; ''
    * {
      /* `otf-font-awesome` is required to be installed for icons */
      font-family: Material Design Icons, Lexend, Iosevka Nerd Font;
    }

    window#waybar {
      background-color: #${base00};
      border-radius: 0px;
      color: #${base08};
      box-shadow: 2px 3px 2px 2px #151515;
      font-size: 14px;
      transition-property: background-color;
      transition-duration: 0.5s;
    }

    window#waybar.hidden {
      opacity: 0.2;
    }

    #pulseaudio {
      color: #${base0B};
    }

    #custom-vpn,
    #network {
      color: #${base0D};
    }

    #cpu {
      color: #${base0E};
    }

    #memory {
      color: #${base0A};
    }

    #clock {
      font-weight: 700;
      font-family: "Iosevka Term";
      padding: 5px 0px 5px 0px;
    }

    #workspaces button {
      background-color: transparent;
      /* Use box-shadow instead of border so the text isn't offset */
      color: #${base09};
      padding-top: 10px;
      box-shadow: inset 0 -3px transparent;
      transition: all 400ms cubic-bezier(0.250, 0.250, 0.555, 1.425);
    }

    #workspaces button:hover {
      color: #${base09};
      box-shadow: inherit;
      text-shadow: inherit;
    }

    #custom-power {
        color: #${base0E};
        padding: 14px 0px 14px 0px;
        margin-bottom: 20px;
    }

    #workspaces button.active {
      color: #${base0A};
      transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
    }
    #workspaces button.urgent {
      background-color: #${base0D};
    }
    #clock,
    #network,
    #custom-swallow,
    #cpu,
    #battery,
    #backlight,
    #memory,
    #workspaces,
    #custom-todo,
    #custom-lock,
    #custom-vpn,
    #custom-weather,
    #custom-power,
    #custom-crypto,
    #volume,
    #pulseaudio {
      border-radius: 8px;
      background-color: #${base00};
      padding: 14px 0px 14px 0px;
      margin: 3px 0px 3px 0px;
    }

    #custom-lock {
        color: #${base09};
    }

    #custom-search {
      background-image: url("${snowflake}");
      background-size: 65%;
      background-position: center;
      padding: 14px 0 0 0;
      background-repeat: no-repeat;
    }
    #backlight {
      color: #${base0A};
    }
    #battery {
      color: #${base0A};
    }

    #battery.warning {
      color: #${base0A};
    }

    #battery.critical:not(.charging) {
      color: #${base0A};
    }
    tooltip {
      font-family: 'Lato', sans-serif;
      border-radius: 15px;
      padding: 20px;
      margin: 30px;
    }
    tooltip label {
      font-family: 'Lato', sans-serif;
      padding: 20px;
    }
  ''
