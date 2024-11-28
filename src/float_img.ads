with AVR.Strings; use AVR.Strings;

package Float_Img is

   -- Новый тип, который оборачивает Float
   type Wrapped_Float is new Float;

   -- Функция для преобразования Float в строку
   function Float_To_String(Val : Float) return AVR_String;

   -- Определение атрибута Image для нового типа
   function Image(Value : Wrapped_Float) return AVR_String;

end Float_Img;