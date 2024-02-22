{ config, pkgs, ... }:
{
  home.username = "jacobpyke";
  home.homeDirectory = "/home/jacobpyke";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = [
  	pkgs.lf
	pkgs.neovim
	pkgs.aria
	pkgs.tmux
	pkgs.nodejs_20 # LTS and Needed for Copilot
	pkgs.direnv
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {

  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zsh = {
	enable = true;
	enableCompletion = true;
	enableAutosuggestions = true;
	syntaxHighlighting.enable = true;
	envExtra = 
		''
			chatgptc() {
				cat | chatgpt "Do not output anything except code, do not add explanations, do not provide a description of your work, do not add the code to a code block. I want you to $@" | sed '/^```/d'
			}
		'';
	shellAliases = {
		aria2c = "aria2c --split=32 --min-split-size=4M --max-connection-per-server=16 --max-concurrent-downloads=16";
		vim = "nvim";
	};
	oh-my-zsh = {
		enable = true;
		theme = "";
	};
	initExtraBeforeCompInit = 
		''
			fpath+=($HOME/.zsh/pure)
			autoload -U promptinit; promptinit
			prompt pure
		'';
	initExtra =
		''
			if [[ "$OSTYPE" == "darwin"* ]]; then
				export PATH="$PATH:/Library/TeX/texbin"
				export PATH="$PATH:/Users/jacobpyke/bin/local/scripts"
				export PATH="$PATH:/Users/jacobpyke/bin/local/applications"
				export PATH="$PATH:/Users/jacobpyke/.cargo/bin"
			else
				export PATH="$PATH:/home/jacobpyke/bin/local/scripts"
				export PATH="$PATH:/home/jacobpyke/.cargo/bin"
			fi

			bindkey -s ^f "tmux-sessionizer\n"

			eval "$(direnv hook zsh)"
		'';
  };

  programs.tmux = {
	enable = true;
	plugins = with pkgs; [
		{ 
			plugin = tmuxPlugins.dracula;
 			extraConfig =
				''
					# available plugins: battery, cpu-usage, git, gpu-usage, ram-usage, tmux-ram-usage, network, network-bandwidth, network-ping, ssh-session, attached-clients, network-vpn, weather, time, mpc, spotify-tui, kubernetes-context, synchronize-panes
					set -g @dracula-show-empty-plugins false
					set -g @dracula-plugins "git attached-clients battery weather time"
					set -g @dracula-show-powerline true

					# it can accept `hostname` (full hostname), `session`, `shortname` (short name), `smiley`, `window`, or any character. 
					set -g @dracula-clients-minimum 1
					set -g @dracula-show-left-icon session
					set -g @dracula-show-fahrenheit false
					set -g @dracula-show-location false
				'';
		}
		tmuxPlugins.vim-tmux-navigator
		{ plugin = tmuxPlugins.mkTmuxPlugin {
			pluginName = "better-vim-tmux-resizer";
			version = "unstable-2021-08-02";
			rtpFilePath = "better-vim-tmux-resizer.tmux";
			src = pkgs.fetchFromGitHub {
			  owner = "RyanMillerC";
			  repo = "better-vim-tmux-resizer";
			  rev = "a791fe5b4433ac43a4dad921e94b7b5f88751048";
			  hash = "sha256-1uHcQQUnViktDBZt+aytlBF1ZG+/Ifv5VVoKSyM9ML0=";
			};
		  }; }
	];

	extraConfig =
		''
		set -g default-terminal "xterm-256color"
		set -ga terminal-overrides ",*256col*:Tc"
		set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
		set-environment -g COLORTERM "truecolor"

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

		set-option -g status-position top
		'';

  };

  programs.home-manager.enable = true;
}
