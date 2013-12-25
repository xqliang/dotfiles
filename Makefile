init:
	# vimrc
	[ -f ~/.vimrc ] && ([ -L ~/.vimrc ] || mv ~/.vimrc{,.`date +%Y%m%d`.bak})
	ln -sf `pwd`/vimrc ~/.vimrc
	# tmux.conf
	[ -f ~/.tmux.conf ] && ([ -L ~/.tmux.conf ] || mv ~/.tmux.conf{,.`date +%Y%m%d`.bak})
	ln -sf `pwd`/tmux.conf ~/.tmux.conf

sync:
	git pull
	git push
