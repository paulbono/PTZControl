@echo off
setlocal enabledelayedexpansion

:: Skip to the main script flow
goto main

:: Function to add minutes to a given time
:adjustTime
echo [LOG] Adjusting time...
set /A "newMinute=%5 + %6"
set /A "newHour=%4"
set /A "newDay=%3"

:adjustMinutes
if !newMinute! LSS 0 (
    set /A "newHour=newHour - 1"
    set /A "newMinute=newMinute + 60"
    goto adjustMinutes
)

:adjustHours
if !newHour! LSS 0 (
    set /A "newDay=newDay - 1"
    set /A "newHour=newHour + 24"
    goto adjustHours
)

set /A "extraHours=newMinute / 60"
set /A "newMinute=newMinute %% 60"
set /A "newHour=newHour + extraHours"
set /A "extraDays=newHour / 24"
set /A "newHour=newHour %% 24"
set /A "newDay=newDay + extraDays"

:: Call adjustDate to handle month and year changes
call :adjustDate !year! !month! !newDay!

:: In :adjustTime after setting newDay, newHour, and newMinute
if !newMonth! LSS 10 set newMonth=0!newMonth!
if !newDay! LSS 10 set newDay=0!newDay!
if !newHour! LSS 10 set newHour=0!newHour!
if !newMinute! LSS 10 set newMinute=0!newMinute!

:: Ensure only the last two characters are kept for newMonth and newDay
set newMonth=!newMonth:~-2!
set newDay=!newDay:~-2!
set newHour=!newHour:~-2!
set newMinute=!newMinute:~-2!

echo [LOG] Time adjusted: newYear=!newYear!, newMonth=!newMonth!, newDay=!newDay!, newHour=!newHour!, newMinute=!newMinute!
goto :EOF



:adjustDate
set /A "tempYear=%1"
set /A "tempMonth=%2"
set /A "tempDay=%3"

:: Break down leap year calculation
set /A "div4=tempYear %% 4"
set /A "div100=tempYear %% 100"
set /A "div400=tempYear %% 400"
set "isLeapYear=0"
if %div4%==0 (
    if %div100%==0 (
        if %div400%==0 (
            set "isLeapYear=1"
        )
    ) else (
        set "isLeapYear=1"
    )
)

:: Adjust for leap year in February
if %isLeapYear%==1 set "daysInMonth=31 29 31 30 31 30 31 31 30 31 30 31"

:adjustLoop
:: Get the number of days in the current month
for /F "tokens=%tempMonth%" %%a in ("%daysInMonth%") do set /A "daysThisMonth=%%a"

:: Adjust if day exceeds the month or is less than 1
if %tempDay% GTR %daysThisMonth% (
    set /A "tempDay-=daysThisMonth"
    set /A "tempMonth+=1"
) else if %tempDay% LEQ 0 (
    set /A "tempMonth-=1"
    if %tempMonth% LEQ 0 (
        set /A "tempYear-=1"
        set "tempMonth=12"
    )
    for /F "tokens=%tempMonth%" %%b in ("%daysInMonth%") do set /A "daysLastMonth=%%b"
    set /A "tempDay+=daysLastMonth"
) else (
    goto :adjustDone
)

:: Check for year change
if %tempMonth% GTR 12 (
    set /A "tempYear+=1"
    set "tempMonth=1"
) else if %tempMonth% LEQ 0 (
    set /A "tempYear-=1"
    set "tempMonth=12"
)

goto adjustLoop

:adjustDone
:: Set the adjusted date
set "newYear=%tempYear%"
set "newMonth=%tempMonth%"
set "newDay=%tempDay%"
goto :EOF


:adjustMonth
call :getLastDayOfMonth %1 %2
if !newDay! leq !lastDayOfMonth! goto EOF
:: Increase month if day exceeds month length
set /A "newDay=%newDay% - lastDayOfMonth"
set /A "newMonth=%2 + 1"
if %newMonth% leq 12 goto adjustDate
set /A "newYear=%1 + 1"
set newMonth=1
goto adjustDate

:: Function to get the last day of a given month
:getLastDayOfMonth
echo [LOG] Inside :getLastDayOfMonth
set /A "year=%1, month=%2"
echo [LOG] Year: %year%, Month: %month%
:: [Leap year calculation and last day of month logic]
goto :EOF

:main
:: Assigning command line arguments to variables
echo [LOG] Assigning input parameters...
set year=%1
set month=%2
set day=%3
set militaryhour=%4
set minute=%5

echo [LOG] Input parameters: Year=%year%, Month=%month%, Day=%day%, Hour=%militaryhour%, Minute=%minute%

:: Calculate timeone (105 minutes before)
echo [LOG] Calculating timeone... %year% %month% %day% %militaryhour% %minute% -105
call :adjustTime %year% %month% %day% %militaryhour% %minute% -105
echo [LOG] then I get !newYear!-!newMonth!-!newDay!T!newHour!:!newMinute!:00
set timeone=!newYear!-!newMonth!-!newDay!T!newHour!:!newMinute!:00
echo [LOG] timeone: !timeone!

:: Calculate timetwo (1 minute before)
echo [LOG] Calculating timetwo...  %year% %month% %day% %militaryhour% %minute% -1
call :adjustTime %year% %month% %day% %militaryhour% %minute% -1
set timetwo=!newYear!-!newMonth!-!newDay!T!newHour!:!newMinute!:00
echo [LOG] timetwo: %timetwo%

:: Calculate timethree (75 minutes after)
echo [LOG] Calculating timethree... %year% %month% %day% %militaryhour% %minute% 75
call :adjustTime %year% %month% %day% %militaryhour% %minute% 75
set timethree=!newYear!-!newMonth!-!newDay!T!newHour!:!newMinute!:00
echo [LOG] timethree: %timethree%

:EOF
:: Transfer variables to the global environment
ENDLOCAL & SET timeone=%timeone% & SET timetwo=%timetwo% & SET timethree=%timethree%
