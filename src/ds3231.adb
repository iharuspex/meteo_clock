with AVR.UART; use AVR.UART;

package body DS3231 is
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

      Send (Self.Address, CONTROL_REG);
      Send (Self.Address, Unsigned_8 (2#0000_0000#));
      Send (Self.Address, Unsigned_8 (2#1000_1000#));
      Finish_Send (Restart);
   end Init;

   ------------------
   -- Set_Register --
   ------------------

   procedure Set_Register
     (Self : DS3231_RTC; Reg : Unsigned_8; Val : Unsigned_8)
   is
   begin
      Send (Self.Address, Reg);
      Send (Self.Address, Val);
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
           Shift_Right (Seconds and 2#1111_0000#, 4) * 10 +
           (Seconds and 2#0000_1111#);
         Minutes :=
           Shift_Right (Minutes and 2#1111_0000#, 4) * 10 +
           (Minutes and 2#0000_1111#);
         Hours   :=
           Shift_Right (Hours and 2#1111_0000#, 4) * 10 +
           (Hours and 2#0000_1111#);
         Day     := Day and 2#0000_0111#;
         Date    :=
           Shift_Right (Date and 2#0011_0000#, 4) * 10 +
           (Date and 2#0000_1111#);
         Month   :=
           Shift_Right (Month and 2#0001_0000#, 4) * 10 +
           (Month and 2#0000_1111#);
         Year    :=
           Shift_Right (Year and 2#1111_0000#, 4) * 10 +
           (Year and 2#0000_1111#);
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

      Curr_Time :=
        AVR.Real_Time.Time_Of
          (Year   => Integer_8 (Year), Month => Month, Day => Date, Hour => Hours,
           Minute => Minutes, Second => Seconds);

      Put_Line (AVR.Real_Time.Image (Curr_Time));

      return Curr_Time;
   end Get_Time;

end DS3231;
