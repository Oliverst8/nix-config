{ pkgs, ... }:

let
  tmux-tokyo-night = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-tokyo-night.tmux";
    rtpFilePath = "tmux-tokyo-night.tmux";
    version = "v1.11.0"; # or the latest release
    src = pkgs.fetchFromGitHub {
      owner = "fabioluciano";
      repo = "tmux-tokyo-night";
      rev = "v1.11.0"; # replace with the tag or commit you want
      sha256 = "sha256-WjDbunWmxbw/jjvc34ujOWif18POC3WVO1s+hk9SLg4=";
    };
  };
in
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    baseIndex = 1;

    plugins = [
      {
        plugin = tmux-tokyo-night;
        extraConfig = ''
          ## Tokyo Night Theme configuration
          set -g @theme_variation "moon"
          set -g @theme_left_separator ""
          set -g @theme_right_separator ""

          ### Enable transparency
          set -g @theme_transparent_status_bar "true"
          set -g @theme_transparent_left_separator_inverse ""
          set -g @theme_transparent_right_separator_inverse ""
        '';
      }
    ];

    extraConfig = ''
      # Bind `prefix + v` to enter copy-mode
      bind v copy-mode

      # In copy-mode (vi keys), pressing i cancels/exits copy-mode
      bind -T copy-mode-vi i send-keys -X cancel

      # In copy-mode, `v` starts a selection (like vim visual mode)
      bind-key -T copy-mode-vi v send -X begin-selection

      # In copy-mode, Escape cancels selections
      bind-key -T copy-mode-vi Escape send -X clear-selection

      # In copy-mode, `y` copies the selection and clears it,
      # but does NOT exit copy-mode — only i can exit
      bind-key -T copy-mode-vi y send -X copy-selection-no-clear \\\; send -X clear-selection
    '';
  };
}
