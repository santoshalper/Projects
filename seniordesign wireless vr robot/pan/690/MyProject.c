#define GYRO 3 // AN3
#define BIT(n) ((1)<<n)
#include "picstuff.h"

#ifdef USEFLT
#define OUTFLT OutFloat
#define FLT float
#else
#define OUTFLT OutInt
#define FLT int
#endif

void Task();
int counter;
FLT gyro;
int raw;

FLT refValue;
FLT angle;
FLT outangle;
int timetaken;

#if 0
#   define  newmain  main
#   undef ISR
#   define ISR() void dontcare(void)
#else
#    define oldmain main
#endif
void init() {
     OSCCON.B4 = 1;
     OSCCON.B5 = 1;
     OSCCON.B6 = 1;
     TRISA=0xff; TRISB=0xff; TRISC=0xff;
     ANSEL=ANSELH=0;
     ANSEL |= BIT(GYRO);
     uart1_init(19200);
     ADC_Init();
     OPTION_REG = 0xD3;// Set prescaler and clock source
     counter=0;
     gyro = 750;
     refValue=0;
     angle=0;

}
void enable_interrupts() {
    _T0IE = 1; // Enable timer zero interrupt
     _GIE = 1; // Global Interrupt enable
}


#define INCREASE 3
#define DECREASE 0





ISR() { // Interrupt service routine
  if (_T0IE && _T0IF) {
    Task();
    TMR0+=95;
    _T0IF = 0;
  }
}



void Task() {
       raw=ADC_Read(GYRO);
     if (counter < 2000) {
        gyro = raw;
        refValue += (gyro>refValue?
                                   (gyro-refValue)/2:
                                   -((refValue-gyro)/2));
        counter++;
     } else {
       gyro += (raw>gyro?
                         (raw-gyro)/8:
                         -((gyro-raw)/8));
       angle+=(gyro>refValue?
                             (gyro-refValue)/32:
                             -((refValue-gyro)/32));
       outangle = 90+(angle/360)*6;
       if(outangle <0) outangle = 0;
       if(outangle>180) outangle = 180;

     }
}
char buffer[20];
void outInt(int x) {
    IntToStr(x, buffer);
    Uart1_Write_Text(buffer);
    Uart1_Write(' ');
}

void outFloat(float x) {
    FloatToStr(x, buffer);
    Uart1_Write_Text(buffer);
      Uart1_Write(' ');
}

void oldmain() {

    delay_ms(1000);
    init();
    enable_interrupts();
    while(1) {
             delay_ms(100);
             if (counter < 2000) {
               outInt(counter);
               OUTFLT(gyro);
               OUTFLT(refValue);
               Uart1_Write_Text("\r\n");
             } else {
               OUTFLT(gyro);OUTFLT(refValue);OUTFLT(angle);OUTFLT(outangle);
               Uart1_Write_Text("\r\n");
             }

    }
}

void newmain() {
     init();

    while(1) {
             delay_ms(10);
             Task();
             OutInt(counter);
             OUTFLT(gyro);  OUTFLT(refValue); OUTFLT(angle); OUTFLT(outangle);
             Uart1_Write_Text("\r\n");
    }
}