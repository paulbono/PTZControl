// Needed for socket communication
const net = require('net');
// Needed for the closest thing I can find to fstring behavior
const util = require('util');
// Needed to read a file
const fs = require('fs');
// Obtain the arguments and pass to minimist to put the args in a map
// npm install minimist
const args = require('minimist')(process.argv);

// Help then exit 
if ("help" in args) {
    console.log('\nnode ptz_cameras.js [commands]\n');
    console.log('\t--main', 'Do these actions to the main camera');
    console.log('\t--alt', 'Do these actions to the alt camera');
    console.log('\t--preset', 'Move Camera to position --preset [value]');
    console.log('\t--pan', 'Set the relative pan --pan [value]');
    console.log('\t--tilt', 'Set the relative tilt --tilt [value]');
    console.log('\t--zoom', 'Set the relative zoom --zoom [value]');
    console.log('\t--off', 'Send off to camera');
    console.log('\t--on', 'Send on to camera');
    console.log('\t--query_zoom', 'Get the current zoom values');
    console.log('\t--query_pan_tilt', 'Get the current pan and tilt values');
    console.log('\t--query_focus', 'Get the current focus values');
    console.log('\t--query_all', 'Run all Queries');
    process.exit(0);
}

// Define constants
const CAMERA_PORT = 1259;
const PAN_SPEED_MAX = "18";
const TILT_SPEED_MAX = "14";
const ON_COMMAND = "8101040002FF";
const OFF_COMMAND = "8101040003FF";
const PAN_TILT_ABSOLUTE_TYPE = "02";
const PAN_TILT_RELATIVE_TYPE = "03";
const PAN_TILT_COMMAND = "810106%s%s%s0%s0%s0%s0%s0%s0%s0%s0%sFF";
const PAN_TILT_INQ_COMMAND = "81090612FF";
// [Move left 01 or right 02 or stay 03][Move Up 01 or down 02 or stay 03]
const LEFT = "01";
const UP = "01";
const RIGHT = "02";
const DOWN = "02";
const STAY = "03";
const PAN_TILT_DIR_COMMAND = "81010601%s%s%s%sFF";
const ZOOM_COMMAND = "810104470%s0%s0%s0%sFF";
const ZOOM_INQ_COMMAND = "81090447FF";
const FOCUS_COMMAND = "810104480%s0%s0%s0%sFF";
const FOCUS_INQ_COMMAND = "81090448FF";
const FOCUS_TYPE_AUTO = "02";
const FOCUS_TYPE_MANUAL = "03";
const FOCUS_TYPE_COMMAND = "81010438%sFF";
const ONE_SECOND_IN_MS = 1000;
const TEN_SECONDS_IN_MS = 10000;


function sleep(ms) {
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
}

function send_command(socket, ip, command) {
    return new Promise(function (resolve, reject) {
        let command_hex = Buffer.from(command, 'hex');
        socket.send(command_hex, 0, Buffer.byteLength(command_hex), CAMERA_PORT, ip);
        socket.on("message", data => {
            resolve(data);
        });
    });
}


async function send_pan_tilt_zoom_focus(camera, socket, ip, preset, pan_tilt_type = PAN_TILT_ABSOLUTE_TYPE) {
    const pan_tilt_command = util.format(PAN_TILT_COMMAND, pan_tilt_type, PAN_SPEED_MAX, TILT_SPEED_MAX, preset.pan[0], preset.pan[1], preset.pan[2], preset.pan[3], preset.tilt[0], preset.tilt[1], preset.tilt[2], preset.tilt[3]).toUpperCase();
    const pan_tilt_command_hex = Buffer.from(pan_tilt_command, 'hex');
    await send_command(socket, ip, pan_tilt_command);

    const zoom_command = util.format(ZOOM_COMMAND, preset.zoom[0], preset.zoom[1], preset.zoom[2], preset.zoom[3]).toUpperCase();
    const zoom_command_hex = Buffer.from(zoom_command, 'hex');
    await send_command(socket, ip, zoom_command);

    const focus_command = util.format(FOCUS_COMMAND, preset.focus[0], preset.focus[1], preset.focus[2], preset.focus[3]).toUpperCase();
    const focus_command_hex = Buffer.from(focus_command, 'hex');
    await send_command(socket, ip, focus_command);
}

function query_zoom(socket, ip) {
    return new Promise(function (resolve, reject) {
        let zoom_inq_command_hex = Buffer.from(ZOOM_INQ_COMMAND, 'hex');
        socket.send(zoom_inq_command_hex, 0, Buffer.byteLength(zoom_inq_command_hex), CAMERA_PORT, ip);
        socket.on("message", data => {
            const response = data.toString('hex').toUpperCase();
            const regExZoomQuery = /90500(?<p>.)0(?<q>.)0(?<r>.)0(?<s>.)FF/mg;
            for (const match of response.matchAll(regExZoomQuery)) {
                if (match.groups !== undefined) {
                    let zoom_value = `${match.groups.p}${match.groups.q}${match.groups.r}${match.groups.s}`;
                    resolve(zoom_value);
                } else {
                    reject("No Matches");
                }
            }
        });
    });
}

