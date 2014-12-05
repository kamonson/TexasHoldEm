TITLE MASM Template

; Zeus cs278 EX
;Write a program that 

INCLUDE Irvine32.inc 

.data

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Card STRUCT																																							    ;
;	Basic class for all all cards suits containing suit and value																										;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
	value byte 0																																						;
	Suit byte 0																																							;
Card ENDS																																								;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;


	cards1 Card <0,0>
	cards2 Card <0,0>
	cards3 Card <0,0>
	cards4 Card <0,0>
	cards5 Card <0,0>
	cards6 Card <0,0>
	cards7 Card <0,0>

	cardp1 Card <0,0>
	cardp2 Card <0,0>
	cardp3 Card <0,0>
	cardp4 Card <0,0>
	cardp5 Card <0,0>
	cardp6 Card <0,0>
	cardp7 Card <0,0>

	isSpadeP DWORD 0
	isHeartP DWORD 0
	isClubP	DWORD 0
	isDimondP DWORD 0
	isFlushP DWORD 0

	isSpadeS DWORD 0
	isHeartS DWORD 0
	isClubS DWORD 0
	isDimondS DWORD 0
	isFlushS DWORD 0

	isStraightS DWORD 0
	isStraightP DWORD 0
	StraightS byte 7 dup (0)
	StraightP byte 7 dup (0)

	PlayerRoyal DWORD 0
	PlayerStraightFlush DWORD 0
	PlayerFour DWORD 0
	PlayerFull DWORD 0
	PlayerFlush DWORD 0
	PlayerStraight DWORD 0
	PlayerThree DWORD 0
	PlayerTwoPair DWORD 0
	PlayerOnePair DWORD 0
	PlayerHighCard DWORD 0

	SpockRoyal DWORD 0
	SpockStraightFlush DWORD 0
	SpockFour DWORD 0
	SpockFull DWORD 0
	SpockFlush DWORD 0
	SpockStraight DWORD 0
	SpockThree DWORD 0
	SpockTwoPair DWORD 0
	SpockOnePair DWORD 0
	SpockHighCard DWORD 0

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

mov al, FullHandSpock[0]
mov cards1.value,al
	.if(al >0 && al < 14)
		mov cards1.suit, 1																					;1=spade,2=heart,3=club,4=dimond
	.elseif(al > 13 && al < 27)
		mov cards1.suit, 2
	.elseif(al > 26 && al < 40)
		mov cards1.suit, 3
	.elseif(al > 39 && al < 53)
		mov cards1.suit, 4
	.endif
mov al, FullHandSpock[1]
mov cards2.value,al
	.if(al >0 && al < 14)
		mov cards2.suit, 1																					;1=spade,2=heart,3=club,4=dimond
	.elseif(al > 13 && al < 27)
		mov cards2.suit, 2
	.elseif(al > 26 && al < 40)
		mov cards2.suit, 3
	.elseif(al > 39 && al < 53)
		mov cards2.suit, 4
	.endif
mov al, FullHandSpock[2]
mov cards3.value,al
	.if(al >0 && al < 14)
		mov cards3.suit, 1																					;1=spade,2=heart,3=club,4=dimond
	.elseif(al > 13 && al < 27)
		mov cards3.suit, 2
	.elseif(al > 26 && al < 40)
		mov cards3.suit, 3
	.elseif(al > 39 && al < 53)
		mov cards3.suit, 4
	.endif
mov al, FullHandSpock[3]
mov cards4.value,al
	.if(al >0 && al < 14)
		mov cards4.suit, 1																					;1=spade,2=heart,3=club,4=dimond
	.elseif(al > 13 && al < 27)
		mov cards4.suit, 2
	.elseif(al > 26 && al < 40)
		mov cards4.suit, 3
	.elseif(al > 39 && al < 53)
		mov cards4.suit, 4
	.endif
mov al, FullHandSpock[4]
mov cards5.value,al
	.if(al >0 && al < 14)
		mov cards5.suit, 1																					;1=spade,2=heart,3=club,4=dimond
	.elseif(al > 13 && al < 27)
		mov cards5.suit, 2
	.elseif(al > 26 && al < 40)
		mov cards5.suit, 3
	.elseif(al > 39 && al < 53)
		mov cards5.suit, 4
	.endif
