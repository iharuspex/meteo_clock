with AVR.I2C;
use type AVR.I2C.I2C_Address;
with AVR.I2C.Master;
with AVR.Real_Time;

with Interfaces; use Interfaces;

package DS3231 is
   type DS3231_RTC is tagged private;

   procedure Init (Self : in out DS3231_RTC; Address : in AVR.I2C.I2C_Address);

   function Get_Time (Self : DS3231_RTC) return AVR.Real_Time.Time;

private
   type DS3231_RTC is tagged record
      Address : AVR.I2C.I2C_Address;
   end record;

   procedure Set_Register
     (Self : DS3231_RTC; Reg : Unsigned_8; Val : Unsigned_8);
   function Get_Register
     (Self : DS3231_RTC; Reg : Unsigned_8) return Unsigned_8;

   SECONDS_REG          : constant Unsigned_8 := 16#00#;
   MINUTES_REG          : constant Unsigned_8 := 16#01#;
   HOURS_REG            : constant Unsigned_8 := 16#02#;
   DAY_REG              : constant Unsigned_8 := 16#03#;
   DATE_REG             : constant Unsigned_8 := 16#04#;
   MONTH_CENTURY_REG    : constant Unsigned_8 := 16#05#;
   YEAR_REG             : constant Unsigned_8 := 16#06#;
   ALARM_1_SECONDS_REG  : constant Unsigned_8 := 16#07#;
   ALARM_1_MINUTES_REG  : constant Unsigned_8 := 16#08#;
   ALARM_1_HOURS_REG    : constant Unsigned_8 := 16#09#;
   ALARM_1_DAY_DATE_REG : constant Unsigned_8 := 16#0A#;
   ALARM_2_MINUTES_REG  : constant Unsigned_8 := 16#0B#;
   ALARM_2_HOURS_REG    : constant Unsigned_8 := 16#0C#;
   ALARM_2_DAY_DATE_REG : constant Unsigned_8 := 16#0D#;
   CONTROL_REG          : constant Unsigned_8 := 16#0E#;
   CTRL_STATUS_REG      : constant Unsigned_8 := 16#0F#;
   AGING_OFFSET_REG     : constant Unsigned_8 := 16#10#;
   TEMP_MSB_REG         : constant Unsigned_8 := 16#11#;
   TEMP_LSB_REG         : constant Unsigned_8 := 16#12#;

end DS3231;
