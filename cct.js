var express = require('express');
const db = require("monk")("britannia:britannia@server:8550/britannia");
const usersdb = db.get('users');

var router = express.Router();

router.post("/verify", async(req, res) => {
    try {
        let data = JSON.parse(Object.keys(req.body)[0]);
        console.log(data);
        let user = await usersdb.findOne({ regKey: parseInt(data.Key) })
        console.log(user)
        if (user) {
            let seskey = parseInt(data.Key) * parseInt(data.ComputerID);
            //seskey = seskey.toString(16);
            console.log(typeof parseInt(user.regKey));
            console.log(typeof parseInt(user.ComputerID));
            await usersdb.update({ _id: user._id }, { $set: { sessionKey: seskey } })
            console.log(await usersdb.findOne({ _id: user._id }))
            res.send("true");
        } else
            res.send("false")
    } catch (error){
        console.log(error)
        res.send("false")

    }
});

router.post("/cords", async(req, res) => {
    try {
        let data = JSON.parse(Object.keys(req.body)[0]);
        console.log(data);
        console.log(parseInt(data.SessionKey));
        let user = await usersdb.findOne({ sessionKey: parseInt(data.SessionKey) });
        console.log(user);
        if (user) {
            await usersdb.update({ _id: user._id }, { $set: { x: data.x, y: data.y, z: data.z } })
            console.log(await usersdb.findOne({ _id: user._id }))
            res.send("true");
        } else
            res.send("false")
    } catch {

    }
});

router.get("/info/:sk", async(req, res) => {
    try {
        const { sk } = req.params;
        let user = await usersdb.findOne({ sessionKey: parseInt(sk)});
        console.log(user);
        if (user) {
            res.send(JSON.stringify({ username: user.username, rank: user.rank, money: user.money }))
        } else
            res.send(JSON.stringify({err:"USER DOESNT EXIST!"}))
    } catch {
        res.send(JSON.stringify({err:"ERROR"}))
    }
});
module.exports = router;