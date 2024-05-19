{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # ===> HARDWARE #
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # ===> HARDWARE #

  # ===> PARTITION #
  fileSystems = {
    "/" = {
      "device" = "/dev/disk/by-label/nixos";
      "fsType" = "xfs";
    };
    "/boot" = {
      "device" = "/dev/disk/by-label/boot";
      "fsType" = "vfat";
    };
  };
  # ===> PARTITION #

  # ===> BOOT #
  boot.initrd.availableKernelModules = [
    "nvme" "xhci_pci" "thunderbolt"
    "usb_storage" "sd_mod" "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # ===> BOOT #

  # ===> NETWORK #
  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "asspain";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  # ===> NETWORK #

  # ===> LOCALIZATION #
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  # ===> LOCALIZATION #

  # ===> SECURITY #
  security.rtkit.enable = true;
  # ===> SECURITY #
  
  # ===> SOUND #
  hardware.pulseaudio.enable = false;
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
  };
  # ===> SOUND #

  # ===> USER #
  users.users.fidelicura = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };
  # ===> USER #

  # ===> DESKTOP #
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us,ru";
    };
  };
  environment.gnome.excludePackages =
  (with pkgs; [
    gnome-tour
    gnome-connections
  ]) ++ (with pkgs.gnome; [
    epiphany
    geary
    evince
  ]);
  # ===> DESKTOP #

  # ===> VIRTUALIZATION #
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  # ===> VIRTUALIZATION #

  # ===> PACKAGE #
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # {{ USUAL }}
    stow
    helix
    telegram-desktop
    wireproxy
    coreutils diffutils findutils binutils fzf
    zip unzip rar unrar gnutar xz atool
    # {{ DEVELOPMENT }}
    git
    gcc clang rustup python3 go
    gnumake cmake just mage
    gnupatch libtool
    lldb gdb
    lld mold
    pkgconf autoconf automake
    clang-tools
  ];
  programs.firefox = {
    enable = true;
    policies = {
      "DisableTelemetry" = true;
      "DisableFirefoxStudies" = true;
      "DisablePocket" = true;
      "DisableFirefoxAccounts" = true;
      "DisableAccounts" = true;
      "DisableFormHistory" = true;
      "PasswordManagerEnabled" = false;
      "OverrideFirstRunPage" = "";
      "OverridePostUpdatePage" = "";
      "DontCheckDefaultBrowser" = true;
      "DisplayBookmarksToolbar" = "never";
      "DisplayMenuBar" = "never";
      "PromptForDownloadLocation" = false;
      "SearchBar" = "unified";
      "SearchSuggestEnabled" = false;
      "SearchEngines" = {
        "Default" = "duckduckgo";
      };
      "UserMessaging" = {
        "WhatsNew" = false;
        "ExtensionRecommendations" = false;
        "FeatureRecommendations" = false;
        "UrlbarInterventions" = false;
        "SkipOnboarding" = false;
        "MoreFromMozilla" = false;
        "Locked" = true;
      };
      "EnableTrackingProtection" = {
        "Value" = true;
        "Locked" = true;
        "Cryptomining" = true;
        "Fingerprinting" = true;
      };
      "ExtensionUpdate" = true;
      "ExtensionSettings" = {
        "*" = {
          "installation_mode" = "blocked";
        };
        "uBlock0@raymondhill.net" = {
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          "installation_mode" = "force_installed";
          "default_area" = "menupanel";
        };
        "adblockultimate@adblockultimate.net" = {
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/adblocker-ultimate/latest.xpi";
          "installation_mode" = "force_installed";
          "default_area" = "menupanel";
        };
        "firefox@ghostery.com" = {
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ghostery/latest.xpi";
          "installation_mode" = "force_installed";
          "default_area" = "menupanel";
        };
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          "installation_mode" = "force_installed";
          "default_area" = "menupanel";
        };
        "{74145f27-f039-47ce-a470-a662b129930a}" = {
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
          "installation_mode" = "force_installed";
          "default_area" = "menupanel";
        };
        "{6e7770ea-7961-483d-b411-43e88edf8c77}" = {
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/gruvbox-d-h/latest.xpi";
          "installation_mode" = "force_installed";
        };
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
          "installation_mode" = "force_installed";
          "default_area" = "menupanel";
        };
        "CanvasBlocker@kkapsner.de" = {
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/latest.xpi";
          "installation_mode" = "force_installed";
          "default_area" = "menupanel";
        };
        "{0c3ab5c8-57ac-4ad8-9dd1-ee331517884d}" = {
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/proxy-toggle/latest.xpi";
          "installation_mode" = "force_installed";
          "default_area" = "navbar";
        };
        "{3346f53a-bd1f-4f3f-94ff-70bb122083b3}" = {
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/toggle-resist-fingerprinting/latest.xpi";
          "installation_mode" = "force_installed";
          "default_area" = "navbar";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          "installation_mode" = "force_installed";
          "default_area" = "navbar";
        };
      };
    };
    preferences = {};
  };
  # ===> PACKAGE #

  # ===> SYSTEM #
  system.copySystemConfiguration = true;
  system.stateVersion = "23.11";
  # ===> SYSTEM #
}
