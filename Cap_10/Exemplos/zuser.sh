#!/bin/bash
#
# zuser
#Lista, adiciona e remove usuários do sistema Z
#
# Requisitos: bantex-4.sh
#
# Uso: zuser [ lista | adiciona | remove ]
#
# 01-02-2024 - MZKY



# Se não passar nenhum argumento, mostra a mensagem de ajuda
[ "$1" ] || {
	echo
	echo "Uso: zuser [ lista | adiciona | remove ]"
	echo
	echo "	lista 	 - Lista todos os usuários do sistema"
	echo "	adiciona - Adiciona um usuário novo no sistema"
	echo "	remove 	 - Remove um usuário do sistema"
	echo
	exit 0
}

# Localização do arquivo do banco de dados
BANCO=usuarios.txt

# Inclui o gerenciador do banco
source bantex-4.sh || {
	echo "Ops, ocorreu algum erro no gerenciador do banco"
	exit 1
}

# Lida com os comandos recebidos
case "$1" in

	lista)
		# Lista dos logins (apaga a primeira linha)
		pega_campo 1 | sed 1d
	;;

	adiciona)
		echo -n "Digite o login do usuário novo: "
		read login
		
		# Temos algo?
		[ "$login" ] || {
			echo "O login não pode ser vazio, tente novamente."
			exit 1
		}

		# Primeiro confere se já não existe esse usuário
		tem_chave "$login" && {
			echo "O usuário '$login' já foi cadastrado."
			exit 1
		}
		
		# Ok, é um usuário novo, prossigamos
		echo -n "Digite o nome completo: "
		read nome
		echo -n "Digite a idade: "
		read idade
		echo -n "É do sexo masculino ou feminino? [M | F] "
		read sexo
		echo
		
		# Dados obtidos, hora de mascara eventuais dois-pontos
		nome=$(echo $nome)
		
		# Tudo pronto, basta inserir
		insere_registro "$login	$nome	$idade	$sexo"
		echo
	;;

	remove)
		# Primeiro msotra lista de usuários, depois pergunta
		echo "Lista dos usuários do sistema:"
		pega_campo 1 | sed 1d | tr \\n ' '
		echo
		echo
		echo -n "Qual usuário você quer remover? "
		read login
		echo
		
		# Vamos apagar ou puxar a orelha?
		if tem_chave "$login"; then
			apaga_registro "$login"
		else
			echo "Não, não, esse usuário não está aqui..."
		fi
		echo
	;;
	
	*)
		# Quaquer outra opção é erro
		echo "Opção inválida $1"
		exit 1
	;;
esac
