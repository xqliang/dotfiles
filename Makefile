init:
	ln -sf \`pwd\`/vimrc ~/.vimrc

sync:
	git pull
	git push
