@echo off

asm68k /m /k /p /o oz+ Test.asm, Test.bin >errors.txt, , Test.lst
type errors.txt
exit 0
