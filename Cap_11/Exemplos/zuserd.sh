#!/bin/bash
#
# zuserd
# Lista, adiciona e remove usuários do sistema Z
#
# Requisitos: bantex.sh, dialog
#
# 01-02-2024 - MZKY
# 04-02-2024 - MZKY - V1:
# - Corrigido bug com caracteres especias nos inputs (Adicionado a variável carac_espec)
#

# Localização do arquivo do banco de dados
BANCO=usuarios.txt

# Trata os caracteres especiais dos inputs
carac_espec='s/[[:alpha:]];[[:alnum:]]//g'

# Inclui o gerenciador do banco
source bantex-4.sh || {
	echo "Ops, ocorreu algum erro no gerenciador do banco."
	return 1
}

while :
do
	acao=$( dialog --stdout \
		--menu "Aplicativo Zuserd - Interface amigável" \
		0 0 0 \
		lista "Lista todos os usuários do sistema" \
		adiciona "Adiciona um novo usuário no sistema" \
		remove "Remove um usuário do sistema")
	[ $? -ne 0 ] && exit 
	
	# Lida com os comandos recebidos
	case "$acao" in

		lista)
			# Lista dos logins (apaga a primeira linha)
			temp=$(mktemp -t temp_zuserd_XXX)
			pega_campo 1 | sed 1d > "$temp"
			dialog --title "Usuários" --textbox "$temp" 13 30
			rm $temp
			continue
		;;

		adiciona)
			login=$(dialog --stdout --inputbox "Digite o login:" 0 0)
			
			login=$(echo "$login" | sed "$carac_espec")
			[ $? -ne 0 ] && continue
			[ "$login" ] || continue

			# Primeiro confere se já não existe esse usuário
			tem_chave "$login" && {
				msg="O usuário '$login' já foi cadastrado."
				dialog --msgbox "$msg" 6 40
				continue
			}

			# Ok, é um usuário novo, prossigamos
			nome=$(dialog --stdout --inputbox "Nome Completo:" 0 0 )
			nome=$(echo "$nome" | sed "$carac_espec")
			[ $? -ne 0 ] && continue

			idade=$(dialog --stdout --inputbox "Idade:" 0 0)
			[ $? -ne 0 ] && continue

			sexo=$(dialog --stdout --radiolist "Para escolher, utilize os botões UP ou DOWN (seta para cima ou para baixo) e pressione a tecla ESPAÇO para marcar a opção, por fim, confirme pressionando ENTER.\n\n\
			Por favor, informe o sexo do usuário: " 0 0 0 \
			F 'Feminino' on \
			M 'Masculino' off \
			NA 'Não informado' off)
			[ $? -ne 0 ] && continue
		
			# Dados obtidos, hora de mascarar eventuais dois-pontos
			nome=$(echo $nome | mascara)

			# Tudo pronto, basta inserir
			msg=$(insere_registro "$login:$nome:$idade:$sexo")
			dialog --title "Resultado" --msgbox "$msg" 6 40
		;;

		remove)
			# Obtém a lista de usuários

			usuarios=$(pega_campo 1,2 | sed 1d)
			usuarios=$(echo "$usuarios" | sed 's/:/ "/; s/$/"/')

			login=$(eval dialog --stdout \
				--menu \"Escolha o usuário a remover\" \
				0 0 0 $usuarios)
			[ $? -ne 0 ] && continue

			login_tratado=$(echo "$login" | sed "$carac_espec")
			msg=$(apaga_registro "$login_tratado")
			dialog --title "Resultado" --msgbox "$login_tratado" 6 40
		;;
	esac
done
echo -e '\033c'
