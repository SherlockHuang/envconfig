set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle/')
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'L9'
Plugin 'vim-scripts/taglist.vim'
Plugin 'tpope/vim-pathogen'
Plugin 'scrooloose/nerdtree'
" Plugin 'vim-scripts/FuzzyFinder'
Plugin 'altercation/vim-colors-solarized'
" Plugin 'vim-scripts/AutoComplPop'
" Plugin 'fholgado/minibufexpl.vim'
Plugin 'mileszs/ack.vim'
Plugin 'vim-scripts/a.vim'
Plugin 'majutsushi/tagbar'
Plugin 'Shougo/vimshell.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/unite.vim'
" Plugin 'ervandew/supertab'
Plugin 'scrooloose/nerdcommenter'
Plugin 'elixir-lang/vim-elixir'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'spin6lock/vim_sproto'
Plugin 'tpope/vim-commentary'
Plugin 'jremmen/vim-ripgrep'
Plugin 'octol/vim-cpp-enhanced-highlight'
" Plugin 'Valloric/YouCompleteMe'
" Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-syntastic/syntastic'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" setup back and swap directory
let data_dir = $HOME.'/.data/'
let backup_dir = data_dir . 'backup' 
let swap_dir = data_dir . 'swap' 
if finddir(data_dir) == ''
    silent call mkdir(data_dir)
endif
if finddir(backup_dir) == ''
    silent call mkdir(backup_dir)
endif
if finddir(swap_dir) == ''
    silent call mkdir(swap_dir)
endif
set backupdir=$HOME/.data/backup " where to put backup file 
set directory=$HOME/.data/swap " where to put swap file 
unlet data_dir
unlet backup_dir
unlet swap_dir

set makeef=error.err

au FileType c,cpp,cs,swig set nomodeline
au FileType bytes set filetype lua
set viminfo+=! " make sure it can save viminfo 
filetype on " enable file type detection 
filetype plugin on " enable loading the plugin for appropriate file type 

set shellredir=>%s\ 2>&1

if &term =~ "xterm"
    set mouse=a
endif

if has("gui_running")
	set guifont=Source\ Code\ Pro:h14
	silent exec "colorscheme solarized"
   	set background=dark

	set lines=40 columns=130
    hi Comment gui=NONE
else
    hi Comment term=NONE
endif

set wildmenu " turn on wild menu, try typing :h and press <Tab> 
set showcmd	" display incomplete commands
set cmdheight=1 " 1 screen lines to use for the command-line 
set ruler " show the cursor position all the time
set shortmess=atI " shortens messages to avoid 'press a key' prompt 
set lazyredraw " do not redraw while executing macros (much faster) 
set display+=lastline " for easy browse last line with wrap text
set laststatus=2 " always have status-line

set guioptions-=m
set guioptions-=T

set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,ucs-bom,chinese
set fileformat=dos
set fileformats=dos

source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

set ai " autoindent 
set si " smartindent 

set showmatch
set matchtime=0
set nu
set hid
set nowrap
set hls
set incsearch
set smartcase

set cindent shiftwidth=4 " Set cindent on to autoinent when editing C/C++ file, with 4 shift width
set tabstop=4 " Set tabstop to 4 characters
set expandtab " Set expandtab on, the tab will be change to space automaticaly

set nf=
set ve=block

set history=50 " keep 50 lines of command line history
set updatetime=1000 " default = 4000
set autoread " auto read same-file change ( better for vc/vim change )

set foldmethod=marker foldmarker={,} foldlevel=9999
set diffopt=filler,context:9999

if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif
set incsearch " do incremental searching
set ignorecase " Set search/replace pattern to ignore case 
set smartcase " Set smartcase mode on, If there is upper case character in the search patern, the 'ignorecase' option will be override.
set backspace=indent,eol,start

function GrepLuaFiles()
	let curWord = expand("<cword>")
	exec ':vimgrep ' . curWord . ' **/*.lua'
	exec ":copen"
endfunction

function AckAllFiles()
	let curWord = expand("<cword>")
	exec ":Ack " . curWord
endfunction

function RecursiveGrep(search_pattern)
    exec "vimgrep " . a:search_pattern . " **/*.*"
    exec ":copen"
endfunction

