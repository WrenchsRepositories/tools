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
GIT_BRANCH_COLOR=${GIT_BRANCH_COLOR:-yellow}


ROOT_FIRST_LINE() {
	printf "%s%s(%s%s%s%s%s%s)-[%s%s%s] <%s>" \
		"$TOP_LEFT_CHAR" "$HORIZ" \
		"%F{$ROOT_USER_COLOR}" "%n" "%f" \
		"%F{$HOST_COLOR}" "@%m" "%f" \
		"%F{$PWD_COLOR}" "%~" "%f" "$(GIT_BRANCH)"
}

FIRST_LINE() {
	printf "%s%s(%s%s%s%s%s%s)-[%s%s%s] <%s>" \
		"$TOP_LEFT_CHAR" "$HORIZ" \
		"%F{$USER_COLOR}" "%n" "%f" \
		"%F{$HOST_COLOR}" "@%m" "%f" \
		"%F{$PWD_COLOR}" "%~" "%f" "$(GIT_BRANCH)"
}

SECOND_PREFIX() {
	printf "%s%s" "$BOTTOM_LEFT_CHAR" "$HORIZ"
}

GIT_BRANCH() {
	if ! command -v git >/dev/null 2>&1; then
		return 0
	fi

	if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		return 0
	fi

	local branch
	branch=$(git symbolic-ref --short HEAD 2>/dev/null) || \
		branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
	if [[ -n $branch && $branch != "HEAD" ]]; then
		local dirty=''
		if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
			dirty='*'
		fi
		echo -n "%F{$GIT_BRANCH_COLOR}${branch}${dirty}%f"
	fi
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
