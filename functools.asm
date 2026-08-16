# rotina que atualiza posicao do NPC com recuo (desvio vertical) e desvio horizontal ao colidir verticalmente
# $4 = endereco de inicio da memoria temporaria
# $5 = posicao atual
# $6 = passo vertical
# $7 = passo horizontal
# retorna $2 = nova posicao (ja com recuo ou desvio se necessario)
atualizaPosicaoNPC:
	sw $5, 0($4)
	sw $6, 4($4)
	sw $7, 8($4)
	
	sw $8, 12($4)
	
	add $8, $0, $31 # salva retorno em $8

	# tenta mover apenas na vertical
	add $5, $5, $0		# posicao atual
	add $6, $6, $0		# deslocamento vertical
	add $7, $0, $0		# deslocamento horizontal
	addi $4, $4, 16		# $4 = memoria temporaria
	jal tentaMover
	subi $4, $4, 16
	bne $2, $5, retornaOK

	# colidiu, tenta recuar
	add $5, $5, $0		# posicao atual
	sub $6, $0, $6 		# inverte passo vertical (se tiver subindo, vai descer, e vice versa)
	add $7, $0, $0		# deslocamento horizontal
	addi $4, $4, 16
	jal tentaMover
	subi $4, $4, 16
	bne $2, $5, baseRecuo
	j tentaDesvio # recuo bloqueado, mantem base original

baseRecuo:
	add $5, $2, $0 # base = posicao do recuo

tentaDesvio:
	# tenta base + passo horizontal
	add $5, $5, $0		# posicao atual
	add $6, $0, $0		# deslocamento vertical
	lw $7, 8($4)		# deslocamento horizontal
	addi $4, $4, 16
	jal tentaMover
	subi $4, $4, 16
	bne $2, $5, retornaOK # desvio conseguiu

	# tenta base - passo horizontal
	add $5, $5, $0		# posicao atual
	add $6, $0, $0		# deslocamento vertical
	sub $7, $0, $7		# deslocamento horizontal (invertido)
	addi $4, $4, 16
	jal tentaMover
	subi $4, $4, 16
	bne $2, $5, retornaOK

	# encurralado, retorna a base
	add $2, $5, $0

retornaOK:
	add $31, $8, $0 # restaura retorno
	lw $5, 0($4)
	lw $6, 4($4)
	lw $7, 8($4)
	
	lw $8, 12($4)
	jr $31

# aplica o deslocamento vertical e horizontal a partir da posicao atual, se nao encontrar barreira
# se o bloco 16x16 no destino estiver livre retorna a nova posicao
# caso contrario retorna a mesma posicao
# $4 = endereco de inicio da memoria temporaria
# $5 = posicao atual
# $6 = deslocamento vertical
# $7 = deslocamento horizontal
# retorna $2 = nova posicao ou a original se colidiu
tentaMover:
	sw $5, 0($4)
	sw $6, 4($4)
	sw $7, 8($4)
	
	sw $8, 12($4)
	sw $9, 16($4)
	sw $10, 20($4)
	
	add $8, $0, $31 # salva retorno

	add $10, $6, $5 # candidato = original + dy
	add $10, $10, $7 # candidato += dx
	
	addi $4, $4, 24	# memoria temporaria
	li $9, 0x003D251E
	sw $9, 0($4) # cor alvo
	add $5, $10, $0	# endereco do bloco 16x16
	addi $6, $0, 16
	addi $7, $0, 16
	jal procuraCor
	subi $4, $4, 24
	
	beq $2, $0, tentaMoverFim # sem colisao, candidato mantido em $10
	lw $10, 0($4) # colidiu, atualiza candidato para 0($4) = posicao original
tentaMoverFim:
	add $2, $10, $0 # retorna $10 (candidato)
	add $31, $8, $0

	lw $5, 0($4)
	lw $6, 4($4)
	lw $7, 8($4)
	
	lw $8, 12($4)
	lw $9, 16($4)
	lw $10, 20($4)
	jr $31

# calcula o novo passo vertical a partir da diferenca das posicoes
# se diferenca == 0 (encurralado em ambos eixos), mantem o passo atual
# $4 = endereco de inicio da memoria temporaria
# $5 = posicao atual 
# $6 = nova posicao
# $7 = passo vertical atual
# retorna $2 = novo passo vertical (multiplo de 1024, com sinal)
atualizaPassoVertical:
	sw $8, 0($4)
	
	sub $8, $6, $5 # diferenca
	bne $8, $0, decompoeVertical
	add $2, $7, $0 # diferenca == 0: mantem passo atual
	j retornaVertical

decompoeVertical:
	# 1028 -> (1024 + 4) + 512 -> 2^5 = 1024 
	addi $8, $8, 512 # bias de arredondamento
	sra $2, $8, 10
	sll $2, $2, 10
retornaVertical:
	lw $8, 0($4)
	jr $31

# calcula o novo passo horizontal a partir da diferenca de posicao
# se diferenca == 0 (encurralado em ambos eixos), mantem o passo atual
# $4 = endereco de inicio da memoria temporaria
# $5 = posicao atual
# $6 = nova posicao
# $7 = passo horizontal atual
# retorna $2 = novo passo horizontal (multiplo de 4, com sinal, em [-512,512))
atualizaPassoHorizontal:
	sw $8, 0($4)
	sw $9, 4($4)
	
	sub $8, $6, $5 # diferenca
	bne $8, $0, decompoeHorizontal
	add $2, $7, $0 # diferenca == 0: mantem passo atual
	j retornaHorizontal
decompoeHorizontal:
	addi $9, $8, 512
	sra $9, $9, 10
	sll $9, $9, 10
	sub $2, $8, $9  # resto
	bne $2, $0, retornaHorizontal
	add $2, $7, $0 # resto == 0: mantem passo atual (preserva direcao)