function RecursiveGrepWithPostFix(search_pattern, post_fix)
    exec "vimgrep " . a:search_pattern . " **/*." . a:post_fix
    exec ":copen"
endfunction

let c_gnu = 1
let c_no_curly_error = 1
"let c_no_bracket_error = 1
"
"" Move in fold
noremap <unique> z<Up> zk
noremap <unique> z<Down> zj
if has("gui_running") "  the <alt> key is only available in gui mode.
    noremap <unique> <M-Up> zk
    noremap <unique> <M-Down> zj
endif

" Fold close & Fold open
noremap <unique> <kPlus> zo
noremap <unique> <kMinus> zc

au BufNewFile,BufEnter * set cpoptions+=d " NOTE: ctags find the tags file from the current path instead of the path of currect file
au BufEnter * :syntax sync fromstart " ensure every file does syntax highlighting (full) 
au BufNewFile,BufRead *.avs set syntax=avs " for avs syntax file.

augroup lua " {
    autocmd FileType lua setlocal includeexpr=substitute(v:fname,'\\.','/','g')
augroup END " }

au FileType python call s:CheckIfExpandTab() " if edit python scripts, check if have \t. ( python said: the programme can only use \t or not, but can't use them together )
function s:CheckIfExpandTab()
    let has_noexpandtab = search('^\t','wn')
    let has_expandtab = search('^    ','wn')

    "
    if has_noexpandtab && has_expandtab
        let idx = inputlist ( ["ERROR: current file exists both expand and noexpand TAB, python can only use one of these two mode in one file.\nSelect Tab Expand Type:",
                    \ '1. expand (tab=space, recommended)', 
                    \ '2. noexpand (tab=\t, currently have risk)',
                    \ '3. do nothing (I will handle it by myself)'])
        let tab_space = printf('%*s',&tabstop,'')
        if idx == 1
            let has_noexpandtab = 0
            let has_expandtab = 1
            silent exec '%s/\t/' . tab_space . '/g'
        elseif idx == 2
            let has_noexpandtab = 1
            let has_expandtab = 0
            silent exec '%s/' . tab_space . '/\t/g'
        else
            return
        endif
    endif

    " 
    if has_noexpandtab == 1 && has_expandtab == 0  
        echomsg 'substitute space to TAB...'
        set noexpandtab
        echomsg 'done!'
    elseif has_noexpandtab == 0 && has_expandtab == 1
        echomsg 'substitute TAB to space...'
        set expandtab
        echomsg 'done!'
    else
        " it may be a new file
        " we use original vim setting
    endif
endfunction

" au FileType c,cpp,javascript set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:// 
" au FileType cs set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:///,f:// 
" au FileType vim set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",f:\"
" au FileType lua set comments=f:--

" ------------------------------------------------------------------ 
" Desc: TagList
" ------------------------------------------------------------------ 

" F4:  Switch on/off TagList
nnoremap <unique> <silent> <F4> :TlistToggle<CR>

let Tlist_Ctags_Cmd ='ctags' 
let Tlist_Show_One_File = 1 " Displaying tags for only one file~
let Tlist_Exist_OnlyWindow = 1 " if you are the last, kill yourself 
let Tlist_Use_Right_Window = 1 " split to the right side of the screen 
let Tlist_Sort_Type = "order" " sort by order or name
let Tlist_Display_Prototype = 0 " do not show prototypes and not tags in the taglist window.
let Tlist_Compart_Format = 1 " Remove extra information and blank lines from the taglist window.
let Tlist_GainFocus_On_ToggleOpen = 1 " Jump to taglist window on open.
let Tlist_Display_Tag_Scope = 1 " Show tag scope next to the tag name.
let Tlist_Close_On_Select = 0 " Close the taglist window when a file or tag is selected.
let Tlist_BackToEditBuffer = 0 " If no close on select, let the user choose back to edit buffer or not
let Tlist_Enable_Fold_Column = 0 " Don't Show the fold indicator column in the taglist window.
let Tlist_WinWidth = 40
let Tlist_Compact_Format = 1 " do not show help
" let Tlist_Ctags_Cmd = 'ctags --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++'
" very slow, so I disable this
" let Tlist_Process_File_Always = 1 " To use the :TlistShowTag and the :TlistShowPrototype commands without the taglist window and the taglist menu, you should set this variable to 1.
":TlistShowPrototype [filename] [linenumber]

