@echo off
setlocal

:: Assigning parameters to variables
set year=%1
set month=%2
set day=%3
set hour=%4
set minute=%5
set expected1=%6
set expected2=%7
set expected3=%8

:: Displaying test case information
echo Test Case: %year%-%month%-%day% %hour%:%minute%
echo Expected: %expected1% %expected2% %expected3%

:: Calling the main script (schedule.bat)
call schedule.bat %year% %month% %day% %hour% %minute%

:: Displaying the actual results
echo Actual: %timeone% %timetwo% %timethree%
echo.

ENDLOCAL & SET timeone=%timeone% & SET timetwo=%timetwo% & SET timethree=%timethree%

