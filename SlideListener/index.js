// Needed to read a file
const fs = require('fs');
const http = require('http');
const express = require('express');
const camera = require('../ptz_cameras.js');
const app = express();
app.use(express.json());
const port = 3000;

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

const ONE_SECOND_IN_MS = 1000;
const TEN_SECONDS_IN_MS = 10000;
const FIFTEEN_SECONDS_IN_MS = 15000;
const FIVE_MINUTES_IN_MS = 300000;


function sleep(ms) {
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
}

let setSessionTags = [];

// Assuming tag will always exist in post data
app.post('/slide', async function (req, res) {
    console.log(req.body);

    // Doing this so we don't trigger the same tag twice in a given "service" since there is state involved here
    if (req.body.tag == "[Start]") {
        setSessionTags = [];
    } else if (setSessionTags.includes(req.body.tag)) {
        res.send('');
        return;
    } else {
        setSessionTags.push(req.body.tag);
    }
    res.json(req.body);

    switch(req.body.tag)
    {
        case "[Start]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "worship_center_pnp"}, "main");
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "wide"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Worship Hymn]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Call To Worship]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "worship_center_pnp"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Press PNP Overlay
            await pressBitCompanionButton(1, 11);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            // Turn on Key 1 "OnAir"
            await pressBitCompanionButton(1, 26);
            break;
        case "[Old Testament]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "worship_center_pnp"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Press PNP Overlay
            await pressBitCompanionButton(1, 11);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            // Turn on Key 1 "OnAir"
            //await pressBitCompanionButton(1, 26);
            break;
        case "[Sermon Hymn]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Press Mac Overlay
            //await pressBitCompanionButton(1, 10);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            // Turn off Key 1 "OnAir"
            await pressBitCompanionButton(1, 26);
            break;
        case "[Sermon Text]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "sermon_center_pnp"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Press PNP Overlay
            await pressBitCompanionButton(1, 11);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            // Turn on Key 1 "OnAir"
            await pressBitCompanionButton(1, 26);
            break;
        case "[Sermon Theme]":
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "sermon_center"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            // Turn off Key 1 "OnAir"
            await pressBitCompanionButton(1, 26);

            // Wait 5 minutes
            await sleep(FIVE_MINUTES_IN_MS);

            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "sermon_center"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);

            // Wait 5 minutes
            await sleep(FIVE_MINUTES_IN_MS);

            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "sermon_center"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);

            break;
        case "[Creed]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "pulpit_center_pnp"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Press PNP Overlay
            await pressBitCompanionButton(1, 11);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            // Turn on Key 1 "OnAir"
            await pressBitCompanionButton(1, 26);
            break;
        case "[Prayer]":
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "altar_center"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            // Turn off Key 1 "OnAir"
            await pressBitCompanionButton(1, 26);
            break;
        case "[Lords Prayer]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Press Mac Overlay
            //await pressBitCompanionButton(1, 10);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Institution]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "altar_center"}, "main");
            // Press Mac Overlay
            //await pressBitCompanionButton(1, 10);
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Distribution]":
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "wide"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);

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
            // Press PNP Overlay
            await pressBitCompanionButton(1, 11);
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            // Turn on Key 1 "OnAir"
            await pressBitCompanionButton(1, 26);
            break;
        case "[Closing Hymn]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Press Mac Overlay
            //await pressBitCompanionButton(1, 10);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            // Turn off Key 1 "OnAir"
            await pressBitCompanionButton(1, 26);
            break;
        case "[Silent prayer]":
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "wide"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Announcements]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "worship_center"}, "main");
            // Press PNP Overlay
            await pressBitCompanionButton(1, 11);
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[After Service Video]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Press Mac Overlay
            //await pressBitCompanionButton(1, 10);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Thank You For Worshiping]":
            // Wait 10 Seconds
            await sleep(TEN_SECONDS_IN_MS);
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "wide"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Wait 1 second
            await sleep(ONE_SECOND_IN_MS);
            // Press Auto
            await pressBitCompanionButton(1, 2);
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
            // TODO Stop Stream
            break;
        default:
            console.log("Don't know this tag");
    }
})

app.listen(port, () => {});
