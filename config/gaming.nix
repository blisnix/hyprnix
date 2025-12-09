{
  config,
  pkgs,
  lib,
  ...
}: {
  # Allow unfree just for the gaming bits (Steam etc.)
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];

  # Steam + useful extras
  programs.steam = {
    enable = true;

    # Optional but nice:
    #remotePlay.openFirewall = true;
    #dedicatedServer.openFirewall = true;
    #localNetworkGameTransfers.openFirewall = true;

    # For Hyprland, gamescope session is handy
    gamescopeSession.enable = true;
  };

  # GameMode for on-demand performance tweaks
  programs.gamemode.enable = true;

  # Gamescope as a system program (handy for custom launch scripts)
  programs.gamescope.enable = true;

  # Game controllers (Steam Deck, Xbox, PS controllers etc.)
  hardware.steam-hardware.enable = true;

  # System packages that are nice to have globally
  environment.systemPackages = with pkgs; [
    mangohud # FPS/frametime overlay
    protonup-qt # Install Proton-GE etc.
    goverlay # GUI for Mangohud/Gamemode
    #lutris
    #heroic
    #bottles
    #wineWowPackages.staging
    #winetricks
  ];
}
