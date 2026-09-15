setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab

setlocal wrap
setlocal linebreak

" 編譯/檢視/清理一律使用 vimtex 原生對應（g:vimtex_mappings_prefix = '<localleader>l'）：
"   <localleader>ll 編譯   <localleader>lk 停止   <localleader>lv 檢視   <localleader>lc 清理
" 完整清單：:nmap <localleader>l

let b:undo_ftplugin = 'setlocal tabstop< shiftwidth< expandtab< wrap< linebreak< conceallevel<'
