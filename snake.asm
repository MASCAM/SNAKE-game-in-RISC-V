.eqv TAMANHO_INICIAL 3
.eqv POSICAO_INICIAL_X 120 	 
.eqv POSICAO_INICIAL_Y 120
.eqv delay_entre_frames 100 

.data
	teclado_anterior: .byte 100 
	str2: .string "SNAKE"
	str3: .string "GAME OVER"
	str4: .string "Pressione 0 para ir ao MENU"
	str5: .string "INICIALIZANDO JOGO..."
	
	
	menu1: .string "BEM VINDO AO SNAKE"
	menu2: .string "1 para comecar"
	menu3: .string "2 para fechar o programa"
	menu4: .string "0 volta para o MENU"
	
	
	Lfase: .string "FASE:"
	fase: .word 1 

	Lvida: .string "VIDAS:"
	vida: .word 3

	Lpontos: .string "PONTOS:"
	pontos: .word 0
	
	posicao_comida: .word 0
	
.text

############################################################################################ Registradores salvos - Nao mexer irresponsavelmente

	# s11 - Tamanho da cobra
	# s10 - Ultimo movimento
	# s8  - Contador de Comida 
	# s7  - delay entre frames
	# s6  - espera delay
	
############################################################################################ InicioMAIN
MAIN:
# Essas tres linhas sao necessarias para funcionar o MMIO
	la t0, exceptionHandling 
	csrw t0, utvec            
	csrwi ustatus, 1
#Limpa a tela	
	li a7, 148
	li a1, 0
	li a0, 0x0
	ecall
	
# Borda superior
	li a7, 147
	li a0, 15
	li a1, 15
	li a2, 305
	li a3, 15
	li a4, 0x0038
	li a5, 0
	ecall
# Borda esquerda	
	li a7, 147
	li a0, 15
	li a1, 15
	li a2, 15
	li a3, 224
	li a4, 0x0038
	li a5, 0
	ecall
# Borda inferior
	li a7, 147
	li a0, 15
	li a1, 224
	li a2, 305
	li a3, 224
	li a4, 0x0038
	li a5, 0
	ecall
# Borda direita
	li a7, 147
	li a0, 304
	li a1, 15
	li a2, 304
	li a3, 224
	li a4, 0x0038
	li a5, 0
	ecall
#Mostra inicializando...	
	li a7,104 
	la a0,str5				# INICIALIZANDO
	li a1,80				# x
	li a2,100				# y
	li a3, 0x0038				# cor do fundo e cor da letra (fundo preto letra verde)
	li a4,0
	ecall

# Musica inical
	li a0,50		# define a nota
	li a1,1000		# define a dura��o da nota em ms
	li a2,1			# define o instrumento
	li a3,127		# define o volume
	li a7,33		# define o syscall
	ecall
	
	li a0,55		# define a nota
	li a1,1000		# define a dura��o da nota em ms
	li a2,1			# define o instrumento
	li a3,127		# define o volume
	li a7,33		# define o syscall
	ecall
	
	li a0,50		# define a nota
	li a1,1000		# define a dura��o da nota em ms
	li a2,1			# define o instrumento
	li a3,127		# define o volume
	li a7,33		# define o syscall
	ecall
	
	li a0,45		# define a nota
	li a1,1500		# define a dura��o da nota em ms
	li a2,1			# define o instrumento
	li a3,127		# define o volume
	li a7,33		# define o syscall
	ecall	

# Pula para o menu principal
	j MENU_PRINCIPAL           


############################################################################################ InicioDISPLAY
# Preenche a tela de preto e desenha linhas
DISPLAY:
# Limpa a tela
	li a7, 48
	li a0, 0
	li a1, 0
	ecall
# Borda superior
	li a7, 147
	li a0, 15
	li a1, 15
	li a2, 305
	li a3, 15
	li a4, 0x0038
	li a5, 0
	ecall
# Borda esquerda	
	li a7, 147
	li a0, 15
	li a1, 15
	li a2, 15
	li a3, 224
	li a4, 0x0038
	li a5, 0
	ecall
# Borda inferior
	li a7, 147
	li a0, 15
	li a1, 224
	li a2, 305
	li a3, 224
	li a4, 0x0038
	li a5, 0
	ecall
