##Universidade de Brasilia
##Carina Romanzeira 241020830
##Artur Nunes de Souza 241002485
##Ana Luiza Gomes de Oliveira 241020821

.data
.include "MapWithHud.data"
.include "PLAYER.data"
.include "blank.data"
.include "ReferenceBackground.data"
.include "BlueWizard.data"
.include "RedWizard.data"
.include "YellowWizard.data"
.include "GreenWizard.data"

# Número de notas na música
TAMANHO_MUSICA: .word 33

# Notas (representadas por números) e duração em ms
NOTAS_MUSICA:
NOTAS: 
        .word 60,400    # C
        .word 64,400    # E
        .word 67,400    # G
        .word 64,400    # E
        .word 60,400    # C
        .word 64,400    # E
        .word 67,400    # G
        .word 64,400    # E
        .word 57,400    # A
        .word 60,400    # C
        .word 64,400    # E
        .word 60,400    # C
        .word 57,400    # A
        .word 60,400    # C
        .word 64,400    # E
        .word 60,400    # C
        .word 55,400    # G
        .word 59,400    # B
        .word 62,400    # D
        .word 59,400    # B
	.word 55,400    # G
        .word 59,400    # B
        .word 62,400    # D
        .word 59,400    # B 
        .word 55,400    # G
        .word 55,400    # G
        .word 55,400    # G
        .word 55,400    # G
        .word 55,1200    # G
        .word 59,400    # B
        .word 62,400    # D
        .word 59,400    # B
        .word 60,1600    # C
  

playerdirectionX:
.word -1
playerdirectionY:
.word 0
positionX:
.word 152 ##initial X position

positionY: ##initial Y position
.word 96

nextpositionX:
.word 152

nextpositionY:
.word 96

positionREDX:
.word 112 ##initial X position

positionREDY: ##initial Y position
.word 48



positionBLUEX:
.word 176 ##initial X position

positionBLUEY: ##initial Y position
.word 16



positionGREENX:
.word 152 ##initial X position

positionGREENY: ##initial Y position
.word 16



positionYELLOWX:
.word 128 ##initial X position

positionYELLOWY: ##initial Y position
.word 16


.text

main:

backgroundloop: #printing the background
	li t1, 0xff000000 ##Loads the adress of the VGA memory
	li t2, 0xFF012C00 ##Loads the "last pixel"
	la t0, MapWithHud ##Loads the adresss of the Map
	addi t0, t0,8 ##By adding 8, the pointer goes to the first pixel of the image

    loop: beq t1, t2, music ##when the pointer reaches the last pixel, the loop ends

        lw t3,0(t0)		##adding 4 in order to print the rest of the pixels
	    sw t3,0(t1)		
	    addi t1,t1,4		
	    addi t0,t0,4
	    j loop
	    
music:

    la a4,TAMANHO_MUSICA       # define the address of the number of notes
    lw a5,0(a4)                # reads the number of notes
    la a4,NOTAS_MUSICA         # defines the address of the notes
    li t0,0                    # resets the note counter
    li a2,99                   # sets the instrument
    li a3,127                  # sets the volume
    li a6,0                    # resets the played notes counter

VERIF:    
    li t1,0xFF200000           # hardware address to check if it can play
    lw t0,0(t1)                # reads the state
    andi t0,t0,0x0001          # checks if the correct bit is activated
    beq t0,zero,LOOP           # if not ready, waits
    lw t2,4(t1)                # reads another hardware value (if needed)

LOOP:       
    beq a6,a5,playerinput      # counter reached the end? then finish execution
    lw a0,0(a4)                # reads the note value
    lw a1,4(a4)                # reads the note duration
    li a7,31                   # sets the syscall for playing the note
    ecall                      # plays the note
    mv a0,a1                   # passes the note duration to the pause
    li a7,32                   # sets the syscall for the pause
    ecall                      # pauses for a0 ms
    addi a4,a4,8               # increments the address to the next note
    addi a6,a6,1               # increments the played notes counter
    j VERIF                    # returns to the loop to play the next note
	    

playerinput:
# Keyboard polling
	li s0,0			
COUNT:  addi s0,s0,1		
 
	jal KEYBOARD       		
	j COUNT			


### This function checks if a key was pressed or not
KEYBOARD:	
	li t1,0xFF200000		## loads KDMMIO adress
	lw t0,0(t1)				## Reads the bit sent by it
	andi t0,t0,0x0001	    

   	beq t0,zero,END   	   	## if there was nothing pressed goes to the end
  	lw t2,4(t1)  			## reads the value of the pressed key
	
	li t5, 0x031            ##Compares the pressed key with the game commands
   	beq t2, t5, start		##starts with 1
   	

	li t5, 0x061 #a			##Goes left if a
   	beq t2, t5, Xleft
	
	li t5, 0x064 #d			##Goes right if d
	beq t2, t5, Xright

	li t5, 0x077 #w
	beq t2, t5, Yup			##Goes up if w

	li t5, 0x073 #s			##Goes down if s
	beq t2, t5, Ydown
END:	ret					##returns

start:
##This part of the code loads the adress and sends it to the render function in order to render the enemies and the player
RedWizardrender:
	la a0, RedWizard
	lw a1, positionREDX           ##X
	lw a2, positionREDY			  ##Y

	jal renderobject

BlueWizardrender:
	la a0, BlueWizard
	lw a1, positionBLUEX          ##X
	lw a2, positionBLUEY		  ##Y

	jal renderobject

