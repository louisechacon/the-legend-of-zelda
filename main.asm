# primeiro cenario		0
# segundo cenario		131072
# link frente um		262144
# link frente dois		263168
# link direita um		264192
# link direita dois		265216
# link esquerda um		266240
# link esquerda dois		267264
# link costas um		268288
# link costas dois		269312
# espada direita		270336
# espada esquerda		271360
# espada cima			272384
# espada baixo			272896
# npc um			273408
# npc dois			274432
# explosao um			275456
# explosao dois			276480
# explosao tres			277504
# tela inicial			278528
# tela vitoria			409600
# tela game over		540672

# buffer link 			671744
# buffer npc 1 			672768
# buffer npc 2			673792
# buffer espada 		674816
# buffer cenario		675840
# buffer explosao		806912

# inicio da memoria livre	807936

.include "assets.asm"

.text
main:
	lui $8, 0x1001 # inicio da memoria
	addi $25, $8, 807936 # inicio da memoria livre
	
	# salva primeiro cenario
	add $4, $25, $0
	sw $8, 0($4) # origem (de onde vai copiar)
	addi $9, $8, 675840 # buffer do cenario
	sw $9, 4($4) # destino (onde vai salvar)
	addi $5, $0, 256 # largura
	addi $6, $0, 128 # altura
	jal salvaTela
iniciaJogoNaTelaInicial:
	lui $8, 0x1001 # inicio da memoria
	addi $25, $8, 807936 # inicio da memoria livre
	# carrega tela inicial
	add $4, $25, $0
	addi $9, $8, 278528 # tela inicial
	sw $9, 0($4) # origem (o que vai desenhar)
	sw $8, 4($4) # destino (onde vai desenhar)
	addi $5, $0, 256 # largura
	addi $6, $0, 128 # altura
	jal desenhaImagem
	
esperaIniciarJogo:    	
    	# verifica entrada do jogador:
	li $4, 0xffff0000
	lw $9, 0($4)

	beq $9, $0, esperaIniciarJogo
	lw $9, 4($4)
	addi $7, $0, ' '
	bne $9, $7, esperaIniciarJogo
	
	# carrega primeiro cenario
	add $4, $25, $0
	addi $9, $8, 675840 # buffer do cenario
	sw $9, 0($4) # origem (o que vai desenhar)
	sw $8, 4($4) # destino (onde vai desenhar)
	addi $5, $0, 256 # largura
	addi $6, $0, 128 # altura
	jal desenhaImagem

# roda animacao inicial
	# dados do link da animacao
	addi $20, $8, 671744 # buffer para o link
	addi $21, $8, 45312 # posicao inicial do link
	addi $22, $8, 33024 # limite do loop subirEscada
	addi $23, $0, 4 # altura do personagem ao desenhar (a medida em que sobe as escada essa altura cresce ate o padrao, 16)
	
	lui $24, 0x1001
	addi $24, $24, 262144
	
	lui $19, 0x1001
	addi $19, $19, 263168 
	add $19, $19, $24 # soma sprites

subirEscada:
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	sw $21, 0($4) # origem = $21
	sw $20, 4($4) # destino = $20
	addi $5, $0, 16	# largura
	add $6, $0, $23	# altura
	jal salvaTela

	lui $4, 0x1001
	addi $4, $4, 807936
	sw $24, 0($4) # origem
	sw $21, 4($4) # destino
	addi $5, $0, 16	# largura
	add $6, $0, $23	# altura
	jal desenhaImagem

    	lui  $4, 0x1001
    	addi $4, $4, 807936 # inicio da memoria livre
    	addi $5, $0, 100000
    	jal  timerDelay
	
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $20, 0($4) # origem
	sw $21, 4($4) # destino
	addi $5, $0, 16	# largura
	add $6, $0, $23	# altura
	jal desenhaImagem
	
	addi $21, $21, -2048
	addi $23, $23, 2

	# troca animacao (pra parecer que o link ta andando)
	sub $24, $19, $24
	bne $21, $22, subirEscada

	addi $22, $22, 28672  # (1024 x 28 pra descer um bloco e mais um pouquinho)
