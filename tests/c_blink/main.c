#include <avr/io.h>
#include <util/delay.h>

#include <avr/avr_mcu_section.h>

#define LED_PIN 5

AVR_MCU(F_CPU, "atmega328p");

int main(void) {
	DDRB |= 1 << LED_PIN;
	while(1) {
		PORTB |= 1 << LED_PIN;
		_delay_ms(1000);
		PORTB &= ~(1 << LED_PIN);
		_delay_ms(1000);
	}
	return 0;
}
