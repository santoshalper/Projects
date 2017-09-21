
_main:

;receiver.c,68 :: 		void main() {
;receiver.c,70 :: 		int i=0;
	CLRF       main_i_L0+0
	CLRF       main_i_L0+1
;receiver.c,71 :: 		OSCCON = 0x78; //16 MHz clock
	MOVLW      120
	MOVWF      OSCCON+0
;receiver.c,72 :: 		INTCON = 0;
	CLRF       INTCON+0
;receiver.c,73 :: 		TRISA = 0xEB;TRISB=0xFF;//RA4,RA2 are out
	MOVLW      235
	MOVWF      TRISA+0
	MOVLW      255
	MOVWF      TRISB+0
;receiver.c,74 :: 		TRISC = 0x86;//RC6,RC5,RC4,and RC0 are out
	MOVLW      134
	MOVWF      TRISC+0
;receiver.c,75 :: 		NSS = 1;
	BSF        PORTC+0, 0
;receiver.c,76 :: 		ANSELA = 0x00;
	CLRF       ANSELA+0
;receiver.c,77 :: 		ANSELB = 0x00;
	CLRF       ANSELB+0
;receiver.c,78 :: 		ANSELC = 0x00;
	CLRF       ANSELC+0
;receiver.c,79 :: 		C1ON_BIT = 0;
	BCF        C1ON_bit+0, 7
;receiver.c,80 :: 		C2ON_BIT = 0;
	BCF        C2ON_bit+0, 7
;receiver.c,81 :: 		Soft_SPI_Init();
	CALL       _Soft_SPI_Init+0
;receiver.c,82 :: 		SSP1STAT |= 0x40;   //data sent on falling edge
	BSF        SSP1STAT+0, 6
;receiver.c,83 :: 		init_PWM();
	CALL       _init_PWM+0
;receiver.c,84 :: 		init_receiver();
	CALL       _init_receiver+0
;receiver.c,85 :: 		Uart1_Init(9600);
	BSF        BAUDCON+0, 3
	MOVLW      160
	MOVWF      SPBRG+0
	MOVLW      1
	MOVWF      SPBRG+1
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;receiver.c,93 :: 		while(1){
L_main0:
;receiver.c,94 :: 		receive(stuff);
	MOVLW      main_stuff_L0+0
	MOVWF      FARG_receive+0
	MOVLW      hi_addr(main_stuff_L0+0)
	MOVWF      FARG_receive+1
	CALL       _receive+0
;receiver.c,95 :: 		for(i=0;i<PAYLOADSIZE;i++){
	CLRF       main_i_L0+0
	CLRF       main_i_L0+1
L_main2:
	MOVLW      128
	XORWF      main_i_L0+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main13
	MOVLW      5
	SUBWF      main_i_L0+0, 0
L__main13:
	BTFSC      STATUS+0, 0
	GOTO       L_main3
;receiver.c,96 :: 		Uart1_Write(stuff[i]);
	MOVF       main_i_L0+0, 0
	MOVWF      R0
	MOVF       main_i_L0+1, 0
	MOVWF      R1
	LSLF       R0, 1
	RLF        R1, 1
	MOVLW      main_stuff_L0+0
	ADDWF      R0, 0
	MOVWF      FSR0L
	MOVLW      hi_addr(main_stuff_L0+0)
	ADDWFC     R1, 0
	MOVWF      FSR0H
	MOVF       INDF0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;receiver.c,95 :: 		for(i=0;i<PAYLOADSIZE;i++){
	INCF       main_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       main_i_L0+1, 1
;receiver.c,97 :: 		}
	GOTO       L_main2
L_main3:
;receiver.c,98 :: 		delay_ms(50);
	MOVLW      2
	MOVWF      R11
	MOVLW      4
	MOVWF      R12
	MOVLW      186
	MOVWF      R13
L_main5:
	DECFSZ     R13, 1
	GOTO       L_main5
	DECFSZ     R12, 1
	GOTO       L_main5
	DECFSZ     R11, 1
	GOTO       L_main5
	NOP
;receiver.c,99 :: 		}
	GOTO       L_main0
;receiver.c,100 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_init_PWM:

;receiver.c,101 :: 		void init_PWM() {
;receiver.c,102 :: 		PWM1_Init(5000);
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      199
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;receiver.c,103 :: 		PWM2_Init(5000);
	BSF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      199
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;receiver.c,104 :: 		SpeedLeft(0);
	CLRF       FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;receiver.c,105 :: 		SpeedRight(0);
	CLRF       FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;receiver.c,106 :: 		PWM1_Start();
	CALL       _PWM1_Start+0
;receiver.c,107 :: 		PWM2_Start();
	CALL       _PWM2_Start+0
;receiver.c,108 :: 		}
L_end_init_PWM:
	RETURN
; end of _init_PWM

_stop:

;receiver.c,109 :: 		void stop() {
;receiver.c,110 :: 		RMotorFor=RMotorRev=LMotorFor=LMotorRev=0;
	BCF        PORTC+0, 4
	BTFSC      PORTC+0, 4
	GOTO       L__stop16
	BCF        PORTA+0, 4
	GOTO       L__stop17
L__stop16:
	BSF        PORTA+0, 4
L__stop17:
	BTFSC      PORTA+0, 4
	GOTO       L__stop18
	BCF        PORTC+0, 6
	GOTO       L__stop19
L__stop18:
	BSF        PORTC+0, 6
L__stop19:
	BTFSC      PORTC+0, 6
	GOTO       L__stop20
	BCF        PORTA+0, 2
	GOTO       L__stop21
L__stop20:
	BSF        PORTA+0, 2
L__stop21:
;receiver.c,111 :: 		SpeedLeft(0);
	CLRF       FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;receiver.c,112 :: 		SpeedRight(0);
	CLRF       FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;receiver.c,113 :: 		}
L_end_stop:
	RETURN
; end of _stop

_setLeft:

;receiver.c,114 :: 		void setLeft(int speed) {
;receiver.c,115 :: 		LMotorFor = (speed & 0x80)>>7;
	MOVLW      128
	ANDWF      FARG_setLeft_speed+0, 0
	MOVWF      R3
	MOVF       FARG_setLeft_speed+1, 0
	MOVWF      R4
	MOVLW      0
	ANDWF      R4, 1
	MOVLW      7
	MOVWF      R2
	MOVF       R3, 0
	MOVWF      R0
	MOVF       R4, 0
	MOVWF      R1
	MOVF       R2, 0
L__setLeft23:
	BTFSC      STATUS+0, 2
	GOTO       L__setLeft24
	ASRF       R1, 1
	RRF        R0, 1
	ADDLW      255
	GOTO       L__setLeft23
L__setLeft24:
	BTFSC      R0, 0
	GOTO       L__setLeft25
	BCF        PORTA+0, 4
	GOTO       L__setLeft26
L__setLeft25:
	BSF        PORTA+0, 4
L__setLeft26:
;receiver.c,116 :: 		LMotorRev = !LMotorFor;
	BTFSC      PORTA+0, 4
	GOTO       L__setLeft27
	BSF        PORTC+0, 4
	GOTO       L__setLeft28
L__setLeft27:
	BCF        PORTC+0, 4
L__setLeft28:
;receiver.c,117 :: 		SpeedLeft(speed & 0x7F);
	MOVLW      127
	ANDWF      FARG_setLeft_speed+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;receiver.c,118 :: 		}
L_end_setLeft:
	RETURN
; end of _setLeft

_setRight:

;receiver.c,119 :: 		void setRight(int speed) {
;receiver.c,120 :: 		RMotorFor = (speed & 0x80)>>7;
	MOVLW      128
	ANDWF      FARG_setRight_speed+0, 0
	MOVWF      R3
	MOVF       FARG_setRight_speed+1, 0
	MOVWF      R4
	MOVLW      0
	ANDWF      R4, 1
	MOVLW      7
	MOVWF      R2
	MOVF       R3, 0
	MOVWF      R0
	MOVF       R4, 0
	MOVWF      R1
	MOVF       R2, 0
L__setRight30:
	BTFSC      STATUS+0, 2
	GOTO       L__setRight31
	ASRF       R1, 1
	RRF        R0, 1
	ADDLW      255
	GOTO       L__setRight30
L__setRight31:
	BTFSC      R0, 0
	GOTO       L__setRight32
	BCF        PORTA+0, 2
	GOTO       L__setRight33
L__setRight32:
	BSF        PORTA+0, 2
L__setRight33:
;receiver.c,121 :: 		RMotorRev = !RMotorFor;
	BTFSC      PORTA+0, 2
	GOTO       L__setRight34
	BSF        PORTC+0, 6
	GOTO       L__setRight35
L__setRight34:
	BCF        PORTC+0, 6
L__setRight35:
;receiver.c,122 :: 		SpeedRight(speed & 0x7F);
	MOVLW      127
	ANDWF      FARG_setRight_speed+0, 0
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;receiver.c,123 :: 		}
L_end_setRight:
	RETURN
; end of _setRight

_singlewrite:

;receiver.c,125 :: 		void singlewrite(int address,int value){
;receiver.c,126 :: 		NSS = 0;
	BCF        PORTC+0, 0
;receiver.c,127 :: 		soft_spi_write(address&0xff);
	MOVLW      255
	ANDWF      FARG_singlewrite_address+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;receiver.c,128 :: 		soft_spi_write(value&0xff);
	MOVLW      255
	ANDWF      FARG_singlewrite_value+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;receiver.c,129 :: 		NSS = 1;
	BSF        PORTC+0, 0
;receiver.c,130 :: 		}
L_end_singlewrite:
	RETURN
; end of _singlewrite

_burstwrite:

;receiver.c,131 :: 		void burstwrite(int address, int* value, int length) {
;receiver.c,132 :: 		int i = 0;
	CLRF       burstwrite_i_L0+0
	CLRF       burstwrite_i_L0+1
;receiver.c,134 :: 		NSS = 0;
	BCF        PORTC+0, 0
;receiver.c,135 :: 		soft_spi_write(address&0xff);
	MOVLW      255
	ANDWF      FARG_burstwrite_address+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;receiver.c,136 :: 		while(i<length) {
L_burstwrite6:
	MOVLW      128
	XORWF      burstwrite_i_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_burstwrite_length+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__burstwrite38
	MOVF       FARG_burstwrite_length+0, 0
	SUBWF      burstwrite_i_L0+0, 0
L__burstwrite38:
	BTFSC      STATUS+0, 0
	GOTO       L_burstwrite7
;receiver.c,137 :: 		j = value+i;
	MOVF       burstwrite_i_L0+0, 0
	MOVWF      R0
	MOVF       burstwrite_i_L0+1, 0
	MOVWF      R1
	LSLF       R0, 1
	RLF        R1, 1
	MOVF       R0, 0
	ADDWF      FARG_burstwrite_value+0, 0
	MOVWF      FSR0L
	MOVF       R1, 0
	ADDWFC     FARG_burstwrite_value+1, 0
	MOVWF      FSR0H
;receiver.c,138 :: 		soft_spi_write(*j&0xff);
	MOVLW      255
	ANDWF      INDF0+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;receiver.c,139 :: 		i++;
	INCF       burstwrite_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       burstwrite_i_L0+1, 1
;receiver.c,140 :: 		}
	GOTO       L_burstwrite6
L_burstwrite7:
;receiver.c,141 :: 		NSS = 1;
	BSF        PORTC+0, 0
;receiver.c,142 :: 		}
L_end_burstwrite:
	RETURN
; end of _burstwrite

_clear_fifo:

;receiver.c,143 :: 		void clear_fifo(void) {
;receiver.c,144 :: 		singlewrite(OPMODEADD,STDBY);
	MOVLW      129
	MOVWF      FARG_singlewrite_address+0
	CLRF       FARG_singlewrite_address+1
	MOVLW      132
	MOVWF      FARG_singlewrite_value+0
	CLRF       FARG_singlewrite_value+1
	CALL       _singlewrite+0
;receiver.c,145 :: 		singlewrite(OPMODEADD,RX);
	MOVLW      129
	MOVWF      FARG_singlewrite_address+0
	CLRF       FARG_singlewrite_address+1
	MOVLW      144
	MOVWF      FARG_singlewrite_value+0
	CLRF       FARG_singlewrite_value+1
	CALL       _singlewrite+0
;receiver.c,146 :: 		}
L_end_clear_fifo:
	RETURN
; end of _clear_fifo

_init_receiver:

;receiver.c,148 :: 		void init_receiver(void){
;receiver.c,149 :: 		int freq[3] = {MSB433,MID433,LSB433};
	MOVLW      108
	MOVWF      init_receiver_freq_L0+0
	MOVLW      0
	MOVWF      init_receiver_freq_L0+1
	MOVLW      128
	MOVWF      init_receiver_freq_L0+2
	MOVLW      0
	MOVWF      init_receiver_freq_L0+3
	CLRF       init_receiver_freq_L0+4
	CLRF       init_receiver_freq_L0+5
	MOVLW      128
	MOVWF      init_receiver_sync_L0+0
	MOVLW      0
	MOVWF      init_receiver_sync_L0+1
	MOVLW      219
	MOVWF      init_receiver_sync_L0+2
	MOVLW      0
	MOVWF      init_receiver_sync_L0+3
	MOVLW      104
	MOVWF      init_receiver_datarate_L0+0
	MOVLW      0
	MOVWF      init_receiver_datarate_L0+1
	MOVLW      43
	MOVWF      init_receiver_datarate_L0+2
	MOVLW      0
	MOVWF      init_receiver_datarate_L0+3
;receiver.c,152 :: 		burstwrite(CARRIERADD,freq,3);
	MOVLW      135
	MOVWF      FARG_burstwrite_address+0
	CLRF       FARG_burstwrite_address+1
	MOVLW      init_receiver_freq_L0+0
	MOVWF      FARG_burstwrite_value+0
	MOVLW      hi_addr(init_receiver_freq_L0+0)
	MOVWF      FARG_burstwrite_value+1
	MOVLW      3
	MOVWF      FARG_burstwrite_length+0
	MOVLW      0
	MOVWF      FARG_burstwrite_length+1
	CALL       _burstwrite+0
;receiver.c,153 :: 		burstwrite(DATARATE,datarate,2);
	MOVLW      131
	MOVWF      FARG_burstwrite_address+0
	CLRF       FARG_burstwrite_address+1
	MOVLW      init_receiver_datarate_L0+0
	MOVWF      FARG_burstwrite_value+0
	MOVLW      hi_addr(init_receiver_datarate_L0+0)
	MOVWF      FARG_burstwrite_value+1
	MOVLW      2
	MOVWF      FARG_burstwrite_length+0
	MOVLW      0
	MOVWF      FARG_burstwrite_length+1
	CALL       _burstwrite+0
;receiver.c,154 :: 		singlewrite(OPMODEADD,STDBY);
	MOVLW      129
	MOVWF      FARG_singlewrite_address+0
	CLRF       FARG_singlewrite_address+1
	MOVLW      132
	MOVWF      FARG_singlewrite_value+0
	CLRF       FARG_singlewrite_value+1
	CALL       _singlewrite+0
;receiver.c,155 :: 		burstwrite(SYNC_WORD,sync,2);
	MOVLW      174
	MOVWF      FARG_burstwrite_address+0
	CLRF       FARG_burstwrite_address+1
	MOVLW      init_receiver_sync_L0+0
	MOVWF      FARG_burstwrite_value+0
	MOVLW      hi_addr(init_receiver_sync_L0+0)
	MOVWF      FARG_burstwrite_value+1
	MOVLW      2
	MOVWF      FARG_burstwrite_length+0
	MOVLW      0
	MOVWF      FARG_burstwrite_length+1
	CALL       _burstwrite+0
;receiver.c,156 :: 		singlewrite(PACKET_LENGTH,PAYLOADSIZE);
	MOVLW      184
	MOVWF      FARG_singlewrite_address+0
	CLRF       FARG_singlewrite_address+1
	MOVLW      5
	MOVWF      FARG_singlewrite_value+0
	MOVLW      0
	MOVWF      FARG_singlewrite_value+1
	CALL       _singlewrite+0
;receiver.c,157 :: 		singlewrite(SETIO,MODE1);
	MOVLW      165
	MOVWF      FARG_singlewrite_address+0
	CLRF       FARG_singlewrite_address+1
	MOVLW      64
	MOVWF      FARG_singlewrite_value+0
	MOVLW      0
	MOVWF      FARG_singlewrite_value+1
	CALL       _singlewrite+0
;receiver.c,158 :: 		singlewrite(OPMODEADD,RX);
	MOVLW      129
	MOVWF      FARG_singlewrite_address+0
	CLRF       FARG_singlewrite_address+1
	MOVLW      144
	MOVWF      FARG_singlewrite_value+0
	CLRF       FARG_singlewrite_value+1
	CALL       _singlewrite+0
;receiver.c,160 :: 		}
L_end_init_receiver:
	RETURN
; end of _init_receiver

_receive:

;receiver.c,161 :: 		void receive(int* info) {
;receiver.c,163 :: 		int buffer= 0;
	CLRF       receive_buffer_L0+0
	CLRF       receive_buffer_L0+1
;receiver.c,165 :: 		j = info;
	MOVF       FARG_receive_info+0, 0
	MOVWF      receive_j_L0+0
	MOVF       FARG_receive_info+1, 0
	MOVWF      receive_j_L0+1
;receiver.c,167 :: 		NSS = 0;
	BCF        PORTC+0, 0
;receiver.c,168 :: 		while(PayloadReady == 0);
L_receive8:
	BTFSC      PORTA+0, 5
	GOTO       L_receive9
	GOTO       L_receive8
L_receive9:
;receiver.c,169 :: 		soft_spi_write(READ_FROM_FIFO&0xff);
	CLRF       FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;receiver.c,170 :: 		while(j<info+PAYLOADSIZE) {
L_receive10:
	MOVLW      10
	ADDWF      FARG_receive_info+0, 0
	MOVWF      R1
	MOVLW      0
	ADDWFC     FARG_receive_info+1, 0
	MOVWF      R2
	MOVF       R2, 0
	SUBWF      receive_j_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__receive42
	MOVF       R1, 0
	SUBWF      receive_j_L0+0, 0
L__receive42:
	BTFSC      STATUS+0, 0
	GOTO       L_receive11
;receiver.c,171 :: 		*j = (int) soft_spi_Read(buffer&0xff);
	MOVLW      255
	ANDWF      receive_buffer_L0+0, 0
	MOVWF      FARG_Soft_SPI_Read_sdata+0
	CALL       _Soft_SPI_Read+0
	MOVLW      0
	MOVWF      R1
	MOVF       receive_j_L0+0, 0
	MOVWF      FSR1L
	MOVF       receive_j_L0+1, 0
	MOVWF      FSR1H
	MOVF       R0, 0
	MOVWF      INDF1+0
	MOVF       R1, 0
	ADDFSR     1, 1
	MOVWF      INDF1+0
;receiver.c,172 :: 		j++;
	MOVLW      2
	ADDWF      receive_j_L0+0, 1
	MOVLW      0
	ADDWFC     receive_j_L0+1, 1
;receiver.c,173 :: 		}
	GOTO       L_receive10
L_receive11:
;receiver.c,174 :: 		clear_fifo();
	CALL       _clear_fifo+0
;receiver.c,175 :: 		NSS=1;
	BSF        PORTC+0, 0
;receiver.c,176 :: 		}
L_end_receive:
	RETURN
; end of _receive
