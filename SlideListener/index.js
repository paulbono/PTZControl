const express = require('express')
const app = express()
app.use(express.json())
const port = 3000

app.post('/slid', (req, res) => {
	res.json(req.body);
	console.log(req.body);
})

app.listen(port, () => {})
