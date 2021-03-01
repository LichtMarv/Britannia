var express = require('express');
const db = require("monk")("britannia:britannia@server:8550/britannia");
const usersdb = db.get('users');

var router = express.Router();

router.get("/reg", async (req, res) => {
    let token = req.cookies.token;
    let user = await usersdb.findOne({ token: parseInt(token) })
    let key = Math.round(Math.random() * 899999999 + 100000000)
    await usersdb.update({ _id: user._id }, { $set: { regKey: key } });
    res.json({ key: key })
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

module.exports = router;