linkDescendo:
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	sw $21, 0($4) # origem
	sw $20, 4($4) # destino
	addi $5, $0, 16	# largura
	add $6, $0, $23	# altura
	jal salvaTela

	lui $4, 0x1001
	addi $4, $4, 807936
	sw $24, 0($4)
	sw $21, 4($4)
	addi $5, $0, 16
	add $6, $0, $23
	jal desenhaImagem
	
    	lui  $4, 0x1001
    	addi $4, $4, 807936 # inicio da memoria livre
    	addi $5, $0, 80000
    	jal  timerDelay
	
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $20, 0($4)
	sw $21, 4($4)
	addi $5, $0, 16
	add $6, $0, $23
	jal desenhaImagem
	
	addi $21, $21, 2048
	# troca animacao (pra parecer que o link ta andando)
	sub $24, $19, $24
	bne $21, $22, linkDescendo
	
# agora inicia virada pro lado
	lui $24, 0x1001
	addi $24, $24, 264192
	
	lui $19, 0x1001
	addi $19, $19, 265216
	add $19, $19, $24 # soma sprites
	
	addi $22, $22, 704
	
linkAndaAteParede:	
	# desenha ele de lado
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	sw $21, 0($4) # origem
	sw $20, 4($4) # destino
	addi $5, $0, 16	# largura
	add $6, $0, $23	# altura
	jal salvaTela

	lui $4, 0x1001
	addi $4, $4, 807936
	sw $24, 0($4)
	sw $21, 4($4)
	addi $5, $0, 16
	add $6, $0, $23
	jal desenhaImagem
	
    	lui  $4, 0x1001
    	addi $4, $4, 807936 # inicio da memoria livre
    	addi $5, $0, 50000
    	jal  timerDelay
	
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $20, 0($4)
	sw $21, 4($4)
	addi $5, $0, 16
	add $6, $0, $23
	jal desenhaImagem
	
	addi $21, $21, 12
	# troca animacao (pra parecer que o link ta andando)
	sub $24, $19, $24
	#bne $21, $22, linkAndaAteParede
	slt $18, $21, $22 # se posicao atual > borda, continua andando
	bne $18, $0, linkAndaAteParede

# carrega segundo cenario
	lui $4, 0x1001
	addi $4, $4, 807936
	lui $9, 0x1001
	addi $9, $9, 131072
	sw $9, 0($4) # origem
	lui $9, 0x1001
	sw $9, 4($4) # destino
	addi $5, $0, 256
	addi $6, $0, 128
	jal desenhaImagem

# prepara dados para o loopJogo
	# dados do link
	addi $21, $21, -960
	add $10, $0, $21 # posicao atual do link na tela
	lui $14, 0x1001
	addi $14, $14, 264192 # sprite do link
	lui $8, 0x1001
	add $8, $8, 270336 # sprite da espada
	addi $25, $10, 32
	addi $12, $0, 16 # guarda largura atual da espada
	
	# dados do NPC 1
	lui $15, 0x1001
	lui $18, 0x1001
	lui $19, 0x1001
	addi $15, $15, 65920 # posicao
	addi $16, $0, 1024 # passo vertical
	addi $17, $0, -12 # passo horizontal
	addi $18, $18, 273408 # sprite (npc 1)
	addi $19, $19, 672768 # buffer (proximo espaco livre depois do npc 2)

	# dados do NPC 2
	lui $20, 0x1001
	lui $23, 0x1001
	lui $24, 0x1001
	addi $20, $20, 66112 # posicao
	addi $21, $0, -1024 # passo vertical
	addi $22, $0, -12 # passo horizontal
	addi $23, $23, 274432 # sprite (npc 2)
	addi $24, $24, 673792 # buffer (depois do buffer anterior)

	# j desenhaNPCs. aqui to desenhando uma vez pq o loop inicia apagando
	# salva fundo e desenha NPC 1
	lui $4, 0x1001
	addi $4, $4, 807936	# $4 = memoria temporaria
	sw $15, 0($4)		# origem: onde esta o NPC 1
	sw $19, 4($4)		# destino: buffer
	addi $5, $0, 16		# largura
	addi $6, $0, 16	# altura
	jal salvaTela # salva o cenario no buffer
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $18, 0($4)
	sw $15, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem

	# salva fundo e desenha NPC 2
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	sw $20, 0($4) # origem
	sw $24, 4($4) # destino
	addi $5, $0, 16	# largura
	addi $6, $0, 16	# altura
	jal salvaTela
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $23, 0($4)
	sw $20, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem
	
