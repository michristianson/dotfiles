# System Settings {{{1
# TODO: Possibly tweak the PATH and NOPOWERLINEFONTS definitions in this section.
# Set the PATH variable.
export GOPATH=$HOME/gopath
export PATH=~/bin:~/.local/bin:$GOPATH:$GOPATH/bin:$PATH

# Set neovim to be the default editor.
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

# Tell X11 to use a US keyboard layout with caps lock
# mapped to control. We then pipe stderr (which has file
# descriptor 2) to /dev/null to silence any errors
# (which will necessarily arise if we're calling this in a
# terminal outside of an X session).
setxkbmap -layout us -option ctrl:nocaps 2> /dev/null

# If we're in a login shell, define the NOPOWERLINEFONTS variable
# so that vim knows not to use powerline fonts in airline.
# If we're not in a login shell, then we may have received the
# NOPOWERLINEFONTS variable from the parent shell (which is
# usually the login shell), so unset it here.
if [[ -o login ]]; then
  export NOPOWERLINEFONTS=""
else
  unset NOPOWERLINEFONTS
fi
# }}}
# Zsh Settings {{{1
# History {{{2
# Set the file where history will be stored.
export HISTFILE=~/.zhistory
# Keep a lot of history.
export HISTSIZE=100000
export SAVEHIST=100000
# Add commands to history immediately, not when the shell exists.
setopt INC_APPEND_HISTORY
# Record the start time and duration of all commands in history.
setopt EXTENDED_HISTORY
# When a duplicate command is entered, delete the previous instance in history.
setopt HIST_IGNORE_ALL_DUPS
# Don't save duplicate commands.
# (As far as I can tell, this is unnecessary when HIST_IGNORE_ALL_DUPS is on.)
#setopt HIST_SAVE_NO_DUPS
# When adding commands to history, remove unnecessary whitespace. 
setopt HIST_REDUCE_BLANKS
# }}}
# Directory Stack {{{2
# NOTE: -n (resp. +n) are used to access the nth item from the top (resp. bottom)
#       of the directory stack for the command cd. For arguments of other
#       commands, use ~-n (resp. ~+n) instead.
# Set the maximum size of the directory stack to 10.
export DIRSTACKSIZE=10
# When using cd, push the old directory onto the directory stack.
setopt AUTO_PUSHD
# Don't store duplicates in the directory stack.
setopt PUSHD_IGNORE_DUPS    
# Don't print the directory stack after pushd or popd.
setopt PUSHD_SILENT         
# Make -n mean "the nth directory in the stack" (typically this is +n, and -n is
# in reverse).
setopt PUSHD_MINUS
# Define an alias to view the directory stack efficiently.
alias d='dirs -v'
# }}}
# Miscellaneous {{{2
# Try to correct the spelling of commands.
setopt CORRECT
# Report the time elapsed for any command that runs longer than 3 seconds.
export REPORTTIME=3
# }}}
# }}}
# Vi mode {{{
# NOTE: Zsh documentation refers to "command mode" as the mode correponding to
# "normal mode" in vim.

# Use vi mode.
bindkey -v
# A standard vim mapping: hitting "jk" puts us in command mode.
bindkey -M viins "jk" vi-cmd-mode
# I was having a weird problem where going to command mode and then back to
# insert mode would make the backspace key not work. The internet informed me
# that the following line is the solution to this problem.
bindkey "^?" backward-delete-char
# Make keybindings faster.
# NOTE: KEYTIMEOUT is in milliseconds, and the default is 400.
export KEYTIMEOUT=10

# Load shell functions that let us search through history with what's been
# typed in the current line so far.
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
# Turn those shell functions into widgets (which are the things used
# in keybindings).
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# Now bind these widgets to the up and down arrows (in general)
# and to "k" and "j" (in command mode).
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# Vi mode comes with keybindings to search through history using ? and / in
# command mode. The below mappings change these searches to be incremental
# (meaning you type your query on a separate line, and the first match appears
# on the current shell input line). I find this unhelpful for a few reasons:
	# (1) I'm not sure how to swap to other matches besides the first one.
	# (2) It seems that the forward incremental search always fails
	#     (I assume because it's searching forward in history from where we
	#     currently are, which is generally at the end of the history).
	# (3) I don't see much benefit in viewing the first match show up as
	#     I'm typing in my query (probably because I'm very used to the
	#     regular, non-incremental search).
