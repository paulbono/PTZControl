#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


if WinExist("Livestream Studio", "Livestream Studio")
{
	WinActivate	
	Send #{up}
	Sleep 1000
	MouseMove 222, 1050, 5
	MouseClick, left
	Sleep 1000
	MouseMove 160, 850, 5
	MouseClick, left
	Sleep 1000
	MouseMove 160, 880, 5
	MouseClick, left
}
else
	MsgBox, "Unable to find Livestream, please re-run init.bat on desktop"