mov al, FullHandSpock[5]
mov cards6.value,al
	.if(al >0 && al < 14)
		mov cards6.suit, 1																					;1=spade,2=heart,3=club,4=dimond
	.elseif(al > 13 && al < 27)
		mov cards6.suit, 2
	.elseif(al > 26 && al < 40)
		mov cards6.suit, 3
	.elseif(al > 39 && al < 53)
		mov cards6.suit, 4
	.endif
mov al, FullHandSpock[6]
mov cards7.value,al
	.if(al >0 && al < 14)
		mov cards7.suit, 1																					;1=spade,2=heart,3=club,4=dimond
	.elseif(al > 13 && al < 27)
		mov cards7.suit, 2
	.elseif(al > 26 && al < 40)
		mov cards7.suit, 3
	.elseif(al > 39 && al < 53)
		mov cards7.suit, 4
	.endif
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

mov al, FullHandplayer[0]
mov cardp1.value,al
	.if(al >0 && al < 14)
		mov cardp1.suit, 1																					;1=spade,2=heart,3=club,4=dimond
	.elseif(al > 13 && al < 27)
		mov cardp1.suit, 2
	.elseif(al > 26 && al < 40)
		mov cardp1.suit, 3
	.elseif(al > 39 && al < 53)
		mov cardp1.suit, 4
	.endif
mov al, FullHandplayer[1]
mov cardp2.value,al
	.if(al >0 && al < 14)
		mov cardp2.suit, 1																					;1=spade,2=heart,3=club,4=dimond
	.elseif(al > 13 && al < 27)
		mov cardp2.suit, 2
	.elseif(al > 26 && al < 40)
		mov cardp2.suit, 3
	.elseif(al > 39 && al < 53)
		mov cardp2.suit, 4
	.endif
mov al, FullHandplayer[2]
mov cardp3.value,al
	.if(al >0 && al < 14)
		mov cardp3.suit, 1																					;1=spade,2=heart,3=club,4=dimond
	.elseif(al > 13 && al < 27)
		mov cardp3.suit, 2
	.elseif(al > 26 && al < 40)
		mov cardp3.suit, 3
	.elseif(al > 39 && al < 53)
		mov cardp3.suit, 4
	.endif
mov al, FullHandplayer[3]
mov cardp4.value,al
	.if(al >0 && al < 14)
		mov cardp4.suit, 1																					;1=spade,2=heart,3=club,4=dimond
	.elseif(al > 13 && al < 27)
		mov cardp4.suit, 2
	.elseif(al > 26 && al < 40)
		mov cardp4.suit, 3
	.elseif(al > 39 && al < 53)
		mov cardp4.suit, 4
	.endif
mov al, FullHandplayer[4]
mov cardp5.value,al
	.if(al >0 && al < 14)
		mov cardp5.suit, 1																					;1=spade,2=heart,3=club,4=dimond
	.elseif(al > 13 && al < 27)
		mov cardp5.suit, 2
	.elseif(al > 26 && al < 40)
		mov cardp5.suit, 3
	.elseif(al > 39 && al < 53)
		mov cardp5.suit, 4
	.endif
mov al, FullHandplayer[5]
mov cardp6.value,al
	.if(al >0 && al < 14)
		mov cardp6.suit, 1																					;1=spade,2=heart,3=club,4=dimond
	.elseif(al > 13 && al < 27)
		mov cardp6.suit, 2
	.elseif(al > 26 && al < 40)
		mov cardp6.suit, 3
	.elseif(al > 39 && al < 53)
		mov cardp6.suit, 4
	.endif
mov al, FullHandplayer[6]
mov cardp7.value,al
	.if(al >0 && al < 14)
		mov cardp7.suit, 1																					;1=spade,2=heart,3=club,4=dimond
	.elseif(al > 13 && al < 27)
		mov cardp7.suit, 2
	.elseif(al > 26 && al < 40)
		mov cardp7.suit, 3
	.elseif(al > 39 && al < 53)
		mov cardp7.suit, 4
	.endif
	ret
