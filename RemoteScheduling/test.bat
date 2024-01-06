@echo off
setlocal

:: Skip to the main script flow
goto main

:shouldSeeSecond
echo should see second
goto :EOF

:main
echo should see first
call :shouldSeeSecond 

:EOF
echo i'm done
