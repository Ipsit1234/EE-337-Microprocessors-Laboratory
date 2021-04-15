ORG 0H;
	LJMP MAIN;
	MAIN:
	MOV 70H, #0FFH;
	MOV 71H, #0FFH;
	MOV 21H, 70H;
	LCALL FUNC;
	MOV 72H, 20H;
	MOV A, 21H;
	SWAP A;
	MOV 21H, A;
	LCALL FUNC;
	MOV 73H, 20H;
	MOV 21H, 71H;
	LCALL FUNC;
	MOV 74H, 20H;
	MOV A, 21H;
	SWAP A;
	MOV 21H, A;
	LCALL FUNC;
	MOV 75H, 20H
	FUNC:	MOV A, 21H;
			ANL A, #01H;
			MOV R0, A;
			MOV A, 21H;
			ANL A, #02H;
			MOV R1, A;
			MOV A, 21H;
			ANL A, #04H;
			MOV R2, A;
			MOV A, 21H;
			ANL A, #08H;
			MOV R3, A;
			MOV A, 21H;
			ANL A, #10H;
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FOR LOWER HALF BYTE
			MOV 22H, R0;
			MOV 23H, R1;
			MOV 24H, R2;
			MOV 25H, R3;
			MOV A, R0; 
			MOV 30H, #05H;
			SHIFT5: RL A;
				   DJNZ 30H, SHIFT5;
			MOV R0, A;
			MOV 30H, #04H;
			MOV A, R1;
			SHIFT4: RL A;
					DJNZ 30H, SHIFT4
			MOV R1, A;
			MOV 30H, #02H;
			MOV A, R3;
			SHIFT2: RL A;
					DJNZ 30H, SHIFT2
			MOV R3, A;
			MOV A, R0; MOVE BO INTO A
			XRL A, R1; B0 XOR B1 = A
			XRL A, R3; BO XOR B1 XOR B3 = A = B5
			MOV 15H, A; B5 ---------------------------------------------
			MOV R0, 22H;
			MOV R1, 23H;
			MOV R2, 24H;
			MOV R3, 25H;
			MOV A, R0; 
			MOV 30H, #04H;
			SHIFT44: RL A;
				   DJNZ 30H, SHIFT44;
			MOV R0, A;
			MOV A, R2; 
			MOV 30H, #02H;
			SHIFT22: RL A;
				   DJNZ 30H, SHIFT22;
			MOV R2, A;
			MOV A, R3;
			MOV 30H, #01H;
			SHIFT11: RL A;
				   DJNZ 30H, SHIFT11;
			MOV R3, A;
			MOV A, R0; A = BO
			XRL A, R2; A = B0 XOR B2
			XRL A, R3; A = BO XOR B2 XOR B3 = B4
			MOV 14H, A; B4 ----------------------------------------------
			MOV R0, 22H;
			MOV R1, 23H;
			MOV R2, 24H;
			MOV R3, 25H;
			MOV A, R1;
			MOV 30H, #05H;
			SHIFT555: RL A;
				   DJNZ 30H, SHIFT555;
			MOV R1, A;
			MOV A, R2;
			MOV 30H, #04H;
			SHIFT444: RL A;
				   DJNZ 30H, SHIFT444;
			MOV R2, A;
			MOV A, R3;
			MOV 30H, #03H;
			SHIFT333: RL A;
				   DJNZ 30H, SHIFT333;
			MOV R3, A;
			MOV A, R1; A = B1
			XRL A, R2; A = B1 XOR B2
			XRL A, R3; A = B1 XOR B2 XOR B3 = B6
			MOV 16H, A; B6
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; NOW WE WILL ADD SO THAT WE GET THE DESIRED ANSWERS
			MOV A, 22H;
			ADD A, 23H;
			ADD A, 24H;
			ADD A, 25H;
			ADD A, 14H;
			ADD A, 15H;
			ADD A, 16H;
			ADD A, #00H;
			MOV 20H, A; 20H WILL HAVE THE RESULT FOR LOWER-HALF BYTE
			RET
	HERE: SJMP HERE;
	END