
_set_pot:

;Project5.c,20 :: 		void set_pot(int value, int control) {
;Project5.c,24 :: 		Soft_SPI_Write(control);
	MOVF       FARG_set_pot_control+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;Project5.c,25 :: 		Soft_SPI_Write(value);
	MOVF       FARG_set_pot_value+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;Project5.c,26 :: 		}
L_end_set_pot:
	RETURN
; end of _set_pot

_PrintAString:

;Project5.c,27 :: 		void PrintAString(char string[]) {
;Project5.c,29 :: 		for(k=0;string[k]!=0;k++) // Recall: String is an array terminated by zero
	CLRF       PrintAString_k_L0+0
	CLRF       PrintAString_k_L0+1
L_PrintAString0:
	MOVF       PrintAString_k_L0+0, 0
	ADDWF      FARG_PrintAString_string+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_PrintAString1
;Project5.c,30 :: 		Uart1_Write(string[k]);
	MOVF       PrintAString_k_L0+0, 0
	ADDWF      FARG_PrintAString_string+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;Project5.c,29 :: 		for(k=0;string[k]!=0;k++) // Recall: String is an array terminated by zero
	INCF       PrintAString_k_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       PrintAString_k_L0+1, 1
;Project5.c,30 :: 		Uart1_Write(string[k]);
	GOTO       L_PrintAString0
L_PrintAString1:
;Project5.c,31 :: 		}
L_end_PrintAString:
	RETURN
; end of _PrintAString

_calcFrequency:

