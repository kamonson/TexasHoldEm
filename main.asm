TITLE Texas Hold 'em

; Kyle Kat Neele
; Write a texas holdem game against spock

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

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
ConvertValue MACRO																																						;
;Macro For converting card data into visable cards																														;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

	.if(bl <= 52 && bl >= 1)
		.if(bl >= 14 && bl <= 26)
			sub bl, 13			
		.elseif(bl >= 27 && bl <= 39)
			sub bl, 26
		.elseif(bl >= 40 && bl <= 52)
			sub bl, 39
			
		.endif
		
		.if(bl >0 && bl < 10)
			movzx eax, bl
			call writeint
		.elseif (bl == 10)
			mov PromptSuit, "J"
			mov EDX, OFFSET PromptSuit
			Call WriteString
		.elseif (bl == 11)
			mov PromptSuit, "Q"
			mov EDX, OFFSET PromptSuit
			Call WriteString
		.elseif (bl == 12)
			mov PromptSuit, "K"
			mov EDX, OFFSET PromptSuit
			Call WriteString
		.elseif (bl == 13)
			mov PromptSuit, "A"
			mov EDX, OFFSET PromptSuit
			Call WriteString
			
		.endif
ENDM
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
ConvertSuit MACRO																																						;
;Macro For converting card suit into visable cards																														;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
	.if(bl == 1)
		mov al, 06
		mov PromptSuit, al
	.elseif(bl == 2)
		mov al, 03h
		mov PromptSuit, al
	.elseif(bl == 3)
		mov al, 05
		mov PromptSuit, al
	.elseif(bl == 4)
		mov al, 04
		mov PromptSuit, al
	.else
		mov al, "X"
		mov PromptSuit, al
	.endif
ENDM

BlankCard Macro
	mov PromptSuit, "X"
	mov edx, OFFSET PromptSuit
	call writestring
ENDM
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;



;Prompts for scoring
	StraightS byte 7 dup (0)
	StraightP byte 7 dup (0)

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

	RFp DWORD 0
	RFs DWORD 0
	HighFourS byte 0
	HighFourP byte 0
	HighThreeS byte 0
	HighThreeP byte 0
	High2PairS byte 0
	High2PairP byte 0
	Low2PairS byte 0
	Low2PairP byte 0
	PairS byte 0
	PairP byte 0
	HighPairS byte 0
	HighPairP byte 0
	HighSts byte 0
	HighStp byte 0
	HighCards byte 0
	HighCardp byte 0

	PlayerRoyal DWORD 0
	PlayerStraightFlush DWORD 0
	PlayerFour DWORD 0
	PlayerFull DWORD 0
	PlayerFlush DWORD 0
	PlayerStraight DWORD 0
	PlayerThree DWORD 0
	PlayerTwoPair DWORD 0
	PlayerOnePair DWORD 0
	PlayerHandValue DWORD 0
	ChipsCall DWORD 0
	ChipsRaise DWORD 0
	SpockBet DWORD 0
	PlayerBet DWORD 0
	FoldS DWORD 0
	FoldP DWORD 0

	SpockRoyal DWORD 0
	SpockStraightFlush DWORD 0
	SpockFour DWORD 0
	SpockFull DWORD 0
	SpockFlush DWORD 0
	SpockStraight DWORD 0
	SpockThree DWORD 0
	SpockTwoPair DWORD 0
	SpockOnePair DWORD 0
	SpockHandValue DWORD 0



;game controll variables
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
	FullHandSpock BYTE 7 dup (0)										;FullHand of ... including 2 cards 6-7 and table cards 1-5
	FullHandPlayer BYTE 7 dup (0)										;FullHand of ... including 2 cards 6-7 and table cards 1-5			

	
	var1 DWORD 0
	var2 DWORD 0

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

;Prompts
	PromptYouWin byte "YOU WIN. FASCINATING , your earning are: ", 0
	PromptYouLose byte "YOU LOSE. LIVE LONG & PROSPER, you walk away with: ", 0
	PromptPlayAgain byte "Would you like to play again 1 for yes or 0 for no:  ",0
	PromptWinImage byte "?",0
	PromptLoseImage byte "?",0
	PromptChipsPlayer byte "?",0
	PromptChipsSpock byte "?",0
	PromptBadInput byte "That is not a valid choice, please try again",0
	PromptSpockTurn byte "Spocks Turn To bet",0
	PromptSpockBet byte "Spock Bets: ",0
	PromptSpockRaise byte "Spock Raises: ",0
	PromptSpockCall byte "Spock Calls",0
	PromptSpockFold byte "Spock Folds",0
	PromptPlayerBet byte "Would you like to bet<1>, call<2>, or fold<0>",0			
	PromptPlayerSecond byte "Would you like to raise<1>, call<2>, or fold<0>",0		
	PromptPlayerTurn byte "It is your turn",0										
	PromptPlayerRaise byte "Ammount to raise: ",0									
	PromptPlayerCall byte "Call",0													
	PromptPlayerFold byte "Fold",0													
	PromptPlayerNotEnoughChips byte "You do not have enough chips for that",0		
	PromptLine byte "--------------------------------------------------------------------"
	PromptCardUnknown byte		"XX",0
	PromptShowSpock byte		"Spock Cards: |XX|  |XX|",0
	PromptShowTable1 byte		"Table Cards: |",0
	PromptShowTable2 byte       "| |",0
	PromptShowTable3 byte       "|",0
	PromptShowPlayer1 byte		"Player Cards: |",0
	PromptShowPlayer2 byte		"| |",0
	PromptShowPlayer3 byte		"|",0
	PromptShowSpockChips byte	"Spock Chips: ",0
	PromptShowTableChips byte	"Table Chips: ",0
	PromptShowPlayerChips byte	"Player Chips: ",0
	PromptSuit byte				"X",0
	PromptShowSpock1 byte		"Spock Cards: |",0
	PromptHandVS1 byte			"Spock Has: ",0
	PromptRF byte				"Royal Flush",0
	PromptSF byte				"Straight Flush",0
	PromptFK byte				"Four of a Kind",0
	PromptFH byte				"Full House",0
	PromptFL byte				"Flush",0
	PromptST byte				"Straight",0
	PromptTK byte				"Three of a Kind",0
	PromptTP byte				"Two Pair",0
	PromptOP byte				"Pair",0
	PromptHandVP1 byte			"Player Has: ",0
	PromptHandVP2 byte			" High",0
	PromptHandWinP byte			"Player Wins the Hand",0
	PromptHandWinS byte			"Spock Wins the Hand",0
	PromptHandWinT byte			"Tie",0
	PromptPressEnter byte		"Press Enter To Continue",0
	pfold byte					"Player Folded",0
	sfold byte					"Spock Folded",0

