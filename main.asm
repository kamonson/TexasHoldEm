TITLE MASM Template

; Zeus cs278 EX
;Write a program that 

INCLUDE Irvine32.inc 

.data

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Card STRUCT																																								;
;Basic class for all all cards suits containing suit and value																											;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
	Suit DWORD 0																																						;
	Value DWORD 0																																						;
Card Ends																																								;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

card1 Card <0,0>

Deck DWORD 52 dup (Card)											;array of Suits
PlayerHand DWORD 2 dup(Card)										;2 Cards for the player
SpokHand DWORD 2 dup(Card)											;2 Cards for the AI
Table DWORD 5 dup(Card)												;3 Flop cards, 1 Turn card, 1 River card
Burn DWORD 2 dup(Card)												;2 Burn cards

NumberCards DWORD ?													;not sure what this is/was for
DeckSmall DWORD 11 (Card)											;11 cards needed for game

spade DWORD 1
heart DWORD 2
club DWORD 3
dimond DWORD 4

.code
main PROC

Call Shuffel
Call DealHand
Call DealFlop
Call DealTurn
Call DealRiver

exit
main ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Shuffel PROC																																							;
;	Recieves: card1, spade, heart, club, dimond, Deck (empty), DeckSmall																								;
;	Returns: DeckSmall																																					;
;	Calls CheckCard																																						;
;Adds 52 cards to the deck 13 from each suit, selects 11 random cards to add to DeckSmall																				;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

mov ecx,13
mov eax,1
mov edx,1
mov ebx, 0
mov edi, spade

	L1:
		mov card1.suit, edi
		mov card1.value, eax
		mov Deck[ebx], OFFSET card1
		inc eax
		inc edx
		add ebx, TYPE Deck
	Loop L1

mov ecx,13
mov eax,1
mov edx,1
mov edi, heart
	
	L2:
		mov card1.suit, edi
		mov card1.value, eax
		mov Deck[ebx], OFFSET card1
		inc eax
		inc edx
		add ebx, TYPE Deck
	Loop L2

mov ecx,13
mov eax,1
mov edx,1
mov edi, club

	L3:
		mov card1.suit, edi
		mov card1.value, eax
		mov Deck[ebx], OFFSET card1
		inc eax
		inc edx
		add ebx, TYPE Deck
	Loop L3

mov ecx,13
mov eax,1
mov edx,1
mov edi, dimond

	L4:
		mov card1.suit, edi
		mov card1.value, eax
		mov Deck[ebx], OFFSET card1
		inc eax
		inc edx
		add ebx, TYPE Deck
	Loop L4

mov eax,deck(8).card.value								;not working bad value

mov ecx, 104
mov edx,0

	L5:
		mov eax,52
		call RandomRange
		mov ebx, eax
		mov eax, 4
		mul ebx
		mov ebx,deck[eax]
		mov esi,deck(0)
		mov deck[eax], esi
		mov deck(0), ebx
		inc edx
	Loop L5

call CheckCard
ret
Shuffel ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
CheckCard PROC																																							;
;	Recieves: Card																																						;
;	Returns: Card with random value not equal to card in SpokHand, PlayerHand, Table, or Burn																			;
;	Calls Suffel if Card == DeckSmall																																	;
;Checks card against DeckSmall if card in DeckSmall then recall Shuffel, when DeckSmall full return to previous function												;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;for (int i=0; i<size of DeckSmall; i++){if (DeckSmall[i] == Card){call Shuffel;} else {DeckSmall.pushback(Card);}

ret
CheckCard ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
DealHand PROC																																							;
;	Recieves: SmallDeck																																					;
;	Returns: Nothing																																					;
;	Assigns cards from DeckSmall to PlayerHand/SpokHand																												;
;Procedure manipulates PlayerHand/SpokHand																																;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;mov NumberCards,0
;move ecx,2
;	D1:
;		pop eax,DeckSmall
;		mov PlayerHand(+ NumberCards),EAX;
;		pop eax,DeckSmall
;		mov SpokHand(+ NumberCards),EAX;
;		
;		add NumberCards, PlayerHand(Size)
;	Loop D1	

ret
DealHand ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
DealFlop PROC																																							;
;	Recieves: SmallDeck																																					;
;	Returns: Nothing																																					;
;	Assigns cards from DeckSmall to Flop																																;
;Procedure manipulates Flop																																				;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;mov NumberCards,0
;pop eax,DeckSmall
;mov Burn, eax
;move ecx,3
;	D2:
;		pop eax,DeckSmall
;		mov Table(+ NumberCards),EAX;
;		add NumberCards, Table(Size)
;	Loop D2	

ret
DealFlop ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
DealTurn PROC																																							;
;	Recieves: SmallDeck																																					;
;	Returns: Nothing																																					;
;	Assigns cards from DeckSmall to Turn																																;
;Procedure manipulates Turn																																				;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;do not include mov NumberCards,0
;pop eax,DeckSmall
;mov Burn, eax
;pop eax,DeckSmall
;mov Table(+ NumberCards),EAX;
;add NumberCards, Table(Size)

ret
DealTurn ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
DealRiver PROC																																							;
;	Recieves: SmallDeck																																					;
;	Returns: Nothing																																					;
;	Assigns cards from DeckSmall to River																																;
;Procedure manipulates River																																			;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;do not include mov NumberCards,0
;pop eax,DeckSmall
;mov Burn, eax
;pop eax,DeckSmall
;mov Table(+ NumberCards),EAX;
;add NumberCards, Table(Size)

ret
DealRiver ENDP

END main