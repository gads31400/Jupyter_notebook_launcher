
.DEFAULT_GOAL= help

install: jupyter.sh jupyter.png jupyter.desktop dir_jupyter.txt  ## Copie les fichiers jupyter.sh jupyter.png jupyter.desktop dir_jupyter.txt
	cp ./jupyter.sh /usr/bin/jupyter.sh
	chmod +x /usr/bin/jupyter.sh
	cp ./jupyter.png /usr/share/pixmaps/jupyter.png
	cp ./jupyter.desktop /usr/share/applications/jupyter.desktop
	cp ./dir_jupyter.txt /usr/share/jupyter/dir_jupyter.txt



uninstall:  ## supprime les fichiers jupyter.sh jupyter.png jupyter.desktop dir_jupyter.txt
	rm /usr/bin/jupyter.sh 
	rm /usr/share/pixmaps/jupyter.png
	rm /usr/share/applications/jupyter.desktop
	rm /usr/share/jupyter/dir_jupyter.txt
help: 
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-10s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
