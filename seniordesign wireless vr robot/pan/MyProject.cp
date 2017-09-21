#line 1 "C:/Users/Vijay Natarajan/Dropbox/school/seniordesign/pan/MyProject.c"



int outangle = 0;
float last = 0;
float curr = 0;
float y[ 5 ];
void main() {
 OSCCON = 0x78;
 INTCON = 0;
 TRISA = 0xFF;TRISB=0xFF;
 TRISC = 0xFF;
 ANSELA = 0x00;
 ANSELB = 0x00;
 ANSELC = 0x00;
 ANSELA.B4 = 1;
 C1ON_BIT = 0;
 C2ON_BIT = 0;
 CCP2CON = 0x0A;
 CCPR2L = 0x40;
 CCPR2H = 0x9C;
 T1CON = 0x01;
 PIE1 = 0x00;
 PIE2 = 0x01;
 PIE3 =0x00;
 PIE4 = 0x00;
 INTCON = 0xC0;
 uart1_init(9600);
 while(1) {
 uart1_write(outangle);
 }
}
float convert(int rawdat) {
 float retdat;

 retdat = (float)rawdat;
 return retdat;
}

void interrupt(void){
 int k;
 PIR2.CCP2IF = 0;
 last = curr;
 curr = convert(adc_read(4));
 for(k=( 5 -1);k>0;k--)
 y[k]=(1- 0.54928 )*y[k-1];
 y[0] = (0.005*(last+curr))* 0.54928 ;
 for(k=0;k< 5 ;k++)
 outangle += y[k];
}
