#line 1 "C:/Users/Vijay Natarajan/Dropbox/school/Summer2013/ECE414/project5/Project5.c"
#line 9 "C:/Users/Vijay Natarajan/Dropbox/school/Summer2013/ECE414/project5/Project5.c"
sbit SoftSpi_SDI at RB4_bit;
sbit SoftSpi_SDO at RC7_bit;
sbit SoftSpi_CLK at RB6_bit;

sbit SoftSpi_SDI_Direction at TRISB4_bit;
sbit SoftSpi_SDO_Direction at TRISC7_bit;
sbit SoftSpi_CLK_Direction at TRISB6_bit;

int WiperValue1 = 128;
int WiperValue0 = 0;

void set_pot(int value, int control) {



 Soft_SPI_Write(control);
 Soft_SPI_Write(value);
}
void PrintAString(char string[]) {
 int k;
 for(k=0;string[k]!=0;k++)
 Uart1_Write(string[k]);
}
float calcFrequency(int wiper) {
 float freq;
 if(wiper > 118) freq= 974.2+7.3455*(129-wiper);
 else if(wiper > 108) freq=969.4788+8.2788*(129-wiper);
 else if(wiper > 98) freq= 938.0636+9.8182*(129-wiper);
 else if(wiper > 88) freq= 906.1394+10.824*(129-wiper);
 else if(wiper > 78) freq= 789.6909+13.673*(129-wiper);
 else if(wiper > 68) freq= 601.3273+17.345*(129-wiper);
 else if(wiper > 58) freq= 396.1636+20.727*(129-wiper);
 else if(wiper > 48) freq= 28.151*(129-wiper)-127.7394;
 else if(wiper > 38) freq= 39.890*(129-wiper)-1078.273;
 else if(wiper > 28) freq= 58.370*(129-wiper)-2765.206;
 else if(wiper > 18) freq= 97*(129-wiper)-6672.4;
 return freq;
 }
char crlf[] = "\r\n";
char prompt[] = "Frequency:press a to raise,z to lower. Voltage:press s to raise,x to lower\r\n";
char freqValue[] = "Frequency = ";
char error[] = "Invalid Entry\r\n";
char temp[10];
void main() {
 char input;
 TRISC = 0xFF;
 TRISB = 0xFF;
 TRISA = 0xFF;
 ANSEL = 0x00;
 ANSELH = 0x00;
 C1ON_bit = 0;
 C2ON_bit = 0;
 Soft_SPI_Init();
 Uart1_Init(9600);
 INTCON = 0;
 set_pot(WiperValue1, 0x10 );
 set_pot(WiperValue0, 0x00 );
 Delay_ms(2000);
 while(1){
 PrintAString(prompt);
 while(!Uart1_Data_Ready());
 input = Uart1_Read();
 if(input == 'z') {
 if(WiperValue1<128) WiperValue1++;
 set_pot(WiperValue1, 0x10 );
 }
 else if(input == 'a') {
 if(WiperValue1>6) WiperValue1--;
 set_pot(WiperValue1, 0x10 );
 }
 else if(input == 'x') {
 if(WiperValue0<128) WiperValue0++;
 set_pot(WiperValue0, 0x00 );
 }
 else if(input == 's') {
 if(WiperValue0 > 0) WiperValue0--;
 set_pot(WiperValue0, 0x00 );
 }
 else PrintAString(error);

 PrintAstring(freqValue);
 InttoStr((int)calcfrequency(WiperValue1),temp);
 PrintAString(temp);
 PrintAstring(crlf);
 }
}
