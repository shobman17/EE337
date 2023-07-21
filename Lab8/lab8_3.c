#include <at89c5131.h>
#include "lcd.h"

sbit SWITCH = P1^0;
int time;
char seconds;
char mins;
int prev_time;

void main(void){
	lcd_init();
	lcd_cmd(0x01);
	msdelay(4);
	lcd_cmd(0x80);
	msdelay(4);
	lcd_write_string("     START      ");
	lcd_cmd(0xC0);
	lcd_write_string("     00:00      ");
	prev_time = 0;
	TMOD = 0x05; // Timer mode 1 with external counter
	TH0 = 0x00;
	TL0 = 0x00;
	while(SWITCH == 0); // wait for DIP switch to be on
	TR0 = 1;
	// at each increment of the counter, 1/60 seconds have passed
	while(SWITCH == 1){
		time = TL0 + (TH0 << 8); // both are 8b counters
		time = (time - time%60)/60; //convert to seconds
		if (time != prev_time){
			seconds = time%60;
			mins = (time - seconds)/60;
			lcd_cmd(0xC0);
			lcd_write_string("     ");
			lcd_write_char((mins - mins%10)/10 + 48);
			lcd_write_char(mins%10 + 48);
			lcd_write_char(':');
			lcd_write_char((seconds - seconds%10)/10 + 48);
			lcd_write_char(seconds%10 + 48);
			prev_time = time;
		}
		
	};
	TR0 = 0;
	lcd_cmd(0x80);
	lcd_write_string("      STOP      ");
	while(1);
}