" Plugins {{{1
" NOTE: I used to use Vundle, but now I've swapped to vim-plug. I had no real
" issues with Vundle, and it seems to be one of the most solid package managers
" available; however, vim-plug seems to be even more reputable, and it
" features a slightly simpler configuration, configurable lazy loading, and
" parallel installation, all of which seem like they could possibly be
" convenient. So I figured I would make the swap, and we'll see how it goes!
"
" Some notes on using vim-plug
" (1) vim-plug does not manage itself as a package. To update vim-plug,
"     run :PlugUpgrade; to update other packages, run :PlugUpdate.
" (2) vim-plug's plug#end() function (which comes after all plugins have been
"     declared in init.vim) has both ``syntax on'' and
"     ``filtetype plugin indent on.'' I already had this in my init.vim, so
"     I currently have no objections; however, other people have had a very
"     hard time figuring out how to turn these off because vim-plug is turning
"     them on automatically.
" (3) vim-plug will only use the plugins given by the Plug commands below.
"     To stop using a plugin, just remove the Plug command; to delete the
"     plugin from the system, remove the Plug command and use :PlugClean[!].



" TODO: Below lists of plugins that seem pretty good, but I'm not using them
" right now. Check back here periodically to see if we should start using them.
"
" Plugins I don't think I need right now
" - antoinemadec/FixCursorHold
" - tpope/repeat
" - christoomey/vim-tmux-navigator
" - EinfachToll/DidYouMean
" - norcalli/nvim-colorizer.lua
" - dstein64/vim-startuptime
"
" Plugins I don't think I would use
" - tpope/vim-abolish
" - tpope/vim-fugitive
" - tpope/vim-sleuth
" - tpope/vim-unimpaired
" - preservim/nerdtree -- or lambdalisue/fern, which might be a better option.
"   if we do ever want to use fern, see the following article for suggested
"   settings:
"   https://bluz71.github.io/2017/05/21/vim-plugins-i-like.html
" - junegunn/fzf -- maybe read this to get motivated to use it:
"   https://bluz71.github.io/2018/12/04/fuzzy-finding-in-vim-with-fzf.html
" - dyng/ctrlsf.vim -- or mileszs/ack.vim
" - nvim-telescope
" - cohama/lexima.vim (or any other "auto-close" plugin)
" - ferranpm/vim-isolate
" - mhinz/vim-sayonara
" - junegunn/peekaboo
"
" Plugins that would take some time to learn to use
" - lifepillar/vim-cheat40 (useful for taking the time to learn other plugins!)
" - ggandor/lightspeed
" - kana/vim-textobj-user (and related plugins providing text objects)
" - wellle/targets
" - tpope/vim-surround
" - svermeulen/vim-subversive
" - andymass/vim-matchup
" - godlygeek/tabular (or the related vim-lion)
" - rhysd/clever-f
" - mbbill/undotree
"
" Potential Coding Plugins
" - sheerun/vim-polyglot (syntax highlighting)
" - dense-analysis/ale (async. linter)
" - UltiSnips (snippet tool), or vim-vsnip. See the following article for
"   details on the difference (and some settings for vim-vsnip):
"   https://bluz71.github.io/2017/05/21/vim-plugins-i-like.html
" - nvim-cmp (completion)
" - shougo/ddc.vim (completion), or VimCompletesMe
" - vim-lsc for LSP support. But I think maybe this is built-in now?
"   See the following article for details:
"   https://bluz71.github.io/2019/10/16/lsp-in-vim-with-the-lsc-plugin.html
" - nvim-treesitter/nvim-treesitter (language-agnostic parser that interfaces
"   with various programming tool plugins)
" - neomake (basically a fancy version of the built-in ":make")
" - vim-test (language-agnostic testing interface)
"
" NOTE: Here are some good references for plugin settings (and other init.vim
" materials).
" https://github.com/martin-svk/dot-files/blob/master/neovim/init.vim
" https://bluz71.github.io/2017/05/21/vim-plugins-i-like.html

call plug#begin()

" Provides the gc command (in normal and visual mode, with motions or counts)
" to toggle commented/uncommented lines.
Plug 'tpope/vim-commentary'

