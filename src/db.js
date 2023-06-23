var mysql = require('mysql');

class Database{
    constructor(){
        this.objConn = mysql.createConnection({
            host : "localhost",
            user : "root",
            password : "",
            database : "clients"
        });

        this.objConn.connect((objError)=>{
            if(objError){
                throw objError;
            }else{
                console.log('database connected');
            }
        });
    }

    executeQuery(strSql, arrParams){
        return new Promise((resolve, reject)=>{
            this.objConn.query(strSql, arrParams, (objError, objResult)=>{
                if(objError){
                    reject(objError);
                }else{
                    resolve(objResult); 
                }
            });
        });
    }
}


module.exports = new Database();