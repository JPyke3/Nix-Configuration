# Note, this is to be used as a home-manager module
{...}: {
  xdg.configFile."sketchybar/sketchybarrc-laptop".source = ./sketchybarrc-laptop;
  xdg.configFile."sketchybar/sketchybarrc-desktop".source = ./sketchybarrc-desktop;

  xdg.configFile."sketchybar/plugins/clock.sh" = {
    text = ''
      #!/usr/bin/env zsh

      sketchybar --set $NAME label="$(date '+%a %b %-d %-H:%M')"
    '';
    executable = true;
  };

  xdg.configFile."sketchybar/plugins/current_space.sh" = {
    text = ''
      #!/usr/bin/env zsh

      update_space() {
      	SPACE_ID=$(echo "$INFO" | jq -r '."display-1"')

      	case $SPACE_ID in
      	1)
      		ICON=󰅶
      		ICON_PADDING_LEFT=7
      		ICON_PADDING_RIGHT=7
      		;;
      	*)
      		ICON=$SPACE_ID
      		ICON_PADDING_LEFT=9
      		ICON_PADDING_RIGHT=10
      		;;
      	esac

      	sketchybar --set $NAME \
      		icon=$ICON \
      		icon.padding_left=$ICON_PADDING_LEFT \
      		icon.padding_right=$ICON_PADDING_RIGHT
      }

      case "$SENDER" in
      "mouse.clicked")
      	# Reload sketchybar
      	sketchybar --remove '/.*/'
      	source $HOME/.config/sketchybar/sketchybarrc
      	;;
      *)
      	update_space
      	;;
      esac
    '';
    executable = true;
  };

  xdg.configFile."sketchybar/plugins/front_app.sh" = {
    text = ''
      #!/usr/bin/env zsh

      ICON_PADDING_RIGHT=5

      case $INFO in
      "Arc")
      	ICON_PADDING_RIGHT=5
      	ICON=󰞍
      	;;
      "Code")
      	ICON_PADDING_RIGHT=4
      	ICON=󰨞
      	;;
      "Calendar")
      	ICON_PADDING_RIGHT=3
      	ICON=
      	;;
      "Discord")
      	ICON=󰙯
      	;;
      "FaceTime")
      	ICON_PADDING_RIGHT=5
      	ICON=
      	;;
      "Finder")
      	ICON=
      	;;
      "Google Chrome")
      	ICON_PADDING_RIGHT=7
      	ICON=
      	;;
      "IINA")
      	ICON_PADDING_RIGHT=4
      	ICON=󰕼
      	;;
      "kitty")
      	ICON=󰄛
      	;;
      "Messages")
      	ICON=󰍦
      	;;
      "Notion")
      	ICON_PADDING_RIGHT=6
      	ICON=󰈄
      	;;
      "Preview")
      	ICON_PADDING_RIGHT=3
      	ICON=
      	;;
      "PS Remote Play")
      	ICON_PADDING_RIGHT=3
      	ICON=
      	;;
      "Spotify")
      	ICON=
      	;;
      "TextEdit")
      	ICON_PADDING_RIGHT=4
      	ICON=
      	;;
      "Transmission")
      	ICON_PADDING_RIGHT=3
      	ICON=󰶘
      	;;
      *)
      	ICON=﯂
      	;;
      esac

      sketchybar --set $NAME icon=$ICON icon.padding_right=$ICON_PADDING_RIGHT
      sketchybar --set $NAME.name label="$INFO"
    '';
    executable = true;
  };

  xdg.configFile."sketchybar/plugins/volume.sh" = {
    text = ''
      #!/usr/bin/env zsh

      case ''${INFO} in
      0)
      	ICON=""
      	ICON_PADDING_RIGHT=21
      	;;
      [0-9])
      	ICON=""
      	ICON_PADDING_RIGHT=12
      	;;
      *)
      	ICON=""
      	ICON_PADDING_RIGHT=6
      	;;
      esac

      sketchybar --set $NAME icon=$ICON icon.padding_right=$ICON_PADDING_RIGHT label="$INFO%"
    '';
    executable = true;
  };

  xdg.configFile."sketchybar/plugins/weather.sh" = {
    text = ''
      #!/usr/bin/env zsh

      IP=$(curl -s https://ipinfo.io/ip)
      LOCATION_JSON=$(curl -s https://ipinfo.io/$IP/json)

      LOCATION="$(echo $LOCATION_JSON | jq '.city' | tr -d '"')"
      REGION="$(echo $LOCATION_JSON | jq '.region' | tr -d '"')"
      COUNTRY="$(echo $LOCATION_JSON | jq '.country' | tr -d '"')"

      # Line below replaces spaces with +
      LOCATION_ESCAPED="''${LOCATION// /+}+''${REGION// /+}"
      WEATHER_JSON=$(curl -s "https://wttr.in/$LOCATION_ESCAPED?format=j1")

      # Fallback if empty
      if [ -z $WEATHER_JSON ]; then

      	sketchybar --set $NAME label=$LOCATION
      	sketchybar --set $NAME.moon icon=

      	return
      fi

      TEMPERATURE=$(echo $WEATHER_JSON | jq '.current_condition[0].temp_C' | tr -d '"')
      WEATHER_DESCRIPTION=$(echo $WEATHER_JSON | jq '.current_condition[0].weatherDesc[0].value' | tr -d '"' | sed 's/\(.\{25\}\).*/\1.../')
      MOON_PHASE=$(echo $WEATHER_JSON | jq '.weather[0].astronomy[0].moon_phase' | tr -d '"')

      case ''${MOON_PHASE} in
      "New Moon")
      	ICON=
      	;;
      "Waxing Crescent")
      	ICON=
      	;;
      "First Quarter")
      	ICON=
      	;;
      "Waxing Gibbous")
      	ICON=
      	;;
      "Full Moon")
      	ICON=
      	;;
      "Waning Gibbous")
      	ICON=
      	;;
      "Last Quarter")
      	ICON=
      	;;
      "Waning Crescent")
      	ICON=
      	;;
      esac

      sketchybar --set $NAME label="$LOCATION  $TEMPERATURE糖 $WEATHER_DESCRIPTION"
      sketchybar --set $NAME.moon icon=$ICON
    '';
    executable = true;
  };

  xdg.configFile."sketchybar/plugins-laptop/battery.sh" = {
    text = ''
      #!/usr/bin/env sh

      # Battery is here bcause the ICON_COLOR doesn't play well with all background colors

      PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
      CHARGING=$(pmset -g batt | grep 'AC Power')

      if [ $PERCENTAGE = "" ]; then
      	exit 0
      fi

      case ''${PERCENTAGE} in
      [8-9][0-9] | 100)
      	ICON=""
      	ICON_COLOR=0xffa6da95
      	;;
      7[0-9])
      	ICON=""
      	ICON_COLOR=0xffeed49f
      	;;
      [4-6][0-9])
      	ICON=""
      	ICON_COLOR=0xfff5a97f
      	;;
      [1-3][0-9])
      	ICON=""
      	ICON_COLOR=0xffee99a0
      	;;
      [0-9])
      	ICON=""
      	ICON_COLOR=0xffed8796
      	;;
      esac

      if [[ $CHARGING != "" ]]; then
      	ICON=""
      	ICON_COLOR=0xffeed49f
      fi

      sketchybar --set $NAME \
      	icon=$ICON \
      	label="''${PERCENTAGE}%" \
      	icon.color=''${ICON_COLOR}
    '';
    executable = true;
  };

  xdg.configFile."sketchybar/plugins-laptop/spotify.sh" = {
    text = ''
      #!/usr/bin/env zsh

      # Max number of characters so it fits nicely to the right of the notch
      # MAY NOT WORK WITH NON-ENGLISH CHARACTERS

      MAX_LENGTH=35

      # Logic starts here, do not modify
      HALF_LENGTH=$(((MAX_LENGTH + 1) / 2))

      # Spotify JSON / $INFO comes in malformed, line below sanitizes it
      SPOTIFY_JSON="$INFO"

      update_track() {

      	if [[ -z $SPOTIFY_JSON ]]; then
      		sketchybar --set $NAME icon.color=0xffeed49f label.drawing=no
      		return
      	fi

      	PLAYER_STATE=$(echo "$SPOTIFY_JSON" | jq -r '.["Player State"]')

      	if [ $PLAYER_STATE = "Playing" ]; then
      		TRACK="$(echo "$SPOTIFY_JSON" | jq -r .Name)"
      		ARTIST="$(echo "$SPOTIFY_JSON" | jq -r .Artist)"

      		# Calculations so it fits nicely
      		TRACK_LENGTH=''${#TRACK}
      		ARTIST_LENGTH=''${#ARTIST}

      		if [ $((TRACK_LENGTH + ARTIST_LENGTH)) -gt $MAX_LENGTH ]; then
      			# If the total length exceeds the max
      			if [ $TRACK_LENGTH -gt $HALF_LENGTH ] && [ $ARTIST_LENGTH -gt $HALF_LENGTH ]; then
      				# If both the track and artist are too long, cut both at half length - 1

      				# If MAX_LENGTH is odd, HALF_LENGTH is calculated with an extra space, so give it an extra char
      				TRACK="''${TRACK:0:$((MAX_LENGTH % 2 == 0 ? HALF_LENGTH - 2 : HALF_LENGTH - 1))}…"
      				ARTIST="''${ARTIST:0:$((HALF_LENGTH - 2))}…"

      			elif [ $TRACK_LENGTH -gt $HALF_LENGTH ]; then
      				# Else if only the track is too long, cut it by the difference of the max length and artist length
      				TRACK="''${TRACK:0:$((MAX_LENGTH - ARTIST_LENGTH - 1))}…"
      			elif [ $ARTIST_LENGTH -gt $HALF_LENGTH ]; then
      				ARTIST="''${ARTIST:0:$((MAX_LENGTH - TRACK_LENGTH - 1))}…"
      			fi
      		fi
      		sketchybar --set $NAME label="''${TRACK}  ''${ARTIST}" label.drawing=yes icon.color=0xffa6da95

      	elif [ $PLAYER_STATE = "Paused" ]; then
      		sketchybar --set $NAME icon.color=0xffeed49f
      	elif [ $PLAYER_STATE = "Stopped" ]; then
      		sketchybar --set $NAME icon.color=0xffeed49f label.drawing=no
      	else
      		sketchybar --set $NAME icon.color=0xffeed49f
      	fi
      }

      case "$SENDER" in
      "mouse.clicked")
      	osascript -e 'tell application "Spotify" to playpause'
      	;;
      *)
      	update_track
      	;;
      esac
    '';
    executable = true;
  };

  xdg.configFile."sketchybar/plugins-desktop/spotify.sh" = {
    text = ''
      #!/usr/bin/env zsh

      # Max number of characters so it fits nicely to the right of the notch
      # MAY NOT WORK WITH NON-ENGLISH CHARACTERS

      MAX_LENGTH=35

      # Logic starts here, do not modify
      HALF_LENGTH=$(((MAX_LENGTH + 1) / 2))

      # Spotify JSON / $INFO comes in malformed, line below sanitizes it
      SPOTIFY_JSON="$INFO"

      update_track() {

      	if [[ -z $SPOTIFY_JSON ]]; then
      		sketchybar --set $NAME background.color=0xffeed49f label.drawing=no
      		return
      	fi

      	PLAYER_STATE=$(echo "$SPOTIFY_JSON" | jq -r '.["Player State"]')

      	if [ $PLAYER_STATE = "Playing" ]; then
      		TRACK="$(echo "$SPOTIFY_JSON" | jq -r .Name)"
      		ARTIST="$(echo "$SPOTIFY_JSON" | jq -r .Artist)"

      		# Calculations so it fits nicely
      		TRACK_LENGTH=''${#TRACK}
      		ARTIST_LENGTH=''${#ARTIST}

      		if [ $((TRACK_LENGTH + ARTIST_LENGTH)) -gt $MAX_LENGTH ]; then
      			# If the total length exceeds the max
      			if [ $TRACK_LENGTH -gt $HALF_LENGTH ] && [ $ARTIST_LENGTH -gt $HALF_LENGTH ]; then
      				# If both the track and artist are too long, cut both at half length - 1

      				# If MAX_LENGTH is odd, HALF_LENGTH is calculated with an extra space, so give it an extra char
      				TRACK="''${TRACK:0:$((MAX_LENGTH % 2 == 0 ? HALF_LENGTH - 2 : HALF_LENGTH - 1))}…"
      				ARTIST="''${ARTIST:0:$((HALF_LENGTH - 2))}…"

      			elif [ $TRACK_LENGTH -gt $HALF_LENGTH ]; then
      				# Else if only the track is too long, cut it by the difference of the max length and artist length
      				TRACK="''${TRACK:0:$((MAX_LENGTH - ARTIST_LENGTH - 1))}…"
      			elif [ $ARTIST_LENGTH -gt $HALF_LENGTH ]; then
      				ARTIST="''${ARTIST:0:$((MAX_LENGTH - TRACK_LENGTH - 1))}…"
      			fi
      		fi
      		sketchybar --set $NAME label="''${TRACK}  ''${ARTIST}" label.drawing=yes background.color=0xffa6da95

      	elif [ $PLAYER_STATE = "Paused" ]; then
      		sketchybar --set $NAME background.color=0xffeed49f
      	elif [ $PLAYER_STATE = "Stopped" ]; then
      		sketchybar --set $NAME background.color=0xffeed49f label.drawing=no
      	else
      		sketchybar --set $NAME background.color=0xffeed49f
      	fi
      }

      case "$SENDER" in
      "mouse.clicked")
      	osascript -e 'tell application "Spotify" to playpause'
      	;;
      *)
      	update_track
      	;;
      esac
    '';
    executable = true;
  };
}
