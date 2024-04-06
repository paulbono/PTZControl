// Needed to read a file
const fs = require('fs');
const http = require('http');
const express = require('express');
const camera = require('../ptz_cameras.js');
const app = express();
app.use(express.json());
const port = 3000;


const ONE_SECOND_IN_MS = 1000;
const TEN_SECONDS_IN_MS = 10000;
const FIFTEEN_SECONDS_IN_MS = 15000;
const ONE_MINUTE_IN_MS = 60000;
const FIVE_MINUTES_IN_MS = 300000;
const OFF = false;
const ON = true;

let ptzRawData = fs.readFileSync('../ptz_data.json');
let ptzData = JSON.parse(ptzRawData);

// Press a button
function pressBitCompanionButton(page, button) {
    return new Promise(function (resolve, reject) {
        let bitCompanionOptions = {
            host: '127.0.0.1',
            port: '8888',
            path: '/press/bank/' + page + '/' + button,
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        };
        var res = http.get(bitCompanionOptions, (res) => {
            console.log(`Status ${res.statusCode}`);
        });
        resolve(res);
    });
}

/** Every Time we press the auto button, keep track of A/B frame */
let liveFrame = "A"
let previewFrame = "B"
let onAir = OFF
function pressAuto(){
    return new Promise(async function (resolve, reject) {
        if (liveFrame == "A") {
            liveFrame = "B"
            previewFrame = "A"
        } else {
            liveFrame = "A"
            previewFrame = "B"
        }
        // Press Auto
        await pressBitCompanionButton(1, 2);
        if (pnpOn[liveFrame] != onAir) {
            onAir = pnpOn[liveFrame]
            // Press Key 1 "OnAir"
            await pressBitCompanionButton(1, 26);
        }
        resolve();
    });
}

/** Set the pnp status based on A/B frame
 * only pressing the button if the previous state is not what was requested */
let pnpOn = {"A": OFF, "B": OFF}
function setPnp(status) {
    return new Promise(async function (resolve, reject) {
        if (pnpOn[previewFrame] != status) {
            pnpOn[previewFrame] = status
            // Press PNP Overlay
            await pressBitCompanionButton(1, 11);
        }
        resolve();
    });
}

function sleep(ms) {
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
}

let setSessionTags = [];

