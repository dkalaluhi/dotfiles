# Native Zsh prompt
#
# Line 1: current directory and git state
# Line 2: previous command failure indicator and input prompt

autoload -Uz vcs_info

# Allow variables and command substitution inside the prompt
setopt PROMPT_SUBST

# Git information
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '%F{green}🌿 %b%f%c%u'
zstyle ':vcs_info:git:*' actionformats '%F{green}🌿 %b%f %F{magenta}(%a)%f%c%u'

# Repository status markers
zstyle ':vcs_info:git:*' stagedstr ' %F{yellow}+%f'
zstyle ':vcs_info:git:*' unstagedstr ' %F{yellow}*%f'

_prompt_precmd() {
    local exit_status=$?

    # Refresh Git information before drawing each prompt.
    vcs_info

    local remote_context=''
    local failure_indicator=''

    # Show the hostname only during an SSH session
    if [[ -n "${SSH_CONNECTION:-}" ]]; then
        remote_context='%F{cyan}🖥 %m%f'$'\n'
    fi

    # Show a red X when the previous command failed.
    if (( exit_status != 0 )); then
        failure_indicator='%F{red}✖%f '
    fi

    PROMPT="${remote_context}%F{blue}📁 %~%f  \${vcs_info_msg_0_}
${failure_indicator}❯ "
}

# Avoid registering the hook more than once when reloading .zshrc
if (( ${precmd_functions[(Ie)_prompt_precmd]} == 0 )); then
    precmd_functions+=(_prompt_precmd)
fi

# Do not use a right-side prompt...for now.
RPROMPT=''
