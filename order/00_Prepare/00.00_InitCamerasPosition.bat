REM NEEDS TO BE UPDATED
pushd C:\Users\User\Desktop\PTZControl
	REM C:\Users\User\AppData\Local\Programs\Python\Python310\python.exe .\ptz_cameras.py --main --preset "worship_center"
	REM button 1/4 is camera 6
	curl http://127.0.0.1:8888/press/bank/1/4
	REM AUTO
	curl http://127.0.0.1:8888/press/bank/1/2
	REM 1:00
	curl http://127.0.0.1:8888/press/bank/2/26
	REM 1:00
	curl http://127.0.0.1:8888/press/bank/2/16
popd 
