#!/bin/bash
# extrair_manchetes_v3.sh
# Mostra as ultimas manchetes do site
# Versão 3: Procura no feed XML
#
# Aurélio, Agosto de 2006

URL="http://br-linux.org/linux/node/feed"

# O padrão são linhas com "<title>".
# O sed remove as tags HTML, restaura as aspas,
# apaga os espaços do inicio e remove a primeira linha.
# head limita o número de manchetes em 5.
#

lynx -source "$URL" | 
	grep '<title><!\[' |
	sed '
		s/<[^CDATA[]*]//g
		s/&quot;/"/g' |
	head -n 5
