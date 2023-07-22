#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance,Force
CoordMode,Mouse,Screen
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


WinActivate Program Manager
WinWaitActive Program Manager

Sleep 200

MouseMove -302, 41, 5
Sleep 300
Send ^{PrintScreen}
Sleep 500

MouseMove 388, 352, 5
Sleep 300
Send ^{PrintScreen}
Sleep 500

	
Run, "C:\Users\User\Desktop\SaveAndSend.bat"

