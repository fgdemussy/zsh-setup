#!/bin/sh
setup_color() {
    # Only use colors if connected to a terminal
    if [ -t 1 ]; then
        RED=$(printf '\033[31m')
        GREEN=$(printf '\033[32m')
        YELLOW=$(printf '\033[33m')
        BLUE=$(printf '\033[34m')
        BOLD=$(printf '\033[1m')
        RESET=$(printf '\033[m')
    else
        RED=""
        GREEN=""
        YELLOW=""
        BLUE=""
        BOLD=""
        RESET=""
    fi
}

vim_syntax_on() {
    echo "syntax on" >>~/.vimrc
}

install_zsh() {
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_plugins() {
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

copy_zshrc() {
    cp .zshrc ~/.zshrc
}

command_exists() {
    command -v "$@" >/dev/null 2>&1
}

fmt_code() {
    # shellcheck disable=SC2016 # backtic in single-quote
    printf '`\033[38;5;247m%s%s`\n' "$*" "$RESET"
}

main() {
    setup_color

    if ! command_exists zsh; then
        echo "${YELLOW}Zsh is not installed.${RESET} Please install zsh first."
        exit 1
    fi

    if [ -d "$ZSH" ]; then
        echo "${YELLOW}The \$ZSH folder already exists ($ZSH).${RESET}"
        cat <<EOF

You ran the installer with the \$ZSH setting or the \$ZSH variable is
exported. You have 3 options:

1. Unset the ZSH variable when calling the installer:
   $(fmt_code "ZSH= sh install.sh")
2. Install Oh My Zsh to a directory that doesn't exist yet:
   $(fmt_code "ZSH=path/to/new/ohmyzsh/folder sh install.sh")
3. (Caution) If the folder doesn't contain important information,
   you can just remove it with $(fmt_code "rm -r $ZSH")

EOF
        exit 1
    fi

    install_zsh
    vim_syntax_on
    install_plugins
    copy_zshrc
    source ~/.zshrc
}

main "$@"
