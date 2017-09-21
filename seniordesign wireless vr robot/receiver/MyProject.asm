
_PrintAString:

;MyProject.c,1 :: 		void PrintAString(char string[]) {
;MyProject.c,3 :: 		for(k=0;string[k]!=0;k++)
	CLRF       PrintAString_k_L0+0
	CLRF       PrintAString_k_L0+1
L_PrintAString0:
	MOVF       PrintAString_k_L0+0, 0
	ADDWF      FARG_PrintAString_string+0, 0
	MOVWF      FSR0L
	MOVF       PrintAString_k_L0+1, 0
	ADDWFC     FARG_PrintAString_string+1, 0
	MOVWF      FSR0H
	MOVF       INDF0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_PrintAString1
;MyProject.c,4 :: 		Uart1_Write(string[k]);
	MOVF       PrintAString_k_L0+0, 0
	ADDWF      FARG_PrintAString_string+0, 0
	MOVWF      FSR0L
	MOVF       PrintAString_k_L0+1, 0
	ADDWFC     FARG_PrintAString_string+1, 0
	MOVWF      FSR0H
	MOVF       INDF0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;MyProject.c,3 :: 		for(k=0;string[k]!=0;k++)
	INCF       PrintAString_k_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       PrintAString_k_L0+1, 1
;MyProject.c,4 :: 		Uart1_Write(string[k]);
	GOTO       L_PrintAString0
L_PrintAString1:
;MyProject.c,5 :: 		}
L_end_PrintAString:
	RETURN
; end of _PrintAString

_main:

;MyProject.c,6 :: 		void main() {
;MyProject.c,10 :: 		char newline[] = "\n";
	MOVLW      10
	MOVWF      main_newline_L0+0
	CLRF       main_newline_L0+1
;MyProject.c,11 :: 		OSCCON = 0x78;
	MOVLW      120
	MOVWF      OSCCON+0
;MyProject.c,12 :: 		INTCON = 0;
	CLRF       INTCON+0
;MyProject.c,13 :: 		TRISA=0xff;TRISB=0xff;TRISC=0xFF;
	MOVLW      255
	MOVWF      TRISA+0
	MOVLW      255
	MOVWF      TRISB+0
	MOVLW      255
	MOVWF      TRISC+0
;MyProject.c,14 :: 		ANSELA=0x14;ANSELB=0x00;ANSELC=0x00;
	MOVLW      20
	MOVWF      ANSELA+0
	CLRF       ANSELB+0
	CLRF       ANSELC+0
;MyProject.c,15 :: 		Uart1_Init(9600);
	BSF        BAUDCON+0, 3
	MOVLW      160
	MOVWF      SPBRG+0
	MOVLW      1
	MOVWF      SPBRG+1
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;MyProject.c,16 :: 		while(1){
L_main3:
;MyProject.c,17 :: 		left = ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0, 0
	MOVWF      main_left_L0+0
	MOVF       R1, 0
	MOVWF      main_left_L0+1
;MyProject.c,18 :: 		right = ADC_Read(3);
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0, 0
	MOVWF      main_right_L0+0
	MOVF       R1, 0
	MOVWF      main_right_L0+1
;MyProject.c,19 :: 		InttoStr(left,temp);
	MOVF       main_left_L0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       main_left_L0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      main_temp_L0+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(main_temp_L0+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;MyProject.c,20 :: 		PrintAString(temp);
	MOVLW      main_temp_L0+0
	MOVWF      FARG_PrintAString_string+0
	MOVLW      hi_addr(main_temp_L0+0)
	MOVWF      FARG_PrintAString_string+1
	CALL       _PrintAString+0
;MyProject.c,21 :: 		InttoStr(right,temp);
	MOVF       main_right_L0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       main_right_L0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      main_temp_L0+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(main_temp_L0+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;MyProject.c,22 :: 		PrintAString(temp);
	MOVLW      main_temp_L0+0
	MOVWF      FARG_PrintAString_string+0
	MOVLW      hi_addr(main_temp_L0+0)
	MOVWF      FARG_PrintAString_string+1
	CALL       _PrintAString+0
;MyProject.c,23 :: 		PrintAString(newline);
	MOVLW      main_newline_L0+0
	MOVWF      FARG_PrintAString_string+0
	MOVLW      hi_addr(main_newline_L0+0)
	MOVWF      FARG_PrintAString_string+1
	CALL       _PrintAString+0
;MyProject.c,24 :: 		delay_ms(1000);
	MOVLW      21
	MOVWF      R11
	MOVLW      75
	MOVWF      R12
	MOVLW      190
	MOVWF      R13
L_main5:
	DECFSZ     R13, 1
	GOTO       L_main5
	DECFSZ     R12, 1
	GOTO       L_main5
	DECFSZ     R11, 1
	GOTO       L_main5
	NOP
;MyProject.c,25 :: 		}
	GOTO       L_main3
;MyProject.c,26 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
