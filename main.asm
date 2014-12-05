TITLE MASM Template

; Zeus cs278 EX
;Write a program that 

INCLUDE Irvine32.inc 

.data

Deck byte 52 dup (?)

																	;array of Suits
PlayerHand byte 2 dup (?)											;2 Cards for the player
SpockHand byte 2 dup (?)											;2 Cards for the AI
Table byte 5 dup (?)												;3 Flop cards, 1 Turn card, 1 River card

DeckMark DWORD ?													;Bookmark for place in Deck
TableMark DWORD ?													;Bookmark for place in Table

ChipsPlayer DWORD 0
ChipsSpock  DWORD 0
ChipsTable DWORD 0
BigBlind DWORD 1													;Variable for who is responsible for Big blind, other is responsible for little blind 1/2 big blind bet
FullHandSpock BYTE 7 dup (0)
FullHandPlayer BYTE 7 dup (0)

PromptYouWin byte "You Win, your earning are: ", 0
PromptYouLose byte "You Lose, you walk away with: ", 0
PromptPlayAgain byte "Would you like to play again 1 for yes or 0 for no:  "
PromptWinImage byte "?"
PromptLoseImage byte "?"
PromptChipsPlayer byte "?"
PromptChipsSpock byte "?"
PromptBadInput byte "That is not a valid choice, please try again"


.code
main PROC
	mov ChipsPlayer, 100
	mov ChipsSpock, 100
	G1:
		Call Ante
		Call Shuffel
		Call DealHand
		Call HandSpock
		Call Bid1
		Call DealFlop
		Call HandSpock
		Call Bid2
		Call DealTurn
		Call HandSpock
		Call Bid3
		Call DealRiver
		Call HandSpock
		Call HandPlayer
		Call CompareHand
	Loop G1

exit
main ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Shuffel PROC																																							;
;	Recieves: nothing																																					;
;	Returns: Full/shuffled Deck																																			;
;Adds 52 cards to the Deck 13 from each suit and shuffles them		Values 1-13 =Spades 14-26 Hearts 27-39 Clubs 40-52													;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
mov ecx, 52
mov dl, 0
mov al, 1
mov esi, 0
	L0:
		mov Deck[esi], al
		inc al
		add esi,TYPE Deck
		inc dl
	Loop L0

mov ecx, 104

	S1:
		mov eax,53
		call randomrange
		mov esi, eax
		mov bl,Deck[esi]
		mov al, Deck[0]
		xchg al,bl
		mov Deck[esi], bl
		mov Deck[0], al
	Loop S1

ret
Shuffel ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
DealHand PROC																																							;
;	Recieves: Deck																																						;
;	Returns: Nothing																																					;
;	Assigns cards from Deck to PlayerHand/SpockHand																														;
;Procedure deals PlayerHand/SpockHand																																	;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
mov ecx, 2
mov esi, 0
mov ebx, 0

	H1:
		mov al, Deck[ebx]
		mov PlayerHand[esi], al
		add ebx, TYPE Deck
		mov al, Deck [ebx]
		mov SpockHand[esi], al
		add esi, TYPE PlayerHand
		add ebx, TYPE Deck
	Loop H1
mov DeckMark,EBX
ret
DealHand ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
DealFlop PROC																																							;
;	Recieves: Deck																																						;
;	Returns: Nothing																																					;
;	Assigns cards from Dek to Flop																																		;
;Procedure deals Flop																																					;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

mov ecx, 3
mov ebx, DeckMark
mov edi,0

	T1:
		mov al, Deck[ebx]
		mov Table[edi], al
		add ebx, TYPE Deck
		add edi, TYPE Table
	Loop T1
mov TableMark,edi
mov DeckMark,ebx
ret
DealFlop ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
DealTurn PROC																																							;
;	Recieves: Deck																																						;
;	Returns: Nothing																																					;
;	Assigns cards from Deck to Turn																																		;
;Procedure skips a card for burn and deals Turn																															;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

mov ebx, DeckMark
add ebx, TYPE Deck		;;;;;;;;;THIS IS THE BURN
mov edi, TableMark
mov al, Deck[ebx]
mov Table[edi],al
add ebx, TYPE Deck
mov DeckMark, EBX
add edi, TYPE Table
mov TableMark, edi

ret
DealTurn ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
DealRiver PROC																																							;
;	Recieves: Deck																																						;
;	Returns: Nothing																																					;
;	Assigns cards from Deck to River																																	;
;Procedure skips a card from Deck for burn and deals River																												;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

