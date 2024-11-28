with AVR; use AVR;
with AVR.Strings; use AVR.Strings;
with Interfaces; use Interfaces;
with AVR.Strings.Edit.Integers; use AVR.Strings.Edit.Integers;

package body Float_Img is

   -- Реализация функции Float_To_String
   function Float_To_String(Val : Float) return AVR_String is
      Integer_Part : Integer_16;
      Fractional_Part : Float;
      Buffer : AVR_String(1 .. 20); -- Буфер для хранения строки
      Index : Pos8 := 1;
      Value : Float := Val;
   begin
      -- Обработка отрицательных чисел
      if Value < 0.0 then
         Buffer(Index) := '-';
         Index := Index + 1;
         Value := -Value;
      end if;

      -- Разделение на целую и дробную части
      Integer_Part := Integer_16(Value);
      Fractional_Part := Value - Float(Integer_Part);

      -- Преобразование целой части в строку
      declare
         Integer_Str : AVR_String := Put(Integer_Part);
      begin
         for I in Integer_Str'Range loop
            if Integer_Str(I) /= ' ' then
               Buffer(Index) := Integer_Str(I);
               Index := Index + 1;
            end if;
         end loop;
      end;

      -- Добавление точки
      Buffer(Index) := '.';
      Index := Index + 1;

      -- Преобразование дробной части в строку
      for I in 1 .. 6 loop
         Fractional_Part := Fractional_Part * 10.0;
         declare
            Digit : Integer_16 := Integer_16(Fractional_Part);
         begin
            Buffer(Index) := Character'Val(Character'Pos('0') + Digit);
            Index := Index + 1;
            Fractional_Part := Fractional_Part - Float(Digit);
         end;
      end loop;

      return Buffer(1 .. Index - 1);
   end Float_To_String;

   -- Реализация атрибута Image для нового типа
   function Image(Value : Wrapped_Float) return AVR_String is
   begin
      return Float_To_String(Float(Value));
   end Image;

end Float_Img;