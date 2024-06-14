{...}: {
  services.skhd = {
    enable = true;
    skhdConfig = ''
         cmd - return : "/Users/jacobpyke/Applications/Home Manager Apps/Kitty.app/Contents/MacOS/kitty" --single-instance -d ~
         alt - 1 : yabai -m space --focus 1
         alt - 2 : yabai -m space --focus 2
         alt - 3 : yabai -m space --focus 3
         alt - 4 : yabai -m space --focus 4
         alt - 5 : yabai -m space --focus 5
         alt - 6 : yabai -m space --focus 6
         alt - 7 : yabai -m space --focus 7
         alt - 8 : yabai -m space --focus 8
         alt - 9 : yabai -m space --focus 9
         alt - 0 : yabai -m space --focus 10
         alt + shift - 1 : yabai -m window --space 1
         alt + shift - 2 : yabai -m window --space 2
         alt + shift - 3 : yabai -m window --space 3
         alt + shift - 4 : yabai -m window --space 4
         alt + shift - 5 : yabai -m window --space 5
         alt + shift - 6 : yabai -m window --space 6
         alt + shift - 7 : yabai -m window --space 7
         alt + shift - 8 : yabai -m window --space 8
         alt + shift - 9 : yabai -m window --space 9
         alt - space : yabai -m window --toggle float
         alt - f : yabai -m window --toggle zoom-fullscreen
         alt - h : yabai -m window --warp west
         alt - j : yabai -m window --warp south
         alt - k : yabai -m window --warp north
         alt - l : yabai -m window --warp east
      alt - shift - r : yabai -m window --display recent
    '';
  };
}
