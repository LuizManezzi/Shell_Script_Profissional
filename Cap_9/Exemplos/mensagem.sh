#!/bin/bash
#
# mensagem.sh
# Mostra uma mensagem colorida na tela, lendo os
# dados de um arquivo de configuração externo.
#
# 30-01-2024

CONFIG="mensagem.conf"		#Inicializando o arquivo de configuração

# Configurações (serão lidas do $CONFIG)
USAR_CORES=0			# config: UsarCores
COR_LETRA=			# config: CorLetra
COR_FUNDO=			# config: Corfundo
MENSAGEM='Mensagem padrão'	# config: Mensagem

# Loop para ler linha a linha a configuração, guardando em $LINHA
while read LINHA; do

	#Ignorando as linhas de comentário
	[ "$(echo $LINHA | cut -c1)" = '#' ] && continue

	# Ignorando as linhas em branco
	[ "$LINHA" ] || continue

	# Guardando os valores em cada variável do bash
        set - $LINHA

        # Extraindo os dados
        # Primeiro vem a chave, o resto é o valor
        chave=$(echo $1 | tr A-Z a-z)
        shift           # Passa para a próxima variável de entrada do bash
        valor=$*        # Se for passado uma string ou valor com espaçamento, a variável armazena tudo em unico valor.

        # Conferindo se está tudo certo
        #echo "+++ $chave --> $valor"

	# Processando as configurações encontradas
	case "$chave" in

	usarcores)
        	[ "$(echo $valor | tr A-Z a-z)" = 'on' ] && USAR_CORES=1
        	;;
	corfundo)
        	COR_FUNDO=$(echo $valor | tr -d -c 0-9) # Só aceita numeros
        	;;
	corletra)
        	COR_LETRA=$(echo $valor | tr -d -c 0-9) # Só aceita numeros
        	;;
	mensagem)
        	[ "$valor" ] && MENSAGEM=$valor
        	;;
	*)
        	echo "Erro no arquivo de configuração"
        	echo "Opção desconhecida '$chave'"
        	exit 1
        	;;
	esac


done < "$CONFIG"

# Configurações carregadas, mostre a mensagem

if [ $USAR_CORES -eq 1 ]; then
	# Mostrar mensagem colorida
	# Exemplo:\033[40;32mOlá\033[m 
	echo -e "\033[$COR_FUNDO;${COR_LETRA}m$MENSAGEM\033[m"
else
	# Não usar cores
	echo "$MENSAGEM"
fi

