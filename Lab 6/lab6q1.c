//Header files
#include <at89c5131.h>
#include <stdio.h>	//for sprintf functions

//Bit definitions
sbit RS=P0^0;
sbit RW=0x81;	//Also can use P0^1 or 0x80^1
sbit EN=P0^2;
sbit LED = P1^4;
sbit SW1 = P1^3;

//Global variables
unsigned char addr = 0x80;
unsigned char data counts _at_ 0x11;
//LCD functions
void lcd_init(void);
void lcd_cmd(unsigned int i);
void lcd_char(unsigned char ch);
void lcd_write_string(unsigned char *s);
void port_init(void);

//Extern functions from assembly files
extern void timer_init(void);
extern void init(void);
extern void timer0_int(void);
extern void timer0_stop(void);

//Timer 0 ISR
void T0_Interrupt(void) interrupt 1
{
			timer0_int();
}


//Delay function for time*1ms
void msdelay(unsigned int time)
{
	int i,j;
	for(i=0;i<time;i++)
	{
		for(j=0;j<360;j++);
	}
}


//LCD utility functions
void lcd_cmd(unsigned int i)
{
	RS=0;
	RW=0;
	EN=1;
	P2=i;
	msdelay(10);
	EN=0;
}
void lcd_char(unsigned char ch)
{
	RS=1;
	RW=0;
	EN=1;
	P2=ch;
	msdelay(10);
	EN=0;
}
void lcd_write_string(unsigned char *s)
{
	while(*s!='\0')		//Can use while(*s)
	{
		lcd_char(*s++);
	}
}

void lcd_init(void) using 3
{
	lcd_cmd(0x38);
	msdelay(4);
	lcd_cmd(0x0E);
	msdelay(4);
	lcd_cmd(0x06);
	msdelay(4);
	lcd_cmd(0x0C);
	msdelay(4);
	lcd_cmd(0x01);
	msdelay(4);
}

//Port initialization
void port_init(void)
{
	P2=0x00;
	EN=0;
	RS=0;
	RW=0;
}

//Main function
int main(void)
{
	unsigned char str1[] = "Toggle SW1";
	unsigned char str2[] = "when LED glows";
	unsigned char str3[] = "Reaction time ";
	unsigned char str4[] = " ms";
	unsigned char str5[2];
	while(1){
		port_init();
		lcd_init();
		init();
		//SW1 = 0;
		lcd_cmd(0x83);
		msdelay(4);
		lcd_write_string(str1);
		msdelay(4);
		lcd_cmd(0x0C1);
		msdelay(4);
		lcd_write_string(str2);
		msdelay(2000);
		LED = 1;
		timer_init();
		while(1){
			if(SW1 == 1){
				LED = 0;
				timer0_stop();
				break;
			}
		}
		lcd_cmd(0x01);
		msdelay(4);
		lcd_cmd(0x81);
		msdelay(4);
		lcd_write_string(str3);
		msdelay(4);
		lcd_cmd(0x0C6);
		sprintf(str5,"%d", counts);
		lcd_write_string(str5);
		lcd_cmd(0x0C9);
		msdelay(4);
		lcd_write_string(str4);
		msdelay(5000);
		lcd_cmd(0x01);
		msdelay(4);
	}
	
}
	