GreenWizardrender:
	la a0, GreenWizard
	lw a1, positionGREENX          	  ##X
	lw a2, positionGREENY			  ##Y

	jal renderobject

	


YellowWizardrender:
	la a0, YellowWizard
	lw a1, positionYELLOWX           ##X
	lw a2, positionYELLOWY			 ##Y

	jal renderobject




playerender: #rendering the player
	la a0, PLAYER
	lw a1, positionX
	lw a2, positionY

	jal renderobject
	

##These loops make the player go a certain direction, and will only change the direction if the player changes it

LOOPmovingX:					
	lw a3, playerdirectionX ##Loads the adresses and send those as arguments
	lw a1, positionX
	lw t6, positionX
	lw a2, positionY
	la a0, blank

	add t6, t6, a3
	la t5, nextpositionX
	sw t6, 0(t5)

##	jal collision

	jal renderobject

	add a1, a1, a3 		##changes the word value based on a3, that means the direction. 1 or -1 for right and left.
	
	la t4, positionX 	##Loads the word adress
	sw a1, 0(t4) 		##Puts the new value in the adress 
	lw a2, positionY 	##Sends the rest of the arguments, postionY
	la a0, PLAYER       ##And the player sprite


	jal renderobject 	##calls rendering function

	jal KEYBOARD  		##checks if something was pressed

	beq t0, zero, LOOPmovingX ##if it wasnt, keeps walking

##Same thing as before, but for the Y axis.
LOOPmovingY:
	lw a4, playerdirectionY 
	lw a1, positionX
	lw a2, positionY
	lw t6, positionY
	la a0, blank

	add t6, t6, a3
	la t5, nextpositionY
	sw t6, 0(t5)

##	jal collision

	jal renderobject
	
	add a2, a2, a4

	la t5, nextpositionY
	sw a2, 0(t5)
		
	la t4, positionY
	sw a2, 0(t4)
	lw a1, positionX
	la a0, PLAYER
	
	jal renderobject

	jal KEYBOARD  ##Checks if something was pressed

	beq t0, zero, LOOPmovingY ##If it wasn't, reads again


	

	
##These funtions select the player direction based on the keyboard input received previously.
Xleft:            
        

	li a3, -1 ##changes the word value
	la t0, playerdirectionX ##loads the adress 
	sw a3, 0(t0) ##puts the new value on the adress
	
	jal LOOPmovingX ##calls the moving function
	
	
	

Xright: #if it goes right
	li a3,  1 #changes the word value
	la t0, playerdirectionX ##loads the adress
	sw a3, 0(t0) ##puts the new value on the adress 
	
	jal LOOPmovingX ##calls the moving function


Yup: #if it gos up
	li a4,  -1 #changes the word value
	la t0, playerdirectionY ##loads the adress
	sw a4, 0(t0) ##puts the new value on the adress 
	
	jal LOOPmovingY ##calls the moving function
	

Ydown: #going down
	li a4,  1 #changes the word value
	la t0, playerdirectionY ##loads the adress
	sw a4, 0(t0) ##puts the new value on the adress 
	
	jal LOOPmovingY ##calls the moving function
	


renderobject:
#a0 has the image adress
#a1 has the X axis
#a2 has the Y axis

	lw s0, 0(a0)	##loads the width
	lw s1, 4(a0)	##loads the height

	mv s2, a0	#move the image adress to s2
	addi s2, s2, 8	#now s2 points to the first pixel of the image

	li s3, 0xff000000 ##bitmapdisplay adress is loaded

	li t1, 320         
	mul t1, t1, a2	##by multiplying a2 by 320, you get where is the line to start rendering the image.
	add t1, t1, a1	##now you add a1 to the value in order to get the colunm.
	add s3, s3, t1	##now we are adding the values in the bitmapDisplay adress. 

	li t1, 0

line:
	bge t1, s1, endR ##when every line is printed, it ends
	li t0, 0 ##if the are still left to be printed, loads 0 to t0 in order to start printing the columns 

column:
	bge t0,s0, endC ##when finishing this one line by filling every columns in the line, go to the label

	lb t2,0(s2)  ##picks up the pixel we are going to print
	sb t2, 0(s3) ##prints the pixel

	addi s2,s2, 1 ##goes to next pixel in the image
	addi s3,s3, 1 ##goes to the next adress in the bitmapdisplay
	addi t0, t0, 1 ##counts the calumns in order to know when it finished printing every column
	j column


endC:

	addi s3, s3, 320 ##when we finish printing the line, go to the next line
	sub s3, s3, s0	##relocate the adress so it can print correctly

	addi t1, t1, 1 ##counts how many lines have been printed, in order to know when to end rendering.
	j line		##go back to the line label in order to continue printing the rest of the lines

endR: 
	ret
####unfinished:
##collision:
##	la a5, ReferenceBackground
##	lw a6, nextpositionX 
##	lw a7, nextpositionY

##	lw s7 0(a5)

##	mv s5, a5 	   ##Reference backgorund adress in s5
##	addi s5, s5, 8 ##pointing to first pixel
##	li t1, 320     ##
##	mul t1, t1, a7 ##multiplying by 320
##	add t1, t1, a6 ##
##	add s5, s5, t1 ##s5 points to the player position in the reference background?

##	li t3, 7
##	lb t4, 0(s5)
	
	
##	bne t4, t3, outplayer
##	ret

	
outplayer:

	jal playerinput