" Changes word motions (w, b, e, ge, aw, iw, and their capital counterparts)
" to respect CamelCaseWords, snake_case_words, titleCaseWords, and more.
" NOTE: There are a couple interesting alternatives to this plugin.
" (1) bkad/CamelCaseMotion, which has mostly the same functionality but
"     allows custom mappings (e.g. if we want to keep vim's built-in w but
"     let <leader>w use this alternative word definition).
" (2) Julian/vim-textobj-variable-segment, which provides a text object for
"     these words but no motion for them.
Plug 'chaoren/vim-wordmotion'

" Displays changes to files in a git repo, and provides other features like
" previewing, staging, and folding unchanged lines.
" TODO: See the following article for suggested settings on this plugin.
" https://bluz71.github.io/2017/05/21/vim-plugins-i-like.html
Plug 'airblade/vim-gitgutter'

" Displays vertical lines (|'s) at each indentation level. We only need a
" plugin for this because we're using expandtab; if actual tab characters
" are used for indentation, the options list and listchars can achieve the
" same functionality quite easily.
Plug 'Yggdroot/indentLine'

" Plugin that provides syntax highlighting in nvim according to base16's
" palette standards. (Also provides the vim analogs of all the base16
" colorschemes that base16-shell provides for the shell.)
" NOTE: If we use base16-shell without this plugin, the colors in nvim will
" still vary based on the shell's colorscheme. However, the base16 colors
" used are the 'wrong ones' according to base16 standards, which makes for
" less pretty and less readable syntax highlighting.
Plug 'chriskempson/base16-vim'

" My preferred plugin for writing LaTeX files.
Plug 'lervag/vimtex'
" Some settings for the vimtex plugin (and for LaTeX in general).
" NOTE: User autocommands are never called automatically; however,
" vim-plug will call this autocommand manually after the plugin is loaded.
" TODO: Make sure this autocommand really does get called! (I can't check it
" now because my currently nvim version isn't supported by vimtex.)
autocmd! User vimtex
            " NOTE: g:tex_flavor is an nvim setting, not a vimtex one.
            \ let g:tex_flavor = 'latex'
            \ let g:vimtex_fold_enabled = 1
            \ let g:vimtex_fold_manual = 1
            \ let g:vimtex_view_method = 'zathura'
            \ let g:vimtex_quickfix_open_on_warning = 0

call plug#end()

" Settings for the base16-vim plugin. These have to come after the call
" to plug#end(), or else we'll get an error.
" NOTE: Every time we call a base16_* command from the shell to change the
" shell's colorscheme, the file ~/.vimrc_background is updated to point to
" the new colorscheme. The main point of these settings is to source
" that file, which keeps nvim's syntax highlighting in sync with the shell's
" colorscheme.
let base16VimFile = expand("~/.vimrc_background")
if filereadable(base16VimFile)
  " This variable provides compatibility with base16-shell.
  let base16colorspace=256
  exec 'source ' . base16VimFile
  " A little trick I found that (usually) sets the background option correctly.
  " It works because most of the light base16 color schemes have the word
  " "light" in them. For the ones that don't, however (e.g. cupertino), this
  " will incorrectly set background=dark.
  if match(readfile(base16VimFile), "light") != -1
      set background=light
  else
      set background=dark
  endif
endif
" }}}
" Options {{{1
" General Functionality {{{2
" NOTE: A very common option to set is nocompatible. However, it is
" actually not good to set this option here, for a few reasons:
" (1) nvim doesn't even have a nocompatible option (it is nocompatible
"     automatically).
" (2) vim automatically sets nocompatible whenever a vimrc or gvimrc
"     is detected on startup, so setting nocompatible in vimrc is
"     completely redundant.
" (3) Setting nocompatible changes certain other settings, which might
"     overrule something that was set before vimrc was run (e.g. in a
"     system-wide vimrc).

" (DEFAULT) Here are two almost universally accepted options that vim does not
" have by default, but nvim does. The first enables syntax highlighting,
" and the second enables vim to load plugins and indent files for
" specific file types.
" NOTE: The line 'filetype plugin indent on' is probably redunant here,
" because vim-plug does this automatically (at the call to plug#end(), which
" comes after all our plugins above).
syntax on
filetype plugin indent on

" We fold around the markers {{{[level] and }}}. The fold method can
" be changed elsewhere for more specific purposes (e.g. folding around
" specific programming languages), but I like to set this as the default
" because it's easy to use, easy to understand, and automatically persistent.
set foldmethod=marker

