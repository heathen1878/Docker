const express = require('express');

const app = express();

app.get('/', (req, res) => {
    res.send('Hi! This web app has been updated');
});

app.listen(8080, () => {
    console.log('Listening on port 80')
})