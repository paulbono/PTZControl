#!/bin/bash

pushd ~/Desktop/PTZControl
    /usr/bin/python3 ./ptz_cameras.py --main --preset "worship_center"
    # Button 1/4 corresponds to camera 6
    curl http://127.0.0.1:8888/press/bank/1/4
popd
