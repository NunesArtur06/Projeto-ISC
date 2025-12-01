.data
# Número de notas na música
TAMANHO_MUSICA: .word 84

# Notas (representadas por números) e duração em ms
NOTAS_MUSICA:
NOTAS: 
        .word 60,300    # C
        .word 64,300    # E
        .word 67,400    # G
        .word 72,400    # C
        .word 71,300    # B
        .word 69,300    # A
        .word 67,400    # G
        .word 64,400    # E
        .word 62,300    # D
        .word 64,300    # E
        .word 67,450    # G
        .word 71,450    # B
        .word 72,500    # C
        .word 74,300    # D
        .word 72,300    # C
        .word 67,400    # G
        .word 64,300    # E
        .word 62,300    # D
        .word 60,400    # C
        .word 62,400    # D
        .word 64,300    # E
        .word 67,300    # G
        .word 71,400    # B
        .word 74,400    # D
        .word 76,300    # E
        .word 74,300    # D
        .word 72,400    # C
        .word 69,400    # A
        .word 67,300    # G
        .word 64,300    # E
        .word 62,400    # D
        .word 60,400    # C
        .word 64,300    # E
        .word 67,300    # G
        .word 71,400    # B
        .word 72,300    # C
        .word 74,300    # D
        .word 72,400    # C
        .word 69,300    # A
        .word 67,300    # G
        .word 64,400    # E
        .word 62,400    # D
        .word 60,300    # C
        .word 64,300    # E
        .word 67,400    # G
        .word 71,400    # B
        .word 72,300    # C
        .word 74,300    # D
        .word 76,400    # E
        .word 72,400    # C
        .word 74,300    # D
        .word 72,300    # C
        .word 69,400    # A
        .word 67,400    # G
        .word 64,300    # E
        .word 62,300    # D
        .word 60,500    # C
        .word 67,450    # G
        .word 69,450    # A
        .word 74,500    # D
        .word 72,500    # C
        .word 67,450    # G
        .word 62,300    # D
        .word 64,300    # E
        .word 65,450    # F
        .word 67,450    # G
        .word 72,500    # C
        .word 69,450    # A
        .word 71,450    # B
        .word 74,500    # D
        .word 72,450    # C
        .word 71,450    # B
        .word 69,450    # A
        .word 67,500    # G
        .word 64,450    # E
        .word 65,450    # F
        .word 67,600    # G
        .word 72,600    # C

.text

        la a4,TAMANHO_MUSICA       # define o endereço do número de notas
        lw a5,0(a4)                # lê o número de notas
        la a4,NOTAS_MUSICA         # define o endereço das notas
        li t0,0                    # zera o contador de notas
        li a2,99                   # define o instrumento
        li a3,127                  # define o volume

VERIF:    
        li t1,0xFF200000
        lw t0,0(t1)
        andi t0,t0,0x0001
        beq t0,zero,LOOP
        lw t2,4(t1)

RESET:     
        la a4,TAMANHO_MUSICA       # define o endereço do número de notas
        lw a5,0(a4)                # lê o número de notas
        la a4,NOTAS_MUSICA         # define o endereço das notas
        li t0,0                    # zera o contador de notas
        li a2,99                   # define o instrumento
        li a3,127                  # define o volume
        li a6, 0
        j VERIF

LOOP:       
        beq a6,a5,RESET            # contador chegou no final? então volte para o início da música
        lw a0,0(a4)                # lê o valor da nota
        lw a1,4(a4)                # lê a duração da nota
        li a7,31                   # define a chamada de syscall
        ecall                      # toca a nota
        mv a0,a1                   # passa a duração da nota para a pausa
        li a7,32                   # define a chamada de syscall 
        ecall                      # realiza uma pausa de a0 ms
        addi a4,a4,8               # incrementa para o endereço da próxima nota
        addi a6,a6,1               # incrementa o contador de notas
        j VERIF                    # volta ao loop
