# FINAL PROJECT

# Hunter Brown
# Devin Cook
# CSC 35-01
# 11/29/2022

.intel_syntax noprefix
.data
Intro:
	.ascii "\n\" \\ * * *  W E L C O M E  T O  Z E T A  * * * / \"\n- Created by Hunter Brown -\n\nHow many *V0YAGERS* (Players) are prepared?\n\n> \0"

PlayerCount:
	.quad 0

P1:
	.quad 100 #HP
	.ascii "OUTLANDER\0"
	#.space 64 #Name

P2:
	.quad 100 #HP
	.ascii "GUNDAM*\0"
	#.space 64 #Name

P3:
	.quad 100 #HP
	.ascii "BAHAMUT\0"
	#.space 64 #Name

P4:
	.quad 100 #HP
	.ascii "UGIO\0"
	#.space 64 #Name

P5:
	.quad 100 #HP
	.ascii "K STAR\0"
	#.space 64 #Name

P6:
	.quad 100 #HP
	.ascii "<<<UNKNOWN TRAVELER>>>\0"
	#.space 64 #Name

P7:
	.quad 100 #HP
	.ascii "THE SINGULARITY\0"
	#.space 64 #Name

P8:
	.quad 100 #HP
	.ascii "SPLIT 8\0"
	#.space 64 #Name

P9:
	.quad 100 #HP
	.ascii "MAKER\0"
	#.space 64 #Name

P10:
	.quad 100 #HP
	.ascii "_*B _>E _?Y _!O _@N _&D\0"
	#.space 64 #Name

Players:
	.quad P1
	.quad P2
	.quad P3
	.quad P4
	.quad P5
	.quad P6
	.quad P7
	.quad P8
	.quad P9
	.quad P10

M0:
	.quad 25 #Base DMG
	.quad 25 #Range	
	.quad 10 #1 out of _ chance
	.quad 5
	.ascii "Cybergenic Strike\0" #Name

M1:
	.quad 15 #Base DMG
	.quad 20 #Range	
	.quad 10 #1 out of _ chance
	.quad 9 #If less than, will hit
	.ascii "Warp Slash\0" #Name

M2:
	.quad 90 #Base DMG
	.quad 25 #Range	
	.quad 10 #1 out of _ chance
	.quad 1
	.ascii "Void Bomb\0" #Name

Moves:
	.quad M0
	.quad M1
	.quad M2

Art:
	.ascii "\0"
	.ascii "\0"
	# . . .

Arts:
	.quad Art

NamePrint:
	.ascii "\nName: \0"

HPPrint:
	.ascii "\nHP: \0"

TargetPrompt:
	.ascii "\n\nWhich player would you like to target?\n\n> \0"

MovePrompt:
	.ascii "\n\nWhich move would you like to use?\n0.) Cybergenic Strike (HR: 50% | DMG: 25-50)\n1.) Warp Slash (HR: 90% | DMG: 15-35)\n2.) Void Bomb (HR: 15% | DMG: 90-115)\n\n> \0"

MoveUse:
	.ascii "\n\nYou used \0"

MoveUse2:
	.ascii " on Player \0"

MoveUse3:
	.ascii "!\n\nIt dealt \0"

MoveUse4:
	.ascii " DMG points!\n\n\0"

MoveMiss:
	.ascii "!\n\nThe move missed!\n\n\0"

NameCreation:
	.ascii "\n\nPlayer \0"

NameCreation2:
	.ascii ", what would you like your name to be?\n\n> \0"

PlayerNum:
	.ascii "\nPlayer: \0"

LatestAlive:
	.quad 0

.text
.global _start
_start:
	lea rdx, Intro
	call PrintZString

	call ScanInt
	#sub rdx, 1
	mov PlayerCount, rdx

	mov rsi, 0 #RSI --> Current Player #

	jmp SkipNC

