setopt PROMPT_SUBST

autoload -Uz colors && colors

TOP_LEFT_CHAR=${TOP_LEFT_CHAR:-'╭'}  
BOTTOM_LEFT_CHAR=${BOTTOM_LEFT_CHAR:-'╰'} 
HORIZ=${HORIZ:-'─'}                   
ROOT_PROMPT_CHAR=${ROOT_PROMPT_CHAR:-'#'}
PROMPT_CHAR=${PROMPT_CHAR:-'$'} 

ROOT_USER_COLOR=${ROOT_USER_COLOR:-red}
USER_COLOR=${USER_COLOR:-cyan}
HOST_COLOR=${HOST_COLOR:-magenta}
PWD_COLOR=${PWD_COLOR:-blue}
ROOT_PROMPT_SYMBOL_COLOR=${PROMPT_SYMBOL_COLOR:-red}
PROMPT_SYMBOL_COLOR=${PROMPT_SYMBOL_COLOR:-cyan}


ROOT_FIRST_LINE() {
	printf "%s%s(%s%s%s%s%s%s)-[%s%s%s]" \
		"$TOP_LEFT_CHAR" "$HORIZ" \
		"%F{$ROOT_USER_COLOR}" "%n" "%f" \
		"%F{$HOST_COLOR}" "@%m" "%f" \
		"%F{$PWD_COLOR}" "%~" "%f"
}

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


if [[ $EUID -eq 0 ]]; then
	PROMPT='$(ROOT_FIRST_LINE)'            
	PROMPT+='%(?..%F{red} ✖ %? %f)'
	PROMPT+=$'\n'                    
	PROMPT+='$(SECOND_PREFIX)%F{'"$ROOT_PROMPT_SYMBOL_COLOR"'}'"$ROOT_PROMPT_CHAR"'%f '  
else
	PROMPT='$(FIRST_LINE)'            
	PROMPT+='%(?..%F{red} ✖ %? %f)'
	PROMPT+=$'\n'                    
	PROMPT+='$(SECOND_PREFIX)%F{'"$PROMPT_SYMBOL_COLOR"'}'"$PROMPT_CHAR"'%f '  
fi