# In spite of this, I'll leave this keybindings commented out here in case I
# change my mind later.
# bindkey -M vicmd "?" history-incremental-search-backward
# bindkey -M vicmd "/" history-incremental-search-forward
# }}}
# Appearance {{{1
# Colors {{{2
# Defining the color scheme that we'll use for our custom appearance settings.
# For this, we use the default ANSI colors of the shell (i.e. colors 1-15
# out of the 256 available colors). Those colors are also typically used by the
# shell in other places (e.g. by ls when LS_COLORS is set, and by the
# base16-shell plugin to set out base16 theme), so using on these colors
# makes our palette consistent with other colored things in the shell.
eval color_base='%F{5}' # magenta
eval color_info='%F{4}' # blue
eval color_accent='%F{12}' # bright blue
eval color_alert1='%F{11}' # bright yellow
eval color_alert2='%F{1}' # red
eval color_greyed_out='%F{247}' # grey
# An alternate color palette that I tweaked myself. It doesn't use colors 1-15,
# which makes it less useful for synchronizing color schemes.
#eval color_base='%F{177}' # light purple
#eval color_info='%F{75}' # not very saturated blue
#eval color_accent='%F{45}' # bright blue
#eval color_alert1='%F{228}' # bright yellow
#eval color_alert2='%F{160}' # saturated red

# Set the LS_COLORS variable so that the command ls --color=auto (which is
# aliased to just ls below) will color everything listed according to type.
# The colors I've given here were just my default (obtained by running
# the utility dircolors).
#
# TODO: maybe spruce up our definition of LS_COLORS, for instance using the 
# very extensive setup given by the following project:
# https://github.com/trapd00r/LS_COLORS
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS
# }}}
# PS1 and Cursor Formatting {{{2
# A function to format PS1 (which is what zsh displays at the left of the line
# editor whenever a new line accepting input is made). The format is as follows:
#
# (GLYPH) current/directory [# jobs in background] 
#
# Here, (GLYPH) is a triangle which points up if we're in insert mode and down
# if we're in command mode. Moreover, the triangle is $color_alert1 if the last
# command failed to execute and is $color_base otherwise.
#
# I got this function from the following website:
# https://zserge.com/blog/terminal.html
# However, I did modify it to imitate the function _format_cursor() below.
_format_ps1() {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
	  GLYPH="▼"
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
	  GLYPH="▲"
  fi
  PS1=" %(?.$color_base.$color_alert1)$GLYPH%(1j.$color_info [%j].%f) $color_base%~%f %(!.$color_alert1#%f .)"
}

# Next, a function to set the cursor to a "block" in command mode and a "beam"
# in insert mode (just like in vim). I got this code from the following website:
# https://thevaluable.dev/zsh-install-configure-mouseless/
# See also https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for more
# on vim cursor shapes.
#
# NOTE: I don't entirely understand how this code works. In particular,
# it seems that cursor_block and cursor_beam contain escape sequences
# corresponding to these cursor types, but I'm not sure why using echo causes
# the right type of cursor to display.
cursor_block='\e[2 q'
cursor_beam='\e[6 q'
_format_cursor() {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
	     echo -ne $cursor_block
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
	       echo -ne $cursor_beam
  fi
}
# }}}
# Widgets to Control PS1 and Cursor {{{2
# The following widget is called whenever the parameter KEYMAP is changed
# (which occurs when we switch between insert mode and command mode).
zle-keymap-select () {
  # Set PS1 to refelect the new value of KEYMAP.
  _format_ps1
  # Now redraw the prompt (so that the new value of PS1 will be used).
  zle reset-prompt
  # Finally, set the cursor mode to reflect the new value of KEYMAP.
  _format_cursor
}
zle -N zle-keymap-select

