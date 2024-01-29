# Função feed: Extrai as manchetes mais recentes de um Feed
# Passse o endereço do feed como argumento
# Exemplo: feed http://br-linux.org/feed/
#

function feed() {
	lynx -nomore -source "$1" | grep '<title><!\[CDATA\[' | tr -d \\t |
		sed '
			s/<[^!<\[CDATA\[]*<!\[CDATA\[//g
			s/\]\]>.*//g
			1d'
}

feed "$1"
