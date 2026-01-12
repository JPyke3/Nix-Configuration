{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        type = "small";
        padding = {
          top = 1;
          left = 2;
        };
      };

      display = {
        separator = " -> ";
      };

      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "terminal"
        {
          type = "memory";
          format = "{used} / {total} ({percentage})";
        }
        {
          type = "disk";
          folders = "/";
        }
        "break"
        "colors"
      ];
    };
  };
}