" Let buffers be marked as hidden when we switch to another buffer. This
" allows us to swap buffers without saving the current file.
" NOTE: It seems that the autowrite option is an alternative to this,
" since it will automatically save files when we swap buffers. However,
" autowrite didn't seem to do anything when hidden is set, and with autowrite
" and nohidden set, I noticed a 1-second delay when swapping buffers. So
" I'll just stick with hidden for now.
set hidden
" set autowrite
" TODO: Do we also want to set switchbuf to control how new buffers are opened?

" Have Vim source files named ".nvimrc", "_nvimrc", or ".exrc" in the
" current working directory. This is useful for setting up project-specific
" configurations.
set exrc
" Make ".nvimrc" and ".exrc" files safer. (This option is on by default in
" most "risky" situations, but as far as I can tell, it doesn't hurt to
" turn it on in all situations!)
set secure

" TODO: Do we have any reason to set options for EOL formats and/or file
" encodings (namely, fileformat, fileformats, fileencoding, fileencodings)?
" It seems like the default values of these options will work just fine for
" most purposes, but we might find a purpose they don't work for in the future.
" }}}
" Backups, Histories, Etc. {{{2
" The writebackup option creates a backup of the file before writing.
" The backup option keeps those backups after writing. Between swap files and
" version control (and the fact that write operations just don't
" usually fail), these don't seem particularly necessary.
" NOTE: if enabled, backups are by default created in the current working
" directory and will be named "[filename]~". These settings are controlled by
" the default values of the options backupdir and backupext.
set nowritebackup
set nobackup "(DEFAULT)

" (DEFAULT) Store swap files in their own directory (typically this will be
" ~/.config/nvim/swap), and prepend directory location to swap files, so that
" the swap files for /foo/bar.txt and /foo2/bar.txt don't clobber each other.
" TODO: Does this work correctly on Windows, or should we be using different
" directories in that case? (This also applies to undodir below.)
if !empty($XDG_DATA_HOME)
    set directory=$XDG_DATA_HOME/nvim/swap//
else
    set directory=$HOME/.local/share/nvim/swap//
end
" (DEFAULT) Write the swap file to disk after every 200 characters, and
" after 4 seconds of nothing being typed.
" NOTE: the updatetime option also affects the CursorHold autocommand event.
set updatecount=200
set updatetime=4000

" Store undo history persistently.
set undofile
" (DEFAULT) In undo history, keep 1000 items.
set undolevels=1000
" (DEFAULT) Store persistent undo files in their own directory.
if !empty($XDG_DATA_HOME)
    set undodir=$XDG_DATA_HOME/nvim/undo/
else
    set undodir=$HOME/.local/share/nvim/undo/
end

" (DEFAULT) In the histories for ":" commands and search patterns, keep up to
" 10,000 entries each. This will also determine how many history entries
" are stored persistently in the ShaDa file, since by default the shada
" option does not provide an alternate number (use ":h sd" for
" more information).
" NOTE: this option affects the historys of a couple other command-line
" commands that have their own histories (like search patterns do); to see
" a full list, use ":help history".
set history=10000
" }}}
" Command Functionality {{{2
" Allow <BS>, <Space>, and ~ in normal/visual to move to the
" previous/next line when used on the first/last character in a line.
set whichwrap=b,s,~

" Any copy/paste command using the unnnamed register (e.g. yy or just y
" with no register before it) will use the register "+, which is synced
" with the system clipboard.
" I like this option in principle, but then I reailzed that d and c in
" normal mode will end up "polluting" the system clipboard, so I'm leaving
" it off (which is the default) for now.
"set clipboard=unnamedplus

" (DEFAULT?) After certain commands (like "<<" or "gg"), move the cursor to
" the first non-blank in the line. I've found conflicting documentation on
" whether this is the default setting or not -- my help files say yes, but
" the documentation on neovim.io/doc says no.
set startofline

