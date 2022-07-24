// index.jsconst express = require('express');
var express = require('express');
const app = express();
app.get('/', (req, res) => {
    res.send('Hello World!')
  })
app.listen(5000, () => console.log('Server is up and running'));