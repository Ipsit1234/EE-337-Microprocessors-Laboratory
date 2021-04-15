LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable
ORG 0H;
LJMP MAIN;
MAIN:	MOV 70H, #40H; LEVEL 2, LEVEL 1
		MOV 71H, #0C8H; LEVEL 4, LEVEL 3
		MOV 72H, 70H; TO HOLD LEVEL 2
		MOV 73H, 71H; TO HOLD LEVEL 4
		ANL 70H, #00FH; LEVEL 1
		ANL 72H, #0F0H; LEVEL 2
		MOV A, 72H;
		SWAP A;
		MOV 72H, A;
		ANL 71H, #00FH; LEVEL 3
		ANL 73H, #0F0H; LEVEL 4
		MOV A, 73H;
		SWAP A;
		MOV 73H, A;
		MOV TMOD, #01H;
		MOV P3, #00H;
		MOV P2, #00H;
		MOV P1, #00H;
		ACALL LCD_INIT;
		ACALL DELAY_SHORT;
		ACALL DELAY_SHORT;
		ACALL DELAY_SHORT;
START:	MOV A,#84h		 ;Put cursor on first row,4 column
		ACALL lcd_command	 ;send command to LCD
		ACALL DELAY_SHORT;
		MOV DPTR, #LEVEL_1;
		ACALL DELAY_SHORT;
		ACALL LCD_SENDSTRING;
		ACALL DELAY_SHORT;
		MOV A, #0C2H;
		ACALL LCD_COMMAND;
		ACALL DELAY_SHORT;
		MOV DPTR, #VALUE;
		ACALL DELAY_SHORT;
		ACALL LCD_SENDSTRING;
		ACALL DELAY_SHORT;
		MOV A, 70H;
		ACALL LCD_SENDBITS;
		ACALL DELAY_SHORT;
		MOV P3, #0FFH;
		MOV P3, 70H;
		ACALL DELAY;
		MOV A,#84h		 ;Put cursor on first row,4 column
		ACALL lcd_command	 ;send command to LCD
		ACALL DELAY_SHORT;
		MOV DPTR, #LEVEL_2;
		ACALL DELAY_SHORT;
		ACALL LCD_SENDSTRING;
		ACALL DELAY_SHORT;
		MOV A, #0C2H;
		ACALL LCD_COMMAND;
		ACALL DELAY_SHORT;
		MOV DPTR, #VALUE;
		ACALL DELAY_SHORT;
		ACALL LCD_SENDSTRING;
		ACALL DELAY_SHORT;
		MOV A, 72H;
		ACALL LCD_SENDBITS;
		ACALL DELAY_SHORT;
		MOV P3, 72H;
		ACALL DELAY;
		MOV A,#84h		 ;Put cursor on first row,4 column
		ACALL lcd_command	 ;send command to LCD
		ACALL DELAY_SHORT;
		MOV DPTR, #LEVEL_3;
		ACALL DELAY_SHORT;
		ACALL LCD_SENDSTRING;
		ACALL DELAY_SHORT;
		MOV A, #0C2H;
		ACALL LCD_COMMAND;
		ACALL DELAY_SHORT;
		MOV DPTR, #VALUE;
		ACALL DELAY_SHORT;
		ACALL LCD_SENDSTRING;
		ACALL DELAY_SHORT;
		MOV A, 71H;
		ACALL LCD_SENDBITS;
		ACALL DELAY_SHORT;
		MOV P3, 71H;
		ACALL DELAY;
		MOV A,#84h		 ;Put cursor on first row,4 column
		ACALL lcd_command	 ;send command to LCD
		ACALL DELAY_SHORT;
		MOV DPTR, #LEVEL_4;
		ACALL DELAY_SHORT;
		ACALL LCD_SENDSTRING;
		ACALL DELAY_SHORT;
		MOV A, #0C2H;
		ACALL LCD_COMMAND;
		ACALL DELAY_SHORT;
		MOV DPTR, #VALUE;
		ACALL DELAY_SHORT;
		ACALL LCD_SENDSTRING;
		ACALL DELAY_SHORT;
		MOV A, 73H;
		ACALL LCD_SENDBITS;
		ACALL DELAY;
		MOV P3, 73H;
		ACALL DELAY;
		LJMP START;
		
		DELAY:	MOV A, #10H; LOWER BYTE
				CPL A;
				ADD A, #1D;
				MOV R0, A;
				MOV A, #27H; UPPER BYTE
				ACALL CHECK_CARRY;
				MOV R2, #29D; 
				AGAIN:	MOV TL0, R0;
						MOV TH0, R1;
						;MOV IE, #82H;
						SETB TR0;
						HERE:	JNB TF0, HERE;
						CLR TR0;
						CLR TF0;
						DJNZ R2, AGAIN;
				RET;
				
		DELAY_SHORT:	
				MOV R4, #10;
				LOOP1:	DJNZ R4, LOOP1;
				 RET;
		CHECK_CARRY:	CPL A;
						JNC GO; 
						ADD A, #1D;
						GO:	MOV R1, A;	
				RET;
				

;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay_short
         clr   LCD_en
	     acall delay_short

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay_short
         clr   LCD_en
         
		 acall delay_short
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay_short
         clr   LCD_en
         
		 acall delay_short

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay_short
         clr   LCD_en

		 acall delay_short
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay_short
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay_SHORT
         clr   LCD_en
         acall delay_short
		 acall delay_short
         ret                  ;Return from busy routine
;----------------------------SEND BITS TO LCD-------------------------------------
LCD_SENDBITS:
		MOV 60H, A;
		MOV 61H, A;
		MOV 62H, A;
		MOV 63H, A;
		ANL 60H, #01H;
		ANL 61H, #02H;
		MOV A, 61H;
		RR A;
		MOV 61H, A;
		ANL 62H, #04H;
		MOV A, 62H;
		RR A;
		RR A;
		MOV 62H, A;
		ANL 63H, #08H;
		MOV A, 63H;
		RR A;
		RR A;
		RR A;
		MOV 63H, A;
		MOV A, #0CCH;
		ACALL LCD_COMMAND;
		ACALL DELAY_SHORT;
		MOV A, 60H;
		ADD A, #30H;
		ACALL LCD_SENDDATA;
		ACALL DELAY_SHORT;
		MOV A, #0CBH;
		ACALL LCD_COMMAND;
		ACALL DELAY_SHORT;
		MOV A, 61H;
		ADD A, #30H;
		ACALL LCD_SENDDATA;
		ACALL DELAY_SHORT;
		MOV A, #0CAH;
		ACALL LCD_COMMAND;
		ACALL DELAY_SHORT;
		MOV A, 62H;
		ADD A, #30H;
		ACALL LCD_SENDDATA;
		ACALL DELAY_SHORT;
		MOV A, #0C9H;
		ACALL LCD_COMMAND;
		ACALL DELAY_SHORT;
		MOV A, 63H;
		ADD A, #30H;
		ACALL LCD_SENDDATA;
		ACALL DELAY_SHORT;		  
		RET;
;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine
;-----------------------------------------------------------------------------------------
ORG 300H;
LEVEL_1:
         DB   "Level 1", 00H;
LEVEL_2:
         DB   "Level 2", 00H;
LEVEL_3:
         DB   "Level 3", 00H;
LEVEL_4:
         DB   "Level 4", 00H;
VALUE:
		 DB   "Value: ", 00H;
END;