" (DEFAULT) When deleting text in insert mode, allow deletion of new lines,
" autoindents, and the text at the start of where we entered insert mode.
" Note that this option effects <BS>, <Del>, and CTRL+W (delete previous
" word) and CTRL+U (delete everything before cursor on line).
set backspace=indent,eol,start
" }}}
" Text Formatting {{{2
" Formatting will introduce line breaks after whitespace to keep all lines
" below 80 characters.
set textwidth=80
"
" Formatting settings:
" jro = Vim inserts comment leaders when hitting "O" in normal mode or
"       <Enter> in insert mode from a commented line, and removes comment
"       leaders when using "J" in normal mode to join lines.
" tc = When typing in insert mode, comments and other text will be
"      automatically wrapped to the length limit set by textwidth.
" q = comments can be manually formatted using "gq" in normal mode.
" l = if a line is already longer than textwidth when we enter insert mode,
"     it will not be automatically wrapped using textwidth. (In other words,
"     the "tc" options mentioned above will only affect lines we're typing
"     in that weren't already over textwidth when we started typing.)
set formatoptions=jrotcql

" Join commands (i.e. J in normal mode) will insert only one space at the
" end of a sentence, not two.
set nojoinspaces
" }}}
" Spacing {{{2
" NOTE: For more information on our spacing options (as well as other possible
" choices for these options), see the following page:
" https://www.reddit.com/r/vim/wiki/tabstop
" By default, new lines get the same indentation as the previous line.
set autoindent
" When hitting <Tab> in insert mode, produce whitespace using spaces instead
" of an actual tab character.
set expandtab

" A <Tab> character counts as 8 spaces. According to ':help tabstop', this
" is the best setting for ensuring that the file looks the way it should when
" used outside of vim. (Note that expandtab will generally cause files we
" create to contain no <Tab> characters, so this option is frequently
" irrelevant.)
set tabstop=8
" When hitting <Tab> or <BS> in insert mode, pretend like tabstop is set
" to 4. In other words, hitting <Tab> inserts 4 spaces, and hitting <BS>
" deletes 4 spaces (unless you just typed a space, in which case <BS> just
" deletes that one space).
" TODO: Do we want softtabstop and shiftwidth to be 2 sometimes and 4 other
" times? For instance, 2 can be nice for LaTeX, while 4 is the standard
" for Python. (We could accomplish this with file extension autocommands.)
set softtabstop=4
" When lines are indented (e.g. by ">" in normal mode, by cindent, etc.),
" count one <Tab> worth of indentation as 4 spaces.
set shiftwidth=4

" Round indents coming from ">" and "<" commands to a multiple of
" shiftwidth. (CTRL-T and CTRL-D in insert mode always do this rounding.)
set shiftround

" (DEFAULT) <Tab> or <BS> in insert mode will interpret the width of a tab
" as shiftwidth, not as softtabstop. This should actually be irrelevant for
" us, since we have shiftwidth and softtabstop set to the same value.
set smarttab
" }}}
" Searching {{{2
" Use an incremental search, i.e. highlight (because hlsearch is on by
" default) search matches as the search pattern is typed in.
set incsearch
" For substitution, perform the substitution effects incrementally, and
" show some off-screen substitutions in a separate window.
set inccommand=split

" Use case-insensitive searching by default, unless the search pattern
" contains an uppercase letter. Note that if "\C" appears anywhere in the
" search pattern forces a case-sensitive search regardless of these options.
" (Similarly, "\c" forces a case-insensitive; but with these options set, we
" may as well just not use uppercase letters instead of typing "\c.")
set ignorecase smartcase

" Highlight matches of the most recent search. (The highlighting can be
" turned off afterwards with the ":nohlsearch" command, or ":noh" for short.)
set hlsearch

" (DEFAULT) In search patterns, make some characters (e.g. $ or .)
" have regex-meaning instead of use literal character, but not all characters
" (e.g. parentheses represent a literal character and must be escaped as
" \( \) for regex grouping). This seems like the most "normal" behavior for
" regexes, and the documentation says that it's recommended for portability
" (since many plugins assume magic is set).
set magic

" (DEFAULT) Let searches wrap around the end of the file.
set wrapscan
" }}}
" Visual {{{2
" (DEFAULT) On the line below the status line (where the command line usually
" appears), show certain partial command info (I'm unclear on what info,
" exactly -- the documentation only mentions the numbers to describe the size
" of the selection in visual mode).
set showcmd
" Don't show the mode on the line below the status line (we already have it
" showing on the status line itself).
set noshowmode

" By default, the ruler shows the following at the right end of the status line:
" [line],[column]   [position in file]
" We don't need this, since our status line settings already display similar
" info.
" NOTE: the ruler doesn't seem to display at all once we've set the statusline
" option, so turning this option off is probably unnecessary. But we'll do it
" anyway, just to be thorough.
set noruler

