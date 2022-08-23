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

const server = new net.Server()
server.listen({ host: "127.0.0.1", port: CAMERA_PORT })
server.on("connection", socket => {
  console.log("\nsomeone connected");
  socket.setNoDelay(true);
  
  socket.on("data", data => {
	  console.log(data);
	  console.log(data.toString('hex').toUpperCase());
	  if ( data.toString('hex').toUpperCase() == ZOOM_INQ_COMMAND ) {
          let response = Buffer.from("905001020304FF", 'hex');
		  socket.write(response);
      } else if ( data.toString('hex').toUpperCase() == PAN_TILT_INQ_COMMAND ) {
          let response = Buffer.from("90500802030405060708FF", 'hex');
		  socket.write(response);
      } else if ( data.toString('hex').toUpperCase() == FOCUS_INQ_COMMAND ) {
          let response = Buffer.from("905009020304FF", 'hex');
		  socket.write(response);
      }
  })

  socket.on("close", () => {
    console.log("connection closed")
  })
})

