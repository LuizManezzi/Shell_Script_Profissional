#!/bin/bash
# extrair_manchetes.sh
# Extrai manchetes dos sites em texto
# Versão 1: Procura por destaques no html do site
#
# Aurélio, Agosto de 2006

URL="http://br-linux.org"

# o padrão são linhas que iniciam com maiúsculas.
# Até a linha "Destaques de hoje" é lixo.
#

lynx -dump -nolist http://br-linux.org |	#-dump transforma o html em txt; -nolist desconsidera todos os links
	grep '^[A-Z]'|				#Seleciona apenas os conteúdos iniciados por letras maiúsculas
	sed '1,/^BR-Linux.org/ d'|  		#Exlui desde a primeira linha até "BR-Linux.org" informado no parametro antes do "d" delete
	head -n 5				#Seleciona apenas os 5 primeiros titúlos após o comando anterior
