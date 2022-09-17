const net = require('net');

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
const FOCUS_TYPE_AUTO="02";
const FOCUS_TYPE_MANUAL="03";
const FOCUS_TYPE_COMMAND = "81010438%sFF";
const ONE_SECOND_IN_MS=1000;
const TEN_SECONDS_IN_MS=10000;


let server = require('dgram').createSocket('udp4');

server.on('listening', () => {
	const serverInfo = server.address();
	console.log(`Server listening on ${serverInfo.address}:${serverInfo.port}`);
});

server.on('message', (msg, rinfo) => {
	console.log(msg);
    console.log(msg.toString('hex').toUpperCase());
    if ( msg.toString('hex').toUpperCase() == ZOOM_INQ_COMMAND ) {
	    let response = Buffer.from("905001020304FF", 'hex');
	    server.send(response, rinfo.port, rinfo.address);
    } else if ( msg.toString('hex').toUpperCase() == PAN_TILT_INQ_COMMAND ) {
	    let response = Buffer.from("90500802030405060708FF", 'hex');
	    server.send(response, rinfo.port, rinfo.address);
    } else if ( msg.toString('hex').toUpperCase() == FOCUS_INQ_COMMAND ) {
	    let response = Buffer.from("905009020304FF", 'hex');
	    server.send(response, rinfo.port, rinfo.address);
    }
});

server.bind({
	address: "127.0.0.1",
	port: CAMERA_PORT
});
