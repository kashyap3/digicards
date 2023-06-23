var bcrypt = require('bcrypt');

class Hashing{
    getHashedPassword(strPlainTxt){
        return new Promise((resolve, reject)=>{
            bcrypt.hash(strPlainTxt, parseInt('web.10.cardz'), (objError, strHash)=>{
                if(objError){
                    const objReject = {
                        code: -1,
                        description : objError
                    }
                    reject(objReject);
                }else{
                    const objResolve =  {
                        code : 1,
                        data : strHash
                    }
                    resolve(objResolve)
                }
            });
        });
    }

    compareHash(strStroredHash, strClientPassword){
        return new Promise ((resolve, reject)=>{
            bcrypt.compare(strClientPassword, strStroredHash, (objError, objResult)=>{
                if(objError){
                    const objReject = {
                        code : -1,
                        description : 'error while comparing password'
                    }
                    reject(objReject);
                }else if(objResult === true){
                    const objResolve = {
                        code : 1,
                        description : 'password match'
                    }
                    resolve(objResolve);
                }else{
                    const objRejct = {
                        code : 0,
                        description : 'Invalid password'
                    }
                    reject(objRejct);
                }
            });
        });
    }
}

module.exports = new Hashing();