# Borda direita
	li a7, 147
	li a0, 304
	li a1, 15
	li a2, 304
	li a3, 224
	li a4, 0x0038
	li a5, 0
	ecall
	
#MOSTRA OS DADOS EM BAIXO DA TELA

#mostra pontuação
	li a7,104 
	la a0,Lpontos				# PONTOS:
	li a1,15				# x
	li a2,230				# y
	li a3, 0x0038				# cor do fundo e cor da letra (fundo preto letra verde)
	li a4,0
	ecall
	
	li a7,101 
	la a0,pontos				# quantidade de pontos
	lw a0,0(a0)
	li a1,75				# x
	li a2,230				# y
	li a3, 0x0038				# cor do fundo e cor da letra (fundo preto letra verde)
	li a4,0
	ecall



#mostra fase
	li a7,104 
	la a0,Lfase				# FASE:
	li a1,235				# x
	li a2,230				# y
	li a3, 0x0038				# cor do fundo e cor da letra (fundo preto letra verde)
	li a4,0
	ecall
	
	li a7,101 
	la a0,fase
	lw a0,0(a0)
	li a1,280				# x
	li a2,230				# y
	li a3, 0x0038				# cor do fundo e cor da letra (fundo preto letra verde)
	li a4,0
	ecall

#mostra vida

	li a7,104 
	la a0,Lvida				# VIDAS:
	li a1,130				# x
	li a2,230				# y
	li a3, 0x0038				# cor do fundo e cor da letra (fundo preto letra verde)
	li a4,0
	ecall
	
	li a7,101 
	la a0,vida				# quantidade de vidas
	lw a0,0(a0)
	li a1,185				# x
	li a2,230				# y
	li a3, 0x0038				# cor do fundo e cor da letra (fundo preto letra verde)
	li a4,0
	ecall
# salva nos .data os vetores necessarios

	la t0, vida				# coloca o endereco de vida em t0
	lw t1, 0(t0)				# coloca a quantidade de vidas em t1
	li t0, 3				# t0 = 3
			
	beqz t1, morreu_lixo			#se vidas < 0 vai para morreu_lixo
	
	li t3, 48
	beq t2, t3, retorna_menu		#ultima tecla pressionada
	blt t1, t0, MOV				#se 0 < vidas < 3 vai para MOV
	
retorna_menu:	 
	 	 
	ret					#senao retorna 

############################################################################################ InicioIMPRIME_SNAKE
IMPRIME_SNAKE:
	jal DISPLAY
	li a7, 104
    	la a0, str2
   	li a1, 14
 	li a2, 10
  	li a3, 0xFF
   	li a4, 0
   	ecall
	j MOV

############################################################################################ InicioMORREU_LIXO
MORREU_LIXO:
	jal DISPLAY
morreu_lixo:
	li a0, 40			# define a nota
	li a1,1000		# define a dura��o da nota em ms
	li a2,1			# define o instrumento
	li a3,127		# define o volume
	li a7,33		# define o syscall
	ecall
	
	li a0, 30			# define a nota
	li a1,2000		# define a dura��o da nota em ms
	li a2,1			# define o instrumento
	li a3,127		# define o volume
	li a7,33		# define o syscall
	ecall

	li a7, 104
    	la a0, str3
   	li a1, 125
 	li a2, 80
  	li a3, 0x0038
   	li a4, 0
   	ecall
   	
   	la a0, str4
   	li a1, 45
 	li a2, 130
  	li a3, 0x0038
   	li a4, 0
   	ecall
   	
 morreu_lixo_loop:
	li t1,0xFF200000			# carrega o endere�o de controle do KDMMIO
	lw t0,0(t1)				# Le bit de Controle Teclado
	andi t0,t0,0x0001			# mascara o bit menos significativo
   	beq t0,zero, morreu_lixo_loop   	# Se nao ha tecla pressionada entao vai para FIM
  	lw t2,4(t1)  
   	
   	li t0,48 				# t0 = 0 -> sai
	beq  t2,t0, menu_escreve
   	j morreu_lixo_loop
   	
