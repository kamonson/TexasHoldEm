TITLE MASM Template

; Zeus cs278 EX
;Write a program that 

INCLUDE Irvine32.inc 

.data
spade DWORD 1,2,3,4,5,6,7,8,9,10,11,12
heart DWORD 1,2,3,4,5,6,7,8,9,10,11,12
club DWORD 1,2,3,4,5,6,7,8,9,10,11,12
dimond DWORD 1,2,3,4,5,6,7,8,9,10,11,12

Deck DWORD spade, heart, club, dimond

PlayerHand DWORD 2 dup(?)
SpokHand DWORD 2 dup(?)
Table DWORD 5 dup(?)
Burn DWORD 2 dup(?)

NumberCards DWORD ?

Card DWORD ?

DeckSmall DWORD 11 dup(?)

.code
main PROC

call Shuffel
call DealHand
Call DealFlop
Call DealTurn
Call DealRiver

exit
main ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Shuffel PROC																																							;
;	Recieves: Deck																																						;
;	Returns: Card with random value																																		;
;	Calls CheckCard																																						;
;Randomly assigns a value to a card from deck containing 1-k from any suite CheckCard creates SmallDeck to deal cards to SpokHand, PlayerHand, Burn and Table			;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
mov eax, deck
call RandomRange
mov Card,eax
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
;Procedure manipulates River																																				;
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