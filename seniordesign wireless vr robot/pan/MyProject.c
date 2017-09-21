//pan angle calculation
#define ALPHA 0.54928
#define SAMPLES 5
int outangle = 0;
float last = 0;
float curr = 0;
float y[SAMPLES];
void main() {
    OSCCON = 0x78; //16 MHz clock
    INTCON = 0;
    TRISA = 0xFF;TRISB=0xFF;
    TRISC = 0xFF;//b3  is input
    ANSELA = 0x00;
    ANSELB = 0x00;
    ANSELC = 0x00;
    ANSELA.B4 = 1;
    C1ON_BIT = 0;
    C2ON_BIT = 0;
    CCP2CON = 0x0A;
    CCPR2L = 0x40;
    CCPR2H = 0x9C;//0x9C40 = 40000 = 4,000,000Hz/100Hz
    T1CON =  0x01;
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
      //convertion from data to speed
      retdat = (float)rawdat;
      return retdat;
}

void interrupt(void){
    int k;
    PIR2.CCP2IF = 0;
    last = curr;
    curr = convert(adc_read(4));
    for(k=(SAMPLES-1);k>0;k--)
       y[k]=(1-ALPHA)*y[k-1];
    y[0] = (0.005*(last+curr))*ALPHA;
    for(k=0;k<SAMPLES;k++)
       outangle += y[k];
}
     