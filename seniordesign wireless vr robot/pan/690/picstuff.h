
/////////////////// MIKROC Bit fields
#   define  _CREN  RCSTA.CREN
#   define  _SPEN  RCSTA.SPEN
#   define  _SYNC  TXSTA.SYNC
#   define  _TXEN  TXSTA.TXEN
#   define  _BRGH  TXSTA.BRGH

#   define _T0IE    INTCON.T0IE
#   define _T0IF    INTCON.T0IF
#   define _GIE    INTCON.GIE

#   define _RCIF    PIR1.RCIF
#   define _TXIF    PIR1.TXIF
#   define _OERR    RCSTA.OERR
#   define _FERR    RCSTA.FERR

#   define _EEIF    PIR1.EEIF

#   define RA3  PORTA.F3
#   define ISR()  void interrupt(void)