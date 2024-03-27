@echo off
setlocal

:: Calling test_case_schedule.bat with each set of parameters
call test_case_schedule.bat 2023 12 25 1 15 "2023-12-24T23:30:00" "2023-12-25T01:14:00" "2023-12-25T02:30:00"
call test_case_schedule.bat 2023 12 25 0 15 "2023-12-24T22:30:00" "2023-12-25T00:14:00" "2023-12-25T01:30:00"
call test_case_schedule.bat 2023 01 31 23 50 "2023-01-31T22:05:00" "2023-01-31T23:49:00" "2023-02-01T01:05:00"
call test_case_schedule.bat 2023 12 31 23 50 "2023-12-31T22:05:00" "2023-12-31T23:49:00" "2024-01-01T01:05:00"
call test_case_schedule.bat 2023 07 15 01 10 "2023-07-14T23:25:00" "2023-07-15T01:09:00" "2023-07-15T02:25:00"
call test_case_schedule.bat 2023 05 10 12 00 "2023-05-10T10:15:00" "2023-05-10T11:59:00" "2023-05-10T13:15:00"

endlocal
