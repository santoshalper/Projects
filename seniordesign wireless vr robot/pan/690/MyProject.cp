#line 1 "C:/Users/Vijay Natarajan/Dropbox/school/seniordesign/pan/690/MyProject.c"
#line 1 "c:/users/vijay natarajan/dropbox/school/seniordesign/pan/690/picstuff.h"
#line 13 "C:/Users/Vijay Natarajan/Dropbox/school/seniordesign/pan/690/MyProject.c"
void Task();
int counter;
 int  gyro;
int raw;

 int  refValue;
 int  angle;
 int  outangle;
int timetaken;








void init() {
 OSCCON.B4 = 1;
 OSCCON.B5 = 1;
 OSCCON.B6 = 1;
 TRISA=0xff; TRISB=0xff; TRISC=0xff;
 ANSEL=ANSELH=0;
 ANSEL |=  ((1)<< 3 ) ;
 uart1_init(19200);
 ADC_Init();
 OPTION_REG = 0xD3;
 counter=0;
 gyro = 750;
 refValue=0;
 angle=0;

}
void enable_interrupts() {
  INTCON.T0IE  = 1;
  INTCON.GIE  = 1;
}









 void interrupt(void)  {
 if ( INTCON.T0IE  &&  INTCON.T0IF ) {
 Task();
 TMR0+=95;
  INTCON.T0IF  = 0;
 }
}



void Task() {
 raw=ADC_Read( 3 );
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

void  main () {

 delay_ms(1000);
 init();
 enable_interrupts();
 while(1) {
 delay_ms(100);
 if (counter < 2000) {
 outInt(counter);
  OutInt (gyro);
  OutInt (refValue);
 Uart1_Write_Text("\r\n");
 } else {
  OutInt (gyro); OutInt (refValue); OutInt (angle); OutInt (outangle);
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
  OutInt (gyro);  OutInt (refValue);  OutInt (angle);  OutInt (outangle);
 Uart1_Write_Text("\r\n");
 }
}
