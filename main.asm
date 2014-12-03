TITLE MASM Template

; Zeus cs278 EX
;Write a program that 

INCLUDE Irvine32.inc 

.data

Deck byte 52 dup (?)

																	;array of Suits
PlayerHand byte 2 dup (?)											;2 Cards for the player
SpokHand byte 2 dup (?)												;2 Cards for the AI
Table byte 5 dup (?)												;3 Flop cards, 1 Turn card, 1 River card

DeckMark DWORD ?													;Bookmark for place in Deck
TableMark DWORD ?													;Bookmark for place in Table

.code
main PROC
	G1:
		Call Shuffel
		Call DealHand
		Call DealFlop
		Call DealTurn
		Call DealRiver
	Loop G1

exit
main ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Shuffel PROC																																							;
;	Recieves: nothing																																					;
;	Returns: Full/shuffled Deck																																			;
;Adds 52 cards to the Deck 13 from each suit and shuffles them																											;
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
;	Assigns cards from Deck to PlayerHand/SpokHand																														;
;Procedure deals PlayerHand/SpokHand																																	;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
mov ecx, 2
mov esi, 0
mov ebx, 0

	H1:
		mov al, Deck[ebx]
		mov PlayerHand[esi], al
		add ebx, TYPE Deck
		mov al, Deck [ebx]
		mov SpokHand[esi], al
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
;Procedure skips a card from Deck for burn and deals River																										;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

mov ebx, DeckMark
add ebx, TYPE Deck		;;;;;;;;;THIS IS THE BURN
mov edi, TableMark
mov al, Deck[ebx]
mov Table[edi],al

ret
DealRiver ENDP

END main