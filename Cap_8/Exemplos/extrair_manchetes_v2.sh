#!/bin/bash
# extrair_manchetes.sh
# Mostra as 5 primeiras manchetes do site
# Versão 2: Procura no html do site
#
# Aurélio, agosto de 2006

URL="http://br-linux.org"

# O padrão são linhas com "<h2> <a"
# O sed remove as tags HTML, restaura as aspas e
# apaga os espaços do inicio.
# O head limita o número de manchetes em 5.
#

lynx -source "$URL" | 
	grep '<h2><a' brlinux.html | 
	sed '
		s/<[^>]*>//g 
		s/&quot;/"/g
		s/[^ ]*//' | 
	head -n 5
