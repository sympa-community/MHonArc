@echo off
if not exist mhonarc.dos goto :error

if exist mhonarc.lck erase mhonarc.lck

perl mhonarc.dos %1 %2 %3 %4 %5 %6 %7 %8 %9

goto :exit

:error
echo You (currently) must be in the mhonarc directory to run the program.
echo.

:exit
