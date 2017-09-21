/*******************************************************************************
******SPI Transmitter Test Program**********************************************
**********Vijay Natarajan*******************************************************
*******************************************************************************/
/*Device configurations*/
/*SPI MESSAGE= address of register / value needed*/
/*Carrier Frequency*/
#define CARRIERADD 0x87
#define MSB433 0x6C 
#define MID433 0x80 
#define LSB433 0x00

/*Data Rate*/
#define DATARATE 0x83
#define MSB24k 0x68
#define LSB24k 0x2B

/*Operation Mode*/
#define OPMODEADD 0x81//write to operational mode register
#define STDBY 0x84 //Enter Standby
#define TX 0x8C    //Enter Transmit

/*FIFO*/
#define WRITE_TO_FIFO 0x80
#define FIFO_THRESH 0xBC
#define THRESH 0x04//may not need to be used

/*Message data*/
#define PREAMBLE_REGISTER 0xAD//default at start:3 byte preamble(using Default)
//wont be bigger that 255 bytes of preamble, so if change wanted, use LSB(0XAD)
#define SYNC_WORD 0xAE
#define SYNC_LENGTH 0x80//sync word enabled, length of 1 byte
#define SYNC_VALUE 0xDB//Network address
#define PACKET_FORMAT 0xB7//use default value
#define PACKET_LENGTH 0xB8
#define PAYLOADSIZE 0x05//should only need 5 bytes of payload sent at a time

/*I/O*/
#define SETIO 0xA5//use default for now
#define PacketSent PORTC.B3

#define NSS PORTC.B0
//inits for soft spi - needed for microc functions
sbit SoftSpi_SDI at RB4_bit;
sbit SoftSpi_SDO at RC7_bit;
sbit SoftSpi_CLK at RB6_bit;

sbit SoftSpi_SDI_Direction at TRISB4_bit;
sbit SoftSpi_SDO_Direction at TRISC7_bit;
sbit SoftSpi_CLK_Direction at TRISB6_bit;

int test[15] = {'h','e','l','l','o',' ','w', 'o','r','l','d','!','!','!','!'};
void singlewrite(int,int);
void burstwrite(int,int*);
void init_transmitter(void);
void transmit(int*);
void main() {
     int stuff[PAYLOADSIZE];
     int i,j = 0;
     OSCCON = 0x78; //16 MHz clock
     INTCON = 0;
     TRISA = 0xFF;TRISB=0xFF;
     TRISC = 0xFE;//b3  is input
     NSS = 1;
     ANSELA = 0x00;
     ANSELB = 0x00;
     ANSELC = 0x00;
     ANSELA.B4 = 1;
     ANSELA.B2 = 1;
     C1ON_BIT = 0;
     C2ON_BIT = 0;
     Soft_SPI_Init();
     uart1_init(9600);
     SSP1STAT |= 0x40;
     init_transmitter();
     while(1){
        stuff[0] = ADC_Read(2)>>2;
        stuff[1] = ADC_Read(3)>>2;
        stuff[2] = 0x0f;
        stuff[3] = 0x0a;
        stuff[4] = 0x0c;
        transmit(stuff);
     }
}
void singlewrite(int address,int value){
     NSS = 0;
     soft_spi_write(address&0xff);
     soft_spi_write(value&0xff);
     NSS = 1;
}
void burstwrite(int address, int* value, int length) {
     int i = 0;
     int * j;
     NSS = 0;
     soft_spi_write(address&0xff);
     while(i<length) {
       j = value+i;
       soft_spi_write(*j&0xFF);
       Uart1_write(*j&0xFF);
       i++;
     }
     NSS = 1;
}


void init_transmitter(void){
     int freq[3] = {MSB433,MID433,LSB433};
     int sync[2] = {SYNC_LENGTH,SYNC_VALUE};
     int datarate[2] = {MSB24k,LSB24k};
     burstwrite(CARRIERADD,freq,3);
     burstwrite(DATARATE,datarate,2);
     singlewrite(OPMODEADD,STDBY);
     singlewrite(FIFO_THRESH,THRESH);
     burstwrite(SYNC_WORD,sync,2);
     singlewrite(PACKET_LENGTH,PAYLOADSIZE);
}
void transmit(int* info) {
     burstwrite(WRITE_TO_FIFO,info,PAYLOADSIZE);
     singlewrite(OPMODEADD,TX);
     while(PacketSent != 1);//waiting to confirm packet sent
     singlewrite(OPMODEADD,STDBY); //clear FIFO
}