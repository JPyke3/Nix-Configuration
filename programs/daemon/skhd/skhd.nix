{...}: {
  services.skhd = {
    enable = true;
    skhdConfig = ''
      cmd - return : /Users/jacobpyke/Applications/Home Manager Apps/Kitty.app/Contents/MacOS/kitty --single-instance -d ~
    '';
  };
}