HandPlayer ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Bid1 PROC
	ret
Bid1 ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Bid2 PROC
	ret
Bid2 ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Bid3 PROC
	ret
Bid3 ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
CompareHand Proc
	call IsAFlush
	call IsAStraight
	ret
CompareHand ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
IsAFlush Proc
;Spock Check
	.if (cards1.suit == 1)
		inc IsSpadeS
	.endif
	.if (cards2.suit == 1)
		inc IsSpadeS
	.endif
	.if (cards3.suit == 1)
		inc IsSpadeS
	.endif
	.if (cards4.suit == 1)
		inc IsSpadeS
	.endif
	.if (cards5.suit == 1)
		inc IsSpadeS
	.endif
	.if (cards6.suit == 1)
		inc IsSpadeS
	.endif
	.if (cards7.suit == 1)
		inc IsSpadeS
	.endif

	.if (cards1.suit == 2)
		inc IsHeartS
	.endif
	.if (cards2.suit == 2)
		inc IsHeartS
	.endif
	.if (cards3.suit == 2)
		inc IsHeartS
	.endif
	.if (cards4.suit == 2)
		inc IsHeartS
	.endif
	.if (cards5.suit == 2)
		inc IsHeartS
	.endif
	.if (cards6.suit == 2)
		inc IsHeartS
	.endif
	.if (cards7.suit == 2)
		inc IsHeartS
	.endif

	.if (cards1.suit == 3)
		inc IsClubS
	.endif
	.if (cards2.suit == 3)
		inc IsClubS
	.endif
	.if (cards3.suit == 3)
		inc IsClubS
	.endif
	.if (cards4.suit == 3)
		inc IsClubS
	.endif
	.if (cards5.suit == 3)
		inc IsClubS
	.endif
	.if (cards6.suit == 3)
		inc IsClubS
	.endif
	.if (cards7.suit == 3)
		inc IsClubS
	.endif

	.if (cards1.suit == 4)
		inc IsDimondS
	.endif
	.if (cards2.suit == 4)
		inc IsDimondS
	.endif
	.if (cards3.suit == 4)
		inc IsDimondS
	.endif
	.if (cards4.suit == 4)
		inc IsDimondS
	.endif
	.if (cards5.suit == 4)
		inc IsDimondS
	.endif
	.if (cards6.suit == 4)
		inc IsDimondS
	.endif
	.if (cards7.suit == 4)
		inc IsDimondS
	.endif

	.if(IsSpadeS>4)
		mov isFlushS, 1
	.endif
	.if(IsHeartS>4)
		mov isFlushS, 1
	.endif
	.if(IsClubS>4)
		mov isFlushS, 1
	.endif
	.if(IsDimondS>4)
		mov isFlushS, 1
	.endif

;Player Check
	.if (cardp1.suit == 1)
		inc IsSpadeP
	.endif
	.if (cardp2.suit == 1)
		inc IsSpadeP
	.endif
	.if (cardp3.suit == 1)
		inc IsSpadeP
	.endif
	.if (cardp4.suit == 1)
		inc IsSpadeP
	.endif
	.if (cardp5.suit == 1)
		inc IsSpadeP
	.endif
	.if (cardp6.suit == 1)
		inc IsSpadeP
	.endif
	.if (cardp7.suit == 1)
		inc IsSpadeP
	.endif

	.if (cardp1.suit == 2)
		inc IsHeartP
	.endif
	.if (cardp2.suit == 2)
		inc IsHeartP
	.endif
	.if (cardp3.suit == 2)
		inc IsHeartP
	.endif
	.if (cardp4.suit == 2)
		inc IsHeartP
	.endif
	.if (cardp5.suit == 2)
		inc IsHeartP
	.endif
	.if (cardp6.suit == 2)
		inc IsHeartP
	.endif
	.if (cardp7.suit == 2)
		inc IsHeartP
	.endif

	.if (cardp1.suit == 3)
		inc IsClubP
	.endif
	.if (cardp2.suit == 3)
		inc IsClubP
	.endif
	.if (cardp3.suit == 3)
		inc IsClubP
	.endif
	.if (cardp4.suit == 3)
		inc IsClubP
	.endif
	.if (cardp5.suit == 3)
		inc IsClubP
	.endif
	.if (cardp6.suit == 3)
		inc IsClubP
	.endif
	.if (cardp7.suit == 3)
		inc IsClubP
	.endif

	.if (cardp1.suit == 4)
		inc IsDimondP
	.endif
	.if (cardp2.suit == 4)
		inc IsDimondP
	.endif
	.if (cardp3.suit == 4)
		inc IsDimondP
	.endif
	.if (cardp4.suit == 4)
		inc IsDimondP
	.endif
	.if (cardp5.suit == 4)
		inc IsDimondP
	.endif
	.if (cardp6.suit == 4)
		inc IsDimondP
	.endif
	.if (cardp7.suit == 4)
		inc IsDimondP
	.endif

	.if(IsSpadeP>4)
		mov isFlushP, 1
	.endif
	.if(IsHeartP>4)
		mov isFlushP, 1
	.endif
	.if(IsClubP>4)
		mov isFlushP, 1
	.endif
	.if(IsDimondP>4)
		mov isFlushP, 1
	.endif