# desenha o personagem no canto esquerdo
	# salva cenario espada
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	lui $5, 0x1001
	addi $5, $5, 674816
	sw $25, 0($4) # origem
	sw $5, 4($4) # destino
	addi $5, $0, 16	# largura
	addi $6, $0, 16	# altura
	jal salvaTela
	
	# desenha o link de lado
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	lui $5, 0x1001
	addi $5, $5, 671744
	sw $10, 0($4) # origem
	sw $5, 4($4) # destino
	addi $5, $0, 16	# largura
	addi $6, $0, 16	# altura
	jal salvaTela
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $14, 0($4)
	sw $10, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem

	# atraso
    	lui  $4, 0x1001
    	addi $4, $4, 807936 # inicio da memoria livre
    	addi $5, $0, 50000
    	jal timerDelay

loopJogo:
	# restaura cenario link
	lui $5, 0x1001
	addi $5, $5, 671744
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $5, 0($4)
	sw $10, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem
	
	# restaura cenario espada
	lui $5, 0x1001
	addi $5, $5, 674816
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $5, 0($4)
	sw $25, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem
	# restaura cenario do NPC 2 (ordem inversa. npc 2 primeiro e npc 1 depois)
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $24, 0($4)
	sw $20, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem

	lui $4, 0x1001
	addi $4, $4, 807936
	sw $19, 0($4)
	sw $15, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem

# atualiza link
	addi $7, $0, 'd'
	beq $9, $7, andaLinkPraDireita
	
	addi $7, $0, 'a'
	beq $9, $7, andaLinkPraEsquerda
	
	addi $7, $0, 's'
	beq $9, $7, andaLinkPraBaixo
	
	addi $7, $0, 'w'
	beq $9, $7, andaLinkPraCima
	
continuaAtualizacoes:
# atualiza NPC 1
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	add $5, $15, $0	# posicao atual
	add $6, $16, $0	# passo vertical
	add $7, $17, $0	# passo horizontal
	jal atualizaPosicaoNPC
	add $11, $2, $0 # nova posicao em $11

	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	add $5, $15, $0	# posicao atual
	add $6, $11, $0	# nova posicao
	add $7, $16, $0	# passo vertical atual
	jal atualizaPassoVertical
	add $16, $2, $0 # atualiza o passo

	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	add $5, $15, $0	# posicao atual
	add $6, $11, $0	# nova posicao
	add $7, $17, $0	# passo horizontal atual
	jal atualizaPassoHorizontal
	add $17, $2, $0 # atualiza o passo

	add $15, $11, $0 # atualiza posicao NPC1

# atualiza NPC 2
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	add $5, $20, $0	# posicao atual
	add $6, $21, $0	# passo vertical
	add $7, $22, $0	# passo horizontal
	jal atualizaPosicaoNPC
	add $11, $2, $0 # nova posicao em $11

	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	add $5, $20, $0	# posicao atual
	add $6, $11, $0	# nova posicao
	add $7, $21, $0	# passo vertical atual
	jal atualizaPassoVertical
	add $21, $2, $0

	lui $4, 0x1001
	addi $4, $4, 807936
	add $5, $20, $0	# posicao atual
	add $6, $11, $0	# nova posicao
	add $7, $22, $0	# passo horizontal atual
	jal atualizaPassoHorizontal
	add $22, $2, $0

	add $20, $11, $0 # atualiza posicao NPC2

	# troca animacao (pra ficar agachando)
	lui $13, 0x1001
	addi $13, $13, 273408
	addi $13, $13, 0x10010000
	addi $13, $13, 274432
	beq $18, $19, pulaAnimacaoNPC1
	sub $18, $13, $18
pulaAnimacaoNPC1:
	beq $23, $24, pulaAnimacaoNPC2
	sub $23, $13, $23
pulaAnimacaoNPC2:
	addi $13, $0, 0
