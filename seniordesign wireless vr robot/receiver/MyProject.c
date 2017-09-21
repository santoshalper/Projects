void PrintAString(char string[]) {
 int k;
 for(k=0;string[k]!=0;k++)
 Uart1_Write(string[k]);
}
void main() {
    int left;
    int right;
    char temp[5];
    char newline[] = "\n";
    OSCCON = 0x78;
    INTCON = 0;
    TRISA=0xff;TRISB=0xff;TRISC=0xFF;
    ANSELA=0x14;ANSELB=0x00;ANSELC=0x00;
    Uart1_Init(9600);
    while(1){
       left = ADC_Read(2);
       right = ADC_Read(3);
       InttoStr(left,temp);
       PrintAString(temp);
       InttoStr(right,temp);
       PrintAString(temp);
       PrintAString(newline);
       delay_ms(1000);
    }
}
       