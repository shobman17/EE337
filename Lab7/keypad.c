#include <at89c5131.h>
#include "lcd.h"

unsigned char correct_pass[]="15A8*D6#";
code unsigned char rows[] = "123A456B789C*0#D";
unsigned char addr;
unsigned char input;
unsigned char check;
unsigned char input_pass[] = "        ";
unsigned char i;
unsigned char j;
bit correct = 0x50;

void main()
{
	correct = 1;
	lcd_init();
	lcd_cmd(0x80);													//Move cursor to first line
	msdelay(4);
	lcd_write_string("Enter Password: ");
	lcd_cmd(0xC0);													//Move cursor to 2nd line of LCD
	msdelay(4);
	P1 = 0x00;
	
	for(j = 0; j<8; j++){
		while(1){																//Will keep running till a key is pressed
			addr = 0;
			P3 = 0x0F; 														//Ground all rows, read all columns
			msdelay(10);
			input = P3&0x0F;
			//P1 = input << 4;
			while(input != 0x0F){									//Wait for all keys to be released
				input = P3&0x0F;
				P1 = 0x10;
			}
			msdelay(10);
			while(input == 0x0F) {								//Wait for any key to be pressed
				input = P3&0x0F;
				P1 = 0x20;
			}
			msdelay(20);													//Debounce delay
			input = P3&0x0F;
			if(input != 0x0F){
				P1 = 0x40;
				check = 0x10;
				for(i = 0; i<4; i++){								//Check all rows
					P3 = 0xFF - check;
					input = P3&0x0F;
					if(input != 0x0F){								//Scan all columns of that row
						input = 0x0F - input;
						while(input != 0x08){
							addr = addr + 1;
							input = input << 1;
						}
						input = rows[addr];							//Get the character corresponding to input button
						lcd_write_char(input);					//Write the character to the lcd
						input_pass[j] = input;					//Store input of keyboard in an array
						if (input != correct_pass[j]) correct = 0; //Check validity of password for every input
						goto afterinputloop;
					}
					addr = addr + 4;
					check = check << 1;
				}
				break;
			}
		}
		afterinputloop:
		addr = 0;
	}

	if(correct == 1){
		lcd_cmd(0x80);													//Move cursor to first line
		msdelay(4);
		lcd_write_string("Correct Password");
		lcd_cmd(0xC0);													//Move cursor to 2nd line of LCD
		msdelay(4);
		lcd_write_string(" Access Granted ");
	} else {
		lcd_cmd(0x80);													//Move cursor to first line
		msdelay(4);
		lcd_write_string(" Wrong Password ");
		lcd_cmd(0xC0);													//Move cursor to 2nd line of LCD
		msdelay(4);
		lcd_write_string(" Access Denied  ");
	}
	while(1);
}