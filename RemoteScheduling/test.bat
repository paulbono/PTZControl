@echo off
setlocal

:: Skip to the main script flow
goto main

:shouldSeeSecond
echo %*
goto :EOF

:shouldSeeThird
echo %
goto :EOF

:main
echo should see first
call :shouldSeeSecond should see second
call :shouldSeeThird should see third
goto :EOF

:EOF
echo i'm done