;Images
	Spock2 BYTE "                                                     " , 0
	Spock3 BYTE "              :                                 :    " , 0
	Spock4 BYTE "            :                                   :    " , 0
	Spock5 BYTE "            :  RRVIttIti+==iiii++iii++=;:,       :   " , 0
	Spock6 BYTE "            : IBMMMMWWWWMMMMMBXXVVYYIi=;:,        :  " , 0
	Spock7 BYTE "            : tBBMMMWWWMMMMMMBXXXVYIti;;;:,,      :  " , 0
	Spock8 BYTE "            t YXIXBMMWMMBMBBRXVIi+==;::;::::       , " , 0
	Spock9 BYTE "           ;t IVYt+=+iIIVMBYi=:,,,=i+=;:::::,      ;;" , 0
	Spock10 BYTE "           YX=YVIt+=,,:=VWBt;::::=,,:::;;;:;:     ;;;" , 0
	Spock11 BYTE "           VMiXRttItIVRBBWRi:.tXXVVYItiIi==;:   ;;;; " , 0
	Spock12 BYTE "           =XIBWMMMBBBMRMBXi;,tXXRRXXXVYYt+;;: ;;;;; " , 0
	Spock13 BYTE "            =iBWWMMBBMBBWBY;;;,YXRRRRXXVIi;;;:;,;;;= " , 0
	Spock14 BYTE "             iXMMMMMWWBMWMY+;=+IXRRXXVYIi;:;;:,,;;=  " , 0
	Spock15 BYTE "             iBRBBMMMMYYXV+:,:;+XRXXVIt+;;:;++::;;;  " , 0
	Spock16 BYTE "             =MRRRBMMBBYtt;::::;+VXVIi=;;;:;=+;;;;=  " , 0
	Spock17 BYTE "              XBRBBBBBMMBRRVItttYYYYt=;;;;;;==:;=    " , 0
	Spock18 BYTE "               VRRRRRBRRRRXRVYYIttiti=::;:::=;=      " , 0
	Spock19 BYTE "                YRRRRXXVIIYIiitt+++ii=:;:::;==       " , 0
	Spock20 BYTE "                +XRRXIIIIYVVI;i+=;=tt=;::::;:;       " , 0
	Spock21 BYTE "                 tRRXXVYti++==;;;=iYt;:::::,;;       " , 0
	Spock22 BYTE "                  IXRRXVVVVYYItiitIIi=:::;,::;       " , 0
	Spock23 BYTE "                   tVXRRRBBRXVYYYIti;::::,::::       " , 0
	Spock24 BYTE "                    YVYVYYYYYItti+=:,,,,,:::::;      " , 0
	Spock25 BYTE "                    YRVI+==;;;;;:,,,,,,,:::::::      " , 0

	Texas1 BYTE "                                           " , 0
	Texas2 BYTE "MMP''MM''YMM" , 0
	Texas3 BYTE "P'   MM   `7" , 0
	Texas4 BYTE "     MM  .gP'Ya `7M'   `MF' ,6'Yb.  ,pP'Ybd	              __             " , 0
	Texas5 BYTE "     MM ,M'   Yb  `VA ,V'  8)   MM  8I   `#	        _..-''--'----_.      " , 0
	Texas6 BYTE "     MM 8M''''''    XMX     ,pm9MM  `YMMMa.	      ,''.-''| .---/ _`-._   " , 0
	Texas7 BYTE "     MM YM.    ,  ,V' VA.  8M   MM  L.   I8	    ,' \ \  ;| | ,/ / `-._`-." , 0
	Texas8 BYTE "   .JMML.`Mbmmd'.AM.   .MA.`Moo9^Yo.M9mmmP'	  ,' ,',\ \( | |// /,-._  / /" , 0
	Hold1 BYTE "	                       ,,        ,,	  ;.`. `,\ \`| |/ / |   )/ / " , 0
	Hold2 BYTE "	`7MMF'  `7MMF'       `7MM      `7MM	 / /`_`.\_\ \| /_.-.'-''/ /  " , 0
	Hold3 BYTE "	  MM      MM           MM        MM	/ /_|_:.`. \ |;'`..')  / /   " , 0
	Hold4 BYTE "	  MM      MM  ,pW'Wq.  MM   ,M''bMM	`-._`-._`.`.;`.\  ,'  / /    " , 0
	Hold5 BYTE "	  MMmmmmmmMM 6W'   `Wb MM ,AP    MM	    `-._`.`/    ,'-._/ /     " , 0
	Hold6 BYTE "	  MM      MM 8M     M8 MM 8MI    MM	      : `-/     \`-.._/      " , 0
	Hold7 BYTE "	  MM      MM YA.   ,A9 MM `Mb    MM	      |  :      ;._ (        " , 0
	Hold8 BYTE "	.JMML.  .JMML.`Ybmd9'.JMML.`Wbmd'MML.	      :  |      \  ` \       " , 0

	Em1 BYTE "																       \         \   |       " , 0
	Em2 BYTE "	    gp `7MM'''YMM			        :        :   ;       " , 0
	Em3 BYTE "	    \/   MM    `7			        |           /        " , 0
	Em4 BYTE "	    `'   MM   d    `7MMpMMMb.pMMMb.	        ;         ,'         " , 0
	Em5 BYTE "	         MMmmMM      MM    MM    MM	       /         /           " , 0
	Em6 BYTE "	         MM   Y  ,   MM    MM    MM	     /         /            " , 0
	Em7 BYTE "	         MM     ,M   MM    MM    MM	              /             " , 0
	Em8 BYTE "	       .JMMmmmmMMM .JMML  JMML  JMML." , 0


.code
main PROC
	call Welcome
	mov ChipsPlayer, 1000
	mov ChipsSpock, 1000
	G1:
		Call Ante
		Call Shuffel
		Call DealHand
		Call HandSpock
		Call Bid
		Call DealFlop
		Call HandSpock
		Call Bid
		Call DealTurn
		Call HandSpock
		Call Bid
		Call DealRiver
		Call HandSpock
		Call HandPlayer
		Call CompareHand
	Loop G1

exit
main ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Welcome PROC
;Display welcome image
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
	call Clrscr
	mov eax, green
	call SetTextColor

	mov edx, OFFSET Texas1
	call WriteString
	call Crlf
	mov edx, OFFSET Texas2
	call WriteString
	call Crlf
	mov edx, OFFSET Texas3
	call WriteString
	call Crlf
	mov edx, OFFSET Texas4
	call WriteString
	call Crlf
	mov edx, OFFSET Texas5
	call WriteString
	call Crlf
	mov edx, OFFSET Texas6
	call WriteString
	call Crlf
	mov edx, OFFSET Texas7
	call WriteString
	call Crlf
	mov edx, OFFSET Texas8
	call WriteString
	call Crlf

	mov edx, OFFSET Hold1
	call WriteString
	call Crlf
	mov edx, OFFSET Hold2
	call WriteString
	call Crlf
	mov edx, OFFSET Hold3
	call WriteString
	call Crlf
	mov edx, OFFSET Hold4
	call WriteString
	call Crlf
	mov edx, OFFSET Hold5
	call WriteString
	call Crlf
	mov edx, OFFSET Hold6
	call WriteString
	call Crlf
	mov edx, OFFSET Hold7
	call WriteString
	call Crlf
	mov edx, OFFSET Hold8
	call WriteString
	call Crlf

	mov edx, OFFSET Em1
	call WriteString
	call Crlf
	mov edx, OFFSET Em2
	call WriteString
	call Crlf
	mov edx, OFFSET Em3
	call WriteString
	call Crlf
	mov edx, OFFSET Em4
	call WriteString
	call Crlf
	mov edx, OFFSET Em5
	call WriteString
	call Crlf
	mov edx, OFFSET Em6
	call WriteString
	call Crlf
	mov edx, OFFSET Em7
	call WriteString
	call Crlf
	mov edx, OFFSET Em8
	call WriteString
	call Crlf
	
	call Crlf
	mov eax, white
	call SetTextColor
	call readint
ret
Welcome ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;


;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Shuffel PROC																																							;
;	Recieves: nothing																																					;
;	Returns: Full/shuffled Deck																																			;
;Adds 52 cards to the Deck 13 from each suit and shuffles them		Values 1-13 =Spades 14-26 Hearts 27-39 Clubs 40-52													;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

mov ecx, 7
mov al, 60
mov esi, 0
	EmptyHands:
		mov StraightS[esi], al
		mov StraightP[esi], al
		add al, 2
		inc esi
	Loop EmptyHands

