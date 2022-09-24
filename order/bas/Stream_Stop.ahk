#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


if WinExist("Livestream Studio", "Livestream Studio")
{
	WinActivate	
	Sleep 200
	MouseMove 1900, 20, 5
	MouseClick, left
}
else
	MsgBox, "Unable to find Livestream, please re-run init.bat on desktop"



