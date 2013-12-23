init:
	ln -sf \`pwd\`/vimrc ~/.vimrc
	ln -sf \`pwd\`/tmux.conf ~/.tmux.conf

sync:
	git pull
	git push