mov ecx, 5
mov al, 70
mov esi, 0
	EmptyTable:
		mov Table[esi],al
		add al, 2
		inc esi
	Loop EmptyTable

mov ecx, 52
mov dl, 0
mov al, 2
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
	
	.if(ChipsPlayer < 25)
			call Lose
		.endif
	
		.if(ChipsSpock < 50)
			call Win	
		.endif
	
		sub ChipsPlayer, 25
		add ChipsTable, 25
		sub ChipsSpock, 50
		add ChipsTable, 50

	.elseif (BigBlind<1)
	
		.if(ChipsPlayer < 50)
			call Lose
		.endif
	
		.if(ChipsSpock < 25)
			call Win	
		.endif
	
			sub ChipsPlayer, 50
			add ChipsTable, 50
			sub ChipsSpock, 25
			add ChipsTable, 25
.endif

mov eax, BigBlind
.if(BigBlind > 0)
	mov eax, 0
.else
	mov eax, 1
.endif
mov bigblind,eax

ret
Ante ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Win PROC																																								;
;	Recieves: PromptWinImage, PromptYouWin, PlayerChips																													;
;	Returns: Nothing																																					;
;	Display image and earnings, calls PlayAgain																															;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
	call clrscr
	mov edx, OFFSET Spock2
	call WriteString
	call Crlf
	mov edx, OFFSET Spock3
	call WriteString
	call Crlf
	mov edx, OFFSET Spock4
	call WriteString
	call Crlf
	mov edx, OFFSET Spock5
	call WriteString
	call Crlf
	mov edx, OFFSET Spock6
	call WriteString
	call Crlf
	mov edx, OFFSET Spock7
	call WriteString
	call Crlf
	mov edx, OFFSET Spock8
	call WriteString
	call Crlf
	mov edx, OFFSET Spock9
	call WriteString
	call Crlf
	mov edx, OFFSET Spock10
	call WriteString
	call Crlf
	mov edx, OFFSET Spock11
	call WriteString
	call Crlf
	mov edx, OFFSET Spock12
	call WriteString
	call Crlf
	mov edx, OFFSET Spock13
	call WriteString
	call Crlf
	mov edx, OFFSET Spock14
	call WriteString
	call Crlf
	mov edx, OFFSET Spock15
	call WriteString
	call Crlf
	mov edx, OFFSET Spock16
	call WriteString
	call Crlf
	mov edx, OFFSET Spock17
	call WriteString
	call Crlf
	mov edx, OFFSET Spock18
	call WriteString
	call Crlf
	mov edx, OFFSET Spock19
	call WriteString
	call Crlf
	mov edx, OFFSET Spock20
	call WriteString
	call Crlf
	mov edx, OFFSET Spock21
	call WriteString
	call Crlf
	mov edx, OFFSET Spock22
	call WriteString
	call Crlf
	mov edx, OFFSET Spock23
	call WriteString
	call Crlf
	mov edx, OFFSET Spock24
	call WriteString
	call Crlf
	mov edx, OFFSET Spock25
	call WriteString
	call Crlf

	call Crlf
	call CRLF
	mov edx, OFFSET PromptYouWin
	call WriteString
	mov eax, ChipsPlayer
	call WriteInt   
	call CRLF
	Call PlayAgain
Win ENDP

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Lose PROC																																								;
;	Recieves: PromptLoseImage, PromptYouLose, PlayerChips																												;
;	Returns: Nothing																																					;
;	Display image and earnings, calls PlayAgain																															;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
	call Clrscr
	call Crlf
	mov edx, OFFSET Spock2
	call WriteString
	call Crlf
	mov edx, OFFSET Spock3
	call WriteString
	call Crlf
	mov edx, OFFSET Spock4
	call WriteString
	call Crlf
	mov edx, OFFSET Spock5
	call WriteString
	call Crlf
	mov edx, OFFSET Spock6
	call WriteString
	call Crlf
	mov edx, OFFSET Spock7
	call WriteString
	call Crlf
	mov edx, OFFSET Spock8
	call WriteString
	call Crlf
	mov edx, OFFSET Spock9
	call WriteString
	call Crlf
	mov edx, OFFSET Spock10
	call WriteString
	call Crlf
	mov edx, OFFSET Spock11
	call WriteString
	call Crlf
	mov edx, OFFSET Spock12
	call WriteString
	call Crlf
	mov edx, OFFSET Spock13
	call WriteString
	call Crlf
	mov edx, OFFSET Spock14
	call WriteString
	call Crlf
	mov edx, OFFSET Spock15
	call WriteString
	call Crlf
	mov edx, OFFSET Spock16
	call WriteString
	call Crlf
	mov edx, OFFSET Spock17
	call WriteString
	call Crlf
	mov edx, OFFSET Spock18
	call WriteString
	call Crlf
	mov edx, OFFSET Spock19
	call WriteString
	call Crlf
	mov edx, OFFSET Spock20
	call WriteString
	call Crlf
	mov edx, OFFSET Spock21
	call WriteString
	call Crlf
	mov edx, OFFSET Spock22
	call WriteString
	call Crlf
	mov edx, OFFSET Spock23
	call WriteString
	call Crlf
	mov edx, OFFSET Spock24
	call WriteString
	call Crlf
	mov edx, OFFSET Spock25
	call WriteString
	call Crlf

	call Crlf
	call CRLF
	mov edx, OFFSET PromptYouLose
	call WriteString
	mov eax, ChipsPlayer
	call WriteInt   
	call CRLF
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
Bid PROC
;Logic for spock ai biding if will lose then fold if hand value low bid low, if hand value high bid high, if out of chips fold
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

Call Display

mov ChipsCall, 0
	call HandValue
.if(FoldS == 1)
	ret
.elseif(FoldP == 1)
	ret
