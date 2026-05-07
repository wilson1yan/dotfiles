setopt SHARE_HISTORY          # Share history between all sessions
setopt INC_APPEND_HISTORY     # Write commands to history file immediately, not on shell exit
setopt HIST_IGNORE_DUPS       # Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicate entries
setopt HIST_FIND_NO_DUPS      # Don't show duplicates when searching

HISTFILE=~/.zsh_history
HISTSIZE=10000                # Lines kept in memory per session
SAVEHIST=10000                # Lines saved to HISTFILE

export PATH="$HOME/.local/bin:$PATH"
 
PROMPT='%F{75}%m%f %F{39}→%f '
 
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
 
bindkey -v
bindkey '^R' history-incremental-search-backward
