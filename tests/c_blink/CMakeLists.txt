cmake_minimum_required(VERSION 3.15)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_CXX_COMPILER avr-g++)
set(CMAKE_C_COMPILER avr-gcc)
set(CMAKE_ASM_COMPILER avr-gcc)

add_definitions(
    -DF_CPU=16000000
    # -DBAUD=${BAUD}
)

project(c_blink C)

set(F_CPU 16000000)
set(MCU atmega328p)
set(BAUD 57600)
set(PROG_TYPE arduino)

set(E_FUSE 0xfd)
set(H_FUSE 0xda)
set(L_FUSE 0xfd)
set(LOCK_BIT 0xff)

set(CMAKE_EXE_LINKER_FLAGS
    "-mmcu=${MCU} -Wl,--print-memory-usage -Wl,--gc-sections -Wl,--undefined=_mmcu,--section-start=.mmcu=0x910000"
)

add_compile_options(
    -mmcu=${MCU} # MCU
    -std=gnu99 # C99 standard
    -Os # optimize
    -Wall # enable warnings
    -Wno-main
    -Wundef
    -pedantic
    -Wstrict-prototypes
    -Werror
    -Wfatal-errors
    -Wl,--relax,--gc-sections
    -g
    -gdwarf-2
    -funsigned-char # a few optimizations
    -funsigned-bitfields
    -fpack-struct
    -fshort-enums
    -ffunction-sections
    -fdata-sections
)

include_directories(
    /usr/include/simavr
)

add_executable(${PROJECT_NAME} "main.c")
set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME ${PROJECT_NAME}.elf)

# Clean extra files
set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "${PROJECT_NAME}.hex;${PROJECT_NAME}.eeprom;${PROJECT_NAME}.lst")