" Color the column right after textwidth to show the line limit visually.
set colorcolumn=+1

" Always keep at least one line on-screen above and below the cursor. I've
" never tried this before, but it seems nice for "previewing" what's
" above/below as we page off the top/bottom of the screen with j/k in
" normal mode.
set scrolloff=1

" Set the popup menu to show at most 10 items at a time. (The rest can still
" be seen by scrolling through the menu.)
set pumheight=10

" Instead of an audio bell (beeping), use a visual bell. This should be
" irrelevant, since the option belloff by default turns off all bells. But
" in case they get turned on somehow, they'll be visual!
set visualbell
" }}}
" Wrapping {{{2
" Visually wrap lines when they get to the edge of the screen.
set wrap
" Instead of wrapping mid-word, wrap at one of the characters specified in
" the breakat option (which includes " " by default, among others).
set linebreak
"When lines get wrapped, display the wrapped lines with the same whitespace
"as the beginning of the line.
set breakindent
"Give the wrapped lines an extra 2 characters of whitespace compared to the
"beginning of the line, never include so much whitespace at the beginning
"that there are less than 40 characters after it on a wrapped line, and
"display the showbreak marking at the beginning of the wrapped line (before all
"the whitespace).
set breakindentopt=shift:2,min:40

" NOTE: the above settings seem to work well for me in the general case. But
" for a more distinct visual cue, the commented-out settings below could be
" useful. They mark wrapped lines with a ">", which comes before the additional
" whitespace of breakindent and breakindentopt, and this ">" will appear in the
" line number column if number is set.
" set showbreak=>\  
" set breakindentopt+=sbr
" set cpoptions+=n
" }}}
"GUI options {{{2
"By definition, the options in this section only apply when we are in
"a GUI (i.e. not when we are in the terminal).
" Don't show the toolbar.
set guioptions-=T
" (Windows only) Alt + other keys cannot be used for shortcuts to menu items.
" Instead, these are available to be mapped by vim.
set winaltkeys=no
"set guifont=Consolas:h10 "Make the font Consolas 10-point on the GUI
"(so I can read it on a 4k screen!)
"Note that this conflicts with setting powerline
"fonts for base16 (set above). This is fine,
"since I only use gVim on Windows, where I
"don't use base16.
"
"TODO: Maybe set the window title in the GUI using the following options:
"      title, titlelen, titleold, titlestring
" }}}
" }}}
" Status Line {{{1
" In this section, we set up a custom status line format. The resulting
" appearance of the status line is heavily inspired by the lightline plugin;
" I've just tweaked it a bit to my liking, and I've used the shell colors
" instead of lightline's separate color scheme in order to keep the colors in
" sync with my base16 color scheme.
"
" To learn how to do this, I mainly consulted the following blog post:
"
" gabri.me/blog/diy-vim-statusline
"
" There are some things in the author's code (linked to in "Update 20 Aug 2017"
" at the top of the page) that I haven't implemented but which might be cool,
" specifically:
"
" 1. Git branch info (using Tim Pope's fugitive plugin)
" 2. Linter status info (using the Ale plugin as a linter)
" 3. More sophisticated formatting of the file path, and colors/glyphs to
"    display flags like modified and read-only.
"
" For the moment, though, I'm satisfied with what we have here.

" A dictionary containing names for all the possible return values of mode().
let g:modenames={
    \ 'n' : 'Normal',
    \ 'no' : 'N-Operator',
    \ 'v' : 'Visual',
    \ 'V' : 'V-Line',
    \ '' : 'V-Block',
    \ 's' : 'Select',
    \ 'S' : 'S-Line',
    \ '' : 'S-Block',
    \ 'i' : 'Insert',
    \ 'ic' : 'I-Complete',
    \ 'ix' : 'I-X-Complete',
    \ 'R' : 'Replace',
    \ 'Rv' : 'R-Virtual',
    \ 'Rc' : 'R-Complete',
    \ 'Rx' : 'R-X-Complete',
    \ 'c' : 'Command',
    \ 'cv' : 'Ex (Vim)',
    \ 'ce' : 'Ex (Normal)',
    \ 'r' : 'Hit Enter',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!' : 'Command in Progress',
    \ 't' : 'Terminal'
    \}

