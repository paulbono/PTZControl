@echo off

echo Starting in 15 seconds

timeout 15

REM Blocks Streaming.ahk
start "I'm Running..." "C:\Program Files (x86)\Livestream Studio Launcher\Livestream Studio.exe"
REM Blocks WrapperScript\On.bat and Desktop\query.bat
start "I'm Running..." "C:\Program Files\Companion\Companion.exe"

timeout 15
start "I'm Running..." "C:\Program Files\Elgato\StreamDeck\StreamDeck.exe"
start "I'm Running..." "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 1" http://10.0.0.132/ -incognito
start "I'm Running..." "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 1" http://10.0.0.154/ -incognito
start "I'm Running..." "C:\Users\User\Desktop\PTZControl\WrapperScript\On.bat"
start "I'm Running..." "C:\Users\User\Desktop\query.bat"

timeout 300 REM Let Livestream start before auto hot key script to select current event
start "I'm Running..." "C:\Users\User\Desktop\Streaming.ahk"
timeout 3
start "I'm Running..." "C:\Users\User\Desktop\PTZControl\order\prep.bat"