.elseif(bigblind == 1) ;spock bid first
	mov edx, OFFSET PromptSpockTurn
	call WriteString
	call CRLF
		.if(SpockHandValue > 8)
			mov edi, ChipsSpock
			sub ChipsSpock, edi
			mov SpockBet,edi
			add ChipsTable, edi
			mov ChipsCall, edi
			
			mov edx, OFFSET PromptSpockBet
			call WriteString
			mov eax, edi
			call writeint
			call CRLF

		.elseif(SpockHandValue > 4)
			.if(ChipsSpock < 100)
				mov edi, ChipsSpock
				sub ChipsSpock, edi
				mov SpockBet,edi
				add ChipsTable, edi
				mov ChipsCall, edi	
				
				mov edx, OFFSET PromptSpockBet
				call WriteString
				mov eax, edi
				call writeint
				call CRLF		
			
			.else
				mov edi, 100
				sub ChipsSpock, edi
				mov SpockBet,edi
				add ChipsTable, edi
				mov ChipsCall, edi

				mov edx, OFFSET PromptSpockBet
				call WriteString
				mov eax, edi
				call writeint
				call CRLF

			.endif
		.elseif(SpockHandValue > 1)
			.if(ChipsSpock < 50)
				mov edi, ChipsSpock
				sub ChipsSpock, edi
				mov SpockBet,edi
				add ChipsTable, edi
				mov ChipsCall, edi

				mov edx, OFFSET PromptSpockBet
				call WriteString
				mov eax, edi
				call writeint
				call CRLF

			.else
				mov edi, 50
				sub ChipsSpock, edi
				mov SpockBet,edi
				add ChipsTable, edi
				mov ChipsCall, edi

				mov edx, OFFSET PromptSpockBet
				call WriteString
				mov eax, edi
				call writeint
				call CRLF

			.endif
		.elseif(HighCardS > 4)
			.if(ChipsSpock < 25)
				mov edi, ChipsSpock
				sub ChipsSpock, edi
				mov SpockBet,edi
				add ChipsTable, edi
				mov ChipsCall, edi

				mov edx, OFFSET PromptSpockBet
				call WriteString
				mov eax, edi
				call writeint
				call CRLF

			.else
				mov edi, 25
				sub ChipsSpock, edi
				mov SpockBet, edi
				add ChipsTable, edi
				mov ChipsCall, edi

				mov edx, OFFSET PromptSpockBet
				call WriteString
				mov eax, edi
				call writeint
				call CRLF

			.endif
		.elseif(HighCardS < 5)
			mov FoldS, 1

			mov edx, OFFSET PromptSpockFold
			call WriteString
			call CRLF
		.endif

		mov edx, OFFSET PromptPlayerSecond
		call WriteString
		call CRLF
			BadInput1:
				Call ReadInt
					.if(eax==1)
						mov edx, OFFSET PromptPlayerRaise
						Call WriteString
						call readint
						call CRLF
						mov ChipsCall, eax
						mov esi, ChipsCall
						add eax, esi
						sub ChipsPlayer, eax
						add ChipsTable, eax
						mov esi, SpockBet
						sub eax, esi
							.if(ChipsSpock < eax)
								mov FoldS, 1
								mov edx, OFFSET PromptSpockFold
								call WriteString
								call CRLF
								ret
							.else
								sub ChipsSpock, eax
								add ChipsTable, eax
								mov edx, OFFSET PromptSpockCall
								Call WriteString
								call CRLF
								ret
							.endif
					.elseif(eax==2)
						mov edx, OFFSET PromptPlayerCall
						Call WriteString
						call CRLF
						mov eax, ChipsCall
						sub ChipsPlayer, eax
						add ChipsTable, eax
						ret
					.elseif(eax==0)
						mov FoldP, 1
						mov edx, OFFSET PromptPlayerFold
						call WriteString
						call CRLF
						ret
					.else
						mov edx, OFFSET PromptBadInput
						Call WriteString
						call CRLF
						jmp BadInput1
					.endif
	
	.elseif(BigBlind==0)												;player turn
		mov edx, OFFSET PromptPlayerTurn
		call WriteString
		call CRLF
		mov edx, OFFSET PromptPlayerBet
		call WriteString
		call CRLF
			BadInput:
				Call ReadInt
					.if(eax==1)
						mov edx, OFFSET PromptPlayerRaise
						Call WriteString
						call readint
						call CRLF
						sub ChipsPlayer, eax
						add ChipsTable, eax
						mov ChipsCall, eax
						add eax, 100

							.if(ChipsSpock < edi)
								mov FoldS, 1
								mov edx, OFFSET PromptSpockFold
								call WriteString
								call CRLF
								ret
							.elseif(SpockHandValue < 1)
										.if(SpockHandValue > 8)
											mov edi, ChipsCall
											add edi, 50
											sub ChipsSpock, edi
											mov SpockBet,edi
											add ChipsTable, edi
											mov ChipsCall, edi
			
											mov edx, OFFSET PromptSpockBet
											call WriteString
											mov eax, edi
											call writeint
											call CRLF

										.elseif(SpockHandValue > 4)
											mov edi, ChipsCall
											add edi, 50
											.if(ChipsSpock < edi)
												mov edi, ChipsSpock
												mov edi, ChipsCall
												add edi, 50
												sub ChipsSpock, edi
												mov SpockBet,edi
												add ChipsTable, edi
												mov ChipsCall, edi
			
												mov edx, OFFSET PromptSpockBet
												call WriteString
												mov eax, edi
												call writeint
												call CRLF		
			
											.else
												mov edi, 50
												sub ChipsSpock, edi
												mov SpockBet,edi
												add ChipsTable, edi
												mov ChipsCall, edi

												mov edx, OFFSET PromptSpockBet
												call WriteString
												mov eax, edi
												call writeint
												call CRLF

											.endif
										.elseif(SpockHandValue > 1)
											mov edi, ChipsCall
											add edi, 25
											.if(ChipsSpock < edi)
												mov edi, ChipsSpock
												sub ChipsSpock, edi
												mov SpockBet,edi
												add ChipsTable, edi
												mov ChipsCall, edi

												mov edx, OFFSET PromptSpockBet
												call WriteString
												mov eax, edi
												call writeint
												call CRLF

											.else
												mov edi, 25
												sub ChipsSpock, edi
												mov SpockBet,edi
												add ChipsTable, edi
												mov ChipsCall, edi

												mov edx, OFFSET PromptSpockBet
												call WriteString
												mov eax, edi
												call writeint
												call CRLF

											.endif
										.elseif(HighCardS > 4)
										mov edi, ChipsCall
											.if(ChipsSpock < edi)
												mov edi, ChipsSpock
												sub ChipsSpock, edi
												mov SpockBet,edi
												add ChipsTable, edi
												mov ChipsCall, edi

												mov edx, OFFSET PromptSpockCall
												call WriteString
												mov eax, edi
												call writeint
												call CRLF

											.else
												mov edi, ChipsCall
												sub ChipsSpock, edi
												mov SpockBet, edi
												add ChipsTable, edi
												mov ChipsCall, edi

												mov edx, OFFSET PromptSpockCall
												call WriteString
												mov eax, edi
												call writeint
												call CRLF
				
											.endif
										.elseif(HighCardS < 5)
											mov FoldS, 1
											mov edx, OFFSET PromptSpockFold
											call WriteString
											call CRLF
										.endif
							
							.elseif(SpockHandValue > 0)
								mov edi, ChipsCall
								sub ChipsSpock, edi
								add ChipsTable, edi
								mov edx, OFFSET PromptSpockCall
								call WriteString
								call CRLF			

							.endif
						ret

					.elseif(eax==2)
						mov edx, OFFSET PromptPlayerCall
						Call WriteString
						call CRLF
						mov eax, ChipsCall
						sub ChipsPlayer, eax
						add ChipsTable, eax
						ret
					.elseif(eax==0)
						mov FoldP, 1
						mov edx, OFFSET PromptPlayerFold
						call WriteString
						call CRLF
						ret
					.else
						mov edx, OFFSET PromptBadInput
						Call WriteString
						call CRLF
						jmp BadInput
					.endif
.endif


	ret
Bid ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
HandValue PROC
;clear hand values and reassess based on variables with stored data
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

mov isSpadeP, 0
mov isHeartP, 0
mov isClubP, 0
mov isDimondP, 0
mov isFlushP, 0
mov isSpadeS, 0
mov isHeartS, 0
mov isClubS, 0
mov isDimondS, 0
mov isFlushS, 0
mov isStraightS, 0
mov isStraightP, 0

mov RFp, 0
mov RFs, 0
mov HighFourS, 0
mov HighFourP, 0
mov HighThreeS, 0
mov HighThreeP, 0
mov High2PairS, 0
mov High2PairP, 0
mov Low2PairS, 0
mov Low2PairP, 0
mov PairS, 0
mov PairP, 0
mov HighPairS, 0
mov HighPairP, 0
mov HighSts, 0
mov HighStp, 0
mov HighCards, 0
mov HighCardp, 0

mov PlayerRoyal, 0
mov PlayerStraightFlush, 0
mov PlayerFour, 0
mov PlayerFull, 0
mov PlayerFlush, 0
mov PlayerStraight, 0
mov PlayerThree, 0
mov PlayerTwoPair, 0
mov PlayerOnePair, 0
mov PlayerHandValue, 0

