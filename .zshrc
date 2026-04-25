export PATH="$HOME/.local/bin:$PATH"
 
PROMPT='%F{75}%m%f %F{39}→%f '
 
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
 
bindkey -v
bindkey '^R' history-incremental-search-backward
