{ config, lib, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.killall
    pkgs.fantasque-sans-mono
    pkgs.nerdfonts
    pkgs.unzip
    pkgs.dunst
    pkgs.pywal
    pkgs.solaar
    pkgs.redshift
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.rofi.enable = true;
  programs.fish = {
    enable = true;

    functions = {
      fish_prompt = "test \"$USER\" = 'root'
      and echo (set_color red)\"#\"

      echo -n (set_color cyan)(prompt_pwd) (set_color red)'❯'(set_color yellow)'❯'(set_color green)'❯ '";
    };

    shellInit = ''
      set --export EDITOR "nvim -f"
      set -U fish_greeting
    '';
  };

  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      alsaSupport = true;
    };
    config = ./polybar/config.ini;
    script = "~/.config/polybar/launch.sh";
  };

  programs.urxvt = {
    enable = true;

    fonts = [ "xft:DejaVu Sans Mono:pixelsize=15" ];

    transparent = false;
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
    ];
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "pepijn";
  home.homeDirectory = "/home/pepijn";

  home.file.".config/i3/config".source = ./i3/config;
  home.file.".Xresources".source = ./.Xresources;
  # home.file.".Xdefaults".source = ./.Xresources;
  home.file.".config/polybar/launch.sh".source = ./polybar/launch.sh;
  home.file.".config/polybar/scripts".source = ./polybar/scripts;
  home.file.".config/polybar/fonts".source = ./polybar/fonts;
  home.file.".config/dunst".source = ./dunst;

  nixpkgs.config.allowUnfree = true;
  home.file.".config/nixpkgs/config.nix".text = ''
    { allowUnfree = true; }
  '';

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}
