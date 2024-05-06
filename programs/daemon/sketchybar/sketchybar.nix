{...}: {
  services.sketchybar = {
    enable = true;
    config = builtins.readFile ./sketchybarrc;
  };
}
