with System;
with AVR;     use AVR;
with AVR.MCU; use AVR.MCU;
with AVR.I2C;
use type AVR.I2C.I2C_Address;
with AVR.I2C.Master;
with AVR.UART; use AVR.UART;
with AVR.Real_Time.Clock;
pragma Unreferenced (AVR.Real_Time.Clock);

with AVR.Wait;
with AVR.Interrupts;
with Avrada_Rts_Config;

with Interfaces; use Interfaces;

procedure Meteo_Clock is
   -- Led on PB5
   LED        : Boolean renames PORTB_Bits (5);
   LED_Config : Boolean renames DDRB_Bits (5);

   procedure Wait_Ms is new AVR.Wait.Generic_Busy_Wait_Milliseconds
     (Crystal_Hertz => Avrada_Rts_Config.Clock_Frequency);

   RTC_Address    : I2C.I2C_Address := 16#68#;
   RTC_Is_Present : Boolean;

   Seconds, Minutes, Hours, Day, Date, Month, Year : Unsigned_8;

   procedure Get_Date is
   begin
      I2C.Master.Send (RTC_Address, Unsigned_8 (16#00#));
      I2C.Master.Finish_Send (Action => I2C.Master.Restart);
      I2C.Master.Request (RTC_Address, 7);

      if I2C.Master.Data_Is_Available then
         Seconds := I2C.Master.Get;
         Minutes := I2C.Master.Get;
         Hours   := I2C.Master.Get;
         Day     := I2C.Master.Get;
         Date    := I2C.Master.Get;
         Month   := I2C.Master.Get;
         Year    := I2C.Master.Get;

         Seconds :=
           Shift_Right (Seconds and 2#1111_0000#, 4) * 10 +
           (Seconds and 2#0000_1111#);
         Minutes :=
           Shift_Right (Minutes and 2#1111_0000#, 4) * 10 +
           (Minutes and 2#0000_1111#);
         Hours   :=
           Shift_Right (Hours and 2#1111_0000#, 4) * 10 +
           (Hours and 2#0000_1111#);
      end if;
   end Get_Date;

begin
   UART.Init (Baud_115200_16MHz);

   Interrupts.Enable;

   I2C.Master.Init;

   --  LED_Config := DD_Output;

   I2C.Master.Detect_Device (RTC_Address, RTC_Is_Present);

   Put_Line ("Start: ");
   I2C.Master.Send (RTC_Address, Unsigned_8 (16#0E#));
   Put_Line ("Send1: ");
   I2C.Master.Send (RTC_Address, Unsigned_8 (2#0000_0000#));
   Put_Line ("Send2: ");
   I2C.Master.Send (RTC_Address, Unsigned_8 (2#1000_1000#));
   Put_Line ("Send3: ");
   I2C.Master.Finish_Send (Action => I2C.Master.Restart);

   loop
      if RTC_Is_Present then
         Get_Date;
         Put (Hours);
         Put (":");
         Put (Minutes);
         Put (":");
         Put (Seconds);
         New_Line;
      else
         Put_Line ("Nop");
      end if;
      --  Wait_Ms (1_000);
      delay 1.0;

      --  LED := High;
      --  Wait_Ms (500);
      --  LED := Low;
      --  Wait_Ms (500);
   end loop;

end Meteo_Clock;