ret
IsAFlush ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
IsAStraight Proc

;Spock Straight

mov al, cards1.value
.if (al == 1||al==14||al==27||al==40)
	mov al,1	
.elseif (al ==2||al==15||al==28||al==41)
	mov al,2
.elseif (al ==3||al==16||al==29||al==42)
	mov al,3
.elseif (al == 4||al==17||al==30||al==43)
	mov al,4
.elseif (al == 5||al==18||al==31||al==44)
	mov al,5
.elseif (al == 6||al==19||al==32||al==45)
	mov al,6
.elseif (al==7||al==20||al==33||al==46)
	mov al,7
.elseif (al == 8||al==21||al==34||al==47)
	mov al,8
.elseif (al == 9||al==22||al==35||al==48)
	mov al,9
.elseif (al == 10||al==23||al==36||al==49)
	mov al,10
.elseif (al == 11||al==24||al==37||al==50)
	mov al,11
.elseif (al == 12||al==25||al==38||al==51)
	mov al,12
.elseif (al == 13||al==26||al==39||al==52)
	mov al,13
.endif
mov straights[0], al

mov al, cards2.value
.if (al == 1||al==14||al==27||al==40)
	mov al,1	
.elseif (al ==2||al==15||al==28||al==41)
	mov al,2
.elseif (al ==3||al==16||al==29||al==42)
	mov al,3
.elseif (al == 4||al==17||al==30||al==43)
	mov al,4
.elseif (al == 5||al==18||al==31||al==44)
	mov al,5
.elseif (al == 6||al==19||al==32||al==45)
	mov al,6
.elseif (al==7||al==20||al==33||al==46)
	mov al,7
.elseif (al == 8||al==21||al==34||al==47)
	mov al,8
.elseif (al == 9||al==22||al==35||al==48)
	mov al,9
.elseif (al == 10||al==23||al==36||al==49)
	mov al,10
.elseif (al == 11||al==24||al==37||al==50)
	mov al,11
.elseif (al == 12||al==25||al==38||al==51)
	mov al,12
.elseif (al == 13||al==26||al==39||al==52)
	mov al,13
.endif
mov straights[1], al

mov al, cards3.value
.if (al == 1||al==14||al==27||al==40)
	mov al,1	
.elseif (al ==2||al==15||al==28||al==41)
	mov al,2
.elseif (al ==3||al==16||al==29||al==42)
	mov al,3
.elseif (al == 4||al==17||al==30||al==43)
	mov al,4
.elseif (al == 5||al==18||al==31||al==44)
	mov al,5
.elseif (al == 6||al==19||al==32||al==45)
	mov al,6
.elseif (al==7||al==20||al==33||al==46)
	mov al,7
.elseif (al == 8||al==21||al==34||al==47)
	mov al,8
.elseif (al == 9||al==22||al==35||al==48)
	mov al,9
.elseif (al == 10||al==23||al==36||al==49)
	mov al,10
.elseif (al == 11||al==24||al==37||al==50)
	mov al,11
