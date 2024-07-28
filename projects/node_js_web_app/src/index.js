const express = require('express');

const app = express();

app.get('/', (req, res) => {
    res.send('Hi! Welcome to my Node JS app');
});

app.listen(8080, () => {
    console.log('Listening on port 80')
})