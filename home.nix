{ config, pkgs, ... }:

{
  home.username = "dwilliams";
  home.homeDirectory = "/home/dwilliams";
  home.stateVersion = "25.11";
  programs = {
     neovim = {
        enable = true;
        defaultEditor = true;
        };
     bash = {
       enable = true;
       shellAliases = {
         ll = "eza -la --group-dirs-first --icons";
         v = "nvim";
         rebuild = "sudo nixos-rebuild switch --flake ~/tony-nixos/";
         update  = "nix flake update --flake ~/tony-nixos && sudo nixos-rebuild switch --flake ~/tony-nixos/";
    };
    # The block below is for commands that should run every time a terminal starts.
    initExtra = ''
      # Source the personal file for all interactive shell sessions
      if [ -f ~/.bashrc-personal ]; then
        source ~/.bashrc-personal
      fi
    '';
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec uwsm start -S hyprland-uwsm.desktop
      fi
    '';
  };
 };
    home.file.".config/hypr/hyprland.conf".source = ./config/hypr/hyprland.conf;
    home.file.".config/hypr/hyprpaper.conf".source = ./config/hypr/hyprpaper.conf;
    home.file.".config/waybar".source = ./config/waybar;
    home.file.".config/foot/foot.ini".source = ./config/foot/foot.ini;
    home.file.".bashrc-personal".source = ./config/.bashrc-personal;
}
