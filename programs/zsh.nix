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
      aria2c = "aria2c --split=32 --min-split-size=4M --max-connection-per-server=16 --max-concurrent-downloads=16";
      vim = "nvim";
    };
    oh-my-zsh = {
      enable = true;
      theme = "";
    };
    initExtraBeforeCompInit = ''
      fpath+=($HOME/.zsh/pure)
      autoload -U promptinit; promptinit
      prompt pure
    '';
    initExtra = ''
         if [[ "$OSTYPE" == "darwin"* ]]; then
         	export PATH="$PATH:/Library/TeX/texbin"
         	export PATH="$PATH:/Users/jacobpyke/bin/local/scripts"
         	export PATH="$PATH:/Users/jacobpyke/bin/local/applications"
         	export PATH="$PATH:/Users/jacobpyke/.cargo/bin"
         else
         	export PATH="$PATH:/home/jacobpyke/bin/local/scripts"
         	export PATH="$PATH:/home/jacobpyke/.cargo/bin"
         fi

      export PATH="$PATH:$HOME/.config/home-manager/"

         bindkey -s ^f "tmux-sessionizer\n"

         eval "$(direnv hook zsh)"

         source "$HOME/.secrets.sh"
    '';
  };
}