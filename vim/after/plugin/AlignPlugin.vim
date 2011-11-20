" auto-align: left justify (l), first sep only (:), 1 sp on either side of
" separator (p1P1), preserve leading whitespace so we don't break indenting (W)
" works for = and =>
AlignCtrl =l:p1P1W =>\?
vmap + = gv :Align<CR>
