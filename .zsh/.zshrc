# vim: foldmethod=marker
# ------------------------------------------------------------------------------
# File: .zshrc 
# Description: Loaded for ZSH interactive sessions
# ------------------------------------------------------------------------------


# 1.0 - Initialization  {{{

# Start profiling
zmodload zsh/zprof  

if [[ ! -f ${ZDOTDIR}/.zcomet/bin/zcomet.zsh ]]; then
	command git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR}/.zcomet/bin
fi
source ${ZDOTDIR}/.zcomet/bin/zcomet.zsh

[ -f $ZDOTDIR/.zlocal.zsh ] && source ${ZDOTDIR}/.zlocal.zsh

# Function Paths 
fpath+="${HOME}/.local/share/zsh/functions"
fpath+="${ZDOTDIR}/.zfunc"
autoload -Uz $fpath[1]/*(.:t)
fpath+="$(brew --prefix)/share/zsh/site-functions" 
# }}}

# 3.0 - Completion {{{

zmodload zsh/complist  # Should be called before compinit

unsetopt completealiases        # Don't expand aliases before completionfinishes
setopt glob_complete			# Show autocompletion menu with globs
setopt menu_complete			# Automatically highlight first element of completion menu
setopt auto_list				# Automatically list choices on ambiguous completion.
setopt complete_in_word			# Complete from both ends of a word.
setopt no_list_beep				# Don't beep when listing choices on ambiguous completion
zstyle ':completion:*' completer _extensions _complete _approximate
# Use cache for commands using cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true
zle -C alias-expension complete-word _generic
zstyle ':completion:alias-expension:*' completer _expand_alias
# Allow you to select in a menu
zstyle ':completion:*' menu select
# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
# zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# Colors for files and directory
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}
# Only display some tags for the command cd
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
# zstyle ':completion:*:complete:git:argument-1:' tag-order !aliases
# Required for completion to be in good groups (named after the tags)
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
# See ZSHCOMPWID "completion matching control"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' keep-prefix true
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'


bindkey -M menuselect 'h' vi-backward-char					# select left in completion menu					
bindkey -M menuselect 'k' vi-up-line-or-history				# select above in completion menu
bindkey -M menuselect 'j' vi-down-line-or-history   		# select below in completion menu
bindkey -M menuselect 'l' vi-forward-char					# select right in completion menu
bindkey -M menuselect '^xg' clear-screen					# Clears the screen?
bindkey -M menuselect '^xi' vi-insert						# Insert
bindkey -M menuselect '^xh' accept-and-hold                	# Hold
bindkey -M menuselect '^xn' accept-and-infer-next-history  	# Next
bindkey -M menuselect '^xu' undo                           	# Undo

# }}}

# {{{ 2.0 - Plugins 
zcomet load romkatv/powerlevel10k		
zcomet load ohmyzsh plugins/direnv
zcomet load ohmyzsh plugins/fd
zcomet trigger gh ohmyzsh plugins/gh
zcomet load ohmyzsh plugins/iterm2
zcomet load ohmyzsh plugins/gnu-utils
zcomet load ohmyzsh plugins/gpg-agent
zcomet load ohmyzsh plugins/ripgrep
zcomet load ohmyzsh plugins/rust
zcomet load ohmyzsh plugins/ssh-agent
zcomet load ohmyzsh plugins/rust
zcomet load ohmyzsh plugins/zoxide
zcomet load ohmyzsh plugins/git
zcomet load ohmyzsh plugins/dash

zcomet trigger tmux ohmyzsh plugins/tmux
zcomet trigger npm ohmyzsh plugins/npm
zcomet trigger nvm ohmyzsh plugins/nvm

zcomet snippet OMZ::lib/directories.zsh
zcomet snippet OMZ::plugins/1password/1password.plugin.zsh
zcomet snippet OMZ::plugins/multipass/multipass.plugin.zsh

zcomet load zsh-users/zsh-autosuggestions			
zcomet load zsh-users/zsh-syntax-highlighting	
zcomet load zsh-users/zsh-completions			
zcomet load softmoth/zsh-vim-mode
zcomet compinit 

zcomet load junegunn/fzf shell completion.zsh key-bindings.zsh

if command -v aws_completer &> /dev/null; then
  autoload -Uz bashcompinit && bashcompinit
  complete -C aws_completer aws
  complete -C aws_completer sam
fi
# }}}

# 5.0 - Integrations {{{
#
(( $+commands[nvim] )) && EDITOR=nvim || EDITOR=vi
(( $+commands[most])) && PAGER=most || PAGER=less
(( $+commands[exa] )) && alias ls='exa'
(( ${+commands[fzf]} )) || ~[fzf]/install --bin

GPG_TTY=$(tty)
export GPG_TTY
export PAGER
export EDITOR
export FZF_COMPLETION_TRIGGER=';;'
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

if [[ $(uname) == 'Darwin' ]]; then
	export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"
	export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
fi

test -e ~/.p10k.zsh && source ~/.p10k.zsh

alias v='vi'
alias nv='nvim'
alias twr='gittower'
alias lzg='lazygit'
alias po='poetry'

# }}}

# 8.0 - History {{{
#
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000
HISTORY_IGNORE="pwd:ls:ll:la:.."
PER_DIRECTORY_HISTORY_TOGGLE=^G
HISTORY_BASE=$HOME/.directory_history

setopt bang_hist				# Perform textual history expansion, csh-style, treating the character ‘!’ specially.
setopt hist_no_functions		# Don't store function definitions
setopt hist_no_store			# Don't store history (fc -l) command
setopt extended_history			# Record timestamp of command in HISTFILE
setopt share_history          	# Share command history data
setopt hist_expire_dups_first 	# Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       	# Ignore duplicated commands history list
setopt hist_ignore_space      	# Ignore commands that start with space
setopt hist_verify            	# Show command with history expansion to user before running it
setopt hist_reduce_blanks		# Remove superfluous blanks from each command line being added to the history list
setopt inc_append_History		# Add new lines to the history file immediately (do not wait until exit)
unsetopt hist_beep				# Shut up shut up shut up

# }}}

# 9.0 - Misc  {{{

alias la='ls -ah'
alias ll='ls -lah'
alias l='ls -lh'

unsetopt beep			# shut up shut up shut up
unsetopt clobber		# Disallow overwriting existing files

setopt local_traps		# Allow functions to have local traps
setopt local_options	# Allow fucntions to have local options

setopt ignore_eof		# Don't exit on EOF
setopt no_bg_nice		# Don't run bg jobs at a lower priority
setopt no_hup			# Don't kill jobs when the shell exits
setopt notify			# notify when background job finishes				

bindkey -M vicmd '^h' run-help				# [N] <Ctrl-H> : show man page for current command 								
bindkey -M viins '^h' run-help				# [I] <Ctrl-H> : show man page for current command 								
bindkey -M viins '^e' autosuggest-accept	# [I] <Ctrl-E> : Accept and complete auto-suggestion
# }}}


