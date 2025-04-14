{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    extraConfig = ''
      "  _   _         __     ___           
      " | \ | | ___  __\ \   / (_)_ __ ___  
      " |  \| |/ _ \/ _ \ \ / /| | '_ ` _ \ 
      " | |\  |  __/ (_) \ V / | | | | | | |
      " |_| \_|\___|\___/ \_/  |_|_| |_| |_|
      ""
      """""""""""""""""""""""""""""""""""""
                                        
      set nocompatible                  " 去除VI一至性
      syntax on                          " 自动语法高亮
      set redrawtime=20000               " 增加渲染时间, 解决大文件不高亮

      set number                         " 显示行号
      set cursorline                     " 突出显示当前行
      set tabstop=4                       " 设置一个TAB为4个空格
      set shiftwidth=4
      set expandtab
      set wildmenu
      let mapleader="\<space>"            " 设置Leader为空格

      " 自动安装 vim-plug 插件管理器
      if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      endif

      let mapleader="\<space>"            " 设置Leader为空格

      """""""""""""""""""""""""""""""""""""
      " 主题设置
      """""""""""""""""""""""""""""""""""""

      " colorscheme solarized        	" 设定配色方案
      " set background=dark		" 设定配色主题
      " set background=light		" 设定配色主题

      " gruvbox配色主题
      autocmd vimenter * ++nested colorscheme gruvbox
      let g:gruvbox_italic=1

      if (empty($TMUX))
        if (has("nvim"))
          let $NVIM_TUI_ENABLE_TRUE_COLOR=1
        endif

        if (has("termguicolors"))
          set termguicolors
        endif
      endif

      """""""""""""""""""""""""""
      "       fcitx设置       "
      """""""""""""""""""""""""""
      let g:input_toggle = 1

      function! Fcitx2en()
         let s:input_status = system("fcitx5-remote")
         if s:input_status == 2
            let g:input_toggle = 1
            let l:a = system("fcitx5-remote -c")
         endif
      endfunction

      function! Fcitx2zh()
         let s:input_status = system("fcitx5-remote")
         if s:input_status != 2
            let l:a = system("fcitx5-remote -o")
            let g:input_toggle = 0
         endif
      endfunction

      set ttimeoutlen=150
      " 退出插入模式
      autocmd InsertLeave * call Fcitx2en()
      " 进入插入模式
      " autocmd InsertEnter * call Fcitx2zh()
      autocmd InsertEnter * call Fcitx2en()

      """""""""""""""""""""""
      "      系统剪贴板       "
      """""""""""""""""""""""
      vmap <leader>y "*y
      nmap <leader>y "*y
      vmap <leader>p "*p
      nmap <leader>p "*p

      " 输入状态移动光标
      imap <c-h> <left>
      imap <c-j> <down>
      imap <c-k> <up>
      imap <c-l> <right>

      " 切换Tab标签
      nmap tn  :tabe<CR>
      nmap th  :tabp<CR>
      nmap tk  :-tabmove<CR>
      nmap tj  :+tabmove<CR>
      nmap tl  :tabn<CR>

      " Shift跨行移动
      nmap J  5j
      nmap K  5k
      vmap J  5j
      vmap K  5k

      " 插入模式下删除行
      imap <c-d> <ESC>ddi
      imap <c-D> <ESC>Di

      " 储存和退出
      map <c-q> :q<CR>
      imap <c-q> <ESC>:q<CR>
      map <c-s> :w<CR>
      imap <c-s> <ESC>:w<CR>
      " map <c-r> :source ~/.vimrc<CR>
      imap <c-r> <ESC>:source ~/.vimrc<CR>

      " 分屏
      map s       :none
      map <a-h>   <c-w>h
      map wh      <c-w>h
      map <a-j>   <c-w>j
      map wj      <c-w>j
      map <a-k>   <c-w>k
      map wk      <c-w>k
      map <a-l>   <c-w>l
      map wl      <c-w>l

      nnoremap <Leader>cmd :below split<CR>:resize 8<CR>:terminal<CR>:set nonumber<CR>
      autocmd TermOpen * tnoremap <Leader>cmd <C-\><C-n>:q<CR>

      map sl      :set splitright<CR>:vsplit<CR>
      map sh      :set nosplitright<CR>:vsplit<CR>
      map sj      :set splitbelow<CR>:split<CR>
      map sk      :set nosplitbelow<CR>:split<CR>

      iab ddd <c-r>=strftime("%Y-%m-%d")<cr>
      iab dddd <c-r>=strftime("%Y-%m-%d %H:%M:%S")<cr>
      iab aude @author<tab>Mr.Cookie<cr>@date<tab>

      " Markdown Preview 配置
      " let g:mkdp_path_to_chrome="qutebrowser"
      " let g:mkdp_path_to_chrome="google-chrome-stable --new-window --app="
      let g:mkdp_path_to_chrome="vimb"
      let g:mkdp_auto_close=0
      let g:mkdt_auto_astar=1
      nmap <F7> <Plug>MarkdownPreview
      nmap <F8> <Plug>StopMarkdownPreview

      " NerdTree 快捷键配置
      " nmap tt :NERDTreeToggle<CR>
      nmap tt :CocCommand explorer<CR>
      let NERDTreeHighlightCursorline = 1 " 高亮当前行
      let NERDTreeShowLineNumbers     = 1 " 显示行号

      " Vim-AirLine 配置
      let laststatus = 2
      let g:aireline_powerline_fonts = 1
      " let g:airline_theme = 'base16'

      " emmet-vim配置
      " let g:user_emmet_leader_key = '<c-,>'
      " let g:user_emmet_expandabbr_key = '<leader><TAB>'

      " TableModeToggle 开关表格模式
      noremap <LEADER>tm :TableModeToggle<CR>
      noremap <LEADER>tr :TableModeRealign<CR>

      call plug#begin('~/.vim/plugged')

      " rakr/vim-one主题
      Plug 'rakr/vim-one'
      Plug 'morhetz/gruvbox'

      " coc.vim
      Plug 'neoclide/coc.nvim', {'branch':'release'}
      Plug 'MunifTanjim/prettier.nvim'
      Plug 'neovim/nvim-lspconfig'

      Plug 'vim-airline/vim-airline'
      Plug 'vim-airline/vim-airline-themes'
      " Plug 'scrooloose/nerdtree'

      " MakeDown
      Plug 'iamcco/markdown-preview.vim'
      " Plug 'instant-markdown/vim-instant-markdown'        " 测试新版MD预览
      Plug 'joker1007/vim-markdown-quote-syntax'

      " TabMode
      Plug 'dhruvasagar/vim-table-mode'

      " 模糊搜索
      " Plug 'kien/ctrlp.vim'
      Plug 'yggdroot/leaderf'

      " 寄存器查看
      Plug 'junegunn/vim-peekaboo'

      " 代码块选择
      Plug 'gcmt/wildfire.vim'

      " 符号包围
      " S  将选中的块添加符号包围 例: S'    将选中块用单引号包围
      " cs 将选中的块包围符号更换 例: cs'"  将单引号更换为双引号
      Plug 'tpope/vim-surround'

      " 自动补全符号
      " Plug 'Raimondi/delimitMate'

      " 可视化缩进
      Plug 'Yggdroot/indentLine'

      Plug 'lambdalisue/suda.vim'         " 忘记sudo vim 可以 :sudowrite 或者 :sw

      " vim ranger
      Plug 'kevinhwang91/rnvimr'

      " 快速注释
      Plug 'scrooloose/nerdcommenter' 

      call plug#end()

      """""""""""""""""""""""
      "      快速注释         "
      """""""""""""""""""""""
      filetype plugin on
      " 默认情况下，在注释分隔符后添加空格
      let g:NERDSpaceDelims = 1

      " 对美化的多行注释使用压缩语法(貌似这个没什么卵用)
      let g:NERDCompactSexyComs = 1

      " 按行对齐注释分隔符左对齐，而不是按代码缩进
      " let g:NERDDefaultAlign = 'left'

      " 默认情况下，将语言设置为使用其备用分隔符（不是很明白所以忽略）
      let g:NERDAltDelims_java = 1

      " 添加您自己的自定义格式或覆盖默认格式（你懂的）
      " let g:NERDCustomDelimiters = { 'php': { 'left': '/*','right': '*/' },'html': { 'left': '<!--','right': '-->' },'py': { 'left': '#' },'sh': { 'left': '#' } }
      let g:NERDCustomDelimiters = { 'html': { 'left': '<!--','right': '-->' },'py': { 'left': '#' },'sh': { 'left': '#' } }

      " 允许注释和反转空行（在注释区域时很有用） （没亲测）
      let g:NERDCommentEmptyLines = 1

      " 取消注释时启用尾随空白的修剪
      let g:NERDTrimTrailingWhitespace = 1

      " 启用 nerdcommenttoggle 检查是否对所有选定行进行了注释
      let g:NERDToggleCheckAllLines = 1

      nmap <c-/> <plug>NERDCommenterToggle
      vmap <c-/> <plug>NERDCommenterToggle
      imap <c-/> <esc><plug>NERDCommenterToggle

      """"""""""""""
      " Leaderf 配置
      """"""""""""""

      " 显示图标
      let g:Lf_ShowDevIcons = 1
      " 设置图标字体
      " let g:Lf_DevIconsFont = "DroidSansMono Nerd Font Mono"
      " UTF8显示半个文字处理, 好像用不到
      " set ambiwidth=double

      let g:Lf_HideHelp = 1
      let g:Lf_UseCache = 0
      let g:Lf_UseVersionControlTool = 0
      let g:Lf_IgnoreCurrentBufferName = 1
      " popup mode
      let g:Lf_WindowPosition = 'popup'
      let g:Lf_PreviewInPopup = 1
      let g:Lf_StlSeparator = { 'left': "\ue0b0", 'right': "\ue0b2", 'font': "Deja

