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
            hostname: "127.0.0.1",
            port: "8888",
            path: "/press/bank/" + page + "/" + button,
            method: "GET"
        };
        http.request(bitCompanionOptions, res => {
            resolve(console.log(res));
        });
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
    //res.json(req.body);

    // Doing this so we don't trigger the same tag twice in a given "service" since there is state involved here
    if (req.body.tag == "[Start]") {
        setSessionTags = [];
    } else if (setSessionTags.includes(req.body.tag)) {
        res.send('');
        return;
    } else {
        setSessionTags.push(req.body.tag);
    }

    switch(req.body.tag)
    {
        case "[Worship Hymn]":
            // Camera 7
            await pressBitCompanionButton(1, 5);

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

            // Press Toggle A
            //await pressBitCompanionButton(1, 30);
            // Press Toggle B
            //await pressBitCompanionButton(1, 31);

            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Old Testment]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "pulpit_center_pnp"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Press PNP Overlay
            await pressBitCompanionButton(1, 11);

            // Press Toggle A
            //await pressBitCompanionButton(1, 30);
            // Press Toggle B
            //await pressBitCompanionButton(1, 31);

            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Sermon Hymn]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Press Mac Overlay
            await pressBitCompanionButton(1, 10);

            // Press Toggle A
            //await pressBitCompanionButton(1, 30);
            // Press Toggle B
            //await pressBitCompanionButton(1, 31);

            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Sermon Text]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "sermon_center_pnp"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Press PNP Overlay
            await pressBitCompanionButton(1, 11);
            // Press Toggle A
            //await pressBitCompanionButton(1, 30);
            // Press Toggle B
            //await pressBitCompanionButton(1, 31);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Sermon Theme]":
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "sermon_center"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Press Toggle A
            //await pressBitCompanionButton(1, 30);
            // Press Toggle B
            //await pressBitCompanionButton(1, 31);
            // Press Auto
            await pressBitCompanionButton(1, 2);

            // Wait 5 minutes
            await sleep(FIVE_MINUTES_IN_MS);

            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "sermon_center"}, "main");
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Press Toggle A
            //await pressBitCompanionButton(1, 30);
            // Press Toggle B
            //await pressBitCompanionButton(1, 31);
            // Press Auto
            await pressBitCompanionButton(1, 2);

            // Wait 5 minutes
            await sleep(FIVE_MINUTES_IN_MS);

            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "sermon_center"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
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
            // Press Toggle A
            //await pressBitCompanionButton(1, 30);
            // Press Toggle B
            //await pressBitCompanionButton(1, 31);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Prayer]":
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "altar_center"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Lords Prayer]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Press Mac Overlay
            await pressBitCompanionButton(1, 10);

            // Press Toggle A
            //await pressBitCompanionButton(1, 30);
            // Press Toggle B
            //await pressBitCompanionButton(1, 31);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Institution]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "altar_center"}, "main");
            // Press Mac Overlay
            await pressBitCompanionButton(1, 10);

            // Press Toggle A
            //await pressBitCompanionButton(1, 30);
            // Press Toggle B
            //await pressBitCompanionButton(1, 31);
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Distribution]":
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "wide"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[End of Distribution]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "altar_center_pnp"}, "main");
            // Press PNP Overlay
            await pressBitCompanionButton(1, 11);
            // Press Toggle A
            //await pressBitCompanionButton(1, 30);
            // Press Toggle B
            //await pressBitCompanionButton(1, 31);
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Closing Hymn]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Press Mac Overlay
            await pressBitCompanionButton(1, 10);

            // Press Toggle A
            //await pressBitCompanionButton(1, 30);
            // Press Toggle B
            //await pressBitCompanionButton(1, 31);
            
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Silent prayer]":
            // Point Camera 6
            camera.send_commands(ptzData, {"preset": "wide"}, "alt");
            // Camera 6
            await pressBitCompanionButton(1, 4);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[Announcements]":
            // Point Camera 5
            camera.send_commands(ptzData, {"preset": "worship_center"}, "main");
            // Press PNP Overlay
            await pressBitCompanionButton(1, 11);
            // Press Toggle A
            //await pressBitCompanionButton(1, 30);
            // Press Toggle B
            //await pressBitCompanionButton(1, 31);
            // Camera 5
            await pressBitCompanionButton(1, 3);
            // Press Auto
            await pressBitCompanionButton(1, 2);
            break;
        case "[After Service Video]":
            // Camera 7
            await pressBitCompanionButton(1, 5);
            // Press Mac Overlay
            await pressBitCompanionButton(1, 10);

            // Press Toggle A
            //await pressBitCompanionButton(1, 30);
            // Press Toggle B
            //await pressBitCompanionButton(1, 31);

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
            // Press Auto
            await pressBitCompanionButton(1, 2);
            // Wait 15 Seconds
            await sleep(FIFTEEN_SECONDS_IN_MS);
            // TODO Copyright
            // Wait 15 Seconds
            await sleep(FIFTEEN_SECONDS_IN_MS);
            // TODO Stop Stream
            break;
        default:
            console.log("Don't know this tag");
    }
    res.send('');
})

app.listen(port, () => {});
