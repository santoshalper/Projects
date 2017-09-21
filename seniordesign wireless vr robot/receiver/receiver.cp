#line 1 "C:/Users/Vijay Natarajan/Dropbox/school/seniordesign/receiver/receiver.c"
#line 52 "C:/Users/Vijay Natarajan/Dropbox/school/seniordesign/receiver/receiver.c"
sbit SoftSpi_SDI at RB4_bit;
sbit SoftSpi_SDO at RC7_bit;
sbit SoftSpi_CLK at RB6_bit;

sbit SoftSpi_SDI_Direction at TRISB4_bit;
sbit SoftSpi_SDO_Direction at TRISC7_bit;
sbit SoftSpi_CLK_Direction at TRISB6_bit;

void stop(void);
void setLeft(int);
void setRight(int);
void init_PWM(void);
void singlewrite(int,int);
void burstwrite(int,int*);
void init_receiver(void);
void receive(int*);
void main() {
 int stuff[ 0x05 ];
 int i=0;
 OSCCON = 0x78;
 INTCON = 0;
 TRISA = 0xEB;TRISB=0xFF;
 TRISC = 0x86;
  PORTC.B0  = 1;
 ANSELA = 0x00;
 ANSELB = 0x00;
 ANSELC = 0x00;
 C1ON_BIT = 0;
 C2ON_BIT = 0;
 Soft_SPI_Init();
 SSP1STAT |= 0x40;
 init_PWM();
 init_receiver();
 Uart1_Init(9600);
#line 93 "C:/Users/Vijay Natarajan/Dropbox/school/seniordesign/receiver/receiver.c"
 while(1){
 receive(stuff);
 for(i=0;i< 0x05 ;i++){
 Uart1_Write(stuff[i]);
 }
 delay_ms(50);
 }
}
void init_PWM() {
 PWM1_Init(5000);
 PWM2_Init(5000);
  PWM1_Set_Duty(0); ;
  PWM2_Set_Duty(0); ;
 PWM1_Start();
 PWM2_Start();
}
void stop() {
  PORTA.B2 = PORTC.B6 = PORTA.B4 = PORTC.B4 =0;
  PWM1_Set_Duty(0); ;
  PWM2_Set_Duty(0); ;
}
void setLeft(int speed) {
  PORTA.B4  = (speed & 0x80)>>7;
  PORTC.B4  = ! PORTA.B4 ;
  PWM1_Set_Duty(speed & 0x7F); ;
}
void setRight(int speed) {
  PORTA.B2  = (speed & 0x80)>>7;
  PORTC.B6  = ! PORTA.B2 ;
  PWM2_Set_Duty(speed & 0x7F); ;
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
 soft_spi_write(*j&0xff);
 i++;
 }
  PORTC.B0  = 1;
}
void clear_fifo(void) {
 singlewrite( 0x81 , 0x84 );
 singlewrite( 0x81 , 0x90 );
}

void init_receiver(void){
 int freq[3] = { 0x6C , 0x80 , 0x00 };
 int sync[2] = { 0x80 , 0xDB };
 int datarate[2] = { 0x68 , 0x2B };
 burstwrite( 0x87 ,freq,3);
 burstwrite( 0x83 ,datarate,2);
 singlewrite( 0x81 , 0x84 );
 burstwrite( 0xAE ,sync,2);
 singlewrite( 0xB8 , 0x05 );
 singlewrite( 0xA5 , 0x40 );
 singlewrite( 0x81 , 0x90 );

}
void receive(int* info) {
 int* j;
 int buffer= 0;
 int count;
 j = info;
 count = 0;
  PORTC.B0  = 0;
 while( PORTA.B5  == 0);
 soft_spi_write( 0x00 &0xff);
 while(j<info+ 0x05 ) {
 *j = (int) soft_spi_Read(buffer&0xff);
 j++;
 }
 clear_fifo();
  PORTC.B0 =1;
}