;Project5.c,32 :: 		float calcFrequency(int wiper) {
;Project5.c,34 :: 		if(wiper > 118) freq= 974.2+7.3455*(129-wiper);
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_calcFrequency_wiper+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__calcFrequency44
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      118
L__calcFrequency44:
	BTFSC      STATUS+0, 0
	GOTO       L_calcFrequency3
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      129
	MOVWF      R0+0
	MOVF       FARG_calcFrequency_wiper+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	CALL       _Int2Double+0
	MOVLW      86
	MOVWF      R4+0
	MOVLW      14
	MOVWF      R4+1
	MOVLW      107
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      205
	MOVWF      R4+0
	MOVLW      140
	MOVWF      R4+1
	MOVLW      115
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      calcFrequency_freq_L0+0
	MOVF       R0+1, 0
	MOVWF      calcFrequency_freq_L0+1
	MOVF       R0+2, 0
	MOVWF      calcFrequency_freq_L0+2
	MOVF       R0+3, 0
	MOVWF      calcFrequency_freq_L0+3
	GOTO       L_calcFrequency4
L_calcFrequency3:
;Project5.c,35 :: 		else if(wiper > 108) freq=969.4788+8.2788*(129-wiper);
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_calcFrequency_wiper+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__calcFrequency45
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      108
L__calcFrequency45:
	BTFSC      STATUS+0, 0
	GOTO       L_calcFrequency5
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      129
	MOVWF      R0+0
	MOVF       FARG_calcFrequency_wiper+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	CALL       _Int2Double+0
	MOVLW      247
	MOVWF      R4+0
	MOVLW      117
	MOVWF      R4+1
	MOVLW      4
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      165
	MOVWF      R4+0
	MOVLW      94
	MOVWF      R4+1
	MOVLW      114
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      calcFrequency_freq_L0+0
	MOVF       R0+1, 0
	MOVWF      calcFrequency_freq_L0+1
	MOVF       R0+2, 0
	MOVWF      calcFrequency_freq_L0+2
	MOVF       R0+3, 0
	MOVWF      calcFrequency_freq_L0+3
	GOTO       L_calcFrequency6
L_calcFrequency5:
;Project5.c,36 :: 		else if(wiper > 98) freq= 938.0636+9.8182*(129-wiper);
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_calcFrequency_wiper+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__calcFrequency46
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      98
L__calcFrequency46:
	BTFSC      STATUS+0, 0
	GOTO       L_calcFrequency7
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      129
	MOVWF      R0+0
	MOVF       FARG_calcFrequency_wiper+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	CALL       _Int2Double+0
	MOVLW      89
	MOVWF      R4+0
	MOVLW      23
	MOVWF      R4+1
	MOVLW      29
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      18
	MOVWF      R4+0
	MOVLW      132
	MOVWF      R4+1
	MOVLW      106
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      calcFrequency_freq_L0+0
	MOVF       R0+1, 0
	MOVWF      calcFrequency_freq_L0+1
	MOVF       R0+2, 0
	MOVWF      calcFrequency_freq_L0+2
	MOVF       R0+3, 0
	MOVWF      calcFrequency_freq_L0+3
	GOTO       L_calcFrequency8
L_calcFrequency7:
;Project5.c,37 :: 		else if(wiper > 88) freq= 906.1394+10.824*(129-wiper);
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_calcFrequency_wiper+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__calcFrequency47
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      88
L__calcFrequency47:
	BTFSC      STATUS+0, 0
	GOTO       L_calcFrequency9
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      129
	MOVWF      R0+0
	MOVF       FARG_calcFrequency_wiper+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	CALL       _Int2Double+0
	MOVLW      27
	MOVWF      R4+0
	MOVLW      47
	MOVWF      R4+1
	MOVLW      45
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      236
	MOVWF      R4+0
	MOVLW      136
	MOVWF      R4+1
	MOVLW      98
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      calcFrequency_freq_L0+0
	MOVF       R0+1, 0
	MOVWF      calcFrequency_freq_L0+1
	MOVF       R0+2, 0
	MOVWF      calcFrequency_freq_L0+2
	MOVF       R0+3, 0
	MOVWF      calcFrequency_freq_L0+3
	GOTO       L_calcFrequency10
L_calcFrequency9:
;Project5.c,38 :: 		else if(wiper > 78) freq= 789.6909+13.673*(129-wiper);
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_calcFrequency_wiper+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__calcFrequency48
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      78
L__calcFrequency48:
	BTFSC      STATUS+0, 0
	GOTO       L_calcFrequency11
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      129
	MOVWF      R0+0
	MOVF       FARG_calcFrequency_wiper+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	CALL       _Int2Double+0
	MOVLW      156
	MOVWF      R4+0
	MOVLW      196
	MOVWF      R4+1
	MOVLW      90
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      56
	MOVWF      R4+0
	MOVLW      108
	MOVWF      R4+1
	MOVLW      69
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      calcFrequency_freq_L0+0
	MOVF       R0+1, 0
	MOVWF      calcFrequency_freq_L0+1
	MOVF       R0+2, 0
	MOVWF      calcFrequency_freq_L0+2
	MOVF       R0+3, 0
	MOVWF      calcFrequency_freq_L0+3
	GOTO       L_calcFrequency12
L_calcFrequency11:
;Project5.c,39 :: 		else if(wiper > 68) freq= 601.3273+17.345*(129-wiper);
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_calcFrequency_wiper+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__calcFrequency49
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      68
L__calcFrequency49:
	BTFSC      STATUS+0, 0
	GOTO       L_calcFrequency13
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      129
	MOVWF      R0+0
	MOVF       FARG_calcFrequency_wiper+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	CALL       _Int2Double+0
	MOVLW      143
	MOVWF      R4+0
	MOVLW      194
	MOVWF      R4+1
	MOVLW      10
	MOVWF      R4+2
	MOVLW      131
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      242
	MOVWF      R4+0
	MOVLW      84
	MOVWF      R4+1
	MOVLW      22
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      calcFrequency_freq_L0+0
	MOVF       R0+1, 0
	MOVWF      calcFrequency_freq_L0+1
	MOVF       R0+2, 0
	MOVWF      calcFrequency_freq_L0+2
	MOVF       R0+3, 0
	MOVWF      calcFrequency_freq_L0+3
	GOTO       L_calcFrequency14
L_calcFrequency13:
;Project5.c,40 :: 		else if(wiper > 58) freq= 396.1636+20.727*(129-wiper);
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_calcFrequency_wiper+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__calcFrequency50
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      58
L__calcFrequency50:
	BTFSC      STATUS+0, 0
	GOTO       L_calcFrequency15
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      129
	MOVWF      R0+0
	MOVF       FARG_calcFrequency_wiper+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	CALL       _Int2Double+0
	MOVLW      229
	MOVWF      R4+0
	MOVLW      208
	MOVWF      R4+1
	MOVLW      37
	MOVWF      R4+2
	MOVLW      131
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      241
	MOVWF      R4+0
	MOVLW      20
	MOVWF      R4+1
	MOVLW      70
	MOVWF      R4+2
	MOVLW      135
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      calcFrequency_freq_L0+0
	MOVF       R0+1, 0
	MOVWF      calcFrequency_freq_L0+1
	MOVF       R0+2, 0
	MOVWF      calcFrequency_freq_L0+2
	MOVF       R0+3, 0
	MOVWF      calcFrequency_freq_L0+3
	GOTO       L_calcFrequency16
L_calcFrequency15:
;Project5.c,41 :: 		else if(wiper > 48) freq= 28.151*(129-wiper)-127.7394;
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_calcFrequency_wiper+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__calcFrequency51
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      48
L__calcFrequency51:
	BTFSC      STATUS+0, 0
	GOTO       L_calcFrequency17
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      129
	MOVWF      R0+0
	MOVF       FARG_calcFrequency_wiper+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	CALL       _Int2Double+0
	MOVLW      63
	MOVWF      R4+0
	MOVLW      53
	MOVWF      R4+1
	MOVLW      97
	MOVWF      R4+2
	MOVLW      131
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      147
	MOVWF      R4+0
	MOVLW      122
	MOVWF      R4+1
	MOVLW      127
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	CALL       _Sub_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      calcFrequency_freq_L0+0
	MOVF       R0+1, 0
	MOVWF      calcFrequency_freq_L0+1
	MOVF       R0+2, 0
	MOVWF      calcFrequency_freq_L0+2
	MOVF       R0+3, 0
	MOVWF      calcFrequency_freq_L0+3
	GOTO       L_calcFrequency18
L_calcFrequency17:
;Project5.c,42 :: 		else if(wiper > 38) freq= 39.890*(129-wiper)-1078.273;
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_calcFrequency_wiper+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__calcFrequency52
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      38
L__calcFrequency52:
	BTFSC      STATUS+0, 0
	GOTO       L_calcFrequency19
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      129
	MOVWF      R0+0
	MOVF       FARG_calcFrequency_wiper+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	CALL       _Int2Double+0
	MOVLW      92
	MOVWF      R4+0
	MOVLW      143
	MOVWF      R4+1
	MOVLW      31
	MOVWF      R4+2
	MOVLW      132
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      188
	MOVWF      R4+0
	MOVLW      200
	MOVWF      R4+1
	MOVLW      6
	MOVWF      R4+2
	MOVLW      137
	MOVWF      R4+3
	CALL       _Sub_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      calcFrequency_freq_L0+0
	MOVF       R0+1, 0
	MOVWF      calcFrequency_freq_L0+1
	MOVF       R0+2, 0
	MOVWF      calcFrequency_freq_L0+2
	MOVF       R0+3, 0
	MOVWF      calcFrequency_freq_L0+3
	GOTO       L_calcFrequency20
L_calcFrequency19:
;Project5.c,43 :: 		else if(wiper > 28) freq= 58.370*(129-wiper)-2765.206;
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_calcFrequency_wiper+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__calcFrequency53
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      28
L__calcFrequency53:
	BTFSC      STATUS+0, 0
	GOTO       L_calcFrequency21
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      129
	MOVWF      R0+0
	MOVF       FARG_calcFrequency_wiper+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	CALL       _Int2Double+0
	MOVLW      225
	MOVWF      R4+0
	MOVLW      122
	MOVWF      R4+1
	MOVLW      105
	MOVWF      R4+2
	MOVLW      132
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      76
	MOVWF      R4+0
	MOVLW      211
	MOVWF      R4+1
	MOVLW      44
	MOVWF      R4+2
	MOVLW      138
	MOVWF      R4+3
	CALL       _Sub_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      calcFrequency_freq_L0+0
	MOVF       R0+1, 0
	MOVWF      calcFrequency_freq_L0+1
	MOVF       R0+2, 0
	MOVWF      calcFrequency_freq_L0+2
	MOVF       R0+3, 0
	MOVWF      calcFrequency_freq_L0+3
	GOTO       L_calcFrequency22
L_calcFrequency21:
;Project5.c,44 :: 		else if(wiper > 18) freq= 97*(129-wiper)-6672.4;
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_calcFrequency_wiper+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__calcFrequency54
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      18
L__calcFrequency54:
	BTFSC      STATUS+0, 0
	GOTO       L_calcFrequency23
	MOVF       FARG_calcFrequency_wiper+0, 0
	SUBLW      129
	MOVWF      R0+0
	MOVF       FARG_calcFrequency_wiper+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	MOVLW      97
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	CALL       _Int2Double+0
	MOVLW      51
	MOVWF      R4+0
	MOVLW      131
	MOVWF      R4+1
	MOVLW      80
	MOVWF      R4+2
	MOVLW      139
	MOVWF      R4+3
	CALL       _Sub_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      calcFrequency_freq_L0+0
	MOVF       R0+1, 0
	MOVWF      calcFrequency_freq_L0+1
	MOVF       R0+2, 0
	MOVWF      calcFrequency_freq_L0+2
	MOVF       R0+3, 0
	MOVWF      calcFrequency_freq_L0+3
L_calcFrequency23:
L_calcFrequency22:
L_calcFrequency20:
L_calcFrequency18:
L_calcFrequency16:
L_calcFrequency14:
L_calcFrequency12:
L_calcFrequency10:
L_calcFrequency8:
L_calcFrequency6:
L_calcFrequency4:
;Project5.c,45 :: 		return freq;
	MOVF       calcFrequency_freq_L0+0, 0
	MOVWF      R0+0
	MOVF       calcFrequency_freq_L0+1, 0
	MOVWF      R0+1
	MOVF       calcFrequency_freq_L0+2, 0
	MOVWF      R0+2
	MOVF       calcFrequency_freq_L0+3, 0
	MOVWF      R0+3
;Project5.c,46 :: 		}
L_end_calcFrequency:
	RETURN