############################################################################################ InicioBATEU
# Atualiza os atributos quando a cobra bate na parede, ou se auto come	
BATEU:
	li a0,30		# define a nota
	li a1,1200		# define a dura��o da nota em ms
	li a2,1			# define o instrumento
	li a3,127		# define o volume
	li a7,33		# define o syscall
	ecall

	la t2, vida			#coloca o endereco de vida em t2
	lw t6, 0(t2)			#coloca do valor de t2 em t6
	addi t6, t6, -1			#diminui uma vida
	sw t6, 0(t2)			#salva a nova vida
	la t0, teclado_anterior
	li t6, 100
	sb t6, 0(t0)
	li s7, delay_entre_frames
	la a7, fase
	li a6, 1
	sw a6, 0(a7)
	j MOSTRA_VIDAS			#mostra o valor atualizado das vidas

morreu:
	la t2, vida
	lw t6, 0(t2)
	beqz t6, MORREU_LIXO		#se as vidas forem zero vai para MORREU_LIXO
	j DISPLAY			#senao vai para MOV 

############################################################################################ InicioGERA_COMIDA
#gera lugar aleatorio da comida e mostra comida
GERA_COMIDA:

# Faz barulho quando come
	li a7, 31
	li a0, 70			# Nota
	li a1, 150			# Duracao
	li a2, 80			# Instrumeto
	li a3, 127			# Volume
	ecall	

# Gera posicao x valida
	li a7, 41		
	li a0, 0			# Gera X como um valor de 2 a 27
	ecall
	li a1, 36	
	remu a0, a0, a1
	addi a0, a0, 2
	slli t0, a0, 3			# Multiplica por 8, x entre 16 e 216 
		
	
	# Salva posicao X da comida
	la t2, posicao_comida
	sw t0, 0(t2)
		
	li a0, 0
	ecall				# Gera aleatorio		
	li a1, 24 			# Gera y como um valor de 2 a 37
	remu a0, a0, a1
	addi a0, a0, 2			
	slli t1, a0, 3			# Multiplica por 8, y entre 16 e 296
		
	sw t1, 4(t2)			# Salva posicao y da comida
	
############################################################################################ InicioVERIFICA_COMIDA_COBRA
# Se a cobra bateu nela mesma, perde vida
VERIFICA_COMIDA_COBRA:
# Nao usar t5 -> Para nao perder ra

	mv t3, t0 			#x
	mv t4, t1			#y
	
# Inicializa contador com tamanho da cobra	
	addi t0, s11, 0			# Inicializa um contador com o tamanho da cobra
	addi t1, sp, 0			# t1 = Topo da pilha
	
	
# Esse loop percorrera todas as posicoes da cobra
percorre_cobra:	     	
   	lh a1, 0(t1)			# Pega x
 	lh a2, 2(t1)			# Pega y
 	
# Subtrai a posicao da comida da posicao da cobra no loop 	
 	sub a1, t3, a1			
 	sub a2, t4, a2
 				
# Se a1 e a2 forem iguais a zero, GERA_COMIDA
	beqz a1, comida_aux	
 	j pula_comida
comida_aux:
	beqz a2, GERA_COMIDA
	
pula_comida:	   	
   	addi t1, t1, 4			# Atualiza percorredor das posicoes da cobra
   	addi t0, t0, -1			# Atualiza contador
   	bnez t0, percorre_cobra
	
	
############################################################################################ InicioMOSTRA_COMIDA		
MOSTRA_COMIDA:

	li a7,111 			#print string
	li a0,111			#a comida e um "o"
	addi a1,t3, 0			#x
	addi a2,t4, 0			#y
	li a3, 0x0037			#cor do fundo e cor da letra (fundo preto letra amarela)
	li a4,0				#frame
	ecall
	ret
	
############################################################################################ InicioMOSTRA_PONTOS
#atualiza a quantudade de pontos do jogador	
MOSTRA_PONTOS:
	li a7,101 
	la a0,pontos				#quantidade de pontos
	lw a0,0(a0)
	li a1,75				#x
	li a2,230				#y
	li a3, 0x0038				#cor do fundo e cor da letra (fundo preto letra verde)
	li a4,0
	ecall
	ret
	