mov SpockRoyal, 0
mov SpockStraightFlush, 0
mov SpockFour, 0
mov SpockFull, 0
mov SpockFlush, 0
mov SpockStraight, 0
mov SpockThree, 0
mov SpockTwoPair, 0
mov SpockOnePair, 0
mov SpockHandValue, 0

	call IsAFlush
	call IsAStraight
	call FourKind
	call ThreeKind
	call TwoPair
	call FullHouse
	Call HighCard

	.if(SpockRoyal > 0)
		mov SpockHandValue, 9
		.elseif(SpockStraightFlush > 0)
			mov SpockHandValue, 8
		.elseif(SpockFour > 0)
			mov SpockHandValue, 7
		.elseif(SpockFull > 0)
			mov SpockHandValue, 6
		.elseif(SpockFlush > 0)
			mov SpockHandValue, 5
		.elseif(SpockStraight > 0)
			mov SpockHandValue, 4
		.elseif(SpockThree > 0)
			mov SpockHandValue, 3
		.elseif(SpockTwoPair > 0)
			mov SpockHandValue, 2
		.elseif(SpockOnePair > 0)
			mov SpockHandValue, 1
		.else
			mov SpockHandValue,0
	.endif

	.if(PlayerRoyal > 0)
		mov PlayerHandValue, 9
		.elseif(PlayerStraightFlush > 0)
			mov PlayerHandValue, 8
		.elseif(PlayerFour > 0)
			mov PlayerHandValue, 7
		.elseif(PlayerFull > 0)
			mov PlayerHandValue, 6
		.elseif(PlayerFlush > 0)
			mov PlayerHandValue, 5
		.elseif(PlayerStraight > 0)
			mov PlayerHandValue, 4
		.elseif(PlayerThree > 0)
			mov PlayerHandValue, 3
		.elseif(PlayerTwoPair > 0)
			mov PlayerHandValue, 2
		.elseif(PlayerOnePair > 0)
			mov PlayerHandValue, 1
		.else
			mov PlayerHandValue,0
	.endif 

	ret
HandValue ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
CompareHand Proc
;Looks at player hand value and compairs against eachother for win lose or tie
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

Call DisplaySpock

	Call HandValue


	.if(FoldS==1)
	mov SpockHandValue,0
	mov HighCards,0
	mov EDX, OFFSET SFOLD
	Call writestring
	call crlf
.endif

.if(FoldP==1)
	mov PlayerHandValue,0
	mov HighCardP,0
	mov edx, OFFSET Pfold
	Call writestring
	call crlf
.endif

	mov esi, PlayerHandValue
	mov edi, SpockHandValue	
	
	.if(esi>edi)
		mov eax, ChipsTable
		add ChipsPlayer, eax
		mov ChipsTable, 0
		mov EDX, OFFSET PromptHandWinP
		call writestring
		call crlf

	.elseif(edi>esi)
		mov eax, ChipsTable
		add ChipsSpock, eax
		mov ChipsTable, 0
		mov EDX, OFFSET PromptHandWinS
		call writestring
		call crlf
	.else
		mov al, HighCardp
		mov bl, Highcards
			.if(al>bl)
				mov eax, ChipsTable
				add ChipsPlayer, eax
				mov ChipsTable, 0
			.elseif(bl>al)
				mov eax, ChipsTable
				add ChipsSpock, eax
				mov ChipsTable, 0
			.elseif(al==bl)
				mov eax, ChipsTable
				mov ebx, 2
				sub edx, edx
				div ebx
				add ChipsSpock, eax
				add ChipsPlayer, eax
				mov ChipsTable, 0
			.endif
		mov EDX, OFFSET PromptHandWinT
		call writestring
		call crlf

	.endif
	mov FoldP, 0
	mov FoldS, 0
	Call RoundWinner
	mov cards1.suit, 0
	mov cards2.suit, 0
	mov cards3.suit, 0
	mov cards4.suit, 0
	mov cards5.suit, 0
	mov cards6.suit, 0
	mov cards7.suit, 0
	ret
CompareHand ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
IsAFlush Proc
;organize and calculate if person has 5 or more cards of same suit based off card.suit
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
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
	.if(isFlushS>0)
		mov SpockFlush,1
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

	.if(isFlushP>0)
		mov PlayerFlush, 1
	.endif

ret
IsAFlush ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
IsAStraight Proc
;organize *player/spockhand into numerical order based off card.value
;if card a = card b then card a=card b and card b= card c
;if subtraction of card a - card b = 1 then go on to check if card a = card b
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

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

mov esi,0
mov edi,1
	mov al, straights[esi]
	mov bl, straights[edi]
	mov var1, esi
	mov var2, edi
	.if(al==bl)
		inc edi
		mov bl, straights[edi]
	.endif
	.if(al==bl)
		inc edi
		mov bl, straights[edi]
	.endif
	sub al,bl
	inc esi
	inc edi
		.if(al==bl)
			mov al, straights[esi]
			mov bl, straights[edi]
			.if(al==bl)
				inc edi
				mov bl, straights[edi]
			.endif
			.if(al==bl)
				inc edi
				mov bl, straights[edi]
			.endif
			sub al,bl
			inc esi
			inc edi
				.if(al==bl)
					mov al, straights[esi]
					mov bl, straights[edi]
					.if(al==bl)
						inc edi
						mov bl, straights[edi]
					.endif
					.if(al==bl)
						inc edi
						mov bl, straights[edi]
					.endif
					sub al,bl
					inc esi
					inc edi
						.if(al==bl)
							mov al, straights[esi]
								mov bl, straights[edi]
								.if(al==bl)
									inc edi
									mov bl, straights[edi]
								.endif
								.if(al==bl)
									inc edi
									mov bl, straights[edi]
								.endif
								sub al,bl
								inc esi
								inc edi
									.if(al==bl)
										mov al, straights[esi]
										mov bl, straights[edi]
										.if(al==bl)
											inc edi
											mov bl, straights[edi]
										.endif
										.if(al==bl)
											inc edi
											mov bl, straights[edi]
										.endif
										sub al,bl
										inc esi
										inc edi
											.if(al==bl)
												inc isstraights
												mov esi, var1
												mov al, straights[esi]
													.if(HighSts < al)
														mov HighSts, al
													.endif

									.endif
							.endif
					.endif
			.endif
	.endif
mov esi, var1
mov edi, var2
inc esi
inc edi

	mov al, straights[esi]
	mov bl, straights[edi]
	mov esi, var1
	mov edi, var2
	.if(al==bl)
		inc edi
		mov bl, straights[edi]
	.endif
	.if(al==bl)
		inc edi
		mov bl, straights[edi]
	.endif
	sub al,bl
	inc esi
	inc edi
		.if(al==bl)
			mov al, straights[esi]
			mov bl, straights[edi]
			.if(al==bl)
				inc edi
				mov bl, straights[edi]
			.endif
			.if(al==bl)
				inc edi
				mov bl, straights[edi]
			.endif
			sub al,bl
			inc esi
			inc edi
				.if(al==bl)
					mov al, straights[esi]
					mov bl, straights[edi]
					.if(al==bl)
						inc edi
						mov bl, straights[edi]
					.endif
					.if(al==bl)
						inc edi
						mov bl, straights[edi]
					.endif
					sub al,bl
					inc esi
					inc edi
						.if(al==bl)
							mov al, straights[esi]
								mov bl, straights[edi]
								.if(al==bl)
									inc edi
									mov bl, straights[edi]
								.endif
								.if(al==bl)
									inc edi
									mov bl, straights[edi]
								.endif
								sub al,bl
								inc esi
								inc edi
									.if(al==bl)
										mov al, straights[esi]
										mov bl, straights[edi]
										.if(al==bl)
											inc edi
											mov bl, straights[edi]
										.endif
										.if(al==bl)
											inc edi
											mov bl, straights[edi]
										.endif
										sub al,bl
										inc esi
										inc edi
											.if(al==bl)
												inc isstraights
												mov esi, var1
												mov al, straights[esi]
													.if(HighSts < al)
														mov HighSts, al
													.endif
									.endif
							.endif
					.endif
			.endif
	.endif
