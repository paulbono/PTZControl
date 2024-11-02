const express = require('express');
const app = express();
const port = 3001;

app.use(express.json());

app.post('/slide', (req, res) => {
    console.log('Received relay from Python:', req.body);
    res.status(200).send('Node.js received the data');
});

app.listen(port, '0.0.0.0', () => {
    console.log(`Node.js server listening on port ${port}`);
});

