/*******************************************************************************
******SPI Receiver Test Program**********************************************
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
#define RX 0x90//enter RX

/*FIFO*/
#define READ_FROM_FIFO 0x00

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
#define MODE1 0x40//set dio to payloadReady
#define PayloadReady PORTA.B5
/*Slave Select for tranceiver*/
#define NSS PORTC.B0
/*Drive Control*/
#define RMotorFor PORTA.B2
#define RMotorRev PORTC.B6
#define LMotorFor PORTA.B4
#define LMotorRev PORTC.B4
#define SpeedLeft(x) PWM1_Set_Duty(x);
#define SpeedRight(x) PWM2_Set_Duty(x);


//inits for soft spi - needed for microc functions
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
     int stuff[PAYLOADSIZE];
     int i=0;
     OSCCON = 0x78; //16 MHz clock
     INTCON = 0;
     TRISA = 0xEB;TRISB=0xFF;//RA4,RA2 are out
     TRISC = 0x86;//RC6,RC5,RC4,and RC0 are out
     NSS = 1;
     ANSELA = 0x00;
     ANSELB = 0x00;
     ANSELC = 0x00;
     C1ON_BIT = 0;
     C2ON_BIT = 0;
     Soft_SPI_Init();
     SSP1STAT |= 0x40;   //data sent on falling edge
     init_PWM();
     init_receiver();
     Uart1_Init(9600);
     /*LMotorFor = 1;
     LMotorRev = !LMotorFor;
     RMotorFor = 1;
     RMotorRev = !RMotorFor;
     SpeedLeft(0xff);
     SpeedRight(0xff);
     delay_ms(1000);*/
     while(1){
        receive(stuff);
        for(i=0;i<PAYLOADSIZE;i++){
             Uart1_Write(stuff[i]);
        }
        delay_ms(50);
     }
}
void init_PWM() {
     PWM1_Init(5000);
     PWM2_Init(5000);
     SpeedLeft(0);
     SpeedRight(0);
     PWM1_Start();
     PWM2_Start();
}
void stop() {
     RMotorFor=RMotorRev=LMotorFor=LMotorRev=0;
     SpeedLeft(0);
     SpeedRight(0);
}
void setLeft(int speed) {
    LMotorFor = (speed & 0x80)>>7;
    LMotorRev = !LMotorFor;
    SpeedLeft(speed & 0x7F);
}
void setRight(int speed) {
    RMotorFor = (speed & 0x80)>>7;
    RMotorRev = !RMotorFor;
    SpeedRight(speed & 0x7F);
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
       soft_spi_write(*j&0xff);
       i++;
     }
     NSS = 1;
}
void clear_fifo(void) {
     singlewrite(OPMODEADD,STDBY);
     singlewrite(OPMODEADD,RX);
}

void init_receiver(void){
     int freq[3] = {MSB433,MID433,LSB433};
     int sync[2] = {SYNC_LENGTH,SYNC_VALUE};
     int datarate[2] = {MSB24k,LSB24k};
     burstwrite(CARRIERADD,freq,3);
     burstwrite(DATARATE,datarate,2);
     singlewrite(OPMODEADD,STDBY);
     burstwrite(SYNC_WORD,sync,2);
     singlewrite(PACKET_LENGTH,PAYLOADSIZE);
     singlewrite(SETIO,MODE1);
     singlewrite(OPMODEADD,RX);
     //singlewrite(0xD8,0x2D);//high sensativity
}
void receive(int* info) {
     int* j;
     int buffer= 0;
     int count;
     j = info;
     count = 0;
     NSS = 0;
     while(PayloadReady == 0);
     soft_spi_write(READ_FROM_FIFO&0xff);
     while(j<info+PAYLOADSIZE) {
          *j = (int) soft_spi_Read(buffer&0xff);
          j++;
     }
     clear_fifo();
     NSS=1;
}