mov esi,var1
mov edi,var2
inc esi
inc edi

	mov al, straights[esi]
	mov bl, straights[edi]
	.if(al==bl)
		inc edi
		mov bl, straights[edi]
	.endif
	.if(al==bl)
		inc edi
		mov bl, straights[edi]
	.endif
	sub al,bl
	inc esi
	inc edi
		.if(al==bl)
			mov al, straights[esi]
			mov bl, straights[edi]
			.if(al==bl)
				inc edi
				mov bl, straights[edi]
			.endif
			.if(al==bl)
				inc edi
				mov bl, straights[edi]
			.endif
			sub al,bl
			inc esi
			inc edi
				.if(al==bl)
					mov al, straights[esi]
					mov bl, straights[edi]
					.if(al==bl)
						inc edi
						mov bl, straights[edi]
					.endif
					.if(al==bl)
						inc edi
						mov bl, straights[edi]
					.endif
					sub al,bl
					inc esi
					inc edi
						.if(al==bl)
							mov al, straights[esi]
								mov bl, straights[edi]
								.if(al==bl)
									inc edi
									mov bl, straights[edi]
								.endif
								.if(al==bl)
									inc edi
									mov bl, straights[edi]
								.endif
								sub al,bl
								inc esi
								inc edi
									.if(al==bl)
										mov al, straights[esi]
										mov bl, straights[edi]
										.if(al==bl)
											inc edi
											mov bl, straights[edi]
										.endif
										.if(al==bl)
											inc edi
											mov bl, straights[edi]
										.endif
										sub al,bl
										inc esi
										inc edi
											.if(al==bl)
												inc isstraights
												mov esi, var1
												mov al, straights[esi]
													.if(HighSts < al)
														mov HighSts, al
													.endif
									.endif
							.endif
					.endif
			.endif
	.endif

	.if(HighSts==13)
		.if(SpockFlush > 0)
			mov SpockRoyal, 1
		.endif
	.endif

	.if (HighStS > 0)
		mov SpockStraight,1
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

	
mov esi,0
mov edi,1
	mov var1, esi
	mov var2, edi
	mov al, straightp[esi]
	mov bl, straightp[edi]
	.if(al==bl)
		inc edi
		mov bl, straightp[edi]
	.endif
	.if(al==bl)
		inc edi
		mov bl, straightp[edi]
	.endif
	sub al,bl
	inc esi
	inc edi
		.if(al==bl)
			mov al, straightp[esi]
			mov bl, straightp[edi]
			.if(al==bl)
				inc edi
				mov bl, straightp[edi]
			.endif
			.if(al==bl)
				inc edi
				mov bl, straightp[edi]
			.endif
			sub al,bl
			inc esi
			inc edi
				.if(al==bl)
					mov al, straightp[esi]
					mov bl, straightp[edi]
					.if(al==bl)
						inc edi
						mov bl, straightp[edi]
					.endif
					.if(al==bl)
						inc edi
						mov bl, straightp[edi]
					.endif
					sub al,bl
					inc esi
					inc edi
						.if(al==bl)
							mov al, straightp[esi]
								mov bl, straightp[edi]
								.if(al==bl)
									inc edi
									mov bl, straightp[edi]
								.endif
								.if(al==bl)
									inc edi
									mov bl, straightp[edi]
								.endif
								sub al,bl
								inc esi
								inc edi
									.if(al==bl)
										mov al, straightp[esi]
										mov bl, straightp[edi]
										.if(al==bl)
											inc edi
											mov bl, straightp[edi]
										.endif
										.if(al==bl)
											inc edi
											mov bl, straightp[edi]
										.endif
										sub al,bl
										inc esi
										inc edi
											.if(al==bl)
												inc isstraightp
												mov esi, var1
												mov al, straightP[esi]
													.if(HighStP < al)
														mov HighStP, al
													.endif
									.endif
							.endif
					.endif
			.endif
	.endif
	mov esi, var1
	mov edi, var2
	inc esi
	inc edi

	mov var1, esi
	mov var2, edi
	mov al, straightp[esi]
	mov bl, straightp[edi]
	.if(al==bl)
		inc edi
		mov bl, straightp[edi]
	.endif
	.if(al==bl)
		inc edi
		mov bl, straightp[edi]
	.endif
	sub al,bl
	inc esi
	inc edi
		.if(al==bl)
			mov al, straightp[esi]
			mov bl, straightp[edi]
			.if(al==bl)
				inc edi
				mov bl, straightp[edi]
			.endif
			.if(al==bl)
				inc edi
				mov bl, straightp[edi]
			.endif
			sub al,bl
			inc esi
			inc edi
				.if(al==bl)
					mov al, straightp[esi]
					mov bl, straightp[edi]
					.if(al==bl)
						inc edi
						mov bl, straightp[edi]
					.endif
					.if(al==bl)
						inc edi
						mov bl, straightp[edi]
					.endif
					sub al,bl
					inc esi
					inc edi
						.if(al==bl)
							mov al, straightp[esi]
								mov bl, straightp[edi]
								.if(al==bl)
									inc edi
									mov bl, straightp[edi]
								.endif
								.if(al==bl)
									inc edi
									mov bl, straightp[edi]
								.endif
								sub al,bl
								inc esi
								inc edi
									.if(al==bl)
										mov al, straightp[esi]
										mov bl, straightp[edi]
										.if(al==bl)
											inc edi
											mov bl, straightp[edi]
										.endif
										.if(al==bl)
											inc edi
											mov bl, straightp[edi]
										.endif
										sub al,bl
										inc esi
										inc edi
											.if(al==bl)
												inc isstraightp
												mov esi, var1
												mov al, straightp[esi]
													.if(HighStp < al)
														mov HighStp, al
													.endif
									.endif
							.endif
					.endif
			.endif
	.endif
	mov esi, var1
	mov edi,var2
	inc esi
	inc edi

	mov var1,esi
	mov var2, edi
	mov al, straightp[esi]
	mov bl, straightp[edi]
	.if(al==bl)
		inc edi
		mov bl, straightp[edi]
	.endif
	.if(al==bl)
		inc edi
		mov bl, straightp[edi]
	.endif
	sub al,bl
	inc esi
	inc edi
		.if(al==bl)
			mov al, straightp[esi]
			mov bl, straightp[edi]
			.if(al==bl)
				inc edi
				mov bl, straightp[edi]
			.endif
			.if(al==bl)
				inc edi
				mov bl, straightp[edi]
			.endif
			sub al,bl
			inc esi
			inc edi
				.if(al==bl)
					mov al, straightp[esi]
					mov bl, straightp[edi]
					.if(al==bl)
						inc edi
						mov bl, straightp[edi]
					.endif
					.if(al==bl)
						inc edi
						mov bl, straightp[edi]
					.endif
					sub al,bl
					inc esi
					inc edi
						.if(al==bl)
							mov al, straightp[esi]
								mov bl, straightp[edi]
								.if(al==bl)
									inc edi
									mov bl, straightp[edi]
								.endif
								.if(al==bl)
									inc edi
									mov bl, straightp[edi]
								.endif
								sub al,bl
								inc esi
								inc edi
									.if(al==bl)
										mov al, straightp[esi]
										mov bl, straightp[edi]
										.if(al==bl)
											inc edi
											mov bl, straightp[edi]
										.endif
										.if(al==bl)
											inc edi
											mov bl, straightp[edi]
										.endif
										sub al,bl
										inc esi
										inc edi
											.if(al==bl)
												inc isstraightp
												mov esi, var1
												mov al, straightp[esi]
													.if(HighStp < al)
														mov HighStp, al
													.endif
									.endif
							.endif
					.endif
			.endif
	.endif

	.if(HighStP==13)
		.if(PlayerFlush > 0)
			mov PlayerRoyal, 1
		.endif
	.endif
	.if (HighStP > 0)
		mov PlayerStraight, 1
	.endif