; end of _calcFrequency

_main:

;Project5.c,52 :: 		void main() {
;Project5.c,54 :: 		TRISC = 0xFF;
	MOVLW      255
	MOVWF      TRISC+0
;Project5.c,55 :: 		TRISB = 0xFF;
	MOVLW      255
	MOVWF      TRISB+0
;Project5.c,56 :: 		TRISA = 0xFF;
	MOVLW      255
	MOVWF      TRISA+0
;Project5.c,57 :: 		ANSEL = 0x00;
	CLRF       ANSEL+0
;Project5.c,58 :: 		ANSELH = 0x00;
	CLRF       ANSELH+0
;Project5.c,59 :: 		C1ON_bit = 0;
	BCF        C1ON_bit+0, 7
;Project5.c,60 :: 		C2ON_bit = 0;
	BCF        C2ON_bit+0, 7
;Project5.c,61 :: 		Soft_SPI_Init();
	CALL       _Soft_SPI_Init+0
;Project5.c,62 :: 		Uart1_Init(9600);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Project5.c,63 :: 		INTCON = 0;
	CLRF       INTCON+0
;Project5.c,64 :: 		set_pot(WiperValue1,WRITEWIPE1);
	MOVF       _WiperValue1+0, 0
	MOVWF      FARG_set_pot_value+0
	MOVF       _WiperValue1+1, 0
	MOVWF      FARG_set_pot_value+1
	MOVLW      16
	MOVWF      FARG_set_pot_control+0
	MOVLW      0
	MOVWF      FARG_set_pot_control+1
	CALL       _set_pot+0
;Project5.c,65 :: 		set_pot(WiperValue0,WRITEWIPE0);
	MOVF       _WiperValue0+0, 0
	MOVWF      FARG_set_pot_value+0
	MOVF       _WiperValue0+1, 0
	MOVWF      FARG_set_pot_value+1
	CLRF       FARG_set_pot_control+0
	CLRF       FARG_set_pot_control+1
	CALL       _set_pot+0
;Project5.c,66 :: 		Delay_ms(2000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main24:
	DECFSZ     R13+0, 1
	GOTO       L_main24
	DECFSZ     R12+0, 1
	GOTO       L_main24
	DECFSZ     R11+0, 1
	GOTO       L_main24
	NOP
	NOP
;Project5.c,67 :: 		while(1){
L_main25:
;Project5.c,68 :: 		PrintAString(prompt);
	MOVLW      _prompt+0
	MOVWF      FARG_PrintAString_string+0
	CALL       _PrintAString+0
;Project5.c,69 :: 		while(!Uart1_Data_Ready());
L_main27:
	CALL       _UART1_Data_Ready+0
	MOVF       R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main28
	GOTO       L_main27
L_main28:
;Project5.c,70 :: 		input = Uart1_Read();
	CALL       _UART1_Read+0
	MOVF       R0+0, 0
	MOVWF      main_input_L0+0
;Project5.c,71 :: 		if(input == 'z') {
	MOVF       R0+0, 0
	XORLW      122
	BTFSS      STATUS+0, 2
	GOTO       L_main29
;Project5.c,72 :: 		if(WiperValue1<128) WiperValue1++;
	MOVLW      128
	XORWF      _WiperValue1+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main56
	MOVLW      128
	SUBWF      _WiperValue1+0, 0
L__main56:
	BTFSC      STATUS+0, 0
	GOTO       L_main30
	INCF       _WiperValue1+0, 1
	BTFSC      STATUS+0, 2
	INCF       _WiperValue1+1, 1
L_main30:
;Project5.c,73 :: 		set_pot(WiperValue1,WRITEWIPE1);
	MOVF       _WiperValue1+0, 0
	MOVWF      FARG_set_pot_value+0
	MOVF       _WiperValue1+1, 0
	MOVWF      FARG_set_pot_value+1
	MOVLW      16
	MOVWF      FARG_set_pot_control+0
	MOVLW      0
	MOVWF      FARG_set_pot_control+1
	CALL       _set_pot+0
;Project5.c,74 :: 		}
	GOTO       L_main31
L_main29:
;Project5.c,75 :: 		else if(input == 'a') {
	MOVF       main_input_L0+0, 0
	XORLW      97
	BTFSS      STATUS+0, 2
	GOTO       L_main32
;Project5.c,76 :: 		if(WiperValue1>6) WiperValue1--;
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _WiperValue1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main57
	MOVF       _WiperValue1+0, 0
	SUBLW      6
L__main57:
	BTFSC      STATUS+0, 0
	GOTO       L_main33
	MOVLW      1
	SUBWF      _WiperValue1+0, 1
	BTFSS      STATUS+0, 0
	DECF       _WiperValue1+1, 1
L_main33:
;Project5.c,77 :: 		set_pot(WiperValue1,WRITEWIPE1);
	MOVF       _WiperValue1+0, 0
	MOVWF      FARG_set_pot_value+0
	MOVF       _WiperValue1+1, 0
	MOVWF      FARG_set_pot_value+1
	MOVLW      16
	MOVWF      FARG_set_pot_control+0
	MOVLW      0
	MOVWF      FARG_set_pot_control+1
	CALL       _set_pot+0
;Project5.c,78 :: 		}
	GOTO       L_main34
L_main32:
;Project5.c,79 :: 		else if(input == 'x') {
	MOVF       main_input_L0+0, 0
	XORLW      120
	BTFSS      STATUS+0, 2
	GOTO       L_main35
;Project5.c,80 :: 		if(WiperValue0<128) WiperValue0++;
	MOVLW      128
	XORWF      _WiperValue0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main58
	MOVLW      128
	SUBWF      _WiperValue0+0, 0
L__main58:
	BTFSC      STATUS+0, 0
	GOTO       L_main36
	INCF       _WiperValue0+0, 1
	BTFSC      STATUS+0, 2
	INCF       _WiperValue0+1, 1
L_main36:
;Project5.c,81 :: 		set_pot(WiperValue0,WRITEWIPE0);
	MOVF       _WiperValue0+0, 0
	MOVWF      FARG_set_pot_value+0
	MOVF       _WiperValue0+1, 0
	MOVWF      FARG_set_pot_value+1
	CLRF       FARG_set_pot_control+0
	CLRF       FARG_set_pot_control+1
	CALL       _set_pot+0
;Project5.c,82 :: 		}
	GOTO       L_main37
L_main35:
;Project5.c,83 :: 		else if(input == 's') {
	MOVF       main_input_L0+0, 0
	XORLW      115
	BTFSS      STATUS+0, 2
	GOTO       L_main38
;Project5.c,84 :: 		if(WiperValue0 > 0) WiperValue0--;
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _WiperValue0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main59
	MOVF       _WiperValue0+0, 0
	SUBLW      0
L__main59:
	BTFSC      STATUS+0, 0
	GOTO       L_main39
	MOVLW      1
	SUBWF      _WiperValue0+0, 1
	BTFSS      STATUS+0, 0
	DECF       _WiperValue0+1, 1
L_main39:
;Project5.c,85 :: 		set_pot(WiperValue0,WRITEWIPE0);
	MOVF       _WiperValue0+0, 0
	MOVWF      FARG_set_pot_value+0
	MOVF       _WiperValue0+1, 0
	MOVWF      FARG_set_pot_value+1
	CLRF       FARG_set_pot_control+0
	CLRF       FARG_set_pot_control+1
	CALL       _set_pot+0
;Project5.c,86 :: 		}
	GOTO       L_main40
L_main38:
;Project5.c,87 :: 		else PrintAString(error);
	MOVLW      _error+0
	MOVWF      FARG_PrintAString_string+0
	CALL       _PrintAString+0
L_main40:
L_main37:
L_main34:
L_main31:
;Project5.c,89 :: 		PrintAstring(freqValue);
	MOVLW      _freqValue+0
	MOVWF      FARG_PrintAString_string+0
	CALL       _PrintAString+0
;Project5.c,90 :: 		InttoStr((int)calcfrequency(WiperValue1),temp);
	MOVF       _WiperValue1+0, 0
	MOVWF      FARG_calcFrequency_wiper+0
	MOVF       _WiperValue1+1, 0
	MOVWF      FARG_calcFrequency_wiper+1
	CALL       _calcFrequency+0
	CALL       _Double2Int+0
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _temp+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;Project5.c,91 :: 		PrintAString(temp);
	MOVLW      _temp+0
	MOVWF      FARG_PrintAString_string+0
	CALL       _PrintAString+0
;Project5.c,92 :: 		PrintAstring(crlf);
	MOVLW      _crlf+0
	MOVWF      FARG_PrintAString_string+0
	CALL       _PrintAString+0
;Project5.c,93 :: 		}
	GOTO       L_main25
;Project5.c,94 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
