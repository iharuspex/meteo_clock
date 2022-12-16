with AVR.Wait;
with Avrada_Rts_Config;

package body LCD_2004 is

   ----------
   -- Init --
   ----------

   procedure Init (LCD_Address : AVR.I2C.I2C_Address) is
   begin
      null;
   end Init;

   procedure Delay_50us is new AVR.Wait.Generic_Wait_USecs
     (Crystal_Hertz => Avrada_Rts_Config.Clock_Frequency, Micro_Seconds => 50);

   -----------------------
   -- Write_Byte_To_LCD --
   -----------------------

   procedure Write_Byte_To_LCD (Byte : Unsigned_8) is
   begin
      AVR.I2C.Master.Send (Display_Address, Byte);
   end Write_Byte_To_LCD;

   -----------
   -- E_Set --
   -----------

   procedure E_Set (Status : Boolean) is
   begin 
      if Status = True then
         LCD_Port_Data := LCD_Port_Data or 16#4#;
      else
         LCD_Port_Data := LCD_Port_Data and not 16#4#;
      end if;
      Write_Byte_To_LCD (LCD_Port_Data);
   end E_Set;

   ------------
   -- RS_Set --
   ------------

   procedure RS_Set (Status : Boolean) is
   begin
      if Status = True then
         LCD_Port_Data := LCD_Port_Data or 16#1#;
      else
         LCD_Port_Data := LCD_Port_Data and not 16#1#;
      end if;
      Write_Byte_To_LCD (LCD_Port_Data);
   end RS_Set;


   -------------
   -- LED_Set --
   -------------

   procedure LED_Set is
   begin
      LCD_Port_Data := LCD_Port_Data or 16#8#;
      Write_Byte_To_LCD (LCD_Port_Data);
   end LED_Set;

   ---------------
   -- Write_Set --
   ---------------

   procedure Write_Set is
   begin
      LCD_Port_Data := LCD_Port_Data and not 16#2#;
      Write_Byte_To_LCD (LCD_Port_Data);
   end Write_Set;

end LCD_2004;
