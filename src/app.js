const express = require('express');
const app = express();
const path = require('path');
const fs = require('fs');
const bodyParser = require('body-parser');
const objMainRouter = require('./Router/main.js');
const objClientRouter = require('./Router/client.js');
const objDb = require('./db.js');
const objHashing = require('./bcrypt.js');




app.use(bodyParser.json());
app.use('/main', objMainRouter);
app.use('/client', objClientRouter);
app.get('/:business_name', (objReq, objRes) => {
    let strClientName = objReq.params.business_name;
    let strPath = path.join(__dirname, '../', strClientName, strClientName + '.html');

    if (!fs.existsSync(strPath)) {
        let strErrorPath = path.join(__dirname, '../errors/404_not_found.html');
        objRes.sendFile(strErrorPath);
    } else {
        objRes.sendFile(strPath);
    }
});

app.get('/admin/client-details', async (objReq, objRes) => {
    let strSql = `CALL sp_client_signup(?, ?, ?, ?);`;
    let arrParams = ['rajesh', 'rajesh@example.com', '7894561231', 'passowrd_test_1'];
    let objResult = await objDb.executeQuery(strSql, arrParams);
    objRes.json(objResult[0][0].message);
});


app.post('/signup', async (objReq, objRes) => {
    try {
        let objHash = await objHashing.getHashedPassword(objReq.body.password);
        if (objHash.code == 1) {
            let strSql = `CALL sp_client_signup(?, ?, ?, ?);`;
            let arrParams = [objReq.body.name, objReq.body.email, objReq.body.phone, objHash.data];
            let objResult = await objDb.executeQuery(strSql, arrParams);
            objRes.json(objResult[0][0].message);
        } else {
            let objError = {
                code: -1,
                description: 'There is some error in signup please try again'
            }
            objRes.json(objError);
        }
    } catch (objError) {
        console.log(objError)
    }

});

app.post('/login', async (objReq, objRes) => {
    try {
        let objResponse;
        let strSql = `CALL sp_client_signin(?);`;
        let arrParams = [objReq.body.phone];
        let objResult = await objDb.executeQuery(strSql, arrParams);
        objResponse = objResult[0][0];
        if (objResponse.code != 1) {
            objRes.json(objResponse);
        } else {
            let objComparePass = await objHashing.compareHash(objResponse.data, objReq.body.password);
            objRes.json(objComparePass);
        }
    } catch (objError) {
        objRes.json(objError)
    }
});

// app.post('/test',  (objReq, objRes) => {
//     // Read the CSS file
//   const css = fs.readFileSync(path.resolve(__dirname, '/businessWebsite.css'), 'utf8');

//   // Render the React component to HTML
//   const html = ReactDOMServer.renderToString('<App />');

//   // Combine the CSS and HTML
//   const fullHtml = `<html><head><style>${css}</style></head><body>${html}</body></html>`;

//   // Send the HTML as the response
//   res.send(fullHtml);
// });

app.get('/temp', (objReq, objRes)=>{

})

app.listen(process.env.PORT | 9000, () => {
    console.log('server started');
});