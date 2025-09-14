{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    baseIndex = 1;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.tokyo-night-tmux;
        extraConfig = "
          ## Tokyo Night Theme configuration
          set -g @theme_variation 'moon'
          set -g @theme_left_separator ''
          set -g @theme_right_separator ''
          set -g @theme_plugins 'datetime,weather,playerctl,yay'
          	  ";
      }
    ];
    extraConfig = "
    	# Bind `prefix + v` to enter copy-mode
    	bind v copy-mode

    	# In copy-mode (vi keys), pressing i cancels/exits copy-mode
    	bind -T copy-mode-vi 'i' send-keys -X cancel

    	# In copy-mode, `v` starts a selection (like vim visual mode)
    	bind-key -T copy-mode-vi 'v' send -X begin-selection

    	# In copy-mode, Esacpe cancels selections
    	bind-key -T copy-mode-vi Escape send -X clear-selection

    	# In copy-mode, `y` copies the selection and clears it,
    	# but does NOT exit copy-mode — only i can exit
    	bind-key -T copy-mode-vi 'y' send -X copy-selection-no-clear \\\; send -X clear-selection
    #
    # 	";
  };
}
