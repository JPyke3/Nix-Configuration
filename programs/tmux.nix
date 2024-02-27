{
  config,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmuxPlugins.mkTmuxPlugin {
          pluginName = "better-vim-tmux-resizer";
          version = "unstable-2021-08-02";
          rtpFilePath = "better-vim-tmux-resizer.tmux";
          src = pkgs.fetchFromGitHub {
            owner = "RyanMillerC";
            repo = "better-vim-tmux-resizer";
            rev = "a791fe5b4433ac43a4dad921e94b7b5f88751048";
            hash = "sha256-1uHcQQUnViktDBZt+aytlBF1ZG+/Ifv5VVoKSyM9ML0=";
          };
        };
      }
    ];

    extraConfig = ''
           set -g default-terminal "xterm-256color"

               set-window-option -g mode-keys vi
               bind-key -T copy-mode-vi v send -X begin-selection
               bind-key -T copy-mode-vi V send -X select-line

               set-environment -g COLORTERM "truecolor"

      # Vim Status bar in tmux
      set -g focus-events on
      set -g status-style bg=default
      set -g status-left-length 90
      set -g status-right-length 90
      set -g status-justify centre

               # vim-like pane resizing
               bind -r C-k resize-pane -U
               bind -r C-j resize-pane -D
               bind -r C-h resize-pane -L
               bind -r C-l resize-pane -R

               # vim-like pane switching
               bind -r k select-pane -U
               bind -r j select-pane -D
               bind -r h select-pane -L
               bind -r l select-pane -R

               # and now unbind keys
               unbind Up
               unbind Down
               unbind Left
               unbind Right

               unbind C-Up
               unbind C-Down
               unbind C-Left
               unbind C-Right
    '';
  };
}
