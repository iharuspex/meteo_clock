#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <simavr/sim_avr.h>
#include <simavr/sim_elf.h>
#include <simavr/sim_gdb.h>

avr_t *avr = NULL;

int main(int argc, char **argv)
{
   char *fw_name = NULL;
   elf_firmware_t elf_fw = {{ 0 }};

   if (argc == 2) {
      fw_name = argv[1];
   } else {
      printf("usage: %s elf-file\n", argv[0]);
      return EXIT_FAILURE;
   }

   elf_read_firmware(fw_name, &elf_fw);
   printf("firmware %s f=%d mmcu=%s\n", fw_name, (int) elf_fw.frequency, elf_fw.mmcu);

   avr = avr_make_mcu_by_name(elf_fw.mmcu);
   if (!avr) {
      fprintf(stderr, "%s: AVR '%s' not known\n", argv[0], elf_fw.mmcu);
      return EXIT_FAILURE;
   }

   free(avr);

   return EXIT_SUCCESS;
}