.elseif (al == 12||al==25||al==38||al==51)
	mov al,12
.elseif (al == 13||al==26||al==39||al==52)
	mov al,13
.endif
mov straights[2], al

mov al, cards4.value
.if (al == 1||al==14||al==27||al==40)
	mov al,1	
.elseif (al ==2||al==15||al==28||al==41)
	mov al,2
.elseif (al ==3||al==16||al==29||al==42)
	mov al,3
.elseif (al == 4||al==17||al==30||al==43)
	mov al,4
.elseif (al == 5||al==18||al==31||al==44)
	mov al,5
.elseif (al == 6||al==19||al==32||al==45)
	mov al,6
.elseif (al==7||al==20||al==33||al==46)
	mov al,7
.elseif (al == 8||al==21||al==34||al==47)
	mov al,8
.elseif (al == 9||al==22||al==35||al==48)
	mov al,9
.elseif (al == 10||al==23||al==36||al==49)
	mov al,10
.elseif (al == 11||al==24||al==37||al==50)
	mov al,11
.elseif (al == 12||al==25||al==38||al==51)
	mov al,12
.elseif (al == 13||al==26||al==39||al==52)
	mov al,13
.endif
mov straights[3], al

mov al, cards5.value
.if (al == 1||al==14||al==27||al==40)
	mov al,1	
.elseif (al ==2||al==15||al==28||al==41)
	mov al,2
.elseif (al ==3||al==16||al==29||al==42)
	mov al,3
.elseif (al == 4||al==17||al==30||al==43)
	mov al,4
.elseif (al == 5||al==18||al==31||al==44)
	mov al,5
.elseif (al == 6||al==19||al==32||al==45)
	mov al,6
.elseif (al==7||al==20||al==33||al==46)
	mov al,7
.elseif (al == 8||al==21||al==34||al==47)
	mov al,8
.elseif (al == 9||al==22||al==35||al==48)
	mov al,9
.elseif (al == 10||al==23||al==36||al==49)
	mov al,10
.elseif (al == 11||al==24||al==37||al==50)
	mov al,11
.elseif (al == 12||al==25||al==38||al==51)
	mov al,12
.elseif (al == 13||al==26||al==39||al==52)
	mov al,13
.endif
mov straights[4], al

mov al, cards6.value
.if (al == 1||al==14||al==27||al==40)
	mov al,1	
.elseif (al ==2||al==15||al==28||al==41)
	mov al,2
.elseif (al ==3||al==16||al==29||al==42)
	mov al,3
.elseif (al == 4||al==17||al==30||al==43)
	mov al,4
.elseif (al == 5||al==18||al==31||al==44)
	mov al,5
.elseif (al == 6||al==19||al==32||al==45)
	mov al,6
.elseif (al==7||al==20||al==33||al==46)
	mov al,7
.elseif (al == 8||al==21||al==34||al==47)
	mov al,8
.elseif (al == 9||al==22||al==35||al==48)
	mov al,9
.elseif (al == 10||al==23||al==36||al==49)
	mov al,10
.elseif (al == 11||al==24||al==37||al==50)
	mov al,11
.elseif (al == 12||al==25||al==38||al==51)
	mov al,12
.elseif (al == 13||al==26||al==39||al==52)
	mov al,13
.endif
mov straights[5], al

mov al, cards7.value
.if (al == 1||al==14||al==27||al==40)
	mov al,1	
.elseif (al ==2||al==15||al==28||al==41)
	mov al,2
.elseif (al ==3||al==16||al==29||al==42)
	mov al,3
.elseif (al == 4||al==17||al==30||al==43)
	mov al,4
.elseif (al == 5||al==18||al==31||al==44)
	mov al,5
.elseif (al == 6||al==19||al==32||al==45)
	mov al,6
.elseif (al==7||al==20||al==33||al==46)
	mov al,7
.elseif (al == 8||al==21||al==34||al==47)
	mov al,8
.elseif (al == 9||al==22||al==35||al==48)
	mov al,9
.elseif (al == 10||al==23||al==36||al==49)
	mov al,10
.elseif (al == 11||al==24||al==37||al==50)
	mov al,11
