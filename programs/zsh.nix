{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    envExtra = ''
      chatgptc() {
      	cat | chatgpt "Do not output anything except code, do not add explanations, do not provide a description of your work, do not add the code to a code block. I want you to $@" | sed '/^```/d'
      }
    '';
    shellAliases = {
      aria2c = "${pkgs.aria}/bin/aria2c --split=32 --min-split-size=4M --max-connection-per-server=16 --max-concurrent-downloads=16";
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
    initExtraBeforeCompInit = ''
      fpath+=($HOME/.zsh/pure)
      autoload -U promptinit; promptinit
      prompt pure
    '';
    initExtra = ''

         if [[ "$OSTYPE" == "darwin"* ]]; then
      export SECRETS_DIR="$(getconf DARWIN_USER_TEMP_DIR)/secrets"
            export PATH="$PATH:/Library/TeX/texbin"
            export PATH="$PATH:/Users/jacobpyke/bin/local/scripts"
            export PATH="$PATH:/Users/jacobpyke/bin/local/applications"
            export PATH="$PATH:/Users/jacobpyke/.cargo/bin"
         else
      	 export SECRETS_DIR="$XDG_RUNTIME_DIR/secrets"
            export PATH="$PATH:/home/jacobpyke/bin/local/scripts"
            export PATH="$PATH:/home/jacobpyke/.cargo/bin"
         fi

         export OPENAI_API_KEY="$(cat $SECRETS_DIR/openai-api-key)"

         export PATH="$PATH:$HOME/.config/home-manager/"

         bindkey -s ^f "tmux-sessionizer\n"

         eval "$(direnv hook zsh)"

         source "$HOME/.secrets.sh"

              function tmux_sessionizer() {
             	  tmux-sessionizer
              }

              function zvm_after_lazy_keybindings() {
               # Here we define the custom widget
               zvm_define_widget tmux_sessionizer

               # In normal mode, press Ctrl-E to invoke this widget
               zvm_bindkey vicmd '^f' tmux_sessionizer
             }
    '';
  };
}
