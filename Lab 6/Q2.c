#include <at89c5131.h>
#include <stdio.h>
#include <headers.h>

sbit OUT = P0^0;

// Parameters for timer 0
unsigned char flag = 's';
unsigned char higher_sa = 0xEF;
unsigned char lower_sa = 0xDA;
unsigned char higher_re = 0xF1;
unsigned char lower_re = 0xB7;
// Parameters for timer 1
unsigned char i = 1;
unsigned char outer = 100;
unsigned char inner_high = 0x63;
unsigned char inner_low = 0xC0;
// Parameters to be exchanged between the 2 timers
unsigned char higher;
unsigned char lower;

void timer0_interrupt(void) interrupt 1{
	TR0 = 0;
	TF0 = 0;
	TH0 = higher;
	TL0 = lower;
	OUT = !OUT;
	TR0 = 1;
}

void timer1_interrupt(void) interrupt 3{
	TR1 = 0;
	TF1 = 0;
	TH1 = inner_high;
	TL1 = inner_low;
	if(i == outer){
		if(flag=='s'){
			higher = higher_sa;
			lower = lower_sa;
			flag = 'r';
		}else{
			higher = higher_re;
			lower = lower_re;
			flag = 's';
		}
		i = 1;
	}else{
		i++;
	}
	TR1 = 1;
}

void main(){
	port_init();
	TMOD = 0x11;
	EA = 1;
	
	ET1 = 1;
	TH1 = inner_high;
	TL1 = inner_low;
	TR1 = 1;
	
	ET0 = 1;
	higher = higher_sa;
	lower = lower_sa;
	TH0 = higher;
	TL0 = lower;
	TR0 = 1;
	
	while(1);
}

void msdelay(unsigned int time){
	int i, j;
	for(i = 0; i<time; i++){
		for(j = 0; j<318; j++);
	}
}

void port_init(void){
	P0 = 0x00;
}