function query_pan_tilt(socket, ip) {
    return new Promise(function (resolve, reject) {
        let pan_tilt_inq_command_hex = Buffer.from(PAN_TILT_INQ_COMMAND, 'hex');
        socket.send(pan_tilt_inq_command_hex, 0, Buffer.byteLength(pan_tilt_inq_command_hex), CAMERA_PORT, ip);
        socket.on("message", data => {
            const response = data.toString('hex').toUpperCase();
            const regExPanTiltQuery = /90500(?<w0>.)0(?<w1>.)0(?<w2>.)0(?<w3>.)0(?<z0>.)0(?<z1>.)0(?<z2>.)0(?<z3>.)FF/mg;
            for (const match of response.matchAll(regExPanTiltQuery)) {
                if (match.groups !== undefined) {
                    let pan_value = `${match.groups.w0}${match.groups.w1}${match.groups.w2}${match.groups.w3}`;
                    let tilt_value = `${match.groups.z0}${match.groups.z1}${match.groups.z2}${match.groups.z3}`;
                    resolve([pan_value, tilt_value]);
                } else {
                    reject("No Matches");
                }
            }
        });
    });
}

function query_focus(socket, ip) {
    return new Promise(function (resolve, reject) {
        let focus_inq_command_hex = Buffer.from(FOCUS_INQ_COMMAND, 'hex');
        socket.send(focus_inq_command_hex, 0, Buffer.byteLength(focus_inq_command_hex), CAMERA_PORT, ip);
        socket.on("message", data => {
            const response = data.toString('hex').toUpperCase();
            const regExFocusQuery = /90500(?<p>.)0(?<q>.)0(?<r>.)0(?<s>.)FF/mg;
            for (const match of response.matchAll(regExFocusQuery)) {
                if (match.groups !== undefined) {
                    let focus_value = `${match.groups.p}${match.groups.q}${match.groups.r}${match.groups.s}`;
                    resolve(focus_value);
                } else {
                    reject("No Matches");
                }
            }
        });
    });
}

async function send_commands(ptz_data, camera) {
    let ip = ptz_data[camera]["ip"];
    
    let socket = require('dgram').createSocket('udp4');
    if ("off" in args) {
        // Sends the off command for the camera
        let preset = ptz_data[camera]["goodnight"];
        if (preset !== undefined) {
            await send_pan_tilt_zoom_focus(camera, socket, ip, preset);
            await sleep(TEN_SECONDS_IN_MS);
        } else {
            console.log("Can't find that preset");
        }
        await send_command(socket, ip, OFF_COMMAND);
    } else if ("on" in args) {
        // Sends the on command for the camera
        await send_command(socket, ip, ON_COMMAND);
    } else if ("preset" in args) {
        // Sends whatever preset data is available for the camera
        let preset = ptz_data[camera][args.preset];
        if (preset !== undefined) {
            await send_pan_tilt_zoom_focus(camera, socket, ip, preset);
        } else {
            console.log("Can't find that preset");
        }
    } else if ("pan" in args || "tilt" in args || "zoom" in args) {
        // Sends a relative pan tilt zoom to the camera
        let data = {
            "zoom": (zoom in args) ? args.zoom : "0000",
            "pan": (pan in args) ? args.pan : "0000",
            "tilt": (tilt in args) ? args.tilt : "0000",
            "focus": "0000"
        };
        await send_pan_tilt_zoom_focus(camera, socket, ip, data, PAN_TILT_RELATIVE_TYPE);
    }

    let query_results = {};
    if ("query_zoom" in args || "query_all" in args) {
        query_results["zoom"] = await query_zoom(socket, ip);
    }
    if ("query_pan_tilt" in args || "query_all" in args) {
        [query_results["pan"], query_results["tilt"]] = await query_pan_tilt(socket, ip);
    }
    if ("query_focus" in args || "query_all" in args) {
        query_results["focus"] = await query_focus(socket, ip);
    }
    if ("query_zoom" in args || "query_pan_tilt" in args || "query_focus" in args || "query_all" in args) {
        console.log(camera, query_results);
    }
    socket.close();
}

let ptzRawData = fs.readFileSync('ptz_data.json');
let ptz_data = JSON.parse(ptzRawData);
if ("main" in args) {
    send_commands(ptz_data, "main");
}

if ("alt" in args) {
    send_commands(ptz_data, "alt");
}

