setopt PROMPT_SUBST

autoload -Uz colors && colors

TOP_LEFT_CHAR=${TOP_LEFT_CHAR:-'╭'}  
BOTTOM_LEFT_CHAR=${BOTTOM_LEFT_CHAR:-'╰'} 
HORIZ=${HORIZ:-'─'}                   
PROMPT_CHAR=${PROMPT_CHAR:-'$'} 

USER_COLOR=${USER_COLOR:-cyan}
HOST_COLOR=${HOST_COLOR:-magenta}
PWD_COLOR=${PWD_COLOR:-blue}
PROMPT_SYMBOL_COLOR=${PROMPT_SYMBOL_COLOR:-cyan}
SUDO_COLOR=${SUDO_COLOR:-blue}


FIRST_LINE() {
  printf "%s%s(%s%s%s%s%s%s)-[%s%s%s]" \
    "$TOP_LEFT_CHAR" "$HORIZ" \
    "%F{$USER_COLOR}" "%n" "%f" \
    "%F{$HOST_COLOR}" "@%m" "%f" \
    "%F{$PWD_COLOR}" "%~" "%f"
}

SECOND_PREFIX() {
  printf "%s%s" "$BOTTOM_LEFT_CHAR" "$HORIZ"
}

PROMPT='$(FIRST_LINE)'            
PROMPT+='%(?..%F{red} ✖ %? %f)'
PROMPT+=$'\n'                    
PROMPT+='$(SECOND_PREFIX)%F{'"$PROMPT_SYMBOL_COLOR"'}'"$PROMPT_CHAR"'%f '  

