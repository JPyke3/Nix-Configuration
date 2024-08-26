{...}: {
  services.invidious = {
    enable = true;
    port = 4664;
    database.createLocally = true;
  };
}
