"~/.vim/ftplugin/tex.vim
setlocal formatoptions+=wa
imap  [[ \begin{
imap  ]] LatexCloseLastEnv
nmap   LatexChangeEnv
vmap   LatexWrapSelection
vmap   LatexWrapSelectionEnv