############################################################################################ InicioMOSTRA_VIDAS
#atualiza as vidas do jogador 
MOSTRA_VIDAS:
	li a7,101 
	la a0,vida				#quantidade de vidas
	lw a0,0(a0)
	li a1,185				#x
	li a2,230				#y
	li a3, 0x0038				#cor do fundo e cor da letra (fundo preto letra verde)
	li a4,0
	ecall
	j morreu
	
############################################################################################ InicioMOSTRA_FASE
#atualiza a fase do jogador
MOSTRA_FASE:
	li a7,101 
	la a0,fase
	lw a0,0(a0)
	li a1,280				#x
	li a2,230				#y
	li a3, 0x0038				#cor do fundo e cor da letra (fundo preto letra verde)
	li a4,0
	ecall
	j volta_come

############################################################################################ InicioVERIFICA_COMEU
# Cobra aumentando o tamanho ao comer uma comida
VERIFICA_COMEU:
	mv t5, ra 			# Salva retorno para funcao invocadora
	
	la t0, posicao_comida
	lw t1, 4(t0)			# t1 = y da comida
	lw t0, 0(t0)  			# t0 = x da comida
	
	sub t0, t3, t0			# posicao cabeça cobra x - posicao da comida x
	sub t1, t4, t1			# posicao cabeça cobra y - posicao da comida y

	
	beqz t0, AUX		
	ret				# Retorna e apaga o último elemento
		
AUX:	beqz t1, COME
	ret				# Retorna e apaga o último elemento 
	
COME:	
	addi s11, s11, 1		# Aumenta tamanho em 1
	
	
	addi s8, s8, 1	
	li t0, 5			# faz t0 = 5
	remu t0, s8, t0			# se o numero de comidas for divisivel por 5, aumentar a velocidade 
	beqz t0, aumenta_velocidade
		
volta_come:	
	
	jal GERA_COMIDA
	
	la t0, pontos			#coloca o endereço de pontos em t0
	lw t1, 0(t0)			#coloca a palavra de t0 em t1
	addi t1, t1, 10			#pontos = pontos + 10
	sw t1, 0(t0)			#coloca o novo valor em pontos
	jal MOSTRA_PONTOS		#mostra pontos
	
	mv ra, t5			# Recupera retorno para funcao invocadora
	addi ra, ra, 4			# Incrementa ra para pular a funcao de apagar uma vez
	ret 				# Retorna pulando a função de apagar o último termo 

aumenta_velocidade:
	addi s7, s7, -10
	
	la t0, fase			#coloca o endere�o de pontos em t0
	lw t1, 0(t0)			#coloca a palavra de t0 em t1
	addi t1, t1, 1			#pontos = pontos + 10
	sw t1, 0(t0)			#coloca o novo valor em pontos
	j MOSTRA_FASE			#mostra pontos


############################################################################################ InicioMOV
# Esta parte do procedimento sera executado apenas uma vez, quando movimento for chamado
MOV:
# Carrega posicao inicial padrao e tamanho inical da snake

	li s10, 101			# Inicializa o valor anterior do teclado
	li s11, TAMANHO_INICIAL
	li s8, 0

	slli t0, s11, 2			# Tamanho da pilha para que caiba a cobra
	sub t0, zero, t0		# inverte o sinal de t0
	add sp, sp, t0			# Cria espaco na pilha 	para 6 elementos		 
	
	jal GERA_COMIDA
	
	li t3, POSICAO_INICIAL_X
	li t4, POSICAO_INICIAL_Y

# Salva posicoes iniciais da cobra
# Cabeca
	sh t3, 0(sp)
	sh t4, 2(sp)
	addi t3, t3, -8
# Meio
	sh t3, 4(sp)
	sh t4, 6(sp)
	addi t3, t3, -8
# Cauda	
	sh t3, 8(sp)
	sh t4, 10(sp)

############################################################################################ InicioMOVIMENTO
MOVIMENTO:
# Mata cobra caso esta bata nas paredes
	li t5, 297			# Limite da direita 
	bge t3, t5, BATEU   	
	
	li t5, 15			# Limite da esquerda 
	blt t3, t5, BATEU   	
	
	li t5, 217			# Limite de baixo
	bge t4, t5, BATEU   		
	
	li t5, 15			# Limite de cima
	blt t4, t5, BATEU
	
