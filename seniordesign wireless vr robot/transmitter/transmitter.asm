
_main:

;transmitter.c,57 :: 		void main() {
;transmitter.c,59 :: 		int i,j = 0;
;transmitter.c,60 :: 		OSCCON = 0x78; //16 MHz clock
	MOVLW      120
	MOVWF      OSCCON+0
;transmitter.c,61 :: 		INTCON = 0;
	CLRF       INTCON+0
;transmitter.c,62 :: 		TRISA = 0xFF;TRISB=0xFF;
	MOVLW      255
	MOVWF      TRISA+0
	MOVLW      255
	MOVWF      TRISB+0
;transmitter.c,63 :: 		TRISC = 0xFE;//b3  is input
	MOVLW      254
	MOVWF      TRISC+0
;transmitter.c,64 :: 		NSS = 1;
	BSF        PORTC+0, 0
;transmitter.c,65 :: 		ANSELA = 0x00;
	CLRF       ANSELA+0
;transmitter.c,66 :: 		ANSELB = 0x00;
	CLRF       ANSELB+0
;transmitter.c,67 :: 		ANSELC = 0x00;
	CLRF       ANSELC+0
;transmitter.c,68 :: 		ANSELA.B4 = 1;
	BSF        ANSELA+0, 4
;transmitter.c,69 :: 		ANSELA.B2 = 1;
	BSF        ANSELA+0, 2
;transmitter.c,70 :: 		C1ON_BIT = 0;
	BCF        C1ON_bit+0, 7
;transmitter.c,71 :: 		C2ON_BIT = 0;
	BCF        C2ON_bit+0, 7
;transmitter.c,72 :: 		Soft_SPI_Init();
	CALL       _Soft_SPI_Init+0
;transmitter.c,73 :: 		uart1_init(9600);
	BSF        BAUDCON+0, 3
	MOVLW      160
	MOVWF      SPBRG+0
	MOVLW      1
	MOVWF      SPBRG+1
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;transmitter.c,74 :: 		SSP1STAT |= 0x40;
	BSF        SSP1STAT+0, 6
;transmitter.c,75 :: 		init_transmitter();
	CALL       _init_transmitter+0
;transmitter.c,76 :: 		while(1){
L_main0:
;transmitter.c,77 :: 		stuff[0] = ADC_Read(2)>>2;
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0, 0
	MOVWF      main_stuff_L0+0
	MOVF       R1, 0
	MOVWF      main_stuff_L0+1
	LSRF       main_stuff_L0+1, 1
	RRF        main_stuff_L0+0, 1
	LSRF       main_stuff_L0+1, 1
	RRF        main_stuff_L0+0, 1
;transmitter.c,78 :: 		stuff[1] = ADC_Read(3)>>2;
	MOVLW      3
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0, 0
	MOVWF      main_stuff_L0+2
	MOVF       R1, 0
	MOVWF      main_stuff_L0+3
	LSRF       main_stuff_L0+3, 1
	RRF        main_stuff_L0+2, 1
	LSRF       main_stuff_L0+3, 1
	RRF        main_stuff_L0+2, 1
;transmitter.c,79 :: 		stuff[2] = 0x0f;
	MOVLW      15
	MOVWF      main_stuff_L0+4
	MOVLW      0
	MOVWF      main_stuff_L0+5
;transmitter.c,80 :: 		stuff[3] = 0x0a;
	MOVLW      10
	MOVWF      main_stuff_L0+6
	MOVLW      0
	MOVWF      main_stuff_L0+7
;transmitter.c,81 :: 		stuff[4] = 0x0c;
	MOVLW      12
	MOVWF      main_stuff_L0+8
	MOVLW      0
	MOVWF      main_stuff_L0+9
;transmitter.c,82 :: 		transmit(stuff);
	MOVLW      main_stuff_L0+0
	MOVWF      FARG_transmit+0
	MOVLW      hi_addr(main_stuff_L0+0)
	MOVWF      FARG_transmit+1
	CALL       _transmit+0
;transmitter.c,83 :: 		}
	GOTO       L_main0
;transmitter.c,84 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_singlewrite:

;transmitter.c,85 :: 		void singlewrite(int address,int value){
;transmitter.c,86 :: 		NSS = 0;
	BCF        PORTC+0, 0
;transmitter.c,87 :: 		soft_spi_write(address&0xff);
	MOVLW      255
	ANDWF      FARG_singlewrite_address+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;transmitter.c,88 :: 		soft_spi_write(value&0xff);
	MOVLW      255
	ANDWF      FARG_singlewrite_value+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;transmitter.c,89 :: 		NSS = 1;
	BSF        PORTC+0, 0
;transmitter.c,90 :: 		}
L_end_singlewrite:
	RETURN
; end of _singlewrite

_burstwrite:

;transmitter.c,91 :: 		void burstwrite(int address, int* value, int length) {
;transmitter.c,92 :: 		int i = 0;
	CLRF       burstwrite_i_L0+0
	CLRF       burstwrite_i_L0+1
;transmitter.c,94 :: 		NSS = 0;
	BCF        PORTC+0, 0
;transmitter.c,95 :: 		soft_spi_write(address&0xff);
	MOVLW      255
	ANDWF      FARG_burstwrite_address+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;transmitter.c,96 :: 		while(i<length) {
L_burstwrite2:
	MOVLW      128
	XORWF      burstwrite_i_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_burstwrite_length+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__burstwrite9
	MOVF       FARG_burstwrite_length+0, 0
	SUBWF      burstwrite_i_L0+0, 0
L__burstwrite9:
	BTFSC      STATUS+0, 0
	GOTO       L_burstwrite3
;transmitter.c,97 :: 		j = value+i;
	MOVF       burstwrite_i_L0+0, 0
	MOVWF      R0
	MOVF       burstwrite_i_L0+1, 0
	MOVWF      R1
	LSLF       R0, 1
	RLF        R1, 1
	MOVF       FARG_burstwrite_value+0, 0
	ADDWF      R0, 1
	MOVF       FARG_burstwrite_value+1, 0
	ADDWFC     R1, 1
	MOVF       R0, 0
	MOVWF      burstwrite_j_L0+0
	MOVF       R1, 0
	MOVWF      burstwrite_j_L0+1
;transmitter.c,98 :: 		soft_spi_write(*j&0xFF);
	MOVF       R0, 0
	MOVWF      FSR0L
	MOVF       R1, 0
	MOVWF      FSR0H
	MOVLW      255
	ANDWF      INDF0+0, 0
	MOVWF      FARG_Soft_SPI_Write_sdata+0
	CALL       _Soft_SPI_Write+0
;transmitter.c,99 :: 		Uart1_write(*j&0xFF);
	MOVF       burstwrite_j_L0+0, 0
	MOVWF      FSR0L
	MOVF       burstwrite_j_L0+1, 0
	MOVWF      FSR0H
	MOVLW      255
	ANDWF      INDF0+0, 0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
;transmitter.c,100 :: 		i++;
	INCF       burstwrite_i_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       burstwrite_i_L0+1, 1
;transmitter.c,101 :: 		}
	GOTO       L_burstwrite2
L_burstwrite3:
;transmitter.c,102 :: 		NSS = 1;
	BSF        PORTC+0, 0
;transmitter.c,103 :: 		}
L_end_burstwrite:
	RETURN
; end of _burstwrite

_init_transmitter:

;transmitter.c,106 :: 		void init_transmitter(void){
;transmitter.c,107 :: 		int freq[3] = {MSB433,MID433,LSB433};
	MOVLW      108
	MOVWF      init_transmitter_freq_L0+0
	MOVLW      0
	MOVWF      init_transmitter_freq_L0+1
	MOVLW      128
	MOVWF      init_transmitter_freq_L0+2
	MOVLW      0
	MOVWF      init_transmitter_freq_L0+3
	CLRF       init_transmitter_freq_L0+4
	CLRF       init_transmitter_freq_L0+5
	MOVLW      128
	MOVWF      init_transmitter_sync_L0+0
	MOVLW      0
	MOVWF      init_transmitter_sync_L0+1
	MOVLW      219
	MOVWF      init_transmitter_sync_L0+2
	MOVLW      0
	MOVWF      init_transmitter_sync_L0+3
	MOVLW      104
	MOVWF      init_transmitter_datarate_L0+0
	MOVLW      0
	MOVWF      init_transmitter_datarate_L0+1
	MOVLW      43
	MOVWF      init_transmitter_datarate_L0+2
	MOVLW      0
	MOVWF      init_transmitter_datarate_L0+3
;transmitter.c,110 :: 		burstwrite(CARRIERADD,freq,3);
	MOVLW      135
	MOVWF      FARG_burstwrite_address+0
	CLRF       FARG_burstwrite_address+1
	MOVLW      init_transmitter_freq_L0+0
	MOVWF      FARG_burstwrite_value+0
	MOVLW      hi_addr(init_transmitter_freq_L0+0)
	MOVWF      FARG_burstwrite_value+1
	MOVLW      3
	MOVWF      FARG_burstwrite_length+0
	MOVLW      0
	MOVWF      FARG_burstwrite_length+1
	CALL       _burstwrite+0
;transmitter.c,111 :: 		burstwrite(DATARATE,datarate,2);
	MOVLW      131
	MOVWF      FARG_burstwrite_address+0
	CLRF       FARG_burstwrite_address+1
	MOVLW      init_transmitter_datarate_L0+0
	MOVWF      FARG_burstwrite_value+0
	MOVLW      hi_addr(init_transmitter_datarate_L0+0)
	MOVWF      FARG_burstwrite_value+1
	MOVLW      2
	MOVWF      FARG_burstwrite_length+0
	MOVLW      0
	MOVWF      FARG_burstwrite_length+1
	CALL       _burstwrite+0
;transmitter.c,112 :: 		singlewrite(OPMODEADD,STDBY);
	MOVLW      129
	MOVWF      FARG_singlewrite_address+0
	CLRF       FARG_singlewrite_address+1
	MOVLW      132
	MOVWF      FARG_singlewrite_value+0
	CLRF       FARG_singlewrite_value+1
	CALL       _singlewrite+0
;transmitter.c,113 :: 		singlewrite(FIFO_THRESH,THRESH);
	MOVLW      188
	MOVWF      FARG_singlewrite_address+0
	CLRF       FARG_singlewrite_address+1
	MOVLW      4
	MOVWF      FARG_singlewrite_value+0
	MOVLW      0
	MOVWF      FARG_singlewrite_value+1
	CALL       _singlewrite+0
;transmitter.c,114 :: 		burstwrite(SYNC_WORD,sync,2);
	MOVLW      174
	MOVWF      FARG_burstwrite_address+0
	CLRF       FARG_burstwrite_address+1
	MOVLW      init_transmitter_sync_L0+0
	MOVWF      FARG_burstwrite_value+0
	MOVLW      hi_addr(init_transmitter_sync_L0+0)
	MOVWF      FARG_burstwrite_value+1
	MOVLW      2
	MOVWF      FARG_burstwrite_length+0
	MOVLW      0
	MOVWF      FARG_burstwrite_length+1
	CALL       _burstwrite+0
;transmitter.c,115 :: 		singlewrite(PACKET_LENGTH,PAYLOADSIZE);
	MOVLW      184
	MOVWF      FARG_singlewrite_address+0
	CLRF       FARG_singlewrite_address+1
	MOVLW      5
	MOVWF      FARG_singlewrite_value+0
	MOVLW      0
	MOVWF      FARG_singlewrite_value+1
	CALL       _singlewrite+0
;transmitter.c,116 :: 		}
L_end_init_transmitter:
	RETURN
; end of _init_transmitter

_transmit:

;transmitter.c,117 :: 		void transmit(int* info) {
;transmitter.c,118 :: 		burstwrite(WRITE_TO_FIFO,info,PAYLOADSIZE);
	MOVLW      128
	MOVWF      FARG_burstwrite_address+0
	CLRF       FARG_burstwrite_address+1
	MOVF       FARG_transmit_info+0, 0
	MOVWF      FARG_burstwrite_value+0
	MOVF       FARG_transmit_info+1, 0
	MOVWF      FARG_burstwrite_value+1
	MOVLW      5
	MOVWF      FARG_burstwrite_length+0
	MOVLW      0
	MOVWF      FARG_burstwrite_length+1
	CALL       _burstwrite+0
;transmitter.c,119 :: 		singlewrite(OPMODEADD,TX);
	MOVLW      129
	MOVWF      FARG_singlewrite_address+0
	CLRF       FARG_singlewrite_address+1
	MOVLW      140
	MOVWF      FARG_singlewrite_value+0
	CLRF       FARG_singlewrite_value+1
	CALL       _singlewrite+0
;transmitter.c,120 :: 		while(PacketSent != 1);//waiting to confirm packet sent
L_transmit4:
	BTFSC      PORTC+0, 3
	GOTO       L_transmit5
	GOTO       L_transmit4
L_transmit5:
;transmitter.c,121 :: 		singlewrite(OPMODEADD,STDBY); //clear FIFO
	MOVLW      129
	MOVWF      FARG_singlewrite_address+0
	CLRF       FARG_singlewrite_address+1
	MOVLW      132
	MOVWF      FARG_singlewrite_value+0
	CLRF       FARG_singlewrite_value+1
	CALL       _singlewrite+0
;transmitter.c,122 :: 		}
L_end_transmit:
	RETURN
; end of _transmit
