function! JSONify()
    1,$!node -p -e "JSON.stringify(eval('(' + require('fs').readFileSync('/dev/stdin', 'utf-8') + ')'), null, 2)"
endfunction
command! JSONify call JSONify()