" Sets the highlighting group SL_Mode based on the current mode.
function! SetModeColor()
    let mode = mode()
    if (mode =~ '^i')
        exec 'hi SL_Mode ctermbg=2 ctermfg=0'
        " OLD: Highlight the entire status bar in insert mode.
        "exec 'hi SL_Mode ctermbg=19 ctermfg=2'
        "exec 'hi SL_Default ctermbg=10 ctermfg=0'
    elseif (mode == 'n' || mode == 'no')
        exec 'hi SL_Mode ctermbg=4 ctermfg=0'
    elseif (mode == 'v' || mode == 'V' || mode == '')
        exec 'hi SL_Mode ctermbg=5 ctermfg=0'
    elseif (mode =~ '^R')
        exec 'hi SL_Mode ctermbg=1 ctermfg=0'
    else
        exec 'hi SL_Mode ctermbg=3 ctermfg=0'
    endif
endfunction

" Returns a string to be used as the value for the statusline option.
function! MakeStatusLine()
    let line = ""
    call SetModeColor()

    let line .= "%#SL_Mode#"
    let mode = mode()
    if has_key(g:modenames, mode)
        let line .= " " . toupper(g:modenames[mode()]) . " "
    else
        let line .= " " . mode . " "
    endif

    let line .= "%#SL_Default#"
    let line .= " [%n] %<%f %([%R%H%W%M]%) "

    let line .= "%="

    let line .= " %{&fileformat} | %{&fileencoding} | %{&filetype} "

    let line .= "%#SL_Mode#"
    let line .= " %l:%c "
    return line
endfunction

" Always display status lines on the window that touches the bottom of the
" terminal. (Windows not at the bottom always have status lines regardless.)
set laststatus=2
" Set the status line format using our custom function.
set statusline=%!MakeStatusLine()

" Some initial settings for highlighting groups used on the status line.
" NOTE: The built-in highlighting groups for the status line
" (namely, StatusLine and User1-9) were behaving very strangely for me:
" 1. For the StatusLine group, I was getting unexpected colors when setting
"    ctermbg and ctermfg. The issue was that StatusLine has "cterm=bold,reverse"
"    by default. Setting "cterm=NONE" for this group fixes this problem.
" 2. When using User1 in place of the group SL_Mode (which is a custom group
"    defined by the code here), there is a long delay in changing the color
"    of the mode on the status line (either a couple seconds or until the
"    user hits a key). The following settings reproduce this behavior using
"    the SetModeColor() function above:
"    hi link User1 SL_Mode
"    set statusline=%{SetModeColor()}%1*\ %{g:modenames[mode()]}\ %0*
"    The solution is to put the line "exec 'redrawstatus'" in SetModeColor()
"    to force a redraw.
" I didn't know about the solutions to either of these problems until after I
" switched to custom highlighting groups, so I'll just stick with those for now.
" (They have more informative names, anyway, and I see no downsides to them!)
highlight SL_Default ctermbg=0 ctermfg=7
highlight SL_Mode ctermbg=7 ctermfg=0
" OLD: highlighting group for the line/column number on the right
" (currently it's just sharing the mode group).
"highlight SL_Ruler ctermbg=7 ctermfg=0
" }}}
" Mappings {{{1
" A standard escape mapping.
inoremap jk <Esc>

" TODO: Maybe reorganize the folds below into more specific folds.

" Movement {{{2
" Set j and k to move by visual lines (which differ from actual lines when
" wrapping occurs).
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Since j and k now do what gj and gk do by default, we can use those
" commands to move up and down 5 lines at a time.
nnoremap gj 5j
nnoremap gk 5k
vnoremap gj 5j
vnoremap gk 5k

" Similarly, make 0 and $ go to the visual start/end of a line.
nnoremap 0 g0
nnoremap $ g$
vnoremap 0 g0
vnoremap $ g$