#desenhaNPCs:
	# desenha NPC1
	beq $18, $19, desenhaONPC1 # $18 eh sprite do npc1; $19 eh o buffer. se forem iguais, significa que o npc1 morreu
	# desenha o link para procurar colisao
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	lui $5, 0x1001
	addi $5, $5, 671744
	sw $10, 0($4) # origem
	sw $5, 4($4) # destino
	addi $5, $0, 16	# largura
	addi $6, $0, 16	# altura
	jal salvaTela
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $14, 0($4)
	sw $10, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem

	lui $4, 0x1001
	addi $4, $4, 807936 # memoria temporaria
	li $5, 0x0080d010
	sw $5, 0($4) # cor alvo
	add $5, $15, $0	# endereco do bloco 16x16
	addi $6, $0, 16
	addi $7, $0, 16
	jal procuraCor
	bne $2, $0, mostraTelaGameOver
	
	lui $4, 0x1001
	addi $4, $4, 807936 # memoria temporaria
	li $5, 0x00c84c0c
	sw $5, 0($4) # cor alvo
	add $5, $15, $0	# endereco do bloco 16x16
	addi $6, $0, 16
	addi $7, $0, 16
	jal procuraCor
	bne $2, $0, mostraTelaGameOver
	
	lui $4, 0x1001
	addi $4, $4, 807936 # memoria temporaria
	li $5, 0x00fc9838
	sw $5, 0($4) # cor alvo
	add $5, $15, $0	# endereco do bloco 16x16
	addi $6, $0, 16
	addi $7, $0, 16
	jal procuraCor
	bne $2, $0, mostraTelaGameOver
	
	# restaura cenario link depois de procurar colisao
	lui $5, 0x1001
	addi $5, $5, 671744
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $5, 0($4)
	sw $10, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem
	
	# desenha espada para procurar colisao
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	lui $5, 0x1001
	addi $5, $5, 674816
	sw $25, 0($4) # origem
	sw $5, 4($4) # destino
	addi $5, $0, 16	# largura
	addi $6, $0, 16	# altura
	jal salvaTela
	addi $7, $0, 'j'
	bne $9, $7, desenhaONPC1
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $8, 0($4)
	sw $25, 4($4)
	add $5, $0, $12
	addi $6, $0, 16
	jal desenhaImagem
	
	lui $4, 0x1001
	addi $4, $4, 807936 # memoria temporaria
	li $5, 0x00fbfbfb
	sw $5, 0($4) # cor alvo
	add $5, $15, $0	# endereco do bloco 16x16
	addi $6, $0, 16
	addi $7, $0, 16
	jal procuraCor
	bne $2, $0, mataNPC1
	
	lui $4, 0x1001
	addi $4, $4, 807936 # memoria temporaria
	li $5, 0x000100a8
	sw $5, 0($4) # cor alvo
	add $5, $15, $0	# endereco do bloco 16x16
	addi $6, $0, 16
	addi $7, $0, 16
	jal procuraCor
	bne $2, $0, mataNPC1
	
	lui $4, 0x1001
	addi $4, $4, 807936 # memoria temporaria
	li $5, 0x005d94fb
	sw $5, 0($4) # cor alvo
	add $5, $15, $0	# endereco do bloco 16x16
	addi $6, $0, 16
	addi $7, $0, 16
	jal procuraCor
	bne $2, $0, mataNPC1
	
	# restaura cenario espada depois de procurar colisao
	lui $5, 0x1001
	addi $5, $5, 674816
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $5, 0($4)
	sw $25, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem
	
	j desenhaONPC1
	
mataNPC1:
	# restaura cenario espada depois de procurar colisao
	lui $5, 0x1001
	addi $5, $5, 674816
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $5, 0($4)
	sw $25, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem
	add $18, $0, $19
	add $13, $0, $15
desenhaONPC1:
	# salva fundo e desenha NPC 1
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	sw $15, 0($4) # origem
	sw $19, 4($4) # destino
	addi $5, $0, 16	# largura
	addi $6, $0, 16	# altura
	jal salvaTela
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $18, 0($4)
	sw $15, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem

