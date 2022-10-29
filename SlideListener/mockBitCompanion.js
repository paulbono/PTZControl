const express = require('express');
const app = express();
app.use(express.json());
const port = 8888;

app.get('/press/bank/:page/:button', function(req, res) {
    console.log(`Pressing Page ${req.params.page} Button ${req.params.button}`)
    return true;
});


app.listen(port, () => {});
