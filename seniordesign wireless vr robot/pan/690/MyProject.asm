
_init:

;MyProject.c,30 :: 		void init() {
;MyProject.c,31 :: 		OSCCON.B4 = 1;
	BSF        OSCCON+0, 4
;MyProject.c,32 :: 		OSCCON.B5 = 1;
	BSF        OSCCON+0, 5
;MyProject.c,33 :: 		OSCCON.B6 = 1;
	BSF        OSCCON+0, 6
;MyProject.c,34 :: 		TRISA=0xff; TRISB=0xff; TRISC=0xff;
	MOVLW      255
	MOVWF      TRISA+0
	MOVLW      255
	MOVWF      TRISB+0
	MOVLW      255
	MOVWF      TRISC+0
;MyProject.c,35 :: 		ANSEL=ANSELH=0;
	CLRF       ANSELH+0
	CLRF       ANSEL+0
;MyProject.c,36 :: 		ANSEL |= BIT(GYRO);
	MOVLW      8
	MOVWF      ANSEL+0
;MyProject.c,37 :: 		uart1_init(19200);
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;MyProject.c,38 :: 		ADC_Init();
	CALL       _ADC_Init+0
;MyProject.c,39 :: 		OPTION_REG = 0xD3;// Set prescaler and clock source
	MOVLW      211
	MOVWF      OPTION_REG+0
;MyProject.c,40 :: 		counter=0;
	CLRF       _counter+0
	CLRF       _counter+1
;MyProject.c,41 :: 		gyro = 750;
	MOVLW      238
	MOVWF      _gyro+0
	MOVLW      2
	MOVWF      _gyro+1
;MyProject.c,42 :: 		refValue=0;
	CLRF       _refValue+0
	CLRF       _refValue+1
;MyProject.c,43 :: 		angle=0;
	CLRF       _angle+0
	CLRF       _angle+1
;MyProject.c,45 :: 		}
L_end_init:
	RETURN
; end of _init

_enable_interrupts:

;MyProject.c,46 :: 		void enable_interrupts() {
;MyProject.c,47 :: 		_T0IE = 1; // Enable timer zero interrupt
	BSF        INTCON+0, 5
;MyProject.c,48 :: 		_GIE = 1; // Global Interrupt enable
	BSF        INTCON+0, 7
;MyProject.c,49 :: 		}
L_end_enable_interrupts:
	RETURN
; end of _enable_interrupts

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;MyProject.c,59 :: 		ISR() { // Interrupt service routine
;MyProject.c,60 :: 		if (_T0IE && _T0IF) {
	BTFSS      INTCON+0, 5
	GOTO       L_interrupt2
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt2
L__interrupt22:
;MyProject.c,61 :: 		Task();
	CALL       _Task+0
;MyProject.c,62 :: 		TMR0+=95;
	MOVLW      95
	ADDWF      TMR0+0, 1
;MyProject.c,63 :: 		_T0IF = 0;
	BCF        INTCON+0, 2
;MyProject.c,64 :: 		}
L_interrupt2:
;MyProject.c,65 :: 		}
L_end_interrupt:
L__interrupt26:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_Task:

