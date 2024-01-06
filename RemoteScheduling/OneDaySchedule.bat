@echo off

schtasks /CREATE /TN "2023-04-09\02 Init" /XML "C:\Users\User\Desktop\PTZControl\RemoteScheduling\02 Init.xml"
schtasks /CREATE /TN "2023-04-09\03 Start Stream" /XML "C:\Users\User\Desktop\PTZControl\RemoteScheduling\03 Start Stream.xml"
schtasks /CREATE /TN "2023-04-09\04 Teardown" /XML "C:\Users\User\Desktop\PTZControl\RemoteScheduling\04 Teardown.xml"