# salva fundo e desenha NPC 2
	beq $23, $24, desenhaONPC2 # $18 eh sprite do npc2; $24 eh o buffer. se forem iguais, significa que o npc2 morreu
	# desenha o link pra buscar colisao entre link e npc 2
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	lui $5, 0x1001
	addi $5, $5, 671744
	sw $10, 0($4) # origem
	sw $5, 4($4) # destino
	addi $5, $0, 16	# largura
	addi $6, $0, 16	# altura
	jal salvaTela
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $14, 0($4)
	sw $10, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem

	# procura as cores do link
	lui $4, 0x1001
	addi $4, $4, 807936 # memoria temporaria
	li $5, 0x0080d010
	sw $5, 0($4) # cor alvo
	add $5, $20, $0	# endereco do bloco 16x16
	addi $6, $0, 16
	addi $7, $0, 16
	jal procuraCor
	bne $2, $0, mostraTelaGameOver
	
	lui $4, 0x1001
	addi $4, $4, 807936 # memoria temporaria
	li $5, 0x00c84c0c
	sw $5, 0($4) # cor alvo
	add $5, $20, $0	# endereco do bloco 16x16
	addi $6, $0, 16
	addi $7, $0, 16
	jal procuraCor
	bne $2, $0, mostraTelaGameOver
	
	lui $4, 0x1001
	addi $4, $4, 807936 # memoria temporaria
	li $5, 0x00fc9838
	sw $5, 0($4) # cor alvo
	add $5, $20, $0	# endereco do bloco 16x16
	addi $6, $0, 16
	addi $7, $0, 16
	jal procuraCor
	bne $2, $0, mostraTelaGameOver
	
	# restaura cenario link depois de procurar colisao
	lui $5, 0x1001
	addi $5, $5, 671744
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $5, 0($4)
	sw $10, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem
	
	# desenha espada para procurar colisao
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	lui $5, 0x1001
	addi $5, $5, 674816
	sw $25, 0($4) # origem
	sw $5, 4($4) # destino
	addi $5, $0, 16	# largura
	addi $6, $0, 16	# altura
	jal salvaTela
	addi $7, $0, 'j'
	bne $9, $7, desenhaONPC2
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $8, 0($4)
	sw $25, 4($4)
	add $5, $0, $12
	addi $6, $0, 16
	jal desenhaImagem
	
	lui $4, 0x1001
	addi $4, $4, 807936 # memoria temporaria
	li $5, 0x00fbfbfb
	sw $5, 0($4) # cor alvo
	add $5, $20, $0	# endereco do bloco 16x16
	addi $6, $0, 16
	addi $7, $0, 16
	jal procuraCor
	bne $2, $0, mataNPC2
	
	lui $4, 0x1001
	addi $4, $4, 807936 # memoria temporaria
	li $5, 0x000100a8
	sw $5, 0($4) # cor alvo
	add $5, $20, $0	# endereco do bloco 16x16
	addi $6, $0, 16
	addi $7, $0, 16
	jal procuraCor
	bne $2, $0, mataNPC2
	
	lui $4, 0x1001
	addi $4, $4, 807936 # memoria temporaria
	li $5, 0x005d94fb
	sw $5, 0($4) # cor alvo
	add $5, $20, $0	# endereco do bloco 16x16
	addi $6, $0, 16
	addi $7, $0, 16
	jal procuraCor
	bne $2, $0, mataNPC2
	
	# restaura cenario espada depois de procurar colisao
	lui $5, 0x1001
	addi $5, $5, 674816
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $5, 0($4)
	sw $25, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem
	
	j desenhaONPC2
	
mataNPC2:
	# restaura cenario espada depois de procurar colisao
	lui $5, 0x1001
	addi $5, $5, 674816
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $5, 0($4)
	sw $25, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem
	
	add $23, $0, $24 # o registrador que guarda o sprite do npc 2 ($23) vai guardar agora o buffer ($24)
	add $13, $0, $20 # o $13 vai guardar a posicao do npc 2. isso vai ser usado pra imprimir a explosao na posicao dele
	
desenhaONPC2:
	# desenha o npc 2 de fato
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	sw $20, 0($4) # origem
	sw $24, 4($4) # destino
	addi $5, $0, 16	# largura
	addi $6, $0, 16	# altura
	jal salvaTela
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $23, 0($4)
	sw $20, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem

# desenha link
	# desenha espada se apertou 'j'
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	lui $5, 0x1001
	addi $5, $5, 674816
	sw $25, 0($4) # origem
	sw $5, 4($4) # destino
	addi $5, $0, 16	# largura
	addi $6, $0, 16	# altura
	jal salvaTela
	addi $7, $0, 'j'
	bne $9, $7, desenhaOLink
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $8, 0($4)
	sw $25, 4($4)
	add $5, $0, $12
	addi $6, $0, 16
	jal desenhaImagem