.elseif (al == 12||al==25||al==38||al==51)
	mov al,12
.elseif (al == 13||al==26||al==39||al==52)
	mov al,13
.endif
mov straights[6], al

mov ecx,6
mov edi,6
mov esi,0
	
	SS1:
		mov edx,esi
		inc edx
		push ecx
		mov ecx, edi
			SS2:
				mov al, straights[esi]
				mov bl, straights[edx]
					.if (al < bl)
						xchg al, bl
						mov straights[esi],al
						mov straights[edx],bl
					.endif 
				inc edx
			Loop SS2
		pop ecx
		inc esi		
		dec edi
	Loop SS1
	
mov al, straights[0]
mov bl, straights[1]
	sub al,bl
	.if(al==1)
		mov al, straights[1]
		mov bl, straights[2]
		sub al,bl
			.if(al==1)
				mov al, straights[2]
				mov bl, straights[3]
				sub al,bl
					.if(al==1)
						mov al, straights[3]
						mov bl, straights[4]
						sub al,bl
							.if(al==1)
								mov al, straights[4]
								mov bl, straights[5]
								sub al,bl
									.if(al==1)
										inc isStraightS
									.endif
							.endif
					.endif
			.endif
	.endif
mov al, straights[1]
mov bl, straights[2]
	sub al,bl
	.if(al==1)
		mov al, straights[2]
		mov bl, straights[3]
		sub al,bl
			.if(al==1)
				mov al, straights[3]
				mov bl, straights[4]
				sub al,bl
					.if(al==1)
						mov al, straights[4]
						mov bl, straights[5]
						sub al,bl
							.if(al==1)
								mov al, straights[5]
								mov bl, straights[6]
								sub al,bl
									.if(al==1)
										inc isStraightS
									.endif
							.endif
					.endif
			.endif
	.endif

mov al, straights[2]
mov bl, straights[3]
sub al,bl
	.if(al==1)
		mov al, straights[3]
		mov bl, straights[4]
		sub al,bl
			.if(al==1)
				mov al, straights[4]
				mov bl, straights[5]
				sub al,bl
					.if(al==1)
						mov al, straights[5]
						mov bl, straights[6]
						sub al,bl
							.if(al==1)
								mov al, straights[6]
								mov bl, straights[7]
								sub al,bl
									.if(al==1)
										inc isStraightS
									.endif
							.endif
					.endif
			.endif
	.endif

;Player Straight
mov al, cardp1.value
.if (al == 1||al==14||al==27||al==40)
	mov al,1	
.elseif (al ==2||al==15||al==28||al==41)
	mov al,2
.elseif (al ==3||al==16||al==29||al==42)
	mov al,3
.elseif (al == 4||al==17||al==30||al==43)
	mov al,4
.elseif (al == 5||al==18||al==31||al==44)
	mov al,5
.elseif (al == 6||al==19||al==32||al==45)
	mov al,6
.elseif (al==7||al==20||al==33||al==46)
	mov al,7
.elseif (al == 8||al==21||al==34||al==47)
	mov al,8
.elseif (al == 9||al==22||al==35||al==48)
	mov al,9
.elseif (al == 10||al==23||al==36||al==49)
	mov al,10
.elseif (al == 11||al==24||al==37||al==50)
	mov al,11
.elseif (al == 12||al==25||al==38||al==51)
	mov al,12
.elseif (al == 13||al==26||al==39||al==52)
	mov al,13
.endif
mov straightp[0], al


mov al, cardp2.value
.if (al == 1||al==14||al==27||al==40)
	mov al,1	
.elseif (al ==2||al==15||al==28||al==41)
	mov al,2
.elseif (al ==3||al==16||al==29||al==42)
	mov al,3
.elseif (al == 4||al==17||al==30||al==43)
	mov al,4
.elseif (al == 5||al==18||al==31||al==44)
	mov al,5
.elseif (al == 6||al==19||al==32||al==45)
	mov al,6
.elseif (al==7||al==20||al==33||al==46)
	mov al,7
.elseif (al == 8||al==21||al==34||al==47)
	mov al,8
