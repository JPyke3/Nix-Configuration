# Note, this is to be used as a home-manager module
{...}: {
  xdg.configFile."sketchybar/plugins/battery.sh" = {
    text = ''
      #!/bin/sh

      PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
      CHARGING="$(pmset -g batt | grep 'AC Power')"

      if [ "$PERCENTAGE" = "" ]; then
        exit 0
      fi

      case "''${PERCENTAGE}" in
        9[0-9]|100) ICON=""
        ;;
        [6-8][0-9]) ICON=""
        ;;
        [3-5][0-9]) ICON=""
        ;;
        [1-2][0-9]) ICON=""
        ;;
        *) ICON=""
      esac

      if [[ "$CHARGING" != "" ]]; then
        ICON=""
      fi

      # The item invoking this script (name $NAME) will get its icon and label
      # updated with the current battery status
      sketchybar --set "$NAME" icon="$ICON" label="''${PERCENTAGE}%"
    '';
    executable = true;
  };

  xdg.configFile."sketchybar/plugins/clock.sh" = {
    text = ''
      #!/bin/sh

      # The $NAME variable is passed from sketchybar and holds the name of
      # the item invoking this script:
      # https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

      sketchybar --set "$NAME" label="$(date '+%d/%m %H:%M')"
    '';
    executable = true;
  };

  xdg.configFile."sketchybar/plugins/front_app.sh" = {
    text = ''
      #!/bin/sh

      # Some events send additional information specific to the event in the $INFO
      # variable. E.g. the front_app_switched event sends the name of the newly
      # focused application in the $INFO variable:
      # https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

      if [ "$SENDER" = "front_app_switched" ]; then
        sketchybar --set "$NAME" label="$INFO"
      fi
    '';
    executable = true;
  };

  xdg.configFile."sketchybar/plugins/space.sh".text = ''
    #!/bin/sh

    # The $SELECTED variable is available for space components and indicates if
    # the space invoking this script (with name: $NAME) is currently selected:
    # https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

    sketchybar --set "$NAME" background.drawing="$SELECTED"
  '';

  xdg.configFile."sketchybar/plugins/volume.sh".text = ''
    #!/bin/sh

    # The volume_change event supplies a $INFO variable in which the current volume
    # percentage is passed to the script.

    if [ "$SENDER" = "volume_change" ]; then
      VOLUME="$INFO"

      case "$VOLUME" in
    	[6-9][0-9]|100) ICON="󰕾"
    	;;
    	[3-5][0-9]) ICON="󰖀"
    	;;
    	[1-9]|[1-2][0-9]) ICON="󰕿"
    	;;
    	*) ICON="󰖁"
      esac

      sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%"
    fi
  '';
}
