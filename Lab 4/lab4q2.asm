ORG 0H;
LJMP MAIN;
MAIN:
	ACALL readNibble;
	LJMP MAIN;
	
	readNibble: 
				CLR P1.7; making them as output pins
				CLR P1.6;
				CLR P1.5;
				CLR P1.4;
				SETB P1.7; leds on
				SETB P1.6;
				SETB P1.5;
				SETB P1.4;
				ACALL DELAY; 
				ACALL DELAY;
				ACALL DELAY; 5s delay
				ACALL DELAY;
				ACALL DELAY;
				SETB P1.3; making these pins as input pins
				SETB P1.2;
				SETB P1.1;
				SETB P1.0;
				MOV 4EH, P1; storing the input in 4EH
				ANL 4EH, #0FH; extracting lower nibble
				MOV A, 4EH; 
				MOV C, ACC.3; using bit-wise operations
				MOV P1.7, C; 
				MOV C, ACC.2;
				MOV P1.6, C;
				MOV C, ACC.1;
				MOV P1.5, C;
				MOV C, ACC.0;
				MOV P1.4, C;
				ACALL DELAY;
				ACALL DELAY;
				ACALL DELAY;
				ACALL DELAY;
				ACALL DELAY;
				RET;

	DELAY:
		MOV R6, #0FAH;
		PRELIM:
			MOV R5, #04H;
			START: 
				MOV R7, #0FAH;
				LOOP_1_MILLI:
					NOP;
					NOP;
					NOP;
					NOP;
					NOP;
					NOP;
					DJNZ R7, LOOP_1_MILLI;
			DJNZ R5, START;
		DJNZ R6, PRELIM;
	RET;
END;
	