desenhaOLink:
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	lui $5, 0x1001
	addi $5, $5, 671744
	sw $10, 0($4) # origem
	sw $5, 4($4) # destino
	addi $5, $0, 16	# largura
	addi $6, $0, 16	# altura
	jal salvaTela
	lui $4, 0x1001
	addi $4, $4, 807936
	sw $14, 0($4)
	sw $10, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem
	
	# atraso
	bne $13, $0, desenhaExplosao
    	lui  $4, 0x1001
    	addi $4, $4, 807936 # inicio da memoria livre
    	addi $5, $0, 50000
    	jal timerDelay
continuaPosDelay:
	bne $18, $19, verificaEntradaDoJogador
	bne $23, $24, verificaEntradaDoJogador
	j mostraTelaVitoria # se os registradores que guardam sprites dos npcs forem iguais do buffer, entao os dois npcs morreram
verificaEntradaDoJogador:
	# verifica entrada do jogador:
	li $4, 0xffff0000
	lw $9, 0($4)

	beq $9, $0, continuaJogo
	lw $9, 4($4)
	addi $7, $0, ' '
	beq $9, $7, pausaJogo
continuaJogo:

	j loopJogo
	
desenhaExplosao:
	# desenha explosao 1
	lui $4, 0x1001
	addi $4, $4, 807936 # $4 = memoria temporaria
	sw $13, 0($4) # origem
	lui $5, 0x1001
	addi $5, $5, 806912
	sw $5, 4($4) # destino
	addi $5, $0, 16	# largura
	addi $6, $0, 16	# altura
	jal salvaTela
	lui $4, 0x1001
	addi $4, $4, 807936
	lui $5, 0x1001
	addi $5, $5, 275456
	sw $5, 0($4)
	sw $13, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem
	
    	lui  $4, 0x1001
    	addi $4, $4, 807936 # inicio da memoria livre
    	addi $5, $0, 17500
    	jal timerDelay
	
	# explosao 2
	lui $4, 0x1001
	addi $4, $4, 807936
	lui $5, 0x1001
	addi $5, $5, 806912
	sw $5, 0($4)
	sw $13, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem
	lui $4, 0x1001
	addi $4, $4, 807936
	lui $5, 0x1001
	addi $5, $5, 276480
	sw $5, 0($4)
	sw $13, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem
	
    	lui  $4, 0x1001
    	addi $4, $4, 807936 # inicio da memoria livre
    	addi $5, $0, 15000
    	jal timerDelay
	
	# explosao 3
	lui $4, 0x1001
	addi $4, $4, 807936
	lui $5, 0x1001
	addi $5, $5, 806912
	sw $5, 0($4)
	sw $13, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem
	lui $4, 0x1001
	addi $4, $4, 807936
	lui $5, 0x1001
	addi $5, $5, 277504
	sw $5, 0($4)
	sw $13, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem
	
    	lui  $4, 0x1001
    	addi $4, $4, 807936 # inicio da memoria livre
    	addi $5, $0, 17500
    	jal timerDelay
	
	lui $4, 0x1001
	addi $4, $4, 807936
	lui $5, 0x1001
	addi $5, $5, 806912
	sw $5, 0($4)
	sw $13, 4($4)
	addi $5, $0, 16
	addi $6, $0, 16
	jal desenhaImagem
	j continuaPosDelay

mostraTelaVitoria:
	lui $4, 0x1001
	addi $4, $4, 807936
	lui $9, 0x1001
	addi $9, $9, 409600
	sw $9, 0($4)
	lui $9, 0x1001
	sw $9, 4($4)
	addi $5, $0, 256
	addi $6, $0, 128
	jal desenhaImagem
esperaSairDaVitoria:    	
    	# verifica entrada do jogador:
	li $4, 0xffff0000
	lw $9, 0($4)

	beq $9, $0, esperaSairDaVitoria
	lw $9, 4($4)
	addi $7, $0, ' '
	bne $9, $7, esperaSairDaVitoria
	j iniciaJogoNaTelaInicial

mostraTelaGameOver:
	lui $4, 0x1001
	addi $4, $4, 807936
	lui $9, 0x1001
	addi $9, $9, 540672
	sw $9, 0($4)
	lui $9, 0x1001
	sw $9, 4($4)
	addi $5, $0, 256
	addi $6, $0, 128
	jal desenhaImagem