.elseif (al == 9||al==22||al==35||al==48)
	mov al,9
.elseif (al == 10||al==23||al==36||al==49)
	mov al,10
.elseif (al == 11||al==24||al==37||al==50)
	mov al,11
.elseif (al == 12||al==25||al==38||al==51)
	mov al,12
.elseif (al == 13||al==26||al==39||al==52)
	mov al,13
.endif
mov straightp[1], al


mov al, cardp3.value
.if (al == 1||al==14||al==27||al==40)
	mov al,1	
.elseif (al ==2||al==15||al==28||al==41)
	mov al,2
.elseif (al ==3||al==16||al==29||al==42)
	mov al,3
.elseif (al == 4||al==17||al==30||al==43)
	mov al,4
.elseif (al == 5||al==18||al==31||al==44)
	mov al,5
.elseif (al == 6||al==19||al==32||al==45)
	mov al,6
.elseif (al==7||al==20||al==33||al==46)
	mov al,7
.elseif (al == 8||al==21||al==34||al==47)
	mov al,8
.elseif (al == 9||al==22||al==35||al==48)
	mov al,9
.elseif (al == 10||al==23||al==36||al==49)
	mov al,10
.elseif (al == 11||al==24||al==37||al==50)
	mov al,11
.elseif (al == 12||al==25||al==38||al==51)
	mov al,12
.elseif (al == 13||al==26||al==39||al==52)
	mov al,13
.endif
mov straightp[2], al


mov al, cardp4.value
.if (al == 1||al==14||al==27||al==40)
	mov al,1	
.elseif (al ==2||al==15||al==28||al==41)
	mov al,2
.elseif (al ==3||al==16||al==29||al==42)
	mov al,3
.elseif (al == 4||al==17||al==30||al==43)
	mov al,4
.elseif (al == 5||al==18||al==31||al==44)
	mov al,5
.elseif (al == 6||al==19||al==32||al==45)
	mov al,6
.elseif (al==7||al==20||al==33||al==46)
	mov al,7
.elseif (al == 8||al==21||al==34||al==47)
	mov al,8
.elseif (al == 9||al==22||al==35||al==48)
	mov al,9
.elseif (al == 10||al==23||al==36||al==49)
	mov al,10
.elseif (al == 11||al==24||al==37||al==50)
	mov al,11
.elseif (al == 12||al==25||al==38||al==51)
	mov al,12
.elseif (al == 13||al==26||al==39||al==52)
	mov al,13
.endif
mov straightp[3], al


mov al, cardp5.value
.if (al == 1||al==14||al==27||al==40)
	mov al,1	
.elseif (al ==2||al==15||al==28||al==41)
	mov al,2
.elseif (al ==3||al==16||al==29||al==42)
	mov al,3
.elseif (al == 4||al==17||al==30||al==43)
	mov al,4
.elseif (al == 5||al==18||al==31||al==44)
	mov al,5
.elseif (al == 6||al==19||al==32||al==45)
	mov al,6
.elseif (al==7||al==20||al==33||al==46)
	mov al,7
.elseif (al == 8||al==21||al==34||al==47)
	mov al,8
.elseif (al == 9||al==22||al==35||al==48)
	mov al,9
.elseif (al == 10||al==23||al==36||al==49)
	mov al,10
.elseif (al == 11||al==24||al==37||al==50)
	mov al,11
.elseif (al == 12||al==25||al==38||al==51)
	mov al,12
.elseif (al == 13||al==26||al==39||al==52)
	mov al,13
.endif
mov straightp[4], al


mov al, cardp6.value
.if (al == 1||al==14||al==27||al==40)
	mov al,1	
.elseif (al ==2||al==15||al==28||al==41)
	mov al,2
.elseif (al ==3||al==16||al==29||al==42)
	mov al,3
.elseif (al == 4||al==17||al==30||al==43)
	mov al,4
.elseif (al == 5||al==18||al==31||al==44)
	mov al,5
.elseif (al == 6||al==19||al==32||al==45)
	mov al,6
.elseif (al==7||al==20||al==33||al==46)
	mov al,7
.elseif (al == 8||al==21||al==34||al==47)
	mov al,8