ret
IsAStraight ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
 FourKind PROC
; compute if person has four cards of same value if card a=b=c=d if not b=c=d=e if...
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
mov ecx, 4
mov esi,0
mov edi,1
	FKs:
		mov al, straights[esi]
		mov bl, straights[edi]
		mov var1, esi
		inc esi
		mov var2, edi
		inc edi
			.if(al==bl)
				mov al, straights[esi]
				mov bl, straights[edi]
				inc esi
				inc edi
					.if(al==bl)
						mov al, straights[esi]
						mov bl, straights[edi]
						inc esi
						inc edi
							.if(al==bl)
								mov SpockFour,1
								mov al, straights[esi]
								mov HighFourS, al
								mov edi,var2
								mov esi,var1
								inc esi
								inc edi
							.endif
					.endif
			.endif
	Loop FKS

;Player

	mov ecx, 4
mov esi,0
mov edi,1
	FKp:
		mov al, straightp[esi]
		mov bl, straightp[edi]
		mov var1, esi
		inc esi
		mov var2, edi
		inc edi
			.if(al==bl)
				mov al, straightp[esi]
				mov bl, straightp[edi]
				inc esi
				inc edi
					.if(al==bl)
						mov al, straightp[esi]
						mov bl, straightp[edi]
						inc esi
						inc edi
							.if(al==bl)
								mov PlayerFour,1
								mov al, straightp[esi]
								mov HighFourP, al
								mov edi,var2
								mov esi,var1
								inc esi
								inc edi
							.endif
					.endif
			.endif
	Loop FKp
ret
FourKind ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
FullHouse PROC
;If 3 of a kind and pair then person has full house
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

.if(HighThrees > 0)
	.if(High2Pairs > 0)
		mov SpockFull, 1
	.endif
.endif

.if(HighThreep > 0)
	.if(High2Pairp > 0)
		mov PlayerFull, 1
	.endif
.endif

ret
FullHouse ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
ThreeKind PROC
;compute if three of a kind
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

mov ecx,5
mov esi,0
mov edi,1

	TKS:
		mov var1, esi
		mov var2, edi
		mov al, straights[esi]
		mov bl, straights[edi]
			.if(al==bl)
				inc esi
				inc edi
				mov al, straights[esi]
				mov bl, straights[edi]
					.if(al==bl)
								mov esi, var1
								mov al, straights[esi]
									.if(HighThreeS < al)
										mov HighThreeS,al
							.endif
					.endif
			.endif
		mov esi,var1
		mov edi, var2
		inc esi
		inc edi
	Loop TKS
	.if(HighThreeS > 0)
		mov SpockThree, 1
	.endif

;player

mov ecx,5
mov esi,0
mov edi,1

	TKP:
		mov var1, esi
		mov var2, edi
		mov al, straightP[esi]
		mov bl, straightP[edi]
			.if(al==bl)
				inc esi
				inc edi
				mov al, straightP[esi]
				mov bl, straightP[edi]
							.if(al==bl)
								mov esi, var1
								mov al, straightP[esi]
									.if(HighThreeP < al)
										mov HighThreeP,al
							.endif
					.endif
			.endif
		mov esi,var1
		mov edi, var2
		inc esi
		inc edi
	Loop TKP
	.if(HighThreeP > 0)
		mov PlayerThree,1
	.endif
ret
ThreeKind ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
TwoPair PROC
;Compute 2pair
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

mov ecx,6
mov esi,0
mov edi,1
TPS:
	mov al, straights[esi]
	mov bl, straights[edi]
		.if(al==bl)
			.if(al > High2Pairs)
				mov High2Pairs, al
				mov SpockOnePair,1
			.elseif (al > low2pairs)
				mov Low2Pairs, al
			.else	
				mov Pairs, al
			.endif
		.endif
	inc esi
	inc edi
Loop TPS

	.if(High2pairs>0)
		.if(Low2pairs>0)
			mov SpockTwoPair, 1
		.endif
	.endif

;player

mov ecx,6
mov esi,0
mov edi,1
TPP:
	mov al, straightp[esi]
	mov bl, straightp[edi]
		.if(al==bl)
			.if(al > High2Pairp)
				mov High2Pairp, al
				mov PlayerOnePair,1
			.elseif (al > low2pairp)
				mov Low2Pairp, al
			.else	
				mov Pairp, al
			.endif
		.endif
	inc esi
	inc edi
Loop TPP

	.if(High2pairp>0)
		.if(Low2pairp>0)
			mov PlayerTwoPair, 1
		.endif
	.endif

ret
TwoPair ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;


;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
HighCard PROC
;Compute highes card from is hand organized by straight
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
mov al, straights[0]
mov HighCards,al

mov al, straightp[0]
mov HighCardp, al
ret
HighCard ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
Display PROC
;Display Cards except for spock
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
	mov PromptSuit, "X"
	Call HandSpock
	Call HandPlayer
	call clrscr

;Spock

	mov edx, OFFSET PromptShowSpock
	Call writestring
	call crlf
	mov edx, OFFSET PromptShowSpockChips
	call writestring
	mov eax, ChipsSpock
	call writeint
	call crlf
	call crlf

;Table

	mov edx, OFFSET PromptShowTable1
	call writestring
	mov bl, cards1.value
	ConvertValue
	.else
		mov edx, OFFSET PromptSuit
		call writestring
	.endif
	mov bl, cards1.suit
	ConvertSuit
	mov al,  PromptSuit
	call writechar

	mov edx, OFFSET PromptShowTable2
	call writestring
	mov bl, cards2.value
	ConvertValue
	.else
		BlankCard
	.endif
	mov bl, cards2.suit
	ConvertSuit
	mov al,  PromptSuit
	call writechar

	mov edx, OFFSET PromptShowTable2
	call writestring
	mov bl, cards3.value
	ConvertValue
	.else
		BlankCard
	.endif
	mov bl, cards3.suit
	ConvertSuit
	mov al, PromptSuit
	call writechar

	mov edx, OFFSET PromptShowTable2
	call writestring
	mov bl, cards4.value
	ConvertValue
	.else
		BlankCard
	.endif
	mov bl, cards4.suit
	ConvertSuit
	mov al, PromptSuit
	call writechar

	mov edx, OFFSET PromptShowTable2
	call writestring
	mov bl, cards5.value
	ConvertValue
	.else
		BlankCard
	.endif
	mov bl, cards5.suit
	ConvertSuit
	mov al, PromptSuit
	call writechar

	mov edx, OFFSET PromptShowTable3
	call writestring
	call crlf
	mov edx, OFFSET PromptShowTableChips
	call writestring
	mov eax, ChipsTable
	call writeint
	call crlf
	call crlf

; Player

	mov edx, OFFSET PromptShowPlayer1
	call writestring
	mov bl, cardp6.value
	ConvertValue
	.else
		BlankCard
	.endif
	mov bl, cardp6.suit
	ConvertSuit
	mov al,  PromptSuit
	call writechar

	mov edx, OFFSET PromptShowPlayer2
	call writestring
	mov bl, cardp7.value
	ConvertValue
	.else
		BlankCard
	.endif
	mov bl, cardp7.suit
	ConvertSuit
	mov al,  PromptSuit
	call writechar

	mov edx, OFFSET PromptShowPlayer3
	call writestring
	call crlf
	mov edx, OFFSET PromptShowPlayerChips
	call writestring
	mov eax, ChipsPlayer
	call writeint
	call crlf
	call crlf
	

