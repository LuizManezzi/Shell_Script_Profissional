#!/bin/bash
# sirene.sh
# Bom para chamar a atenção

echo -ne "\033[11;900]" # Cada bipe dua 900 milesegundos
while :			# Loop infinito
do
	echo -ne "\033[10;500]\a" ; sleep 1 # Tom alto (augo)
	echo -ne "\033[10;400]\a" ; sleep 1 # Tom baixo (grave)
done

