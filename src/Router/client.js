const express = require('express');

const router = express.Router();

router.get('/web-card-promo', (objReq, ojbRes)=>{
    ojbRes.sendFile(__dirname + '/client.html');
});

module.exports = router;