const express = require('express');
const bodyParser = require('body-parser');
const port = process.env.PORT || 1337;
const app = express();
const routes = require('./routes.js');
const version = 'v1';
console.log(`Using /api/${version}`);

app.use(bodyParser.json());
app.use(`/api/${version}/drugs`, routes);

app.get("/", function(req, res){
    res.send(true);
});

app.listen(port, () => console.log(`Listening on port ${port}`));
