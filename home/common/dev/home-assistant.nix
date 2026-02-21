{ pkgs, lib, ... }: {
  services.syncthing = {
    enable = true;

    settings = {
      options.urAccepted = -1;

      devices."home-assistant".id =
        "PSFBJHV-APK4RY7-TFT3CU7-U3QUUWX-PJCLSBX-NGH7OIL-I7KMY4A-E7L2SQ2";

      folders."home-assistant" = {
        path = "~/workspace/home-assistant";
        devices = [ "home-assistant" ];
        type = "sendreceive";
        ignorePerms = false;
        versioning = {
          type = "simple";
          params.keep = "3";
        };
      };
    };
  };

  home.packages = lib.optionals pkgs.stdenv.isLinux [ pkgs.esphome ];
}
