# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "matts-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/mnt/nfs/file-server" = {
    device = "file-server.home.arpa:/srv/nfs/pool";
    fsType = "nfs";
    options = [ "x-systemd.automount" "x-systemd.idle-timeout=60" "noauto" ];
  };

  fileSystems."/mnt/nfs/backup-server" = {
    device = "backup-server.home.arpa:/srv/nfs/pool";
    fsType = "nfs";
    options = [ "x-systemd.automount" "x-systemd.idle-timeout=60" "noauto" ];
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  users.groups.system.gid = 2000;
  users.groups.private.gid = 2001;
  users.groups.public.gid = 2002;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.matt.gid = 1000;
  users.users.matt = {
    group = "matt";
    isNormalUser = true;
    description = "Matt";
    extraGroups = [ "users" "networkmanager" "wheel" "wireshark" "private" "public" ];
    packages = with pkgs; [
      firefox
      remmina
      chromium
      deskflow
      vscode
      go
      python314
      zellij
      neovim
      fzf
      ripgrep
      wireshark
      nmap
      protonvpn-gui
      jq
      inetutils
      wakelan
      weston
      lua
      luarocks
      rustup
      gcc
      nodejs_24
      tree-sitter
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.ubuntu
  ];

  programs.niri.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
  };

  programs.wireshark.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    tmux
    vim
    git
    curl
    wget
    nixfmt-rfc-style
    nfs-utils
    wireguard-tools
    
# stuff for niri
    rio
    alacritty
    fuzzel
    mako
    waybar
#    xdg-desktop-portal-gtk
#    xdg-desktop-portal-gnome
    swaybg
    swayidle
    swaylock
    xwayland-satellite
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

#  services.xserver = {
#    enable = true;
#    desktopManager = {
#      xterm.enable = false;
#      xfce.enable = true;
#     xfce.enableWaylandSession = true;
#    };
#  };
#  services.displayManager.defaultSession = "xfce";

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 24800 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.nftables.enable = true;

  virtualisation.incus.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.waydroid.enable = true;

#  systemd.user.services."cortile" = {
#    enable = true;
#    description = "Tiling Window Manager";
#    serviceConfig = {
#      Type = "simple";
#      ExecStart = "/etc/profiles/per-user/matt/bin/cortile";
#    };
#  };
  
  location.latitude = 51.509865;
  location.longitude = -0.118092;
  services.redshift = {
    enable = true;
    brightness = {
      day = "1";
      night = "0.5";
    };
    temperature = {
      day = 5500;
      night = 3700;
    };
  };

  # services.kmscon = {
  #   enable = true;
  #   useXkbConfig = true;
  #   extraConfig = ''
  #     xkb-layout=gb
  #   '';
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
