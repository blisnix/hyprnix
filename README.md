## Project:

## Super Simple NixOS config for Hyprland

## This configuration was taken directly from [`tony,btw` YouTube video](https://www.youtube.com/watch?v=7QLhCgDMqgw&t=138s)

### Hyprland:

- Autoloin
- Simple flake
- Simple Home Manager
- Noctalia shell
- Simple waybar as alternative
- NeoVIM configured by nixvim
- Tony,BTWs TMUX configuration

**Noctalia Shell**

![Noctalia Shell](config/images/ScreenShot-Noctalia.png)

![Noctalia Shell htop](config/images/ScreenShot-htop-noctalia.png)

**Waybar**

![Waybar](config/images/ScreenShot-waybar.png)

![Waybar htop](config/images/ScreenShot-htop-waybar.png)

### `Flake.nix`

```nix
{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixvim, noctalia, ... }: {
    nixosConfigurations.hyprland-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.dwilliams = import ./home.nix;
            backupFileExtension = "backup";
            extraSpecialArgs = { inherit inputs; };
          };
        }
      ];
    };
  };
}

```

## `configuration.nix`

```nix

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 40; # use ~50% of RAM for compressed swap (tweak as you like)
    priority = 100; # higher than any disk-based swap
  };

  networking = {
    hostName = "hyprland-btw";
    networkmanager.enable = true;
  };

  time.timeZone = "America/New_York";

  # Add services
  services = {
    getty.autologinUser = "dwilliams";
    openssh.enable = true;
    tumbler.enable = true;
    envfs.enable = true;
    libinput.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = false;
    };
    firefox.enable = true;
    thunar.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";



  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dwilliams = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [

    ## Hyprland specific
    hyprpaper
    hyprshot
    hypridle
    hyprlock
    hyprpicker
    libnotify # send alerts
    xdg-desktop-portal-hyprland


    # Hyprland Related
    quickshell
    clipman
    grim
    slurp
    nwg-look
    nwg-dock-hyprland
    nwg-menu
    nwg-panel
    nwg-launchers
    rofi
    wofi
    waybar
    waypaper
    matugen


    atop
    bat
    btop
    bottom
    clang
    curl
    eza
    fastfetch
    foot
    git
    gcc
    git
    gping
    google-chrome
    htop
    hyfetch
    kitty
    lunarvim
    luarocks
    ncdu
    nh
    onefetch
    pciutils
    ripgrep
    starship
    tmux
    ugrep
    vim
    wget
    yazi
    zig
    zoxide
  ];
  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      fira-code
      fira-code-symbols
      font-awesome
      hackgen-nf-font
      ibm-plex
      inter
      jetbrains-mono
      material-icons
      maple-mono.NF
      minecraftia
      nerd-fonts.im-writing
      nerd-fonts.blex-mono
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-monochrome-emoji
      powerline-fonts
      roboto
      roboto-mono
      symbola
      terminus_font
    ];
  };


  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  security.sudo.wheelNeedsPassword = true;
  system.stateVersion = "25.11"; # Did you read the comment?

}


}




```
