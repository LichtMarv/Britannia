var express = require('express');
const db = require("monk")("britannia:britannia@purplepenguin.ddns.net:8550/britannia");
const usersdb = db.get('users');
var path = require('path');

var router = express.Router();

router.get("/", async (req,res) => {
    try {
        let token = req.cookies.token;
        let user = await usersdb.findOne({ token: parseInt(token) })
        console.log(user)
        if (user) {
            res.sendFile(path.join(__dirname + '/private/account.html'));
        } else {
            res.redirect("../login")
        }

    } catch (error) {
        res.send("TEST")
        console.error(error)
    }
})

router.get("/reg", async (req, res) => {
    let token = req.cookies.token;
    let user = await usersdb.findOne({ token: parseInt(token) })
    let key = Math.round(Math.random() * 899999999 + 100000000)
    if(user) {
        await usersdb.update({ _id: user._id }, { $set: { regKey: key } });
        res.json({ key: key })
    }else{
        res.cookie("page","login")
        res.redirect(req.originalUrl)
    }
})

router.get("/key", async (req, res) => {
    let token = req.cookies.token;
    let user = await usersdb.findOne({ token: parseInt(token) })
    res.json({ key: user.regKey })
})

router.post("/changePwd", async (req, res) => {
    console.log("change PWD")
    try {
        let token = req.cookies.token;
        let user = await usersdb.findOne({ token: parseInt(token) })
        if (user.password == req.body.old) {
            console.log("CHANGING PASSWORD ...")
            await usersdb.update({ _id: user._id }, { $set: { password: req.body.new } })
            res.json({ suc: "true" })
        }
        else {
            console.log("WORNG PASSWORD ...")
            res.json({ suc: "false" })
        }
    } catch {
        res.json({ suc: "false" })
    }
})

router.post("/add", async (req, res) => {
    try {
        let body = req.body
        let user = await usersdb.findOne({ username: body.username})
        if (user.password == body.password) {
            await usersdb.insert({ username: body.nusername,password: body.npassword, money: 0, token:0 })
            res.json({ suc: "true" })
        }
        else {
            console.log("WORNG PASSWORD ...")
            res.json({ suc: "false" })
        }
    } catch (error){
        res.json({ suc: "false" })
        console.log(error)
    }
})

module.exports = router;