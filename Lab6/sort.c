#include <at89c5131.h>
#include "lcd.h"

code unsigned char blank[]="                ";
unsigned char in;
unsigned char inputs[5];
unsigned char i;
unsigned char j;

void main() {
	// take all inputs---------------------------------------------------
	P1 = 0x00;
	lcd_init();
	lcd_cmd(0x80);													//Move cursor to first line
	msdelay(4);
	lcd_write_string("  START PROGRAM ");
	msdelay(5000);
	lcd_cmd(0x80);
	lcd_write_string("  FIRST INPUT   ");
	P1 = 0x0F;															//Prepare for input
	msdelay(5000);
	in = P1&0x0F;														//First input
	inputs[0]=in;
	for(i = 1; i<=4;i++){
		lcd_cmd(0x80);
		lcd_write_string("   NEXT INPUT   ");
		in = in*16;															//Roll left by 4 bits
		P1 = in|0x0F;														//Display output and make the lower nibble ready for input
		msdelay(5000);
		in = P1&0x0F;														//Take input
		inputs[i] = in;													//Store in array
		lcd_cmd(0x80);
		lcd_write_string(blank);
		msdelay(500);														//Just to make inputs easier
	}
	lcd_cmd(0x80);
	lcd_write_string("   SORTING...   ");
	in = in*16;
	P1 = in;
	msdelay(5000);
	
	// sort--------------------------------------------------------------
	for (i = 0; i<=4; i++){
			for (j = i+1; j<=4; j++) {
				if (inputs[i] > inputs[j]) {			//Bubble sort lmao
					inputs[i] = inputs[i] + inputs[j];
					inputs[j] = inputs[i] - inputs[j];
					inputs[i] = inputs[i] - inputs[j];
				}
			}
	}
	P1 = 0x00;
	msdelay(1000);
	lcd_cmd(0x80);
	lcd_write_string("     SORTING    ");
	lcd_cmd(0xC0);													//Move cursor to 2nd line of LCD
	lcd_write_string("    COMPLETE    ");
	msdelay(1000);
	
	//display sorted------------------------------------------------------
	for (i = 0; i<=4; i++){
		P1 = inputs[i]*16;
		msdelay(5000);
		P1 = 0x00;
		msdelay(1000);
	}
	
	//take input for search-----------------------------------------------
	P1 = 0xFF;
	lcd_cmd(0x80);
	lcd_write_string("  NUMBER TO BE  ");
	lcd_cmd(0xC0);													//Move cursor to 2nd line of LCD
	lcd_write_string("    SEARCHED    ");
	msdelay(5000);
	in = P1&0x0F;
	lcd_cmd(0x80);
	lcd_write_string(blank);
	lcd_cmd(0xC0);													//Move cursor to 2nd line of LCD
	lcd_write_string(blank);
	msdelay(1000);
	
	//search for number and display---------------------------------------------------
	j = 0;
	for (i = 0; i<=4; i++){
		if (inputs[i]==in){
			j = 1;
			break;
		}
	}
	if (j==1) {
		lcd_cmd(0x80);
		lcd_write_string("THE INDEX IS");
		P1 = (i+1)*16;
	} else {
		lcd_cmd(0x80);
		lcd_write_string("     NUMBER     ");
		lcd_cmd(0xC0);													//Move cursor to 2nd line of LCD
		lcd_write_string("   NOT FOUND    ");
		P1 = 0xF0;
	}
	
	while(1);
}