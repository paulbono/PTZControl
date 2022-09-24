const express = require('express')
const app = express()
app.use(express.json())
const port = 3000

app.post('/slid', (req, res) => {
	console.log(req.body);
	res.json(req.body);
})

app.listen(port, () => {})
