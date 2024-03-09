{ inputs }:
{ desktop }:
{ pkgs, ... }:

{
  imports = [
    (import ./gtk.nix {
      inherit (inputs.nix-colors.lib-contrib { inherit pkgs; })
        gtkThemeFromScheme;
    })
    import
    ./hyprland.nix
    import
    ./rofi.nix
    import
    ./swaylock.nix
    import
    ./swaync.nix
    import
    ./waybar.nix
  ];
}
