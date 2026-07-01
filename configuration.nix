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
#    theme = "/boot/grub/themes/catppuccin-macchiato-grub-theme";
    configurationName = "NixOS";
    useOSProber = false;
#    extraEntries = ''
#      menuentry "Windows 10" --class windows --class os {
#          insmod part_gpt
#          insmod fat
#          insmod search_fs_uuid
#          insmod chain
#          search --no-floppy --fs-uuid --set=root 8C4D-C213
#          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
#      }
#    '';
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
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
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
      sf = "synfetch";
      java = "steam-run java";
    };
  };

  environment.sessionVariables = {
  PATH = [ "$HOME/.local/bin" ];
  };

  # Some custom builds
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
    unzip
    unrar
    tmux
    rofi
#    dwm
#    st
    noctalia-shell
    cava
    xwallpaper
#    (pkgs.callPackage /home/beamy/beamwm/beamwm.nix {})
    xwayland-satellite
    wlr-randr
    openjdk21
    dnsmasq
    bridge-utils
    netcat-openbsd
    virt-viewer
    cmatrix
    steam-run-free
    gamemode
    mission-center
    linuxPackages.cpupower
  ];
  # programs Programs apps Apps ^

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        xorg.libXxf86vm 
        libGL
      ];
    };
  };

  # Virtualisation
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };
  programs.virt-manager.enable = true;

  # Polkit agent (mates)
  security.polkit.enable = true;
  systemd.user.services.polkit-mate-authentication-agent-1 = {
  description = "polkit-mate-authentication-agent-1";
  wantedBy = [ "graphical-session.target" ];
  wants = [ "graphical-session.target" ];
  after = [ "graphical-session.target" ];
  serviceConfig = {
    Type = "simple";
    ExecStart = "${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
    Restart = "on-failure";
    RestartSec = 1;
    TimeoutStopSec = 10;
    };
  };

  # Fonts
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

  # Conflicts
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
  environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = pkgs.lib.mkForce "${pkgs.gnome-desktop}/share/gsettings-schemas/gnome-desktop-${pkgs.gnome-desktop.version}";

  # idk what this is, useless
  system.stateVersion = "26.05";

  # Services and DE's / WM's
  services.flatpak.enable = true;
  services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
  };
  programs.xwayland.enable = true;
  services.printing.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = false;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
#  services.xserver.windowManager.dwm.enable = true;
  programs.hyprland.enable = true;
  programs.niri.enable = true;
  programs.steam.enable = true;
#  services.displayManager.sessionPackages = [
#  	(pkgs.callPackage /home/beamy/beamwm/beamwm.nix {}) 
#  	(pkgs.callPackage /home/beamy/mangowm/mango.nix {}) 
#  ];
}