;MyProject.c,69 :: 		void Task() {
;MyProject.c,70 :: 		raw=ADC_Read(GYRO);
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _raw+0
	MOVF       R0+1, 0
	MOVWF      _raw+1
;MyProject.c,71 :: 		if (counter < 2000) {
	MOVLW      128
	XORWF      _counter+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      7
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Task28
	MOVLW      208
	SUBWF      _counter+0, 0
L__Task28:
	BTFSC      STATUS+0, 0
	GOTO       L_Task3
;MyProject.c,72 :: 		gyro = raw;
	MOVF       _raw+0, 0
	MOVWF      _gyro+0
	MOVF       _raw+1, 0
	MOVWF      _gyro+1
;MyProject.c,73 :: 		refValue += (gyro>refValue?
	MOVLW      128
	XORWF      _refValue+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      _raw+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Task29
	MOVF       _raw+0, 0
	SUBWF      _refValue+0, 0
L__Task29:
	BTFSC      STATUS+0, 0
	GOTO       L_Task4
;MyProject.c,74 :: 		(gyro-refValue)/2:
	MOVF       _refValue+0, 0
	SUBWF      _gyro+0, 0
	MOVWF      R3+0
	MOVF       _refValue+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _gyro+1, 0
	MOVWF      R3+1
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	BTFSC      R0+1, 6
	BSF        R0+1, 7
	MOVF       R0+0, 0
	MOVWF      R5+0
	MOVF       R0+1, 0
	MOVWF      R5+1
	GOTO       L_Task5
L_Task4:
;MyProject.c,75 :: 		-((refValue-gyro)/2));
	MOVF       _gyro+0, 0
	SUBWF      _refValue+0, 0
	MOVWF      R3+0
	MOVF       _gyro+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _refValue+1, 0
	MOVWF      R3+1
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	BTFSC      R0+1, 6
	BSF        R0+1, 7
	MOVF       R0+0, 0
	SUBLW      0
	MOVWF      R0+0
	MOVF       R0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      R5+0
	MOVF       R0+1, 0
	MOVWF      R5+1
L_Task5:
	MOVF       R5+0, 0
	ADDWF      _refValue+0, 1
	MOVF       R5+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _refValue+1, 1
;MyProject.c,76 :: 		counter++;
	INCF       _counter+0, 1
	BTFSC      STATUS+0, 2
	INCF       _counter+1, 1
;MyProject.c,77 :: 		} else {
	GOTO       L_Task6
L_Task3:
;MyProject.c,78 :: 		gyro += (raw>gyro?
	MOVLW      128
	XORWF      _gyro+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      _raw+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Task30
	MOVF       _raw+0, 0
	SUBWF      _gyro+0, 0
L__Task30:
	BTFSC      STATUS+0, 0
	GOTO       L_Task7
;MyProject.c,79 :: 		(raw-gyro)/8:
	MOVF       _gyro+0, 0
	SUBWF      _raw+0, 0
	MOVWF      R3+0
	MOVF       _gyro+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _raw+1, 0
	MOVWF      R3+1
	MOVLW      3
	MOVWF      R2+0
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__Task31:
	BTFSC      STATUS+0, 2
	GOTO       L__Task32
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	BTFSC      R0+1, 6
	BSF        R0+1, 7
	ADDLW      255
	GOTO       L__Task31
L__Task32:
	MOVF       R0+0, 0
	MOVWF      R5+0
	MOVF       R0+1, 0
	MOVWF      R5+1
	GOTO       L_Task8
L_Task7:
;MyProject.c,80 :: 		-((gyro-raw)/8));
	MOVF       _raw+0, 0
	SUBWF      _gyro+0, 0
	MOVWF      R3+0
	MOVF       _raw+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _gyro+1, 0
	MOVWF      R3+1
	MOVLW      3
	MOVWF      R2+0
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__Task33:
	BTFSC      STATUS+0, 2
	GOTO       L__Task34
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	BTFSC      R0+1, 6
	BSF        R0+1, 7
	ADDLW      255
	GOTO       L__Task33
L__Task34:
	MOVF       R0+0, 0
	SUBLW      0
	MOVWF      R0+0
	MOVF       R0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      R5+0
	MOVF       R0+1, 0
	MOVWF      R5+1
L_Task8:
	MOVF       R5+0, 0
	ADDWF      _gyro+0, 0
	MOVWF      R1+0
	MOVF       _gyro+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R5+1, 0
	MOVWF      R1+1
	MOVF       R1+0, 0
	MOVWF      _gyro+0
	MOVF       R1+1, 0
	MOVWF      _gyro+1
;MyProject.c,81 :: 		angle+=(gyro>refValue?
	MOVLW      128
	XORWF      _refValue+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      R1+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Task35
	MOVF       R1+0, 0
	SUBWF      _refValue+0, 0
L__Task35:
	BTFSC      STATUS+0, 0
	GOTO       L_Task9
;MyProject.c,82 :: 		(gyro-refValue)/32:
	MOVF       _refValue+0, 0
	SUBWF      _gyro+0, 0
	MOVWF      R3+0
	MOVF       _refValue+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _gyro+1, 0
	MOVWF      R3+1
	MOVLW      5
	MOVWF      R2+0
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__Task36:
	BTFSC      STATUS+0, 2
	GOTO       L__Task37
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	BTFSC      R0+1, 6
	BSF        R0+1, 7
	ADDLW      255
	GOTO       L__Task36
L__Task37:
	MOVF       R0+0, 0
	MOVWF      R5+0
	MOVF       R0+1, 0
	MOVWF      R5+1
	GOTO       L_Task10
L_Task9:
;MyProject.c,83 :: 		-((refValue-gyro)/32));
	MOVF       _gyro+0, 0
	SUBWF      _refValue+0, 0
	MOVWF      R3+0
	MOVF       _gyro+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _refValue+1, 0
	MOVWF      R3+1
	MOVLW      5
	MOVWF      R2+0
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	MOVF       R2+0, 0
L__Task38:
	BTFSC      STATUS+0, 2
	GOTO       L__Task39
	RRF        R0+1, 1
	RRF        R0+0, 1
	BCF        R0+1, 7
	BTFSC      R0+1, 6
	BSF        R0+1, 7
	ADDLW      255
	GOTO       L__Task38
L__Task39:
	MOVF       R0+0, 0
	SUBLW      0
	MOVWF      R0+0
	MOVF       R0+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      R5+0
	MOVF       R0+1, 0
	MOVWF      R5+1
L_Task10:
	MOVF       R5+0, 0
	ADDWF      _angle+0, 0
	MOVWF      R0+0
	MOVF       _angle+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R5+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _angle+0
	MOVF       R0+1, 0
	MOVWF      _angle+1
;MyProject.c,84 :: 		outangle = 90+(angle/360)*6;
	MOVLW      104
	MOVWF      R4+0
	MOVLW      1
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVLW      6
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVF       R0+0, 0
	ADDLW      90
	MOVWF      R2+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      R2+1
	MOVF       R2+0, 0
	MOVWF      _outangle+0
	MOVF       R2+1, 0
	MOVWF      _outangle+1
;MyProject.c,85 :: 		if(outangle <0) outangle = 0;
	MOVLW      128
	XORWF      R2+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Task40
	MOVLW      0
	SUBWF      R2+0, 0
L__Task40:
	BTFSC      STATUS+0, 0
	GOTO       L_Task11
	CLRF       _outangle+0
	CLRF       _outangle+1
L_Task11:
;MyProject.c,86 :: 		if(outangle>180) outangle = 180;
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _outangle+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Task41
	MOVF       _outangle+0, 0
	SUBLW      180
L__Task41:
	BTFSC      STATUS+0, 0
	GOTO       L_Task12
	MOVLW      180
	MOVWF      _outangle+0
	CLRF       _outangle+1
L_Task12:
;MyProject.c,88 :: 		}
L_Task6:
;MyProject.c,89 :: 		}
L_end_Task:
	RETURN
