import argparse
import json
import re
import socket
import subprocess
import sys
import time
import xmlrpc.client
from threading import Thread


CAMERA_PORT = 1259
PAN_SPEED_MAX = "18"
TILT_SPEED_MAX = "14"
ON_COMMAND = "8101040002FF"
OFF_COMMAND = "8101040003FF"
PAN_TILT_ABSOLUTE_TYPE = "02"
PAN_TILT_RELATIVE_TYPE = "03"
PAN_TILT_COMMAND = "810106{PAN_TILT_TYPE}{PAN_SPEED}{TILT_SPEED}0{PAN[0]}0{PAN[1]}0{PAN[2]}0{PAN[3]}0{TILT[0]}0{TILT[1]}0{TILT[2]}0{TILT[3]}FF"
PAN_TILT_INQ_COMMAND = "81090612FF"
#[Move left 01 or right 02 or stay 03][Move Up 01 or down 02 or stay 03]
LEFT = "01"
UP = "01"
RIGHT = "02"
DOWN = "02"
STAY = "03"
PAN_TILT_DIR_COMMAND = "81010601{PAN_SPEED}{TILT_SPEED}{DIRECTION_X}{DIRECTION_Y}FF"
ZOOM_COMMAND = "810104470{ZOOM[0]}0{ZOOM[1]}0{ZOOM[2]}0{ZOOM[3]}FF"
ZOOM_INQ_COMMAND = "81090447FF"
FOCUS_COMMAND = "810104480{FOCUS[0]}0{FOCUS[1]}0{FOCUS[2]}0{FOCUS[3]}FF"
FOCUS_INQ_COMMAND = "81090448FF"
FOCUS_TYPE_AUTO="02"
FOCUS_TYPE_MANUAL="03"
FOCUS_TYPE_COMMAND = "81010438{FOCUS_TYPE}FF"
ONE_SECOND=1

def launch_daemon(debug=False):
    command = "{} data_daemon.py".format(sys.executable)
    if debug:
        command = command + " --debug"
    else:
        command = command.replace("python.exe", "pythonw.exe")
    subprocess.Popen(command, creationflags=subprocess.DETACHED_PROCESS, close_fds=True, shell=True)

def get_connection(ip):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, 0)
    s.connect((ip, CAMERA_PORT))
    s.settimeout(ONE_SECOND)
    return s

def send_pan_tilt_zoom_focus(data_server, camera, conn, preset, pan_tilt_type=PAN_TILT_ABSOLUTE_TYPE):
    pan_tilt_command = bytes.fromhex(PAN_TILT_COMMAND.format(PAN_TILT_TYPE=pan_tilt_type, PAN_SPEED=PAN_SPEED_MAX, TILT_SPEED=TILT_SPEED_MAX, PAN=preset["pan"], TILT=preset["tilt"]).upper())
    conn.send(pan_tilt_command)
    #response = conn.recv(1024).hex()
    #print(response)
    zoom_command = bytes.fromhex(ZOOM_COMMAND.format(ZOOM=preset["zoom"]).upper())
    conn.send(zoom_command)
    #response = conn.recv(1024).hex()
    #print(response)
    focus_command = bytes.fromhex(FOCUS_COMMAND.format(FOCUS=preset["focus"]).upper())
    conn.send(focus_command)
    #response = conn.recv(1024).hex()
    #print(response)
    # data_server.set(camera, "current_pos", preset)

