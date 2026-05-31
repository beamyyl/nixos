{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Bucharest";

  security.sudo.wheelNeedsPassword = false;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.beamy = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" "sudo" "docker" "kubectl" ];
    };
    shellAliases = {
      ff = "fastfetch";
      syu = "sudo nixos-rebuild switch --upgrade";
    };
  };

  # dwm things
#  nixpkgs.overlays = [
#    (final: prev: {
#      dwm = prev.dwm.overrideAttrs (oldAttrs: {
#        src = builtins.path { path = "/home/beamy/dwm/dwm"; };
#      });
#      st = prev.st.overrideAttrs (oldAttrs: {
#        src = builtins.path { path = "/home/beamy/dwm/st"; };
#      });
#    })
#  ];

  environment.systemPackages = with pkgs; [
    neovim 
    wget
    fastfetch
    pfetch
    screenfetch
    alacritty
    foot
    pcmanfm
    picom
    xset
    xclip
    maim
    slurp
    grim
    wl-clipboard
    firefox
    librewolf
    git
    gcc
    gpp
    gnome-tweaks
    gnome-extension-manager
    ptyxis
    papirus-icon-theme
    spotify
    unzip
    unrar
    tmux
    rofi
#    (pkgs.callPackage /home/beamy/beamwm/beamwm.nix {})
#    dwm
#    st
    noctalia-shell
    xwallpaper
  ];

  # apps Apps ^

  # Fonts:
  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    nerd-fonts.adwaita-mono
  ];

  # Drivers
  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # Conflicts:
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";

  system.stateVersion = "26.05";

  # Services and DE's / WM's
  services.flatpak.enable = true;
  services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
  };
#  services.xserver.windowManager.dwm.enable = true;
#  services.displayManager.sessionPackages = [ (pkgs.callPackage /home/beamy/beamwm/beamwm.nix {}) ];
  services.printing.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = false;
  services.displayManager.sddm.enable = true;
  systemd.services.display-manager.wantedBy = lib.mkForce [ ];
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  programs.hyprland.enable = true;
}
