with AVR.I2C;
use type AVR.I2C.I2C_Address;
with AVR.I2C.Master;

with Interfaces; use Interfaces;

package LCD_2004 is
   
   procedure Init (LCD_Address : AVR.I2C.I2C_Address);

private

   Display_Address : AVR.I2C.I2C_Address;

   LCD_Port_Data : Unsigned_8 := 0;

   procedure Write_Byte_To_LCD (Byte : Unsigned_8);

   procedure E_Set (Status : Boolean);
   procedure RS_Set (Status : Boolean);
   procedure LED_Set;
   procedure Write_Set;

end LCD_2004;