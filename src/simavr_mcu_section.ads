pragma Restrictions (No_Elaboration_Code);

with System; use System;
with AVR;    use AVR;

package SimAVR_MCU_Section is

   type MMCU_Tag is private;

   type MMCU_String_T is record
      Tag : Nat8;
      Len : Nat8;
      Str : String (1 .. 64);
   end record;
   --  with Pack;

   type MMCU_Long_T is record
      Tag : Nat8;
      Len : Nat8;
      Val : Nat32;
   end record;
   --  with Pack;

   type MMCU_T is array (1 .. 2) of Nat8;

   --  type Some_Type is new Nat8 with Linker_Section => ".mmcu";

   --  MMCU_String_Instance : MMCU_String_T
   --  with Linker_Section => ".mmcu", Volatile => True;

   --  MMCU_Long_Instance : MMCU_Long_T
   --  with Linker_Section => ".mmcu", Volatile => True;

   --  MMCU : MMCU_T
   --  with Linker_Section => ".mmcu", Volatile => True;

   --  Some_Data : Nat8 := 16#FA#
   --  with Linker_Section => ".mmcu", Volatile => True;
   -- ------------------------------------------------------
   MMCU_1 : MMCU_T := (0, 0)
   with Linker_Section => ".mmcu", Volatile => True;

   MMCU_Long_Instance_1 : MMCU_Long_T :=
     (Tag => 2, Len => Nat8 (MMCU_Long_T'Size / 8 - 2), Val => 16000000)
   with Linker_Section => ".mmcu", Volatile => True;

   MMCU_String_Instance_1 : MMCU_String_T :=
     (Tag => 1,
      Len => Nat8 (MMCU_String_T'Size / 8 - 2),
      Str =>
        ('a',
         't',
         'm',
         'e',
         'g',
         'a',
         '3',
         '2',
         '8',
         'p',
         others => (Character'Val (0))))
   with Linker_Section => ".mmcu", Volatile => True;


   --  pragma Unreferenced(MMCU_1);
   --  pragma Unreferenced(MMCU_Long_Instance_1);
   --  pragma Unreferenced(MMCU_String_Instance_1);


   --  generic
   --     MCU_Name : String;
   --     Freq : Nat32;
   --  procedure Initialize_AVR_MCU_Data;

private
   type MMCU_Tag is
     (Tag,
      Name,
      Frequency,
      VCC,
      AVCC,
      AREF,
      LFuse,
      HFuse,
      EFuse,
      Signature,
      Simavr_Command,
      Simavr_Console,
      VCD_Filename,
      VCD_Period,
      VCD_Trace,
      VCD_Port_Pin,
      VCD_IRQ,
      Port_External_Pull);

end SimAvr_MCU_Section;