NameCreator:
	lea rdx, NameCreation
	call PrintZString

	mov rdx, rsi
	call PrintInt

	lea rdx, NameCreation2
	call PrintZString

	mov rcx, 64
	call ScanZString

	mov rdi, [Players + (rsi * 8)]
	add rdi, 8
	#mov [rdi], rdx

	add rsi, 1
	cmp rsi, PlayerCount
	jl NameCreator

SkipNC: #Testing purposes
	
	mov rsi, 0
	
Head:
	mov rdi, [Players + (rsi * 8)]
	mov rax, [rdi]

	mov rcx, 1
	cmp PlayerCount, rcx
	jle GameOver

	sub rcx, 1
	cmp rax, rcx
	jle PlayerIsDead #Skip them, they cannot play since HP <= 0

	# Display Name & HP
	lea rdx, PlayerNum
	call PrintZString

	mov rdx, rsi
	call PrintInt

	lea rdx, NamePrint
	call PrintZString

	add rdi, 8
	mov rdx, rdi

	call PrintZString

	lea rdx, HPPrint
	call PrintZString

	mov rdx, rax

	call PrintInt

	# Prompt for desired Target
	lea rdx, TargetPrompt
	call PrintZString

	call ScanInt
	mov rbx, rdx #RBX --> Target #

	# Moves
	lea rdx, MovePrompt
	call PrintZString

	call ScanInt
	mov rax, rdx #RAX --> Move #

	
	# Display aftermath & DMG

	lea rdx, MoveUse
	call PrintZString

	mov rdi, [Moves + (rax * 8)]
	add rdi, 32
	
	mov rdx, rdi    #Prints Move Name
	call PrintZString
		
	lea rdx, MoveUse2
	call PrintZString

	mov rdx, rbx	#Prints Targeted Player
	call PrintInt

	sub rdi, 24     #Grabs DMG Range
	mov rdx, [rdi]
	
	call Random
	add rdx, 1

	sub rdi, 8      #Grabs Base DMG
	add rdx, [rdi]
	
	mov rax, rdx #DAMAGE DEALT --> RAX
	
	add rdi, 24 #Now grabbing the chance amt out of 10

	mov rcx, [rdi]
	mov rdx, 10

	call Random
	add rdx, 1

	cmp rdx, rcx
	jle Hit
Miss:
	lea rdx, MoveMiss
	call PrintZString

	jmp Tail
Hit:
	lea rdx, MoveUse3
	call PrintZString

	#Print DMG
	mov rdx, rax
	call PrintInt

	lea rdx, MoveUse4
	call PrintZString	
	
	# Update target's health
#	mov rdx, [Players + (rbx * 8)]
#	call PrintInt

#	mov rdx, [[Players + (rbx * 8)]]
#	call PrintInt

	mov rcx, [Players + (rbx * 8)]
	lea rdx, [Players + (rbx * 8)]
	call PrintInt

	lea rdx, [rcx]
	call PrintInt	

	mov rdx, [rcx]

	call PrintInt

	mov rdx, rax

	#mov rcx, [Players + (rbx * 8)]
	#sub rcx, rax
	#mov [Players + (rbx * 8)], rcx
	subq [[Players + (rbx * 8)]], rdx

	# Debug, since I am getting segmentation errors

	mov rdx, [[Players + (rbx * 8)]]
	call PrintInt

	jmp Tail

PlayerIsDead:
	# Remove from list somehow, maybe create a blacklist that is checked when the index is changed

			
Tail:
	mov rdi, [[Players + (rsi * 8)]]
	cmp rdi, 0 #If player managed to suicide, do not count as latest alive for end result if game ends
	jle Tail2
	jmp Alive

Alive:
	mov LatestAlive, rsi

Tail2:
	add rsi, 1
	cmp rsi, PlayerCount
	jge ResetCount
	jmp Head

ResetCount:
	mov rsi, 0
	jmp Head

GameOver:
	#Declare winner

	call Exit
