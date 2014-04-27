init:
	@for f in vimrc tmux.conf pythonstartup bashrc gitconfig profile; do \
		if [ -f ~/.$$f ]; then \
			if [ ! -L ~/.$$f ]; then \
				echo "backup old file: mv ~/.$$f ~/.$$f.`date +%Y%m%d%H%M%S`.bak"; \
				mv ~/.$$f{,.`date +%Y%m%d%H%M%S`.bak}; \
			else \
				oldlink="`readlink ~/.$$f`"; \
				if [ "$$oldlink" != "`pwd`/$$f" ]; then \
					echo "remove old link: rm ~/.$$f (-> $$oldlink)"; \
					rm ~/.$$f; \
				else \
					echo "exist link: ~/.$$f -> `pwd`/$$f"; \
				fi; \
			fi; \
		fi; \
		if [ ! -f ~/.$$f ]; then \
			echo "create link: ln -s `pwd`/$$f ~/.$$f"; \
			ln -sf `pwd`/$$f ~/.$$f; \
		fi; \
	done
