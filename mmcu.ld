SECTIONS
{
    .mmcu 0x910000 : AT(0x910000)
    {
        KEEP(*(.mmcu))
    }
}