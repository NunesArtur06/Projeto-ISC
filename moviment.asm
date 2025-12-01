.data
.include "MapWithHud.data"
.include "PLAYER.data"
.include "blank.data"

positionX:
.word 152 ##posição X inicial

positionY: ##posição Y inicial
.word 96


.text
main:

backgroundloop: #printing the background
	li t1, 0xff000000 ##endereço do frame 0 da memoria vga
	li t2, 0xFF012C00 
	la t0, MapWithHud
	addi t0, t0,8

    loop: beq t1, t2, next

        lw t3,0(t0)		
	    sw t3,0(t1)		
	    addi t1,t1,4		
	    addi t0,t0,4
	    j loop

next:
# Polling do teclado e echo na tela
	li s0,0			# zera o contador
CONTA:  addi s0,s0,1		# incrementa o contador
#	jal KEY1		# le o teclado	blocking
	jal KEY2       		# le o teclado 	non-blocking
	j CONTA			# volta ao loop

### Espera o usuário pressionar uma tecla
KEY1: 	li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
LOOP: 	lw t0,0(t1)			# Le bit de Controle Teclado
   	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,LOOP		# não tem tecla pressionada então volta ao loop
   	lw t2,4(t1)			# le o valor da tecla
   	li t5, 0x031
   	beq t2, t5, playerender
   	li t5, 0x061
   	beq t2, t5, Xleft
	ret				# retorna

### Apenas verifica se há tecla pressionada
KEY2:	li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,FIM   	   	# Se não há tecla pressionada então vai para FIM
  	lw t2,4(t1)  			# le o valor da tecla tecla
	li t5, 0x031
   	beq t2, t5, playerender
   	
	li t5, 0x061 #a
   	beq t2, t5, Xleft
	
	li t5, 0x064 #d
	beq t2, t5, Xright

	li t5, 0x077 #w
	beq t2, t5, Yup

	li t5, 0x073 #s
	beq t2, t5, Ydown
FIM:	ret				# retorna




playerender: #rendering the player
	la a0, PLAYER
	lw a1, positionX
	lw a2, positionY

	jal renderobject
	
	j next
	
Xleft:            
        ## se for para esquerda
	lw a1, positionX
	lw a2, positionY
	la a0, blank
	
	jal renderobject
	
	addi a1, a1, -1
	la t0, positionX
	sw a1, 0(t0)
	lw a2, positionY
	la a0, PLAYER
	
	jal renderobject
	
	j next

Xright:
	lw a1, positionX
	lw a2, positionY
	la a0, blank
	
	jal renderobject
	
	addi a1, a1, +1
	la t0, positionX
	sw a1, 0(t0)
	lw a2, positionY
	la a0, PLAYER
	
	jal renderobject
	
	j next

Yup:
	lw a1, positionX
	lw a2, positionY
	la a0, blank
	
	jal renderobject
	
	addi a2, a2, -1
	la t0, positionY
	sw a2, 0(t0)
	lw a1, positionX
	la a0, PLAYER
	
	jal renderobject
	
	j next

Ydown:
	lw a1, positionX
	lw a2, positionY
	la a0, blank
	
	jal renderobject
	
	addi a2, a2, +1
	la t0, positionY
	sw a2, 0(t0)
	lw a1, positionX
	la a0, PLAYER
	
	jal renderobject
	
	j next


renderobject:

	lw s0, 0(a0)   ##largura 
	lw s1, 4(a0)	##altura

	mv s2, a0	#endereço da imagem para s2
	addi s2, s2, 8  ##s2 aponta para o inicio da imagem

	li s3, 0xff000000 ##coloca o endereço do bitmapdisplay em s3

	li t1, 320         ##offset
	mul t1, t1, a2
	add t1, t1, a1
	add s3, s3, t1

	li t1, 0

line:
	bge t1, s1, endR
	li t0, 0

column:
	bge t0,s0, endC

	lb t2,0(s2)
	sb t2, 0(s3)

	addi s2,s2, 1
	addi s3,s3, 1
	addi t0, t0, 1
	j column


endC:

	addi s3, s3, 320
	sub s3, s3, s0

	addi t1, t1, 1
	j line

endR: 
	ret
	
	
	
	
