init:
    git clone git@github.com:xqliang/dotfiles .dotfiles
    cd .dotfiles
    ln -sf \`pwd\`/vimrc ~/.vimrc

sync:
    git pull
    git push