" Switch between windows easily with CTRL+h/j/k/l.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
"}}}
" Changes to Built-In Actions {{{2
" When using J to join lines, keep the cursor where in place.
nnoremap J mmJ`m

" When we don't specify a different register, the commands y, c, d, s, and x
" all copy text into the unnamed register (""). This can be inconvenient if
" we yank something to paste elsewhere but then delete something else before
" pasting. Below are mappings that provide two solutions to this problem.
"
" Solution 1: Register "0 receives only yanked text, so we make a mapping
" that lets us paste from register "0 easily.
" (Mnemonic: "yank paste", i.e. pasting the last yank.)
" NOTE: yp and yP by default do nothing.
nnoremap yp "0p
nnoremap yP "0P
" Solution 2: Make mappings for c and d commands that get sent to the
" black hole register "_. This prevents them from overwriting any registers
" that we might use. (Mnemonic for d: "delete permanently")
" NOTE: By default, dp does ":diff put" when in diff mode. I've never used
"       diff mode before, but if we're worried about this, we can make
"       autocommands on OptionSet and VimEnter events that check for diff
"       mode and map dp back to the original dp when this happens.
"       As far as I know, cp does nothing by default.
" NOTE: This doesn't stop x and s from overwriting the unnamed register.
"       However, those commands are rarely the source of the problem for me.
nnoremap cp "_c
nnoremap dp "_d
" }}}
" New Actions {{{2
" S in normal mode "splits lines" (the opposite of J).
" NOTE: by default, S is a synonym for cc, so we aren't really
" losing anything with this mapping.
nnoremap S mmi<CR><ESC>`m


" The following mappings introduce an easy set of steps for a common task:
" (1) Type c* or c# in normal mode to delete the word nearest (e.g. under)
"     the cursor and then enter insert mode.
" (2) Type whatever you want that word to be instead.
" (3) Go back to normal mode.
" (4) Press . to repeat this replacement for the next (for c*) or previous
"     (for c#) instance of the same word. If you want to skip the next
"     instance, press 2n.
nnoremap c* *``cgn
nnoremap c# #``cgN
" The above mappings use the * and # commands for searching, which use
" the ignorecase option but not the smartcase option. In order to use both,
" use the following mappings:
" nnoremap C* /\<<C-R>=expand('<cword>')<CR>\><CR>``cgn
" nnoremap C# /\<<C-R>=expand('<cword>')<CR>\><CR>``cgN

" Use Q to replay the q macro quickly. Useful for one-off macros.
" NOTE: by default, Q and gQ are synonyms (they both go into "Ex mode,"
" which I rarely if ever have use for anyway).
nnoremap Q @q
vnoremap Q :normal @q<CR>

" // or ?? in visual mode search for the selected text.
" NOTE: if you just want to search for one word, use * and # in normal mode.
vnoremap // "my/\V<C-R>=escape(@m,'/\')<CR><CR>
vnoremap ?? "my?\V<C-R>=escape(@m,'/\')<CR><CR>

" J and K in visual mode move the selected text up/down one line.
vnoremap J :move '>+1<CR>gv=gv
vnoremap K :move '<-2<CR>gv=gv

" Format all lines in the current file.
nnoremap ,i gg=G``
" Trim whitespace from the ends of all lines in the current file.
nnoremap ,t :%s/\s\+$//e<CR>
" }}}
" File/Buffer/Etc. Actions {{{2
" Easy buffer swapping.
nnoremap <Space>b :ls<CR>:b<Space>

" Toggle search highlighting (mainly to turn it off after a search).
" NOTE: Tim Pope's vim-unimpaired plugin provides a mapping of yoh that does
" the same thing. But since this one comes up frequently, I wanted to give it
" a mapping that's even faster to type.
nnoremap <Space>h :set invhlsearch<CR>

" Some shortcuts for saving and quitting.
nnoremap <Space>w :w<CR>
nnoremap <Space>q :q<CR>

" Refresh _vimrc in the current session. (Mnemonic: "Source Vimrc")
nnoremap <Space>sv :so $MYVIMRC<CR>:noh<CR>:echo 'vimrc refreshed'<CR>

" Executes the current line as if it were typed after a colon in
" normal mode. (Mnemonic: "Execute Line")
"nnoremap <Space>el "myy:@m<CR>
"}}}
" }}}
" Autocommands {{{1
" The below was copied from an example _vimrc file that came with a version
" of vim I had once (though I added in the 'zv').
"
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g`\"zv" |
            \ endif

" A function to clear the command line 3 seconds after we finish inputting
" a command. Since we don't have showcmd set, the output of previous commands
" can linger on the command line sometimes. If this gets annoying, then we can
" use this autocommand to take care of it.
"function! ClearCmd(timer) abort
"    echon ''
"endfunction
"autocmd CmdlineLeave : call timer_start(3000, funcref('ClearCmd'))
" }}}
" Global variables {{{1
" By default, all .tex files will be assumed to be LaTeX, not just TeX.
" }}}