# Mata cobra se ela se comer 
	mv t5, ra 			# Salva ra
	jal VERIFICA_AUTO_COMEU	
	mv ra, t5 			# recupera ra	

# Inicializa contador com tamanho da cobra	
	addi t0, s11, 0			# Inicializa um contador com o tamanho da cobra
	addi t1, sp, 0			# t1 = Topo da pilha

# Imprime cabeca da cobra 	
	li a7, 111
  	li a3, 0xffffffff
   	li a4, 0
imprime_snake:	 
	li a0, 111	   	
   	lh a1, 0(t1)			# Pega x
 	lh a2, 2(t1)			# Pega y
	
   	ecall
   	
loop:
# Pausa por 1 segundo
	li a7, 30
	ecall
	mv a7, a0
	blt a7, s6, loop
	add s6, a7, s7

# Pegar dado do teclado e armazenar em t2
	li t1,0xFF200000		# carrega o endereco de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo


# Se nao ha tecla pressionada, realiza estado anterior		
   	beq t0,zero, estado_anterior	# Se nao ha tecla pressionada entao volta para o loop
  	
  	lh t2,4(t1)			# Armazena proxima tecla em t2
  	mv s10, t2
  	
volta_anterior:
	   	  	
# Tratamento para cada tecla pressionada
  	li t0,48 			# t0 = 0 -> sai
	beq  t2,t0, MENU_PRINCIPAL
	
	la t0, teclado_anterior 	#pega a ultima tecla direcional pressionada
	lb t6, 0(t0)
	
testa_esquerda:	
	li t0, 100			
	beq t6, t0, testa_direita	# se tava indo pra direita nem compara
	li t0, 97			# t0 = a
	beq t2,t0, esquerda

testa_direita:
	li t0, 97
	beq t6, t0, testa_baixo		#se tava indo pra esquerda nem compara
	li t0,100 			# t0 = d
	beq  t2,t0, direita
	
testa_baixo:
	li t0, 119
	beq t6, t0, testa_cima		#se tava indo pra cima nem compara
	li t0,115 			# t0 = s
	beq  t2,t0, baixo

testa_cima:
	li t0, 115
	beq t6, t0, INVALIDO		#se tava indo pra baixo nem compara
	li t0,119 			# t0 = w
	beq  t2,t0, cima
	
INVALIDO:	
	mv t2, t6
	li t0, 100
	beq t6, t0, direita
	li t0, 97
	beq t6, t0, esquerda
	li t0, 119
	beq t6, t0, cima
	li t0, 115
	beq t6, t0, baixo
 		
esquerda:
	la t0, teclado_anterior
	sb t2, 0(t0)
	jal VERIFICA_COMEU
	jal APAGA_ULTIMO
# Pega primeira posicao em x
	lh t3,0(sp)
	lh t4,2(sp)
	addi t3, t3, -8
	addi sp, sp, -4	
	sh t3,0(sp)
	sh t4,2(sp)
	j MOVIMENTO
			
direita:
	la t0, teclado_anterior
	sb t2, 0(t0)
	jal VERIFICA_COMEU
	jal APAGA_ULTIMO
# Pega primeira posicao em x	
	lh t3,0(sp)
	lh t4,2(sp)
	addi t3, t3, 8
	addi sp, sp, -4	
	sh t3,0(sp)
	sh t4,2(sp)
	j MOVIMENTO
	
cima:
	la t0, teclado_anterior
	sb t2, 0(t0)
	jal VERIFICA_COMEU
	jal APAGA_ULTIMO
# Pega primeira posicao em y	
	lh t3,0(sp)
	lh t4,2(sp)
	addi t4, t4, -8
	addi sp, sp, -4	
	sh t3,0(sp)
	sh t4,2(sp)
	j MOVIMENTO
	
baixo:
	la t0, teclado_anterior
	sb t2, 0(t0)
	jal VERIFICA_COMEU
	jal APAGA_ULTIMO
# Pega primeira posicao em y	
	lh t3,0(sp)
	lh t4,2(sp)
	addi t4, t4, 8
	addi sp, sp, -4	
	sh t3,0(sp)
	sh t4,2(sp)
	j MOVIMENTO
	
# Coloca o movimento anterior em t2
estado_anterior:
	mv t2, s10
	j volta_anterior
		
