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
      alt - space : yabai -m window --toggle float
    '';
  };
}
