with AVR;     use AVR;
with AVR.MCU; use AVR.MCU;
with AVR.Wait;
with Avrada_Rts_Config;

procedure Meteo_Clock is
   -- Led on PB5
   LED        : Boolean renames PORTB_Bits (5);
   LED_Config : Boolean renames DDRB_Bits (5);

   procedure Wait_Ms is new AVR.Wait.Generic_Busy_Wait_Milliseconds
     (Crystal_Hertz => Avrada_Rts_Config.Clock_Frequency);

begin

   LED_Config := DD_Output;

   loop
      LED := High;
      Wait_Ms (500);
      LED := Low;
      Wait_Ms (500);
   end loop;

end Meteo_Clock;
