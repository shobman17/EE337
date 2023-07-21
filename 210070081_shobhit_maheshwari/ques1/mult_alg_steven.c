#include <at89c5131.h>
#include "lcd.h"

long unsigned int x,y,x0,y0,x1,y1,z,z0,z1,z2,z3;
//int count;
//int cycle = 33000; // in microseconds
char prod_string[11]={0,0,0,0,0,0,0,0,0,0,'\0'};	
char time_string[6] = {0,0,0,0,0,'\0'};
unsigned int time;
char i;

//void timer0_isr () interrupt 1
//{
//	 count++;
//	 TR0 = 1;
//	 TF0 = 0;
//   //Reload values for TH0 and TL0. Start timer 0.
//}

void main(void) {
	
	x = 14571;
	y = 8636;
	//count = 0;
	TMOD = 0x10; // Timer 0 in mode 1
	TH1 = 0x00;
	TL1 = 0x00;
	TR1 = 1;

	x1 = x/10;
	x0 = x%10;
	y1 = y/10;
	y0 = y%10;
	z0 = x0*y0;
	z1 = x0*y1;
	z2 = x1*y0;
	z3 = x1*y1;
	z = z0 + (z1 + z2)*10 + z3*100;
	
	TR1 = 0;
	time = ((unsigned int)(TH1 << 8 | TL1))/2;
	lcd_init();
	msdelay(4);
	
	for(i = 9; i>=0;i--) {
		prod_string[i] = (unsigned int)(z%10 + 48);
		z = z - z%10;
		z = z/10;
	}

	int_to_string(time,time_string);
	
	lcd_cmd(0x80);
	lcd_write_string("Prod1=");
	lcd_write_string(prod_string);
	lcd_cmd(0xC0);
	lcd_write_string("Time1=");
	lcd_write_string(time_string);
	
	while (1);
}