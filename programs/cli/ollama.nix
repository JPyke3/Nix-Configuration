{pkgs, ...}: {
  services.ollama = {
    enable = true;
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1100"; # used to be necessary, but doesn't seem to anymore
    };
  };
}
