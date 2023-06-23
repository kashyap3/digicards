const express = require('express');

const router = express.Router();


router.get('/admin', (ojbReq, ojbRes)=>{
    ojbRes.send('hello there from route');
});

module.exports = router;