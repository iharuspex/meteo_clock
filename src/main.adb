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

-- Note: get MCU name and  Freq from .mmcu section for simavr support
-- simavr/simavr/sim/avr/avr_mcu_section.h will be helpful

--  with Float_Img; use Float_Img;

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
   F : Float := 0.55;

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


   function Image_F (Value : Float) return AStr5
   is
      function "+" is
         new Ada.Unchecked_Conversion (Source => Float,
                                       Target => Unsigned_16);
      Result : AStr5;
      Val_U16 : constant Unsigned_16 := +Value;
   begin
      U16_Img_Right (Val_U16, Result);
      for I in Unsigned_8'(2) .. 4 loop
         Result(I-1) := Result(I);
      end loop;
      Result(4) := '.';
      return Result;
   end Image_F;


   RT_Clock  : DS3231_RTC;
   Curr_Time : AVR.Real_Time.Time;

   Now_Time : AVR.Real_Time.Time;

begin
   UART.Init (Baud_115200_16MHz);

   Interrupts.Enable;

   I2C.Master.Init;
   RT_Clock.Init (RTC_Address);

   LED_Config := DD_Output;

   --  Put_Line (Float_To_String (F));

   RT_Clock.Set_Time;

   loop
      Curr_Time := RT_Clock.Get_Time;
      
      Wait_Ms (500);

      LED := High;
      Wait_Ms (250);
      LED := Low;
      Wait_Ms (250);
   end loop;

end Main;