esperaSairDoGameOver:    	
    	# verifica entrada do jogador:
	li $4, 0xffff0000
	lw $9, 0($4)

	beq $9, $0, esperaSairDoGameOver
	lw $9, 4($4)
	addi $7, $0, ' '
	bne $9, $7, esperaSairDoGameOver
	j iniciaJogoNaTelaInicial

andaLinkPraDireita:
	add $5, $10, $0		# posicao atual
	add $6, $0, $0		# deslocamento vertical
	addi $7, $0, 8		# deslocamento horizontal
    	lui  $4, 0x1001
    	addi $4, $4, 807936
	jal tentaMover
	add $10, $2, $0
	addi $25, $10, 32
	add $12, $0, 16 # a largura da espada aqui eh 16
	
	# muda sprite da espada
	lui $8, 0x1001
	addi $8, $8, 270336
	
	# muda sprite do link
	lui $4, 0x1001
	addi $4, $4, 264192
	bne $14, $4, andaLinkPraDireitaFim
	lui $4, 0x1001
	addi $4, $4, 265216
	
andaLinkPraDireitaFim:
	add $14, $0, $4
	j continuaAtualizacoes
	
andaLinkPraEsquerda:
	add $5, $10, $0		# posicao atual
	add $6, $0, $0		# deslocamento vertical
	addi $7, $0, -8		# deslocamento horizontal
    	lui  $4, 0x1001
    	addi $4, $4, 807936
	jal tentaMover
	add $10, $2, $0
	addi $25, $10, -32
	add $12, $0, 16 # a largura da espada aqui eh 16
	
	# muda sprite da espada
	lui $8, 0x1001
	addi $8, $8, 271360
	
	# muda sprite do link
	lui $4, 0x1001
	addi $4, $4, 266240
	bne $14, $4, andaLinkPraEsquerdaFim
	lui $4, 0x1001
	addi $4, $4, 267264
	
andaLinkPraEsquerdaFim:
	add $14, $0, $4
	j continuaAtualizacoes
	
andaLinkPraBaixo:
	add $5, $10, $0		# posicao atual
	addi $6, $0, 2048	# deslocamento vertical
	add $7, $0, $0		# deslocamento horizontal
    	lui  $4, 0x1001
    	addi $4, $4, 807936
	jal tentaMover
	add $10, $2, $0
	addi $25, $10, 8208
	add $12, $0, 8 # a largura da espada aqui eh 8
	
	# muda sprite da espada
	lui $8, 0x1001
	addi $8, $8, 272896
	
	# muda sprite do link
	lui $4, 0x1001
	addi $4, $4, 262144
	bne $14, $4, andaLinkPraBaixoFim
	lui $4, 0x1001
	addi $4, $4, 263168
andaLinkPraBaixoFim:
	add $14, $0, $4
	j continuaAtualizacoes

andaLinkPraCima:
	add $5, $10, $0		# posicao atual
	addi $6, $0, -2048	# deslocamento vertical
	add $7, $0, $0		# deslocamento horizontal
    	lui  $4, 0x1001
    	addi $4, $4, 807936
	jal tentaMover
	add $10, $2, $0
	addi $25, $10, -8176
	add $12, $0, 8 # a largura da espada aqui eh 8
	
	# muda sprite da espada
	lui $8, 0x1001
	addi $8, $8, 272384

	lui $4, 0x1001
	addi $4, $4, 268288
	bne $14, $4, andaLinkPraCimaFim
	lui $4, 0x1001
	addi $4, $4, 269312
andaLinkPraCimaFim:
	add $14, $0, $4
	j continuaAtualizacoes

pausaJogo:
# verifica entrada do jogador:
	li $4, 0xffff0000
	lw $5, 0($4)

	beq $5, $0, pulaLeitura
	lw $6, 4($4)
	addi $7, $0, ' '
	beq $6, $7, continuaJogo
pulaLeitura:

	# atraso
    	lui  $4, 0x1001
    	addi $4, $4, 807936 # inicio da memoria livre
    	addi $5, $0, 50000
    	jal  timerDelay

	j pausaJogo

fim:
	addi $2, $0, 10
	syscall

.include "functools.asm"