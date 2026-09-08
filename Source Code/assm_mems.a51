FULL PROJECT CODE: 
ORG 0000H 
 	 
START: 
    MOV P3, #0FFH     
    MOV P1, #0FFH     
    MOV P0, #00H      
    MOV P2, #00H      
 
Check_Conditions: 
    
    JNB P3.1, P3_1_IS_0 
     
    ; P3.1 is 1: 
JB P3.0, P3_0_IS_1_IN_A  
 
; Pattern is (1-0) 
CALL MODE3 
    JMP Check_Conditions     
 
P3_0_IS_1_IN_A: 
     
    CALL MODE4 
    JMP Check_Conditions  
     
P3_1_IS_0: 
    ; P3.1 is 0: 
    JB P3.0, P3_0_IS_1_IN_B  
     
    ; Pattern is (0-0) 
    CALL MODE1 
    JMP Check_Conditions    
 
P3_0_IS_1_IN_B: 
    ; Pattern is (0-1) 
    CALL MODE2 
    JMP Check_Conditions     
 
 
MODE1: 
     
MOV A, P1 
CLR C 
RRC A 
MOV R0, A         
 
     
    MOV A, #05H 
    MOV B, R0 
    MUL AB 
    MOV R1, A         
    MOV R2, B         
    MOV A, R0 
    MOV B, R0 
    MUL AB 
    MOV R3, A         
    MOV R4, B        
 
     
    MOV A, #05H 
    MOV B, R3 
    MUL AB 
    MOV R5, A         
    MOV R6, B         
 
     
    MOV A, #05H 
    MOV B, R4         MUL AB            
 
ADD A, R6         
MOV R6, A         
     
  
    MOV A, B          
    ADDC A, #00H      
    MOV R4, A         
 
  
    MOV A, R1        
    ADD A, R5         
    MOV R7, A      
 
    MOV A, R2         
    ADDC A, R6        
    MOV R0, A         
 
    
    MOV A, R4         
    ADDC A, #00H      
     
 
    JZ NO_OVERFLOW 
     
SET_OVERFLOW: 
SETB P3.2 
JMP DISPLAY_RESULT 
 
NO_OVERFLOW: 
    CLR P3.2 
 
DISPLAY_RESULT: 
    MOV P0, R7     MOV P2, R0 
    CALL DELAY_2SEC 
    RET                
DELAY_2SEC: 
    MOV R3, #40 
DELAY_LOOP: 
    MOV TMOD, #01H 
    MOV TH0, #4CH 
    MOV TL0, #00H 
    SETB TR0 WAIT: 
    JNB TF0, WAIT 
    CLR TR0 
    CLR TF0 
    DJNZ R3, DELAY_LOOP 
    RET 
 
MODE2: 
 
MOV A, P1 
MOV R0, A       
 
     
    MOV B, A 
    MUL AB 
    MOV R1, A         
    MOV R2, B         
 
    MOV A, #1EH       
    MOV B, R1             MUL AB 
    MOV R7, A         
    MOV R4, B         
 
     
    MOV A, #1EH     
    MOV B, R2       
    MUL AB          
     
    ADD A, R4         
    MOV R0, A        
     
 
MOV A, B        
ADDC A, #00H      MOV R5, A         
 
JZ NO_OVERFLOW_1 
     
SET_OVERFLOW_1: 
    SETB P3.3 
    JMP DISPLAY_RESULT_1 
     
NO_OVERFLOW_1: 
    CLR P3.3 
 
DISPLAY_RESULT_1: 
    MOV P0, R0        
    MOV P2, R7        
    CALL DELAY_1_5SEC 
    RET                
DELAY_1_5SEC: 
    MOV R3, #30 
DELAY_LOOP_1: 
    MOV TMOD, #01H 
    MOV TH0, #4BH 
    MOV TL0, #0FDH 
    SETB TR0 WAIT_1: 
    JNB TF0, WAIT_1 
    CLR TR0 
CLR TF0 
    DJNZ R3, DELAY_LOOP_1 
    RET 
 
 
MODE3: 
    MOV A, P1            
    MOV B, #30          
    DIV AB              
     
     
    CJNE A, #09H, CHECK_LIMIT CHECK_LIMIT: 
    JC PROCESS_DATA      
    MOV A, #08H          
 
PROCESS_DATA: 
    MOV R2, A            
 
     
    MOV DPTR, #BRIGHTNESS_TABLE 
    MOV A, R2 
    MOVC A, @A+DPTR   
    MOV R6, A            
 
 
CPL A               
MOV R7, A           
 
   
    MOV A, R2           
    MOV R3, A            
    MOV A, #00H          
     
    CJNE R3, #00H, LOOP_P0 
    SJMP SAVE_P0 LOOP_P0: 
    SETB C              
    RLC A                
    DJNZ R3, LOOP_P0     SAVE_P0: 
    MOV R4, A            
 
    MOV A, R2            
    MOV R3, A            
    MOV A, #00H          
 
    CJNE R3, #00H, LOOP_P2 
    SJMP SAVE_P2 LOOP_P2: 
    SETB C              
    RRC A                
    DJNZ R3, LOOP_P2     SAVE_P2: 
MOV R5, A         
 
     
    MOV R1, #22          
     
