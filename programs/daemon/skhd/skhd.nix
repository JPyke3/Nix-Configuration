{...}: {
  services.skhd = {
    enable = true;
    skhdConfig = ''
         cmd - return : "/Users/jacobpyke/Applications/Home Manager Apps/Kitty.app/Contents/MacOS/kitty" --single-instance -d ~
      option - 1 : yabai -m space --focus 1
      option - 2 : yabai -m space --focus 2
      option - 3 : yabai -m space --focus 3
      option - 4 : yabai -m space --focus 4
    '';
  };
}