.elseif (al == 9||al==22||al==35||al==48)
	mov al,9
.elseif (al == 10||al==23||al==36||al==49)
	mov al,10
.elseif (al == 11||al==24||al==37||al==50)
	mov al,11
.elseif (al == 12||al==25||al==38||al==51)
	mov al,12
.elseif (al == 13||al==26||al==39||al==52)
	mov al,13
.endif
mov straightp[5], al


mov al, cardp7.value
.if (al == 1||al==14||al==27||al==40)
	mov al,1	
.elseif (al ==2||al==15||al==28||al==41)
	mov al,2
.elseif (al ==3||al==16||al==29||al==42)
	mov al,3
.elseif (al == 4||al==17||al==30||al==43)
	mov al,4
.elseif (al == 5||al==18||al==31||al==44)
	mov al,5
.elseif (al == 6||al==19||al==32||al==45)
	mov al,6
.elseif (al==7||al==20||al==33||al==46)
	mov al,7
.elseif (al == 8||al==21||al==34||al==47)
	mov al,8
.elseif (al == 9||al==22||al==35||al==48)
	mov al,9
.elseif (al == 10||al==23||al==36||al==49)
	mov al,10
.elseif (al == 11||al==24||al==37||al==50)
	mov al,11
.elseif (al == 12||al==25||al==38||al==51)
	mov al,12
.elseif (al == 13||al==26||al==39||al==52)
	mov al,13
.endif
mov straightp[6], al

mov ecx,6
mov edi,6
mov esi,0
	
	PS1:
		mov edx,esi
		inc edx
		push ecx
		mov ecx, edi
			PS2:
				mov al, straightp[esi]
				mov bl, straightp[edx]
					.if (al < bl)
						xchg al, bl
						mov straightp[esi],al
						mov straightp[edx],bl
					.endif 
				inc edx
			Loop PS2
		pop ecx
		inc esi		
		dec edi
	Loop PS1
	
mov al, straightp[0]
mov bl, straightp[1]
	sub al,bl
	.if(al==1)
		mov al, straightp[1]
		mov bl, straightp[2]
		sub al,bl
			.if(al==1)
				mov al, straightp[2]
				mov bl, straightp[3]
				sub al,bl
					.if(al==1)
						mov al, straightp[3]
						mov bl, straightp[4]
						sub al,bl
							.if(al==1)
								mov al, straightp[4]
								mov bl, straightp[5]
								sub al,bl
									.if(al==1)
										inc isstraightp
									.endif
							.endif
					.endif
			.endif
	.endif
mov al, straightp[1]
mov bl, straightp[2]
	sub al,bl
	.if(al==1)
		mov al, straightp[2]
		mov bl, straightp[3]
		sub al,bl
			.if(al==1)
				mov al, straightp[3]
				mov bl, straightp[4]
				sub al,bl
					.if(al==1)
						mov al, straightp[4]
						mov bl, straightp[5]
						sub al,bl
							.if(al==1)
								mov al, straightp[5]
								mov bl, straightp[6]
								sub al,bl
									.if(al==1)
										inc isstraightp
									.endif
							.endif
					.endif
			.endif
	.endif

mov al, straightp[2]
mov bl, straightp[3]
sub al,bl
	.if(al==1)
		mov al, straightp[3]
		mov bl, straightp[4]
		sub al,bl
			.if(al==1)
				mov al, straightp[4]
				mov bl, straightp[5]
				sub al,bl
					.if(al==1)
						mov al, straightp[5]
						mov bl, straightp[6]
						sub al,bl
							.if(al==1)
								mov al, straightp[6]
								mov bl, straightp[7]
								sub al,bl
									.if(al==1)
										inc isstraightp
									.endif
							.endif
					.endif
			.endif
	.endif
ret
IsAStraight ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
FourKind PROC

ret
FourKind ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
FullHouse PROC

ret
FullHouse ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
ThreeKind PROC

ret
ThreeKind ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
TwoPair PROC

ret
TwoPair ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Pair PROC

ret
Pair ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
HighCard PROC

ret
HighCard ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Tie PROC

ret
Tie ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

END main