mov ebx, DeckMark
add ebx, TYPE Deck		;;;;;;;;;THIS IS THE BURN
mov edi, TableMark
mov al, Deck[ebx]
mov Table[edi],al

ret
DealRiver ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Ante PROC																																								;
;	Recieves: BigBlind, ChipsPlayer, ChipsSpock, ChipsTable,																											;
;	Returns: ChipsPlayer(modified) ChipsSpock(modified), ChipTable(modified)																							;
;	Big and Little blinds paid in for oppening bet																														;
;Procedure Checks to ensure that player and spock have the chips to make bet if not game end call win/lose, change the value of chips									;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

.if(BigBlind > 0)
	mov BigBlind, 0
	.if(ChipsPlayer < 25)
			call Lose
		.endif
	
		.if(ChipsSpock < 50)
			call Win	
		.endif

		.else
			sub ChipsPlayer, 25
			add ChipsTable, 25
			sub ChipsSpock, 50
			add ChipsTable, 50
	.endif

	.if(BigBlind<1)
		mov BigBlind, 1
		.if(ChipsPlayer < 50)
			call Lose
		.endif
	
		.if(ChipsSpock < 25)
			call Win	
		.endif

		.else
			sub ChipsPlayer, 50
			add ChipsTable, 50
			sub ChipsSpock, 25
			add ChipsTable, 25
	.endif

ret
Ante ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Win PROC																																								;
;	Recieves: PromptWinImage, PromptYouWin, PlayerChips																													;
;	Returns: Nothing																																					;
;	Display image and earnings, calls PlayAgain																															;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
	mov edx, OFFSET PromptWinImage
	call WriteString
	mov edx, ChipsPlayer
	call WriteString
	Call PlayAgain
Win ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Lose PROC																																								;
;	Recieves: PromptLoseImage, PromptYouLose, PlayerChips																												;
;	Returns: Nothing																																					;
;	Display image and earnings, calls PlayAgain																															;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
	mov edx, OFFSET PromptLoseImage
	call WriteString
	mov edx, ChipsPlayer
	call WriteString
	Call PlayAgain
Lose ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
PlayAgain PROC																																							;
;	Recieves: PromptPlayAgain																																			;
;	Returns: Nothing																																					;
;	Asks if you want to PlayAgain, if y call main/if n invoke exitproccess/if else prompbadinput																		;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
	mov edx, OFFSET PromptPlayAgain
	call WriteString
	call Readint
		.if(eax==0)
			INVOKE ExitProcess, 0
		.elseif(eax==1)
			call Main
		.else
			mov al, PromptBadInput
			call PlayAgain
		.endif
ret
PlayAgain ENDP


;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
HandSpock PROC																																							;
;	Recieves: Table, SpockHand, FullHandSpock																															;
;	Returns: FullHandSpock																																				;
;	Adds Spock and table together to make a full hand of available cards																								;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
mov eax, 0
mov ecx, 5
	FSH1:	
		mov dl, table[eax]																						;FullSpockHand1
		mov FullHandSpock[eax],dl		
		add eax, TYPE FullHandSpock
	Loop FSH1																						
mov ebx, 0
mov ecx, 2
	FSH2:																										;FullSpockHand2
		mov dl, SpockHand[ebx]
		mov FullHandSpock[eax],dl
		add eax, TYPE FullHandSpock
		add ebx, TYPE SpockHand
	Loop FSH2
ret
HandSpock ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
HandPlayer PROC																																							;
;	Recieves: Table, PlayerHand, FullHandPlayer																															;
;	Returns: FullHandPlayer																																				;
;	Adds Player and table together to make a full hand of available cards																								;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
mov eax, 0
mov ecx, 5
	FPH1:																									;FullPlayerHand1
		mov dl, table[eax]																						
		mov FullHandPlayer[eax], dl
		add eax, TYPE FullHandPlayer
	Loop FPH1																						
mov ebx, 0
mov ecx, 2
	FPH2:																									;FullPlayerHand2
		mov dl, PlayerHand[ebx]																						
		mov FullHandPlayer[eax], dl
		add eax, TYPE FullHandPlayer
		mov ebx, TYPE PlayerHand
	Loop FPH2
ret
HandPlayer ENDP


Bid1 PROC
	ret
Bid1 ENDP


Bid2 PROC
	ret
Bid2 ENDP


Bid3 PROC
	ret
Bid3 ENDP

CompareHand Proc
	ret
CompareHand ENDP


END main