############################################################################################ InicioVERIFICA_AUTO_COMEU
# Se a cobra bateu nela mesma, perde vida
VERIFICA_AUTO_COMEU:
# Nao usar t5 -> Para nao perder ra
	lh t3, 0(sp) 
	lh t4, 2(sp)
	
# Inicializa contador com tamanho da cobra	
	addi t0, s11, -1		# Inicializa um contador com o tamanho da cobra
	addi t1, sp, 0			# t1 = Topo da pilha
	addi t1, t1, 4	 		# Pula a cabeca da cobra
	
# Esse loop percorrera todas as posicoes da cobra
percorre_snake:	     	
   	lh a1, 0(t1)			# Pega x
 	lh a2, 2(t1)			# Pega y
 	
# Subtrai a posicao da cabeca da posicao da cobra no loop 	
 	sub a1, t3, a1			
 	sub a2, t4, a2
 				
# Se a1 e a2 forem iguais a zero, BATEU
	beqz a1, auto_aux	
 	j pula_auto
auto_aux:
	beqz a2, BATEU
pula_auto:
   	addi t1, t1, 4			# Atualiza percorredor das posicoes da cobra
   	addi t0, t0, -1			# Atualiza contador
   	bnez t0, percorre_snake
	
	ret

############################################################################################ InicioAPAGA_ULTIMO
APAGA_ULTIMO:
	
	addi t0, s11, -1		# Tamanho - 1 -> Usaremos para acessar o ultimo elemento
	slli t0, t0, 2			# Obtendo o quando o percorredor pulará na pilha para chegar ao ultimo elemento
	add  t0, t0, sp 		# t0 e o endereco inicial do ultimo elemento
	
	lh t3, 0(t0)			# Acessa o elemento de x
	lh t4, 2(t0)  			# Acessa o elemento de y
	
	li a7, 111
    	li a0, 111   	
   	mv a1, t3
 	mv a2, t4
  	li a3, 0x0
   	li a4, 0
   	ecall
   	ret
   	
############################################################################################ InicioMenuPrincipal

MENU_PRINCIPAL:

	jal DISPLAY

menu_escreve:
# Limpa a tela
	li a7, 48
	li a0, 0
	li a1, 0
	ecall
	li a7, 104
    la a0, menu1
   	li a1, 90
 	li a2, 80
  	li a3, 0x0038
   	li a4, 0
   	ecall
   	
   	la a0, menu2
   	li a1, 30
 	li a2, 130
  	li a3, 0x0038
   	li a4, 0
   	ecall
   	
   	la a0, menu3
   	li a1, 30
 	li a2, 150
  	li a3, 0x0038
   	li a4, 0
   	ecall
   	
   	la a0, menu4
   	li a1, 30
 	li a2, 170
  	li a3, 0x0038
   	li a4, 0
   	ecall


menu_principal:	

	li t1,0xFF200000		# carrega o endere�o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,menu_principal   	# Se nao ha tecla pressionada entao vai para FIM
  	lw t2,4(t1)  			# le o valor da tecla tecla
	#sw t2,12(t1)  			# escreve a tecla pressionada no display
	
	
	la t3, pontos			#volta para a quantidade de pontos inicial (0)
	li t4, 0
	sw t4, 0(t3)
	
	la t3, vida			#volta para a quantidade de vidas inicial (3)
	li t4, 3
	sw t4, 0(t3)
	
	la t3, fase			#volta para fase inicial (1)
	li t4, 1
	sw t4, 0(t3)
	
	li t0,49 			# t0 = 1
	li s7, delay_entre_frames
	li a7, 30
	ecall
	mv s6, a0
	add s6, s6, s7
	beq  t2, t0, IMPRIME_SNAKE
	
	li t0,50 			# t0 = 2
	beq  t2,t0,FINAL
	
	j menu_principal

############################################################################################ FimMenuPrincipal

		
############################################################################################ InicioFINAL
FINAL:
	# Limpa a tela
	li a7, 48			
	li a0, 0
	li a1, 0
	ecall
	
	# ecall de saida
	li a7, 10
    	ecall
	j MAIN
# Inclui funcoes do Lamar
.include "SYSTEMv17b.s"