ret
Display ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
DisplaySpock PROC
;Display Spocks cards
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
	mov PromptSuit, "X"
	Call HandSpock
	Call HandPlayer
	call clrscr

;Spock

	mov EDX, OFFSET PromptShowSpock1
	call writestring
	mov bl, cards6.value
	ConvertValue
	.else
		BlankCard
	.endif
	mov bl, cards6.suit
	ConvertSuit
	mov al,  PromptSuit
	call writechar

	mov edx, OFFSET PromptShowPlayer2
	call writestring
	mov bl, cards7.value
	ConvertValue
	.else
		BlankCard
	.endif
	mov bl, cards7.suit
	ConvertSuit
	mov al,  PromptSuit
	call writechar

	mov edx, OFFSET PromptShowPlayer3
	call writestring
	call crlf
	mov edx, OFFSET PromptShowSpockChips
	call writestring
	mov eax, ChipsSpock
	call writeint
	call crlf
	call crlf

;Table

	mov edx, OFFSET PromptShowTable1
	call writestring
	mov bl, cards1.value
	ConvertValue
	.else
		mov edx, OFFSET PromptSuit
		call writestring
	.endif
	mov bl, cards1.suit
	ConvertSuit
	mov al,  PromptSuit
	call writechar

	mov edx, OFFSET PromptShowTable2
	call writestring
	mov bl, cards2.value
	ConvertValue
	.else
		BlankCard
	.endif
	mov bl, cards2.suit
	ConvertSuit
	mov al,  PromptSuit
	call writechar

	mov edx, OFFSET PromptShowTable2
	call writestring
	mov bl, cards3.value
	ConvertValue
	.else
		BlankCard
	.endif
	mov bl, cards3.suit
	ConvertSuit
	mov al,  PromptSuit
	call writechar

	mov edx, OFFSET PromptShowTable2
	call writestring
	mov al, cards4.value
	ConvertValue
	.else
		BlankCard
	.endif
	mov bl, cards4.suit
	ConvertSuit
	mov al,  PromptSuit
	call writechar

	mov edx, OFFSET PromptShowTable2
	call writestring
	mov bl, cards5.value
	ConvertValue
	.else
		BlankCard
	.endif
	mov bl, cards5.suit
	ConvertSuit
	mov al,  PromptSuit
	call writechar

	mov edx, OFFSET PromptShowTable3
	call writestring
	call crlf
	mov edx, OFFSET PromptShowTableChips
	call writestring
	mov eax, ChipsTable
	call writeint
	call crlf
	call crlf

; Player

	mov edx, OFFSET PromptShowPlayer1
	call writestring
	mov bl, cardp6.value
	ConvertValue
	.else
		BlankCard
	.endif
	mov bl, cardp6.suit
	ConvertSuit
	mov al,  PromptSuit
	call writechar

	mov edx, OFFSET PromptShowPlayer2
	call writestring
	mov bl, cardp7.value
	ConvertValue
	.else
		BlankCard
	.endif
	mov bl, cardp7.suit
	ConvertSuit
	mov al,  PromptSuit
	call writechar

	mov edx, OFFSET PromptShowPlayer3
	call writestring
	call crlf
	mov edx, OFFSET PromptShowPlayerChips
	call writestring
	mov eax, ChipsPlayer
	call writeint
	call crlf
	call crlf

ret
DisplaySpock ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
RoundWinner PROC
;Display hand values and who wins
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
;Spock
	.if(SpockHandValue == 9)
		mov EDX, OFFSET PromptHandVS1
		call WriteString
		mov EDX, OFFSET PromptRF
		Call WriteString
	.elseif(SpockHandValue == 8)
		mov EDX, OFFSET PromptHandVS1
		call WriteString
		mov EDX, OFFSET PromptSF
		Call WriteString
	.elseif(SpockHandValue == 7)
		mov EDX, OFFSET PromptHandVS1
		call WriteString
		mov EDX, OFFSET PromptFK
		Call WriteString
		mov EDX, OFFSET PromptHandVP2
		call writestring
	.elseif(SpockHandValue == 6)
		mov EDX, OFFSET PromptHandVS1
		call WriteString
		mov EDX, OFFSET PromptFH
		Call WriteString
	.elseif(SpockHandValue == 5)
		mov EDX, OFFSET PromptHandVS1
		call WriteString
		mov EDX, OFFSET PromptFL
		Call WriteString
	.elseif(SpockHandValue == 4)
		mov EDX, OFFSET PromptHandVS1
		call WriteString
		mov EDX, OFFSET PromptST
		Call WriteString
	.elseif(SpockHandValue == 3)
		mov EDX, OFFSET PromptHandVS1
		call WriteString
		mov EDX, OFFSET PromptTK
		Call WriteString
		mov EDX, OFFSET PromptHandVP2
		call writestring
	.elseif(SpockHandValue == 2)
		mov EDX, OFFSET PromptHandVS1
		call WriteString
		mov EDX, OFFSET PromptTP
		Call WriteString
		mov EDX, OFFSET PromptHandVP2
		call writestring
	.elseif(SpockHandValue == 1)
		mov EDX, OFFSET PromptHandVS1
		call WriteString
		mov EDX, OFFSET PromptOP
		Call WriteString
	.else
		mov EDX, OFFSET PromptHandVS1
		call WriteString 
		mov EDX, OFFSET PromptHandVP2
		call writestring
	.endif
	call CRLF

;player
	.if(PlayerHandValue == 9)
		mov EDX, OFFSET PromptHandVP1
		call WriteString
		mov EDX, OFFSET PromptRF
		Call WriteString
	.elseif(PlayerHandValue == 8)
		mov EDX, OFFSET PromptHandVP1
		call WriteString
		mov EDX, OFFSET PromptSF
		Call WriteString
	.elseif(PlayerHandValue == 7)
		mov EDX, OFFSET PromptHandVP1
		call WriteString
		mov EDX, OFFSET PromptFK
		Call WriteString
		mov EDX, OFFSET PromptHandVP2
		call writestring
	.elseif(PlayerHandValue == 6)
		mov EDX, OFFSET PromptHandVP1
		call WriteString
		mov EDX, OFFSET PromptFH
		Call WriteString
	.elseif(PlayerHandValue == 5)
		mov EDX, OFFSET PromptHandVP1
		call WriteString
		mov EDX, OFFSET PromptFL
		Call WriteString
	.elseif(PlayerHandValue == 4)
		mov EDX, OFFSET PromptHandVP1
		call WriteString
		mov EDX, OFFSET PromptST
		Call WriteString
	.elseif(PlayerHandValue == 3)
		mov EDX, OFFSET PromptHandVP1
		call WriteString
		mov EDX, OFFSET PromptTK
		Call WriteString
		mov EDX, OFFSET PromptHandVP2
		call writestring
	.elseif(PlayerHandValue == 2)
		mov EDX, OFFSET PromptHandVP1
		call WriteString
		mov EDX, OFFSET PromptTP
		Call WriteString
		mov EDX, OFFSET PromptHandVP2
		call writestring
	.elseif(SpockHandValue == 1)
		mov EDX, OFFSET PromptHandVP1
		call WriteString
		mov EDX, OFFSET PromptOP
		Call WriteString
	.else
		mov EDX, OFFSET PromptHandVP1
		call WriteString 
		mov EDX, OFFSET PromptHandVP2
		call WriteString
	.endif
	call CRLF
	mov EDX, OFFSET PromptPressEnter
	Call writeString
	call readint
	ret
RoundWinner ENDP
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------;
END main