" let taglist support shader language as c-like language
let tlist_hlsl_settings = 'c;d:macro;g:enum;s:struct;u:union;t:typedef;v:variable;f:function'

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

set guifont=Source\ Code\ Pro:h14
" set nobackup " make backup file and leave it around 
set nowritebackup

" command -nargs=1 Rgrep call RecursiveGrep('<args>')
" command -nargs=+ Rpgrep call RecursiveGrepWithPostFix(<f-args>)

" map Rg Rgrep
" map Rpg Rpgrep

"" let g:ackprg = 'ag --nogroup --nocolor --column'

set ffs=unix,dos
nnoremap <unique> <silent> <Leader>gg :call AckAllFiles()<CR>

set clipboard=unnamed

nnoremap <unique> <slient> <Leader>gg :call AckAllFiles()<CR>
" map <C-P> :FufCoverageFile<CR>
" map <Leader>bl :MBEToggle<CR>
map <C-Tab> :MBEbb<CR>
map <C-S-Tab> :MBEbf<CR>

nmap tf :NERDTreeFocus<CR>
nmap tt :NERDTreeToggle<CR>
nmap tl :nohl<CR>

nnoremap <silent> <F4> :TagbarToggle<CR>

" unite.vim
" nnoremap <C-P> :<C-u>Unite -start-insert file_rec/async:!<CR>
" nnoremap <Leader>gg :Unite grep:.<CR>
nnoremap <Leader>gl :Unite -quick-match buffer<CR>
" nnoremap <Leader>gd :YcmCompleter GoTo<CR>
" 
" let NERDTreeIgnore = ['\.pyc$', '\.meta$']
" let g:ycm_autoclose_preview_window_after_completion = 1
" let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_disable_for_files_larger_than_kb = 0
" let g:ycm_add_preview_to_completeopt=0
" set completeopt-=preview

" language messages zh_CN.utf-8

let g:SuperTabDefaultCompletionType = "<c-n>"
let g:ctrlp_working_path_mode="a"
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
let g:ctrlp_map = '<c-p>'

hi Comment gui=NONE term=NONE
au BufNewFile,BufRead *lua.bytes setf lua
set cc=100

function QfMakeConv()
   let qflist = getqflist()
   for i in qflist
      let i.text = iconv(i.text, "utf-8", "cp936")
   endfor
   call setqflist(qflist)
endfunction

au QuickfixCmdPost make call QfMakeConv()

" let g:clang_library_path='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/'
" let g:clang_complete_auto=1
" let g:clang_hl_errors=1
" let g:clang_complete_copen=0
" let g:clang_use_library=1
" let g:clang_user_options='--stdlib=libc++ -std=c++11'
" map <c-i> <c-space>
" let g:ycm_key_invoke_completion = '<c-l>'

let g:NERDTreeNodeDelimiter = "\u00a0"

function OpenNERDTree()
    :NERDTree
endfunction

" autocmd VimEnter * call OpenNERDTree()

let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1

" resize window
map <silent> <s-up> :res -5<cr>
map <silent> <s-down> :res +5<cr>
map <silent> <s-right> :vertical resize +5<cr>
map <silent> <s-left> :vertical resize -5<cr>

let g:airline_theme='bubblegum'

execute pathogen#infect()

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_lua_checkers = ['luac', 'luacheck']
let g:syntastic_lua_luacheck_args = '--no-unused-args'

autocmd QuickFixCmdPost *grep* cwindow
autocmd QuickFixCmdPost *log* cwindow

set exrc

let g:fugitive_git_executable = 'LANG=en_US.UTF8 git'

map fs :Rg -F <cword><CR>
map fa :Rg -F <cword>
map fn :Rg -F <cword> --no-ignore<CR>

nmap fc :Rg "\b<cword>\b" % <CR>
nmap fw :Rg "\b<cword>\b" <CR>
nmap fr :Rg "\b<cword>\b"
vmap fw "oy:Rg "\b<C-R>o\b" <CR>
vmap fr "oy:Rg "\b<C-R>o\b"
vmap fc "oy:Rg "\b<C-R>o\b" % <CR>

