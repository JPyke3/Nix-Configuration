{
  config,
  pkgs,
  lib,
  ...
}: {
  home.file.".zsh/pure".source = pkgs.fetchFromGitHub {
    owner = "sindresorhus";
    repo = "pure";
    rev = "a02209d36c8509c0e62f44324127632999c9c0cf";
    hash = "sha256-BmQO4xqd/3QnpLUitD2obVxL0UulpboT8jGNEh4ri8k=";
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    envExtra = ''
      chatgptc() {
      	cat | chatgpt "Do not output anything except code, do not add explanations, do not provide a description of your work, do not add the code to a code block. I want you to $@" | sed '/^```/d'
      }
    '';
    shellAliases = {
      aria2c = "${pkgs.aria2}/bin/aria2c --split=32 --min-split-size=4M --max-connection-per-server=16 --max-concurrent-downloads=16";
      vim = "nvim";
      ls = "${pkgs.eza}/bin/eza --icons --git";
      ll = "ls -lh -s date";
    };
    oh-my-zsh = {
      enable = true;
      theme = "";
    };
    plugins = [
      {
        #zsh vi mode
        name = "zsh-vi-mode";
        src = pkgs.fetchFromGitHub {
          owner = "jeffreytse";
          repo = "zsh-vi-mode";
          rev = "v0.11.0";
          sha256 = "sha256-xbchXJTFWeABTwq6h4KWLh+EvydDrDzcY9AQVK65RS8=";
        };
      }
    ];
    initContent = lib.mkMerge [
      # Fastfetch on terminal open (skip in nested shells/tmux/zellij)
      (lib.mkOrder 100 ''
        if [[ -z "$TMUX" && -z "$ZELLIJ" && $SHLVL -eq 1 ]]; then
          fastfetch
        fi
      '')
      # Before compinit (order 550)
      (lib.mkOrder 550 ''
        fpath+=($HOME/.zsh/pure)
        autoload -U promptinit; promptinit
        prompt pure
      '')
      # After compinit (default order 1000)
      ''
        # Amazon Q pre block. Keep at the top of this file.
        [[ -f "$HOME/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

        if [[ "$OSTYPE" == "darwin"* ]]; then
          export SECRETS_DIR="$(getconf DARWIN_USER_TEMP_DIR)secrets"
          export PATH="$PATH:/Library/TeX/texbin"
          export PATH="$PATH:/Users/jacobpyke/bin/local/scripts"
          export PATH="$PATH:/Users/jacobpyke/bin/local/applications"
          export PATH="$PATH:/Users/jacobpyke/.cargo/bin"
          export PATH="$PATH:/Users/jacobpyke/Library/Python/3.9/bin"
        else
          export SECRETS_DIR="$XDG_RUNTIME_DIR/secrets"
          export PATH="$HOME/.local/bin:$PATH"
          export PATH="$PATH:/home/jacobpyke/bin/local/scripts"
          export PATH="$PATH:/home/jacobpyke/.cargo/bin"
          [[ -d "$HOME/.opencode/bin" ]] && export PATH="$HOME/.opencode/bin:$PATH"
        fi

        export OPENAI_API_KEY="$(cat ~/.secrets/llms/openai_api_key)"
        export UP_API_KEY="$(cat ~/.secrets/up/accesskey)"
        export PATH="$PATH:$HOME/.config/home-manager/"
        bindkey -s ^f "tmux-sessionizer\n"
        eval "$(direnv hook zsh)"

        function tmux_sessionizer() {
          tmux-sessionizer
        }

        function zvm_after_lazy_keybindings() {
          # Here we define the custom widget
          zvm_define_widget tmux_sessionizer

          # In normal mode, press Ctrl-E to invoke this widget
          zvm_bindkey vicmd '^f' tmux_sessionizer
        }

        # Amazon Q post block. Keep at the bottom of this file.
        [[ -f "$HOME/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "$HOME/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('/Users/jacobpyke/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
          eval "$__conda_setup"
        else
          if [ -f "/Users/jacobpyke/miniconda3/etc/profile.d/conda.sh" ]; then
            . "/Users/jacobpyke/miniconda3/etc/profile.d/conda.sh"
          else
            export PATH="/Users/jacobpyke/miniconda3/bin:$PATH"
          fi
        fi
        unset __conda_setup
        # <<< conda initialize <<<

        if [ -f "/Users/jacobpyke/.config/fabric/fabric-bootstrap.inc" ]; then . "/Users/jacobpyke/.config/fabric/fabric-bootstrap.inc"; fi

        # wrap the ollama command, if the parameter is pull with no other parameters pull all models
        function ollama() {
          if [[ $1 == "pull" ]] && [[ $# -eq 1 ]]; then
            echo "pulling all models..."
            ollama list | awk '$1 !~ /^registry.local/ {print $1}' | while read -r model; do
              echo "Pulling $model"
              ollama pull "$model"
            done
          else
            command ollama "$@"
          fi
        }
      ''
    ];
  };
}
