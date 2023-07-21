#include <at89c5131.h>
#include "lcd.h"
#include "serial.h"

code unsigned char names[12] = {'D','S','O','A','F','G','D','M','M','D','P','S'};
unsigned char quant[4] = {'5','5','8','6'};
code unsigned char max_quant[4] = {'5','5','8','6'};
unsigned char state,i,input,j,index, quantity;

void main(void) {
	
	uart_init();
	lcd_init();
	msdelay(4);
	lcd_cmd(0x80);
	lcd_write_string("hi");
	state = 0; //initial state
	while(1){
		if (state == 0){ // in initial state
			transmit_string("Resources available: ");
			for (i = 0; i<4;i++){
				for(j = i*3;j<i*3+3;j++){
					transmit_char(names[j]);
				}
				transmit_char('-');
				transmit_char(quant[i]);
				transmit_char(' ');
			}
			transmit_string("\r\n");
			transmit_string("Press I for Issue and R for Return");
			transmit_string("\r\n");
			input = receive_char();
			if (input == 'I' | input == 'i'){
				state = 1; // issue state
			} else if (input == 'R' | input == 'r') {
				state = 2; // return state
			} else {
				state = 0; // remain in initial state if wrong key pressed
			}
		} 
		
		else if (state == 1) { // issue state
			transmit_string("Enter resource to be borrowed: ");
			index = receive_char() - 48 - 1;
			if (index > 3){
				transmit_string("Invalid index");
				transmit_string("\r\n");
				input = receive_char();
				state = 0;
				continue;
			}
			transmit_string("\r\n");
			transmit_string("Enter quantity to be borrowed: ");
			quantity = receive_char();
			transmit_string("\r\n");
			if (quantity <= quant[index]){
				transmit_string("Requested resource allocated!");
				quant[index] = (quant[index] - quantity) + 48;
			} else {
				transmit_string("Requested resource not available...");
			}
			transmit_string("\r\n");
			state = 0;
			input = receive_char();
		}
		
		else if (state == 2) { // return state
			transmit_string("Enter resource to be returned: \r\n");
			index = receive_char() - 48 - 1;
			if (index > 3){
				transmit_string("Invalid index");
				transmit_string("\r\n");
				input = receive_char();
				state = 0;
				continue;
			} else if (quant[index] == max_quant[index]) {
				transmit_string("You can't return what you don't have...");
				transmit_string("\r\n");
				input = receive_char();
				state = 0;
				continue;
			}
			
			transmit_string("Enter quantity: ");
			quantity = receive_char();
			transmit_string("\r\n");
			if (quantity + quant[index] - 48 > max_quant[index]){
				transmit_string("Returned resource out of bounds");
				transmit_string("\r\n");
				input = receive_char();
				state = 0;
			} else {
				transmit_string("Returned resource received!\r\n");
				quant[index] = quant[index] + (quantity - 48);
				input = receive_char();
				state = 0;
			}
			
		}
		
		else{state = 0;}
	}
}