# The following widget is called whenever a new line is created to accept input
# to the shell. All it does is put us in insert mode and
# set the cursor appropriately.
zle-line-init () {
  zle -K viins
  echo -ne $cursor_beam
}
zle -N zle-line-init
# }}}
# Old Stuff {{{2
# This is some old stuff to display git information on the right of the screen.
# I got it from the Oh My Zsh theme "theunraveler." However, I don't currently
# use git for anything, and since I'm not using Oh My Zsh anymore, I suspect it
# won't work without a little finagling.
# Another option to check out: "Purification" (found on Github, defines a simple
# prompt theme including git info).
#
#RPROMPT='%{$color_base%}$(git_prompt_info)%{$reset_color%} $(git_prompt_status)%{$reset_color%}'
# ZSH_THEME_GIT_PROMPT_PREFIX=""
# ZSH_THEME_GIT_PROMPT_SUFFIX=""
# ZSH_THEME_GIT_PROMPT_DIRTY=""
# ZSH_THEME_GIT_PROMPT_CLEAN=""
# ZSH_THEME_GIT_PROMPT_ADDED="%{$color_accent%} ✈"
# ZSH_THEME_GIT_PROMPT_MODIFIED="%{$color_alert1%} ✭"
# ZSH_THEME_GIT_PROMPT_DELETED="%{$color_alert2%} ✗"
# ZSH_THEME_GIT_PROMPT_RENAMED="%{$color_info%} ➦"
# ZSH_THEME_GIT_PROMPT_UNMERGED="%{$color_base%} ✂"
# ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$color_greyed_out%} ✱"
# }}}
# }}}
# Completion {{{1
# NOTE: the following is the pattern used for defining a zstyle command
# (see the Zsh documentation, Chapter 20, for more information).
# :completion:<function>:<completer>:<command>:<argument>:<tag>

# General {{{2
# Define completers in use (order matters here).
zstyle ':completion:*' completer _expand _complete _approximate
# Matchers take the suggestions supplied by a completer and determine if they
# match what was typed in. The patterns used for this matching are somewhat hard
# to read, but the below line causes completers to be tried against the following
# matchers (in order):
# 1. No matcher (i.e. "is it an exact match with what was typed in?")
# 2. Case-insensitive matching
# 3. Case-insensitive and substring matching (i.e. what was typed in can be any
#    substring of the completion suggestion).
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

# Use caching for completion. (I'm not totally sure how helpful this is,
# but it seems like it couldn't hurt!)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zcompcache

# Show descriptions for completion suggestions.
zstyle ':completion:*' verbose true

# Always use menu selection for completion.
zstyle ':completion:*' menu select
# When using menu selection, automatically select the first suggestion
# immediately (without this, one has to hit tab a couple extra times to start
# cycling through suggestions).
setopt MENU_COMPLETE

# Allow completion of file names beginning with "." all the time. (By default,
# such file names are only suggested if the "." is part of what is typed in.)
setopt GLOB_DOTS
# }}}
# Menu Appearance {{{2
# Split menu completion into different groups based on the type of the
# suggestion (e.g. files will be grouped separately from commands).
zstyle ':completion:*' group-name ''
# Define a natural order to list different groups of commands.
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

# Color completion options differently based on the type of suggestion.
# The coloring will match the coloring used by the ls command, which is
# determined by the variable LS_COLORS. It is important that LS_COLORS is
# already set before this is done (we set it in the Appearance section above).
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}  
# The zsh documentation suggests that the line below will also give colors
# matching that of the ls command. However, this wasn't working for me (it
# did give some colors, but they were different than what ls was giving).
#zstyle ':completion:*' list-colors ''

# Define some descriptive messages for menu selection.
zstyle ':completion:*' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
# I'm not sure where this next one comes up or what it looks like, but the
# documentation says it appears for options that take in exactly one argument
# but which the completer doesn't otherwise give information for. This seems
# like it could be useful, if it ever does come up!
zstyle ':completion:*' auto-description '-- specify: %d (auto-description) --'

# When the menu selection doesn't fit on the screen, the below style determines
# the scrolling message displayed at the bottom of the window.
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# Sort files by time accessed.
zstyle ':completion:*' file-sort access
# }}}
# Specific Completion Settings {{{2
# When ".." appears in what is typed, ignore parents and the current working
# directory (so ../ will not suggest . and foo/.. will not suggest foo).
zstyle ':completion:*' ignore-parents parent pwd ..

