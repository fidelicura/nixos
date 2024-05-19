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
    package = pkgs.firefox-esr;
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
        "Default" = "DuckDuckGo";
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
      };
    };
    preferences = {
      "nglayout.initialpaint.delay" = 0;
      "nglayout.initialpaint.delay_in_oopif" = 0;
      "content.notify.interval" = 100000;
      "layout.css.grid-template-masonry-value.enabled" = true;
      "dom.enable_web_task_scheduling" = true;
      "layout.css.has-selector.enabled" = true;
      "dom.security.sanitizer.enabled" = true;
      "gfx.canvas.accelerated.cache-items" = 4096;
      "gfx.canvas.accelerated.cache-size" = 512;
      "gfx.content.skia-font-cache-size" = 20;
      "browser.cache.disk.enable" = false;
      "media.memory_cache_max_size" = 65536;
      "media.cache_readahead_limit" = 7200;
      "media.cache_resume_threshold" = 3600;
      "image.mem.decode_bytes_at_a_time" = 32768;
      "network.buffer.cache.size" = 262144;
      "network.buffer.cache.count" = 128;
      "network.http.max-connections" = 1800;
      "network.http.max-persistent-connections-per-server" = 10;
      "network.http.max-urgent-start-excessive-connections-per-host" = 5;
      "network.http.pacing.requests.enabled" = false;
      "network.dnsCacheEntries" = 1000;
      "network.dnsCacheExpiration" = 86400;
      "network.dns.max_high_priority_threads" = 8;
      "network.ssl_tokens_cache_capacity" = 10240;
      "network.http.speculative-parallel-limit" = 0;
      "network.dns.disablePrefetch" = true;
      "browser.urlbar.speculativeConnect.enabled" = false;
      "browser.places.speculativeConnect.enabled" = false;
      "network.prefetch-next" = false;
      "network.predictor.enabled" = false;
      "network.predictor.enable-prefetch" = false;
      "browser.contentblocking.category" = "strict";
      "privacy.partition.bloburl_per_partition_key" = true;
      "browser.uitour.enabled" = false;
      "privacy.globalprivacycontrol.enabled" = true;
      "privacy.globalprivacycontrol.functionality.enabled" = true;
      "privacy.trackingprotection.enabled" =	true;
      "privacy.trackingprotection.pbmode.enabled" = true;
      "privacy.donottrackheader.enabled" = true;
      "general.useragent.override" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML = like Gecko) Chrome/119.0.0.0 Safari/537.36";
      "privacy.resistFingerprinting" = true;
      "browser.search.region" = "UK";
      "doh-rollout.home-region" = "UK";
      "security.OCSP.enabled" = 0;
      "security.remote_settings.crlite_filters.enabled" = true;
      "security.pki.crlite_mode" = 2;
      "security.cert_pinning.enforcement_level" = 2;
      "security.ssl.treat_unsafe_negotiation_as_broken" = true;
      "browser.xul.error_pages.expert_bad_cert" = true;
      "security.tls.enable_0rtt_data" = false;
      "browser.privatebrowsing.forceMediaMemoryCache" = true;
      "browser.sessionstore.interval" = 60000;
      "privacy.history.custom" = true;
      "browser.search.separatePrivateDefault.ui.enabled" = true;
      "browser.urlbar.update2.engineAliasRefresh" = true;
      "browser.search.suggest.enabled" = false;
      "browser.urlbar.suggest.quicksuggest.sponsored" = false;
      "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
      "browser.formfill.enable" = false;
      "security.insecure_connection_text.enabled" = true;
      "security.insecure_connection_text.pbmode.enabled" = true;
      "network.IDN_show_punycode" = true;
      "services.sync.prefs.sync.layout.spellcheckDefault" = false;
      "services.sync.prefs.sync.spellchecker.dictionary" = false;
      "dom.security.https_first" = true;
      "dom.security.https_only_mode" =	true;
      "signon.rememberSignons" = false;
      "editor.truncate_user_pastes" = false;
      "extensions.formautofill.addresses.enabled" = false;
      "extensions.formautofill.creditCards.enabled" = false;
      "network.auth.subresource-http-auth-allow" = 1;
      "security.mixed_content.block_display_content" = true;
      "pdfjs.enableScripting" = false;
      "extensions.postDownloadThirdPartyPrompt" = false;
      "network.http.referer.XOriginTrimmingPolicy" = 2;
      "privacy.userContext.ui.enabled" = true;
      "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
      "media.peerconnection.ice.default_address_only" = true;
      "browser.safebrowsing.downloads.remote.enabled" = false;
      "identity.fxaccounts.enabled" = false;
      "permissions.default.desktop-notification" = 2;
      "permissions.default.geo" = 2;
      "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
      "permissions.manager.defaultsUrl" = "";
      "webchannel.allowObject.urlWhitelist" = "";
      "geo.enabled" = false;
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.server" = "data: =";
      "toolkit.telemetry.archive.enabled" = false;
      "toolkit.telemetry.newProfilePing.enabled" = false;
      "toolkit.telemetry.shutdownPingSender.enabled" = false;
      "toolkit.telemetry.updatePing.enabled" = false;
      "toolkit.telemetry.bhrPing.enabled" = false;
      "toolkit.telemetry.firstShutdownPing.enabled" = false;
      "toolkit.telemetry.coverage.opt-out" = true;
      "toolkit.coverage.opt-out" = true;
      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
      "app.shield.optoutstudies.enabled" = false;
      "browser.discovery.enabled" = false;
      "breakpad.reportURL" = "";
      "browser.tabs.crashReporting.sendReport" = false;
      "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
      "captivedetect.canonicalURL" = "";
      "network.captive-portal-service.enabled" = false;
      "network.connectivity-service.enabled" = false;
      "app.normandy.enabled" = false;
      "app.normandy.api_url" = "";
      "browser.ping-centre.telemetry" = false;
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;
      "layout.css.prefers-color-scheme.content-override" = 2;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "app.update.suppressPrompts" = true;
      "browser.compactmode.show" = true;
      "browser.privatebrowsing.vpnpromourl" = "";
      "extensions.getAddons.showPane" = false;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      "browser.shell.checkDefaultBrowser" = false;
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
      "browser.preferences.moreFromMozilla" = false;
      "browser.tabs.firefox-view" = false;
      "browser.tabs.tabmanager.enabled" = false;
      "browser.aboutConfig.showWarning" = false;
      "browser.aboutwelcome.enabled" = false;
      "browser.display.focus_ring_on_anything" = true;
      "browser.display.focus_ring_style" = 0;
      "browser.display.focus_ring_width" = 0;
      "browser.privateWindowSeparation.enabled" = false;
      "cookiebanners.service.mode" = 2;
      "cookiebanners.service.mode.privateBrowsing" = 2;
      "browser.translations.enable" = true;
      "browser.toolbars.bookmarks.visibility" = "never";
      "browser.urlbar.shortcuts.bookmarks" = false;
      "browser.urlbar.shortcuts.history" = false;
      "browser.urlbar.shortcuts.tabs" = false;
      "browser.translations.alwaysTranslateLanguages" = false;
      "browser.translations.neverTranslateLanguages" = true;
      "browser.translations.autoTranslate" = false;
      "full-screen-api.transition-duration.enter" = "0 0";
      "full-screen-api.transition-duration.leave" = "0 0";
      "full-screen-api.warning.delay" = -1;
      "full-screen-api.warning.timeout" = 0;
      "browser.urlbar.suggest.history" = false;
      "browser.urlbar.suggest.engines" = false;
      "browser.urlbar.suggest.topsites" = false;
      "browser.urlbar.suggest.calculator" = true;
      "browser.urlbar.unitConversion.enabled" = true;
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "extensions.pocket.enabled" = false;
      "browser.download.useDownloadDir" = false;
      "browser.download.always_ask_before_handling_new_types" = true;
      "browser.download.alwaysOpenPanel" = false;
      "browser.download.manager.addToRecentDocs" = false;
      "browser.download.open_pdf_attachments_inline" = true;
      "pdfjs.sidebarViewOnLoad" = 2;
      "browser.bookmarks.openInTabClosesMenu" = false;
      "browser.menu.showViewImageInfo" = true;
      "findbar.highlightAll" = true;
      "apz.overscroll.enabled" = true;
      "general.smoothScroll" = true; 
      "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
      "general.smoothScroll.msdPhysics.enabled" = true;
      "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
      "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
      "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
      "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = 2;
      "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
      "general.smoothScroll.currentVelocityWeighting" = 1;
      "general.smoothScroll.stopDecelerationWeighting" = 1;
      "mousewheel.default.delta_multiplier_y" = 300;
      "browser.startup.page" = 3;
      "media.videocontrols.picture-in-picture.enabled" = false;
    };
  };
  # ===> PACKAGE #

  # ===> GARBAGE #
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };
  # ===> GARBAGE #

  # ===> SYSTEM #
  system.copySystemConfiguration = true;
  system.stateVersion = "23.11";
  # ===> SYSTEM #
}
