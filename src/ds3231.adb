with AVR.UART; use AVR.UART;

package body DS3231 is
   use AVR.I2C;
   use AVR.I2C.Master;

   ----------
   -- Init --
   ----------

   procedure Init (Self : in out DS3231_RTC; Address : in AVR.I2C.I2C_Address)
   is
      RTC_Is_Present : Boolean;
   begin
      Self.Address := Address;

      -- перенести, возможно
      Detect_Device (Self.Address, RTC_Is_Present);

      if RTC_Is_Present then
         Put_Line ("DS3231: ok");
      end if;

      Send (Self.Address, CONTROL_REG);
      Send (Self.Address, Unsigned_8 (2#0000_0000#));
      Send (Self.Address, Unsigned_8 (2#1000_1000#));
      Finish_Send (Restart);
   end Init;

   ------------------
   -- Set_Register --
   ------------------

   procedure Set_Register
     (Self : DS3231_RTC; Reg : Unsigned_8; Val : Unsigned_8) is
   begin
      -- This is not working :(
      --  Send (Self.Address, Reg);
      --  Send (Self.Address, Val);

      -- And this is work perfectly
      Send (Self.Address, Reg, Val);
      Finish_Send (Restart);
   end Set_Register;

   ------------------
   -- Get_Register --
   ------------------

   function Get_Register
     (Self : DS3231_RTC; Reg : Unsigned_8) return Unsigned_8
   is
      Val : Unsigned_8 := 0;
   begin
      Send (Self.Address, Reg);
      Finish_Send (Restart);
      Request (Self.Address, 1);

      if Data_Is_Available then
         Val := Get;
      end if;

      return Val;
   end Get_Register;

   --------------
   -- Get_Time --
   --------------

   function Get_Time (Self : DS3231_RTC) return AVR.Real_Time.Time is
      Seconds, Minutes, Hours, Day, Date, Month, Year : Unsigned_8;

      Curr_Time : AVR.Real_Time.Time;
   begin
      Send (Self.Address, SECONDS_REG);
      Finish_Send (Restart);
      Request (Self.Address, 7);

      if Data_Is_Available then
         Seconds := Get;
         Minutes := Get;
         Hours   := Get;
         Day     := Get;
         Date    := Get;
         Month   := Get;
         Year    := Get;

         Seconds :=
           Shift_Right (Seconds and 2#1111_0000#, 4) * 10
           + (Seconds and 2#0000_1111#);
         Minutes :=
           Shift_Right (Minutes and 2#1111_0000#, 4) * 10
           + (Minutes and 2#0000_1111#);
         Hours :=
           Shift_Right (Hours and 2#1111_0000#, 4) * 10
           + (Hours and 2#0000_1111#);
         Day := Day and 2#0000_0111#;
         Date :=
           Shift_Right (Date and 2#0011_0000#, 4) * 10
           + (Date and 2#0000_1111#);
         Month :=
           Shift_Right (Month and 2#0001_0000#, 4) * 10
           + (Month and 2#0000_1111#);
         Year :=
           Shift_Right (Year and 2#1111_0000#, 4) * 10
           + (Year and 2#0000_1111#);
      end if;

      Put (Hours);
      Put (":");
      Put (Minutes);
      Put (":");
      Put (Seconds);

      Put (" day: ");
      Put (Day);
      Put (" ");
      Put (Date);
      Put ("-");
      Put (Month);
      Put ("-");
      Put (Year);
      New_Line;

      return Curr_Time;
   end Get_Time;

   --------------
   -- Set_Time --
   --------------

   procedure Set_Time (Self : DS3231_RTC) is

      -- Test time is 6:59:52 day: 5 29-11-24

      Seconds  : Unsigned_8 := 52;
      Minutes  : Unsigned_8 := 59;
      Hours    : Unsigned_8 := 6;
      Day      : Unsigned_8 := 5;
      Date     : Unsigned_8 := 29; 
      Month    : Unsigned_8 := 11;
      Year     : Unsigned_8 := 24;
   begin
      Seconds := Shift_Left (Seconds / 10, 4) + (Seconds rem 10);
      Minutes := Shift_Left (Minutes / 10, 4) + (Minutes rem 10);
      Hours := Shift_Left (Hours / 10, 4) + (Hours rem 10);
      Day := Day and 2#0000_0111#;
      Date  := Shift_Left (Date / 10, 4) + (Date rem 10);
      Month  := Shift_Left (Month / 10, 4) + (Month rem 10);
      Year  := Shift_Left (Year / 10, 4) + (Year rem 10);

      Self.Set_Register(SECONDS_REG, Seconds);
      Self.Set_Register(MINUTES_REG, Minutes);
      Self.Set_Register(HOURS_REG, Hours);
      Self.Set_Register(DAY_REG, Day);
      Self.Set_Register(DATE_REG, Date);
      Self.Set_Register(MONTH_CENTURY_REG, Month);
      Self.Set_Register(YEAR_REG, Year);

   end Set_Time;

end DS3231;