PWM_OUTER: 
    MOV R3, #90         
     
PWM_CYCLE: 
    
    MOV A, R6            
    JZ SKIP_ON           
     
    MOV P0, R4           
    MOV P2, R5         
     
    MOV R0, A           
DELAY_ON: 
    DJNZ R0, DELAY_ON    
SKIP_ON: 
 
     
    MOV A, R7            
    JZ SKIP_OFF          
 
MOV P0, #00H         
MOV P2, #00H 
 
MOV R0, A            
DELAY_OFF:     DJNZ R0, DELAY_OFF   
SKIP_OFF: 
 
     
    DJNZ R3, PWM_CYCLE   
    DJNZ R1, PWM_OUTER   
     
           
 	Mode3_done: 
 	RET 
 
BRIGHTNESS_TABLE: 
    DB 0       
    DB 20          DB 60      
    DB 100      
    DB 110     
    DB 130      
    DB 160     
    DB 200    
    DB 255      
 
MODE4: 
MOV R0, P1          
MOV A, R0 
MOV R6, A            
 
    CLR C                 
    SUBB A, #127 
    JC USE_600MS 
    CLR P3.5              
    JMP CHECK_NUM USE_600MS: 
    SETB P3.5             
 
CHECK_NUM: 
    CJNE R0, #00H, JOJO 
    JMP Mode4_done      JOJO: 
    CJNE R0, #01H, MOVE 
    JMP COMPOSITE         
 
MOVE: 
    MOV A, R6 
    CJNE A, #02H, MOVE1 
    JMP PRIME             
 
MOVE1: 
MOV A, R6 
MOV B, #02H 
DIV AB 
MOV A, B 
JZ COMPOSITE          
 
    MOV R2, #03H          
 
LOOP_CONDITION: 
    MOV A, R2 
    MOV B, R2 
    MUL AB                
    CLR C 
    SUBB A, R6            
    JNC PRIME             
 
    MOV A, R6 
    MOV B, R2 
    DIV AB 
    MOV A, B 
    JZ COMPOSITE          
 
    MOV A, R2 
    ADD A, #02H           
    MOV R2, A 
    JMP LOOP_CONDITION 
 
PRIME:     MOV P0, #00H 
MOV P2, #00H 
MOV A, #01H           
MOV 30H, #80H         
    MOV R7, #08H 
 
BIT_LOOP: 
    PUSH ACC             
    MOV P0, A 
    MOV A, 30H 
    MOV P2, A 
 
    JB P3.5, CALL600_P 
    CALL DELAY_300MS 
    JMP DELAY1_DONE CALL600_P:     CALL DELAY_600MS 
DELAY1_DONE: 
 
    POP ACC             
    PUSH ACC              
 
    MOV P0, #00H 
    MOV P2, #00H 
 
    JB P3.5, CALL600_P2 
    CALL DELAY_300MS 
    JMP DELAY2_DONE CALL600_P2: 
CALL DELAY_600MS 
DELAY2_DONE: 
 
    MOV A, 30H 
    RR A 
    MOV 30H, A            
 
    POP ACC              
    RL A 
                       
    DJNZ R7, BIT_LOOP 
 
    MOV P0, #00H 
    MOV P2, #00H 
    JMP Mode4_done 
 
COMPOSITE: 
    MOV P0, #00H 
    MOV P2, #00H 
    MOV A, #01H           
    MOV 30H, #80H         
    MOV R7, #08H 
 
BIT_LOOP_1: 
    PUSH ACC             
    MOV P2, A 
MOV A, 30H 
MOV P0, A 
 
    JB P3.5, CALL600_C 
    CALL DELAY_300MS 
    JMP DELAY3_DONE CALL600_C:     CALL DELAY_600MS 
DELAY3_DONE: 
 
    POP ACC             
    PUSH ACC              
 
    MOV P0, #00H 
    MOV P2, #00H 
 
    JB P3.5, CALL600_C2 
    CALL DELAY_300MS 
    JMP DELAY4_DONE CALL600_C2:     CALL DELAY_600MS 
DELAY4_DONE: 
 
    MOV A, 30H 
    RR A 
    MOV 30H, A 
 
POP ACC               
RL A 
                         
    DJNZ R7, BIT_LOOP_1 
 
    MOV P0, #00H 
    MOV P2, #00H 
    JMP Mode4_done 
 
DELAY_300MS: 
    MOV R5, #5 
ONE_CYCLE_300: 
    MOV TMOD, #01H 
    MOV TL0, #60H 
    MOV TH0, #28H 
    SETB TR0 
WAIT_TF0: 
    JNB TF0, WAIT_TF0 
    CLR TF0 
    CLR TR0 
    DJNZ R5, ONE_CYCLE_300 
    RET 
 
DELAY_600MS: 
    MOV R5, #10 
ONE_CYCLE_600:     MOV TMOD, #01H MOV TL0, #60H MOV TH0, #28H 
    SETB TR0 
WAIT_TF0_600: 
    JNB TF0, WAIT_TF0_600 
    CLR TF0 
    CLR TR0 
    DJNZ R5, ONE_CYCLE_600 
    RET 
 
Mode4_done: 
    RET 
 
END 