; end of _Task

_outInt:

;MyProject.c,91 :: 		void outInt(int x) {
;MyProject.c,92 :: 		IntToStr(x, buffer);
	MOVF       FARG_outInt_x+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       FARG_outInt_x+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _buffer+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;MyProject.c,93 :: 		Uart1_Write_Text(buffer);
	MOVLW      _buffer+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;MyProject.c,94 :: 		Uart1_Write(' ');
	MOVLW      32
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;MyProject.c,95 :: 		}
L_end_outInt:
	RETURN
; end of _outInt

_outFloat:

;MyProject.c,97 :: 		void outFloat(float x) {
;MyProject.c,98 :: 		FloatToStr(x, buffer);
	MOVF       FARG_outFloat_x+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       FARG_outFloat_x+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       FARG_outFloat_x+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       FARG_outFloat_x+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      _buffer+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
;MyProject.c,99 :: 		Uart1_Write_Text(buffer);
	MOVLW      _buffer+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;MyProject.c,100 :: 		Uart1_Write(' ');
	MOVLW      32
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;MyProject.c,101 :: 		}
L_end_outFloat:
	RETURN
; end of _outFloat

_main:

;MyProject.c,103 :: 		void oldmain() {
;MyProject.c,105 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main13:
	DECFSZ     R13+0, 1
	GOTO       L_main13
	DECFSZ     R12+0, 1
	GOTO       L_main13
	DECFSZ     R11+0, 1
	GOTO       L_main13
	NOP
	NOP
;MyProject.c,106 :: 		init();
	CALL       _init+0
;MyProject.c,107 :: 		enable_interrupts();
	CALL       _enable_interrupts+0
;MyProject.c,108 :: 		while(1) {
L_main14:
;MyProject.c,109 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main16:
	DECFSZ     R13+0, 1
	GOTO       L_main16
	DECFSZ     R12+0, 1
	GOTO       L_main16
	DECFSZ     R11+0, 1
	GOTO       L_main16
	NOP
;MyProject.c,110 :: 		if (counter < 2000) {
	MOVLW      128
	XORWF      _counter+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORLW      7
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main45
	MOVLW      208
	SUBWF      _counter+0, 0
L__main45:
	BTFSC      STATUS+0, 0
	GOTO       L_main17
;MyProject.c,111 :: 		outInt(counter);
	MOVF       _counter+0, 0
	MOVWF      FARG_outInt_x+0
	MOVF       _counter+1, 0
	MOVWF      FARG_outInt_x+1
	CALL       _outInt+0
;MyProject.c,112 :: 		OUTFLT(gyro);
	MOVF       _gyro+0, 0
	MOVWF      FARG_outInt_x+0
	MOVF       _gyro+1, 0
	MOVWF      FARG_outInt_x+1
	CALL       _outInt+0
;MyProject.c,113 :: 		OUTFLT(refValue);
	MOVF       _refValue+0, 0
	MOVWF      FARG_outInt_x+0
	MOVF       _refValue+1, 0
	MOVWF      FARG_outInt_x+1
	CALL       _outInt+0
;MyProject.c,114 :: 		Uart1_Write_Text("\r\n");
	MOVLW      ?lstr1_MyProject+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;MyProject.c,115 :: 		} else {
	GOTO       L_main18
L_main17:
;MyProject.c,116 :: 		OUTFLT(gyro);OUTFLT(refValue);OUTFLT(angle);OUTFLT(outangle);
	MOVF       _gyro+0, 0
	MOVWF      FARG_outInt_x+0
	MOVF       _gyro+1, 0
	MOVWF      FARG_outInt_x+1
	CALL       _outInt+0
	MOVF       _refValue+0, 0
	MOVWF      FARG_outInt_x+0
	MOVF       _refValue+1, 0
	MOVWF      FARG_outInt_x+1
	CALL       _outInt+0
	MOVF       _angle+0, 0
	MOVWF      FARG_outInt_x+0
	MOVF       _angle+1, 0
	MOVWF      FARG_outInt_x+1
	CALL       _outInt+0
	MOVF       _outangle+0, 0
	MOVWF      FARG_outInt_x+0
	MOVF       _outangle+1, 0
	MOVWF      FARG_outInt_x+1
	CALL       _outInt+0
;MyProject.c,117 :: 		Uart1_Write_Text("\r\n");
	MOVLW      ?lstr2_MyProject+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;MyProject.c,118 :: 		}
L_main18:
;MyProject.c,120 :: 		}
	GOTO       L_main14
;MyProject.c,121 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_newmain:

;MyProject.c,123 :: 		void newmain() {
;MyProject.c,124 :: 		init();
	CALL       _init+0
;MyProject.c,126 :: 		while(1) {
L_newmain19:
;MyProject.c,127 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_newmain21:
	DECFSZ     R13+0, 1
	GOTO       L_newmain21
	DECFSZ     R12+0, 1
	GOTO       L_newmain21
	NOP
;MyProject.c,128 :: 		Task();
	CALL       _Task+0
;MyProject.c,129 :: 		OutInt(counter);
	MOVF       _counter+0, 0
	MOVWF      FARG_outInt_x+0
	MOVF       _counter+1, 0
	MOVWF      FARG_outInt_x+1
	CALL       _outInt+0
;MyProject.c,130 :: 		OUTFLT(gyro);  OUTFLT(refValue); OUTFLT(angle); OUTFLT(outangle);
	MOVF       _gyro+0, 0
	MOVWF      FARG_outInt_x+0
	MOVF       _gyro+1, 0
	MOVWF      FARG_outInt_x+1
	CALL       _outInt+0
	MOVF       _refValue+0, 0
	MOVWF      FARG_outInt_x+0
	MOVF       _refValue+1, 0
	MOVWF      FARG_outInt_x+1
	CALL       _outInt+0
	MOVF       _angle+0, 0
	MOVWF      FARG_outInt_x+0
	MOVF       _angle+1, 0
	MOVWF      FARG_outInt_x+1
	CALL       _outInt+0
	MOVF       _outangle+0, 0
	MOVWF      FARG_outInt_x+0
	MOVF       _outangle+1, 0
	MOVWF      FARG_outInt_x+1
	CALL       _outInt+0
;MyProject.c,131 :: 		Uart1_Write_Text("\r\n");
	MOVLW      ?lstr3_MyProject+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;MyProject.c,132 :: 		}
	GOTO       L_newmain19
;MyProject.c,133 :: 		}
L_end_newmain:
	RETURN
; end of _newmain
