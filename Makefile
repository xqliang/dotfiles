init:
	# vimrc
	[ -f ~/.vimrc ] && ([ -L ~/.vimrc ] || mv ~/.vimrc{,.`date +%Y%m%d`.bak}) || true
	ln -sf `pwd`/vimrc ~/.vimrc
	# tmux.conf
	[ -f ~/.tmux.conf ] && ([ -L ~/.tmux.conf ] || mv ~/.tmux.conf{,.`date +%Y%m%d`.bak}) || true
	ln -sf `pwd`/tmux.conf ~/.tmux.conf
	# pythonstartup
	[ -f ~/.pythonstartup ] && ([ -L ~/.pythonstartup ] || mv ~/.pythonstartup{,.`date +%Y%m%d`.bak}) || true
	ln -sf `pwd`/pythonstartup ~/.pythonstartup
	# bashrc
	[ -f ~/.bashrc ] && ([ -L ~/.bashrc ] || mv ~/.bashrc{,.`date +%Y%m%d`.bak}) || true
	ln -sf `pwd`/bashrc ~/.bashrc

sync:
	git pull
	git push
