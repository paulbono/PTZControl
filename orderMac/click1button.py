import pyautogui
import time
import os

# Function to wait 500ms
def wait():
    time.sleep(0.5)

# Bring OBS to the foreground
os.system("osascript -e 'activate application \"OBS\"'")
wait()

print("right")
# Right arrow key press
pyautogui.press("right")
wait()

print("right")
# Right arrow key press
pyautogui.press("right")
wait()

print("click")
# Click at (700, 300)
pyautogui.click(700, 300)
wait()

print("tab")
# Tab key press
pyautogui.press("tab")
wait()

print("right")
# Right arrow key press
pyautogui.press("right")
wait()

print("right")
# Right arrow key press
pyautogui.press("right")
wait()

print("right")
# Space key press
pyautogui.press("space")