# Allow the completer _approximate to insert a match automatically if there is
# only one match. (Otherwise, this completer generally needs menu completion,
# since it can generate many very different matches.)
zstyle ':completion:*' insert-unambiguous true

# Tell the completer _expand not to expand tildes (or other prefixes).
zstyle ':completion:*' keep-prefix true

# When searching for path names, fill as many starting letters as possible in
# each directory, and then list all possible combinations of completions for the
# remaining directories. This could in principle give way too many
# completions to be tractable -- if that ever becomes a problem, we might just
# want prefix instead (which lets us complete each directory one-by-one).
#
# NOTE: it seems that omitting "prefix" from the options below doesn't affect the
# behavior. I've decided to leave it, since the current behavior does include
# what "prefix" is intended to do.
zstyle ':completion:*' expand prefix suffix

# Completing on "cd -" will complete for options instead of for directories in
# the directory stack
#zstyle ':completion:*' complete-options true
# }}}
# Keybindings {{{2
# Load a module that gives extra functionality to completion listings.
# Our only use for loading it here is to define some useful keybindings during
# menu selection.
# I'm told this should come before calling compinit,
# though I'm not really sure why (it seems to work just as well if done after).
zmodload zsh/complist

# Define keybindings for "vim-like" navigation in menu selection.
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# A keybinding to let us type more to narrow down the completions.
# Note that this does not play nicely with the hkjl keybindings above,
# which makes it not particularly useful.
bindkey -M menuselect '^xi' vi-insert

# A keybinding to accept the current match but stay in menu selection
# (so that we can choose another match, which will be inserted after
# the previous one).
bindkey -M menuselect '^xh' accept-and-hold
# A keybinding to accept the current match and then run completion again.
# Useful e.g. for completing directly paths in multiple steps.
bindkey -M menuselect '^xn' accept-and-infer-next-history
# A keybinding to undo a match accepted by one of the above two keybindings.
bindkey -M menuselect '^xu' undo
# }}}

# Initialize completion. I've seen this written many different ways,
# but this is what was put in my zshrc by compinstall, so I'm sticking with it.
autoload -Uz compinit
compinit
# }}}
# Functions and Aliases {{{1
# A useful utility function for scripts (and for our plugin setup later).
_has() {
  return $( whence $1 >/dev/null )
}

# This function can be run on the command line. It takes one path
# as an argument and runs fzf to search within that path. (Note that
# fzf sometimes returns search results within the current working directory
# as well.)
function ffzf {
  find . $1 | fzf
}

# An alias to make ls color everything according to the LS_COLORS variable
# (set in the Appearance section above).
alias ls="ls --color=auto"

# An alias to source ~/.zshrc
alias sc="source $HOME/.zshrc"

# An alias to run zathura (my go-to PDF viewer). I've commented this out
# for now, because I'm not sure how much I'll be using PDF's in the future
# (I used to use them a lot, hence the alias).
# TODO: Do we still want this alias? If so, maybe we should change it to
# zz instead of aa, to make a little bit more mnemonic?
#alias aa="zathura"

# TODO: Add more aliases as needed

# }}}
# Plugins and Command-Line Functions {{{1
# TODO: Possible Plugins
# 1. Movement plugins (Wait and see what we need)
#    - bd
#    - z or z.lua or zoxide (they're all similar, and I'm not sure which is best)
# 2. Colors
#    - base16 (already installed)
#    - zsh-syntax-highlighting (already installed)
#    - https://github.com/trapd00r/LS_COLORS
#      (just a way to trick out LS_COLORS; not necessary, but might be nice.)
#    - diffsofancy (wait and see if we need this.)
# 3. zsh-system-clipboard (https://github.com/kutsan/zsh-system-clipboard)
#    (already installed)
# 4. Tmux session manager (e.g. tsm). (Wait and see if we need this.)

