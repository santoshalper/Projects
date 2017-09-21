
_main:

;MyProject.c,8 :: 		void main() {
;MyProject.c,9 :: 		OSCCON = 0x78; //16 MHz clock
	MOVLW      120
	MOVWF      OSCCON+0
;MyProject.c,10 :: 		INTCON = 0;
	CLRF       INTCON+0
;MyProject.c,11 :: 		TRISA = 0xFF;TRISB=0xFF;
	MOVLW      255
	MOVWF      TRISA+0
	MOVLW      255
	MOVWF      TRISB+0
;MyProject.c,12 :: 		TRISC = 0xFF;//b3  is input
	MOVLW      255
	MOVWF      TRISC+0
;MyProject.c,13 :: 		ANSELA = 0x00;
	CLRF       ANSELA+0
;MyProject.c,14 :: 		ANSELB = 0x00;
	CLRF       ANSELB+0
;MyProject.c,15 :: 		ANSELC = 0x00;
	CLRF       ANSELC+0
;MyProject.c,16 :: 		ANSELA.B4 = 1;
	BSF        ANSELA+0, 4
;MyProject.c,17 :: 		C1ON_BIT = 0;
	BCF        C1ON_bit+0, 7
;MyProject.c,18 :: 		C2ON_BIT = 0;
	BCF        C2ON_bit+0, 7
;MyProject.c,19 :: 		CCP2CON = 0x0A;
	MOVLW      10
	MOVWF      CCP2CON+0
;MyProject.c,20 :: 		CCPR2L = 0x40;
	MOVLW      64
	MOVWF      CCPR2L+0
;MyProject.c,21 :: 		CCPR2H = 0x9C;//0x9C40 = 40000 = 4,000,000Hz/100Hz
	MOVLW      156
	MOVWF      CCPR2H+0
;MyProject.c,22 :: 		T1CON =  0x01;
	MOVLW      1
	MOVWF      T1CON+0
;MyProject.c,23 :: 		PIE1 = 0x00;
	CLRF       PIE1+0
;MyProject.c,24 :: 		PIE2 = 0x01;
	MOVLW      1
	MOVWF      PIE2+0
;MyProject.c,25 :: 		PIE3 =0x00;
	CLRF       PIE3+0
;MyProject.c,26 :: 		PIE4 = 0x00;
	CLRF       PIE4+0
;MyProject.c,27 :: 		INTCON = 0xC0;
	MOVLW      192
	MOVWF      INTCON+0
;MyProject.c,28 :: 		uart1_init(9600);
	BSF        BAUDCON+0, 3
	MOVLW      160
	MOVWF      SPBRG+0
	MOVLW      1
	MOVWF      SPBRG+1
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;MyProject.c,29 :: 		while(1) {
L_main0:
;MyProject.c,30 :: 		uart1_write(outangle);
	MOVF       _outangle+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;MyProject.c,31 :: 		}
	GOTO       L_main0
;MyProject.c,32 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_convert:

;MyProject.c,33 :: 		float convert(int rawdat) {
;MyProject.c,36 :: 		retdat = (float)rawdat;
	MOVF       FARG_convert_rawdat+0, 0
	MOVWF      R0
	MOVF       FARG_convert_rawdat+1, 0
	MOVWF      R1
	CALL       _Int2Double+0
;MyProject.c,37 :: 		return retdat;
;MyProject.c,38 :: 		}
L_end_convert:
	RETURN
; end of _convert

_interrupt:
	CLRF       PCLATH+0
	CLRF       STATUS+0

;MyProject.c,40 :: 		void interrupt(void){
;MyProject.c,42 :: 		PIR2.CCP2IF = 0;
	BCF        PIR2+0, 0
;MyProject.c,43 :: 		last = curr;
	MOVF       _curr+0, 0
	MOVWF      _last+0
	MOVF       _curr+1, 0
	MOVWF      _last+1
	MOVF       _curr+2, 0
	MOVWF      _last+2
	MOVF       _curr+3, 0
	MOVWF      _last+3
;MyProject.c,44 :: 		curr = convert(adc_read(4));
	MOVLW      4
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0, 0
	MOVWF      FARG_convert_rawdat+0
	MOVF       R1, 0
	MOVWF      FARG_convert_rawdat+1
	CALL       _convert+0
	MOVF       R0, 0
	MOVWF      _curr+0
	MOVF       R1, 0
	MOVWF      _curr+1
	MOVF       R2, 0
	MOVWF      _curr+2
	MOVF       R3, 0
	MOVWF      _curr+3
;MyProject.c,45 :: 		for(k=(SAMPLES-1);k>0;k--)
	MOVLW      4
	MOVWF      interrupt_k_L0+0
	MOVLW      0
	MOVWF      interrupt_k_L0+1
L_interrupt2:
	MOVLW      128
	MOVWF      R0
	MOVLW      128
	XORWF      interrupt_k_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt12
	MOVF       interrupt_k_L0+0, 0
	SUBLW      0
L__interrupt12:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt3
;MyProject.c,46 :: 		y[k]=(1-ALPHA)*y[k-1];
	MOVF       interrupt_k_L0+0, 0
	MOVWF      R0
	MOVF       interrupt_k_L0+1, 0
	MOVWF      R1
	LSLF       R0, 1
	RLF        R1, 1
	LSLF       R0, 1
	RLF        R1, 1
	MOVLW      _y+0
	ADDWF      R0, 0
	MOVWF      FLOC__interrupt+0
	MOVLW      hi_addr(_y+0)
	ADDWFC     R1, 0
	MOVWF      FLOC__interrupt+1
	MOVLW      1
	SUBWF      interrupt_k_L0+0, 0
	MOVWF      R3
	MOVLW      0
	SUBWFB     interrupt_k_L0+1, 0
	MOVWF      R4
	MOVF       R3, 0
	MOVWF      R0
	MOVF       R4, 0
	MOVWF      R1
	LSLF       R0, 1
	RLF        R1, 1
	LSLF       R0, 1
	RLF        R1, 1
	MOVLW      _y+0
	ADDWF      R0, 0
	MOVWF      FSR0L
	MOVLW      hi_addr(_y+0)
	ADDWFC     R1, 0
	MOVWF      FSR0H
	MOVF       INDF0+0, 0
	MOVWF      R0
	ADDFSR     0, 1
	MOVF       INDF0+0, 0
	MOVWF      R1
	ADDFSR     0, 1
	MOVF       INDF0+0, 0
	MOVWF      R2
	ADDFSR     0, 1
	MOVF       INDF0+0, 0
	MOVWF      R3
	MOVLW      198
	MOVWF      R4
	MOVLW      196
	MOVWF      R5
	MOVLW      102
	MOVWF      R6
	MOVLW      125
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
	MOVF       FLOC__interrupt+0, 0
	MOVWF      FSR1L
	MOVF       FLOC__interrupt+1, 0
	MOVWF      FSR1H
	MOVF       R0, 0
	MOVWF      INDF1+0
	MOVF       R1, 0
	ADDFSR     1, 1
	MOVWF      INDF1+0
	MOVF       R2, 0
	ADDFSR     1, 1
	MOVWF      INDF1+0
	MOVF       R3, 0
	ADDFSR     1, 1
	MOVWF      INDF1+0
;MyProject.c,45 :: 		for(k=(SAMPLES-1);k>0;k--)
	MOVLW      1
	SUBWF      interrupt_k_L0+0, 1
	MOVLW      0
	SUBWFB     interrupt_k_L0+1, 1
;MyProject.c,46 :: 		y[k]=(1-ALPHA)*y[k-1];
	GOTO       L_interrupt2
L_interrupt3:
;MyProject.c,47 :: 		y[0] = (0.005*(last+curr))*ALPHA;
	MOVF       _last+0, 0
	MOVWF      R0
	MOVF       _last+1, 0
	MOVWF      R1
	MOVF       _last+2, 0
	MOVWF      R2
	MOVF       _last+3, 0
	MOVWF      R3
	MOVF       _curr+0, 0
	MOVWF      R4
	MOVF       _curr+1, 0
	MOVWF      R5
	MOVF       _curr+2, 0
	MOVWF      R6
	MOVF       _curr+3, 0
	MOVWF      R7
	CALL       _Add_32x32_FP+0
	MOVLW      10
	MOVWF      R4
	MOVLW      215
	MOVWF      R5
	MOVLW      35
	MOVWF      R6
	MOVLW      119
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
	MOVLW      157
	MOVWF      R4
	MOVLW      157
	MOVWF      R5
	MOVLW      12
	MOVWF      R6
	MOVLW      126
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
	MOVF       R0, 0
	MOVWF      _y+0
	MOVF       R1, 0
	MOVWF      _y+1
	MOVF       R2, 0
	MOVWF      _y+2
	MOVF       R3, 0
	MOVWF      _y+3
;MyProject.c,48 :: 		for(k=0;k<SAMPLES;k++)
	CLRF       interrupt_k_L0+0
	CLRF       interrupt_k_L0+1
L_interrupt5:
	MOVLW      128
	XORWF      interrupt_k_L0+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt13
	MOVLW      5
	SUBWF      interrupt_k_L0+0, 0
L__interrupt13:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt6
;MyProject.c,49 :: 		outangle += y[k];
	MOVF       interrupt_k_L0+0, 0
	MOVWF      R0
	MOVF       interrupt_k_L0+1, 0
	MOVWF      R1
	LSLF       R0, 1
	RLF        R1, 1
	LSLF       R0, 1
	RLF        R1, 1
	MOVLW      _y+0
	ADDWF      R0, 0
	MOVWF      FLOC__interrupt+0
	MOVLW      hi_addr(_y+0)
	ADDWFC     R1, 0
	MOVWF      FLOC__interrupt+1
	MOVF       _outangle+0, 0
	MOVWF      R0
	MOVF       _outangle+1, 0
	MOVWF      R1
	CALL       _Int2Double+0
	MOVF       FLOC__interrupt+0, 0
	MOVWF      FSR0L
	MOVF       FLOC__interrupt+1, 0
	MOVWF      FSR0H
	MOVF       INDF0+0, 0
	MOVWF      R4
	ADDFSR     0, 1
	MOVF       INDF0+0, 0
	MOVWF      R5
	ADDFSR     0, 1
	MOVF       INDF0+0, 0
	MOVWF      R6
	ADDFSR     0, 1
	MOVF       INDF0+0, 0
	MOVWF      R7
	CALL       _Add_32x32_FP+0
	CALL       _Double2Int+0
	MOVF       R0, 0
	MOVWF      _outangle+0
	MOVF       R1, 0
	MOVWF      _outangle+1
;MyProject.c,48 :: 		for(k=0;k<SAMPLES;k++)
	INCF       interrupt_k_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       interrupt_k_L0+1, 1
;MyProject.c,49 :: 		outangle += y[k];
	GOTO       L_interrupt5
L_interrupt6:
;MyProject.c,50 :: 		}
L_end_interrupt:
L__interrupt11:
	RETFIE     %s
; end of _interrupt
