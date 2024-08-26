{...}: {
  services.invidious = {
    enable = true;
    nginx.enable = true;
    port = 4664;
  };
}