# fzf and ag setup {{{2
# NOTE: When installing fzf through a package manager one time, I couldn't
# find the keybindings script (below it's assumed to be run in ~/.fzf.zsh),
# and the CTRL+T and other hotkeys weren't working by default (and I couldn't
# figure out how to get them to work, even after sourcing the file
# key-bindings.zsh). So maybe installing manually is better. . .
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if _has fzf && _has ag; then
  # Set up the default command and Ctrl+T to use Ag for the search.
  export FZF_DEFAULT_COMMAND='ag --nocolor --hidden --ignore .git -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  # We can't set the Alt+C command to use Ag because Ag will detect files, not
  # directories! But we could theoretically reset it to this function if we
  # want to respect gitignore while searching directories:
  #
  # https://github.com/junegunn/blsd
  #
  # see also this thread:
  #
  # https://github.com/junegunn/fzf/issues/986
  #
  #export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
  
  # TODO: Change the below code to adjust the color scheme of fzf (maybe
  # matching the color scheme used in our theme above?)
  #export FZF_DEFAULT_OPTS='
  #--color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
  #--color info:108,prompt:109,spinner:108,pointer:168,marker:168
  #'
fi
# }}}
# Plugin: Base16 Shell {{{2
# This gives us access to many nice themes that we can choose from inside the
# shell (instead of just letting the terminal emulator set the colors, as is
# usually the case). It also has ways to interface with vim and tmux so that we
# can synchronize our color scheme with those programs. This makes our color
# scheme consistent (within each terminal session) and portable (in the sense
# that we can get the same color scheme on any other machine just by setting up
# this plugin).
#
# NOTE: There do still seem to be slight differences in the precise shade of
# the colors between different terminal emulators. However, the plugin does
# specifically change the default ANSI colors of the terminal emulator, so
# within the same terminal emulator, anything using the usual ANSI color palette
# will use the same colors.
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"
# Below are several themes I like; I've uncommented one of them so that the
# shell will automatically use that theme on startup.
# For a full list of themes I like, see base16-themes.txt.
#base16_brewer
#base16_chalk
#base16_circus
#base16_materia
#base16_material
base16_oceanicnext
#base16_paraiso
#base16_porple
#base16_railscasts
#base16_solarflare
#base16_synth-midnight-dark
#base16_tomorrow-night-eighties
# }}}
# Plugin: Zsh System Clipboard {{{2
# By default, copy-pasting with y and p in vi mode will only use zsh's internal
# register. This plugin synchronizes that register with the system clipboard, so
# that we can copy in zsh and paste in another program (or vice versa). The
# ZSH_SYSTEM_CLIPBOARD_TMUX_SUPPORT setting also causes anything copied with zsh
# to appear in tmux's clipboard buffers; however, this doesn't seem to be
# working for me, so I've turned it off for now. (For tmux's buffers to be sent
# to the system clipboard and zsh, we use a special keybinding in tmux for 
# copying.)
#
# NOTE: This plugin should be sourced after all bindings, because it parses
# the output of the commands bindkey -M vicmd, bindkey -M emacs, and
# bindkey -M visual. Also, the line that sets ZSH_SYSTEM_CLIPBOARD_TMUX_SUPPORT
# must come before the line sourcing the plugin.
#
# NOTE: As far as I can tell, zsh doesn't have separate clipboard registers
# like vim. The usual "[symbol] can be prepended to y or p commands, but it
# doesn't actually give you a separate register corresponding to [symbol].
# That said, this plugin does a great job of synchronizing the one register
# with the system clipboard.
source ~/.zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh
# typeset -g ZSH_SYSTEM_CLIPBOARD_TMUX_SUPPORT='true'
# }}}
# Plugin: Zsh Syntax Highlighting {{{2
# NOTE: This plugin is supposed to be sourced at the end of zshrc to
# work properly. More precisely, the documentation says that, depending on the
# version of zsh, the source command must come either after all custom widgets
# (defined used zle -N) or after anything that uses add-zle-hook-widget to add
# a zle-line-pre-redraw hook.
#
# TODO: is fast-syntax-highlighting a better option? Seems to
# have better performance (though I probably wouldn't notice) and slightly
# better highlighting of things (though mainly in situations I probably
# wouldn't encounter).
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# }}}
# }}}
