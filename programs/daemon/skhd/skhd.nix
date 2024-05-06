{...}: {
  services.skhd = {
    enable = true;
    skhdConfig = ''
      cmd - return : "/Users/jacobpyke/Applications/Home Manager Apps/Kitty.app/Contents/MacOS/kitty" --single-instance -d ~
         alt - 1 : yabai -m space --focus 1
         alt - 2 : yabai -m space --focus 2
         alt - 3 : yabai -m space --focus 3
         alt - 4 : yabai -m space --focus 4
    '';
  };
}