def send_commands(data_server, args, camera):
    try:
        ip = data_server.get(camera, "ip")
    except:
        launch_daemon(args.debug)
        ip = data_server.get(camera, "ip")
        print(data_server.ptz_data_size())
    conn = get_connection(ip)
    query_results = {}
    if args.off:
        preset = data_server.get(camera, "goodnight")
        if preset:
            send_pan_tilt_zoom_focus(data_server, camera, conn, preset)
            time.sleep(10)
        else:
            print("Can't find that preset")
        data = bytes.fromhex(OFF_COMMAND)
        conn.send(data)
        # response = conn.recv(1024).hex()
        # print(response)
    if args.on:
        data = bytes.fromhex(ON_COMMAND)
        conn.send(data)
    if args.preset:
        preset = data_server.get(camera, args.preset)
        if preset:
            send_pan_tilt_zoom_focus(data_server, camera, conn, preset)
        else:
            print("Can't find that preset")
    if args.pan or args.tilt or args.zoom:
        data = {
            "zoom": args.zoom if args.zoom else "0000",
            "pan": args.pan if args.pan else "0000",
            "tilt": args.tilt if args.tilt else "0000",
            "focus": "0000"
        }
        # TODO handle if data if input is bad
        send_pan_tilt_zoom_focus(data_server, camera, conn, data, PAN_TILT_RELATIVE_TYPE)
    if args.query_zoom or args.query_all:
        conn.send(bytes.fromhex(ZOOM_INQ_COMMAND))
        response = conn.recv(1024).hex().upper()
        match = re.match(r"90500(?P<p>.)0(?P<q>.)0(?P<r>.)0(?P<s>.)FF", response)
        if match:
            zoom_response = match.groupdict()
            zoom_value = "{}{}{}{}".format(zoom_response["p"], zoom_response["q"], zoom_response["r"], zoom_response["s"])
            query_results["zoom"] = zoom_value
    if args.query_pan_tilt or args.query_all:
        conn.send(bytes.fromhex(PAN_TILT_INQ_COMMAND))
        response = conn.recv(1024).hex().upper()
        match = re.match(r"90500(?P<w0>.)0(?P<w1>.)0(?P<w2>.)0(?P<w3>.)0(?P<z0>.)0(?P<z1>.)0(?P<z2>.)0(?P<z3>.)FF", response)
        if match:
            pan_tilt_response = match.groupdict()
            pan_value = "{}{}{}{}".format(pan_tilt_response["w0"], pan_tilt_response["w1"], pan_tilt_response["w2"], pan_tilt_response["w3"])
            tilt_value = "{}{}{}{}".format(pan_tilt_response["z0"], pan_tilt_response["z1"], pan_tilt_response["z2"], pan_tilt_response["z3"])
            query_results["pan"] = pan_value
            query_results["tilt"] = tilt_value
    if args.query_focus or args.query_all:
        conn.send(bytes.fromhex(FOCUS_INQ_COMMAND))
        response = conn.recv(1024).hex().upper()
        match = re.match(r"90500(?P<p>.)0(?P<q>.)0(?P<r>.)0(?P<s>.)FF", response)
        if match:
            focus_response = match.groupdict()
            focus_value = "{}{}{}{}".format(focus_response["p"], focus_response["q"], focus_response["r"], focus_response["s"])
            query_results["focus"] = focus_value
    if args.query_zoom or args.query_pan_tilt or args.query_focus or args.query_all:
        print(camera, json.dumps(query_results))
        if args.log:
            data_server.log(xmlrpc.client.dumps(({camera: query_results},)))
    conn.close()

def process_input(args):
    # Set up daemon url
    data_server = xmlrpc.client.ServerProxy('http://127.0.0.1:8001')
    # Launch daemon
    if args.launch_daemon:
        launch_daemon(args.debug)
    
    if args.main_action:
        camera = "main"
        send_commands(data_server, args, camera)

    if args.alt_action:
        camera = "alt"
        send_commands(data_server, args, camera)

    # threads = []
    # # Create Main camera thread
    # if args.main_action:
    #     camera = "main"
    #     threads.append(Thread(target=send_commands, args=(data_server, args, camera)))

    # # Create Alt camera thread
    # if args.alt_action:
    #     camera = "alt"
    #     threads.append(Thread(target=send_commands, args=(data_server, args, camera)))

    # # Execute the threads
    # for thread in threads:
    #     thread.start()

    # # Join the completed threads
    # for thread in threads:
    #     thread.join()

    # Shutdown daemon
    if args.stop_daemon or args.off:
        data_server.stop_daemon()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Interact with PTZ cameras')
    parser.add_argument('--launch_daemon', dest='launch_daemon', action='store_true', default=False, help='Start the Daemon (This should be done automatically)')
    parser.add_argument('--stop_daemon', dest='stop_daemon', action='store_true', default=False, help='Stop the Daemon (This should occur automatically when cameras are shut off)')
    parser.add_argument('--main', dest='main_action', action='store_true', default=False, help='Do these actions to the main camera')
    parser.add_argument('--alt', dest='alt_action', action='store_true', default=False, help='Do these actions to the alt camera')
    parser.add_argument('--preset', dest='preset', type=str, help='Move Camera to position --preset [value]')
    parser.add_argument('--pan', dest='pan', type=str, help='Set the relative pan --pan [value]')
    parser.add_argument('--tilt', dest='tilt', type=str, help='Set the relative tilt --tilt [value]')
    parser.add_argument('--zoom', dest='zoom', type=str, help='Set the relative zoom --zoom [value]')
    parser.add_argument('--off', dest='off', action='store_true', default=False, help='Send off to camera')
    parser.add_argument('--on', dest='on', action='store_true', default=False, help='Send on to camera')
    parser.add_argument('--query_zoom', dest='query_zoom', action='store_true', default=False, help='Get the current zoom values')
    parser.add_argument('--query_pan_tilt', dest='query_pan_tilt', action='store_true', default=False, help='Get the current pan and tilt values')
    parser.add_argument('--query_focus', dest='query_focus', action='store_true', default=False, help='Get the current focus values')
    parser.add_argument('--query_all', dest='query_all', action='store_true', default=False, help='Run all Queries')
    parser.add_argument('--log', dest='log', action='store_true', default=False, help='Add to ptz_data')
    parser.add_argument('--debug', dest='debug', action='store_true', default=False, help='Launch debug windows')
    
    args = parser.parse_args()
    process_input(args)