// Assuming tag will always exist in post data
app.post('/slide', async function (req, res) {
    console.log(req.body);
    if (req.body.tag === undefined) {
        console.log("'tag' not found in post body");
        return;
    }

    // Doing this so we don't trigger the same tag twice in a given "service" since there is state involved here
    if (req.body.tag == "[Start]") {
        setSessionTags = [];
    } else if (setSessionTags.includes(req.body.tag)) {
        //res.send('');
        //return;
    } else if (req.body.tag.includes("Special")) {
        //Do nothing
    } else {
        setSessionTags.push(req.body.tag);
    }
    res.json(req.body);

    switch(req.body.tag)
    {
        case "[Start]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();
            break;
        case "[Begin Program]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "worship_center"}, "main");
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "wide"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();
            // Press welcome to Christ Pewaukee
            await pressBitCompanionButton(2, 2);
            // turn on overlay
            await pressBitCompanionButton(2, 8);
            // Wait 60 Seconds
            await sleep(ONE_MINUTE_IN_MS);
            // Turn off overlay
            await pressBitCompanionButton(2, 8);
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();
            break;
        case "[Worship Hymn]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();
            break;
        case "[Baptism]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "baptism"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await pressAuto();
            break;
        case "[Call To Worship]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "worship_center_pnp"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(ON);
            await pressAuto();
            break;
        case "[Old Testament]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "pulpit_center_pnp"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(ON);
            await pressAuto();
            break;
        case "[Old Testament Warnecke]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "worship_center_pnp"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(ON);
            await pressAuto();
            break;
        case "[Sermon Hymn]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();
            break;
        case "[Sermon Text]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "sermon_center_pnp"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(ON);
            await pressAuto();
            break;
        case "[Sermon Text Krause]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "pulpit_center_pnp"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(ON);
            await pressAuto();
            break;
        case "[Sermon Theme]":
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "sermon_center"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();

            // Wait 5 minutes
            await sleep(FIVE_MINUTES_IN_MS);

            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "sermon_center"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();

            // Wait 5 minutes
            await sleep(FIVE_MINUTES_IN_MS);

            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "sermon_center"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();

            break;
        case "[Pulpit]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "pulpit_center"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await pressAuto();
            break;
		case "[Creed]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "pulpit_center_pnp"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(ON);
            await pressAuto();
            break;
        case "[Prayer]":
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "altar_center"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();
            break;
        case "[Lords Prayer]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();
            break;
        case "[Institution]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "altar_center"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();
            break;
        case "[Distribution]":
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "wide"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();

            // Press CELC
            await pressBitCompanionButton(2, 3);
            // turn on overlay
            await pressBitCompanionButton(2, 8);
            // Wait 15 Seconds
            await sleep(FIFTEEN_SECONDS_IN_MS);
            // Press Private communion
            await pressBitCompanionButton(2, 18);
            await sleep(FIFTEEN_SECONDS_IN_MS);
            // Press Online Offering
            await pressBitCompanionButton(2, 19);
            await sleep(FIFTEEN_SECONDS_IN_MS);
            // Press Contact us
            await pressBitCompanionButton(2, 4);
            await sleep(FIFTEEN_SECONDS_IN_MS);
            // Press Private communion
            await pressBitCompanionButton(2, 18);
            await sleep(FIFTEEN_SECONDS_IN_MS);
            // Press Online Offering
            await pressBitCompanionButton(2, 19);
            await sleep(FIFTEEN_SECONDS_IN_MS);
            // Press Contact us
            await pressBitCompanionButton(2, 4);
            await sleep(FIFTEEN_SECONDS_IN_MS);

            // Turn off overlay
            await pressBitCompanionButton(2, 8);
            break;
        case "[End of Distribution]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "altar_center_pnp"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(ON);
            await pressAuto();
            break;
        case "[Closing Hymn]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();
            break;
        case "[Silent prayer]":
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "wide"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();
            break;
        case "[Announcements]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "worship_center"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();
            break;
        case "[After Service Video]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();
            break;
        case "[Thank You For Worshiping]":
        case "[Thank You For Worshipping]":
            // Wait 10 Seconds
            await sleep(TEN_SECONDS_IN_MS);
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "wide"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            await setPnp(OFF);
            await pressAuto();
            // Wait 15 Seconds
            await sleep(FIFTEEN_SECONDS_IN_MS);
            // Press Copyright
            await pressBitCompanionButton(2, 21);
            // turn on overlay
            await pressBitCompanionButton(2, 8);
            // Wait 15 Seconds
            await sleep(FIFTEEN_SECONDS_IN_MS);
            // Turn off overlay
            await pressBitCompanionButton(2, 8);
            // Stop Stream
            await pressBitCompanionButton(1, 16);
            break;
        case "[Sanctuary Special]":
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "wide"}, "alt");
            await setPnp(OFF);
            await pressAuto();
            // Camera 6
            await pressBitCompanionButton(1, 4);
            await pressAuto();
            break;
        case "[Hymn Special]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            await setPnp(OFF);
            await pressAuto();
            break;
        default:
            console.log("Don't know this tag");
    }
})

async function startOnLaunch() {
    // Camera 7
    await pressBitCompanionButton(1, 5);
    // Wait 1 second
    await sleep(ONE_SECOND_IN_MS);
    await setPnp(OFF);
    await pressAuto();
    // Camera 7
    await pressBitCompanionButton(1, 5);
    // Wait 1 second
    await sleep(ONE_SECOND_IN_MS);
    await setPnp(OFF);
    await pressAuto();
}

startOnLaunch();
app.listen(port, () => {});