retornaHorizontal:
	lw $8, 0($4)
	lw $9, 4($4)
	jr $31

# copia de regiao de memoria (buffer) para um retangulo do cenario
# considera 0xFFFFFFFF como transparencia
# $4 = endereco de inicio da memoria livre
# $5 = largura
# $6 = altura
# endereco de origem em 0($4)
# endereco de destino em 4($4)
desenhaImagem:
	sw $5, 8($4)
	sw $6, 12($4)
	
	sw $7, 16($4)
	sw $8, 20($4)
	sw $9, 24($4)
	
	lw $7, 0($4) # carrega origem
	lw $8, 4($4) # carrega destino

desenhaLinha:
	beq $6, $0, desenhaFim # altura zerada encerra

desenhaPixel:
	beq $5, $0, desenhaProximaLinha # fim da linha, ajusta ponteiro destino
	
	lw  $9, 0($7) # le pixel da origem
	nor $9, $9, $0 # inverte bits (0xFFFFFFFF vira 0x00000000). fiz isso pra economizar registrador
	beq $9, $0, desenhaProximoPixel # se era 0xFFFFFFFF, nao pinte

	nor $9, $9, $0 # restaura cor original
	sw $9, 0($8) # escreve pixel no destino

desenhaProximoPixel:
	addi $7, $7, 4 # avanca origem
	addi $8, $8, 4 # avanca destino
	subi $5, $5, 1 # decrementa colunas restantes
	j desenhaPixel

desenhaProximaLinha:
	lw $5, 8($4)
	sll $9, $5, 2
	sub $8, $8, $9 # recua ao inicio da linha no destino
	addi $8, $8, 1024 # desce para proxima linha da tela
	subi $6, $6, 1
	j desenhaLinha

desenhaFim:
	lw $5, 8($4)
	lw $6, 12($4)
	
	lw $7, 16($4)
	lw $8, 20($4)
	lw $9, 24($4)
	jr $31

# copia de retangulo do cenario para uma regiao de memoria (buffer)
# $4 = endereco de inicio da memoria temporaria
# $5 = largura
# $6 = altura
# endereco de origem em 0($4)
# endereco de destino em 4($4)
salvaTela:
	sw $5, 8($4)
	sw $6, 12($4)
	
	sw $7, 16($4)
	sw $8, 20($4)
	sw $9, 24($4)
	
	lw $7, 0($4) # carrega origem
	lw $8, 4($4) # carrega destino

salvaLinha:
	beq $6, $0, salvaFim # altura eh contador. se zerada, encerra

salvaPixel:
	beq $5, $0, salvaProximaLinha
	
	lw $9, 0($7) # le pixel da tela
	sw $9, 0($8) # escreve no buffer
	
	addi $7, $7, 4
	addi $8, $8, 4
	subi $5, $5, 1
	j salvaPixel

salvaProximaLinha:
	lw $5, 8($4)
	sll $9, $5, 2
	sub $7, $7, $9 # recua ao inicio da linha copiada
	addi $7, $7, 1024 # avanca para proxima linha da tela
	subi $6, $6, 1
	j salvaLinha

salvaFim:
	lw $5, 8($4)
	lw $6, 12($4)
	
	lw $7, 16($4)
	lw $8, 20($4)
	lw $9, 24($4)
	jr $31

# procura uma cor em uma area retangular da tela
# $4 = endereco de inicio da memoria temporaria
# $5 = endereco inicial
# $6 = largura
# $7 = altura
# cor alvo armazenada em 0($4)
# retorna $2 = 1 se achou, 0 caso contrario
procuraCor:
	sw $5, 4($4)		# salva endereco inicial
	sw $6, 8($4)		# salva largura
	sw $7, 12($4)		# salva altura
	
	sw $8, 16($4)		# salva $8 para usa-lo como temporario
	sw $9, 20($4)		# salva $9 para usa-lo como temporario
	
	addi $2, $0, 0		# retorno padrao: nao achou

procuraLinha:
	beq $7, $0, procuraFim	# altura eh contador. quando zerada, encerra

procuraPixel:
	beq $6, $0, procuraProximaLinha # fim da linha, vai pra a proxima
	
	lw $8, 0($5)		# pixel da tela
	lw $9, 0($4)		# cor alvo
	beq $8, $9, achouCor	# achou a cor procurada

	addi $5, $5, 4		# avanca endereco para a proxima coluna
	subi $6, $6, 1		# reduz contador de colunas restantes
	j procuraPixel

procuraProximaLinha:
	lw $6, 8($4) 		# reinicia contador de colunas
	sll $9, $6, 2		# $9 = largura em bytes (largura * 4)
	sub $5, $5, $9		# volta o endereco para o inicio da linha atual
	addi $5, $5, 1024	# avanca endereco para a proxima linha
	subi $7, $7, 1		# reduz contador de linhas restantes
	j procuraLinha

achouCor:
	addi $2, $0, 1		# retorna 1

procuraFim:
	lw $5, 4($4)		# restaura endereco inicial
	lw $6, 8($4)		# restaura largura
	lw $7, 12($4)		# restaura altura
	
	lw $8, 16($4)		# restaura $8 usado como temporario
	lw $9, 20($4)		# restaura $9 usado como temporario
	jr $31

# rotina de atraso
# $4 = endereco de inicio da memoria temporaria
# $5 = numero de iteracoes
timerDelay:
	sw $5, 0($4) # salva na memoria

timerDelayLoop:
	beq $5, $0, timerDelayFim
	subi $5, $5, 1
	j timerDelayLoop

timerDelayFim:
	lw $5, 0($4) # restaura da memoria
	jr $31