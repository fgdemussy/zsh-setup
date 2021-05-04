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
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

install_plugins() {
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i"_postinstall" '/^plugins=/N;s/(git)/(git zsh-navigation-tools zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc
}

main() {
    setup_color

    install_zsh

    if [[ $? -eq 0 ]]; then
        vim_syntax_on
        install_plugins
        zsh
    else
        echo "${YELLOW}Installing Oh-my-zsh failed."
        exit 1
    fi
}

main "$@"
