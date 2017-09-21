#line 1 "C:/Users/Vijay Natarajan/Dropbox/school/seniordesign/transmitter/transmitter.c"
#line 44 "C:/Users/Vijay Natarajan/Dropbox/school/seniordesign/transmitter/transmitter.c"
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
 int stuff[ 0x05 ];
 int i,j = 0;
 OSCCON = 0x78;
 INTCON = 0;
 TRISA = 0xFF;TRISB=0xFF;
 TRISC = 0xFE;
  PORTC.B0  = 1;
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
  PORTC.B0  = 0;
 soft_spi_write(address&0xff);
 soft_spi_write(value&0xff);
  PORTC.B0  = 1;
}
void burstwrite(int address, int* value, int length) {
 int i = 0;
 int * j;
  PORTC.B0  = 0;
 soft_spi_write(address&0xff);
 while(i<length) {
 j = value+i;
 soft_spi_write(*j&0xFF);
 Uart1_write(*j&0xFF);
 i++;
 }
  PORTC.B0  = 1;
}


void init_transmitter(void){
 int freq[3] = { 0x6C , 0x80 , 0x00 };
 int sync[2] = { 0x80 , 0xDB };
 int datarate[2] = { 0x68 , 0x2B };
 burstwrite( 0x87 ,freq,3);
 burstwrite( 0x83 ,datarate,2);
 singlewrite( 0x81 , 0x84 );
 singlewrite( 0xBC , 0x04 );
 burstwrite( 0xAE ,sync,2);
 singlewrite( 0xB8 , 0x05 );
}
void transmit(int* info) {
 burstwrite( 0x80 ,info, 0x05 );
 singlewrite( 0x81 , 0x8C );
 while( PORTC.B3  != 1);
 singlewrite( 0x81 , 0x84 );
}
