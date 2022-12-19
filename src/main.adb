with System;
with AVR;           use AVR;
with AVR.MCU;       use AVR.MCU;
with AVR.UART;      use AVR.UART;
with AVR.Real_Time; use AVR.Real_Time;
with AVR.Strings;   use AVR.Strings;
with AVR.Int_Img;   use AVR.Int_Img;

with AVR.I2C;
use type AVR.I2C.I2C_Address;
with AVR.I2C.Master;

with AVR.Wait;
with AVR.Interrupts;
with Avrada_Rts_Config;

with DS3231; use DS3231;

with Interfaces; use Interfaces;
with Ada.Unchecked_Conversion;

procedure Main is
   -- Led on PB5
   LED        : Boolean renames PORTB_Bits (5);
   LED_Config : Boolean renames DDRB_Bits (5);

   procedure Wait_Ms is new AVR.Wait.Generic_Busy_Wait_Milliseconds
     (Crystal_Hertz => Avrada_Rts_Config.Clock_Frequency);

   RTC_Address : I2C.I2C_Address := 16#68#;
   --  RTC_Is_Present : Boolean;

   Seconds, Minutes, Hours, Day, Date, Month, Year : Unsigned_8;
   Temp                                            : Float;

   --------------
   -- Get_Temp --
   --------------

   procedure Get_Temp is
      MSB, LSB : Unsigned_8;
   begin
      I2C.Master.Send (RTC_Address, Unsigned_8 (16#11#));
      I2C.Master.Finish_Send (Action => I2C.Master.Restart);
      I2C.Master.Request (RTC_Address, 2);

      MSB := I2C.Master.Get;
      LSB := I2C.Master.Get;

      Temp := Float (MSB and 2#0111_1111#);
      Temp := Temp + Float (Shift_Right (LSB, 6)) * 0.25;
   end Get_Temp;

   RT_Clock  : DS3231_RTC;
   Curr_Time : AVR.Real_Time.Time;

begin
   UART.Init (Baud_115200_16MHz);

   Interrupts.Enable;

   I2C.Master.Init;
   RT_Clock.Init (RTC_Address);

   --  LED_Config := DD_Output;

   Put_Line (Image_F (F));

   loop
      Curr_Time := RT_Clock.Get_Time;

      --  Put_Line (Time_Image (Curr_Time));

      --  if RTC_Is_Present then
      --     Get_Date;
      --     Put (Hours);
      --     Put (":");
      --     Put (Minutes);
      --     Put (":");
      --     Put (Seconds);

      --     Put (" day: ");
      --     Put (Day);
      --     Put (" ");
      --     Put (Date);
      --     Put ("-");
      --     Put (Month);
      --     Put ("-");
      --     Put (Year);
      --     --  Get_Temp;
      --     --  Put (" temp: ");
      --     --  Put (Unsigned_8 (Temp));
      --     New_Line;
      --  else
      --     Put_Line ("Nop");
      --  end if;

      Wait_Ms (1_000);

      --  LED := High;
      --  Wait_Ms (500);
      --  LED := Low;
      --  Wait_Ms (500);
   end loop;

end Main;
