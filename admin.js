var express = require('express');
const db = require("monk")("britannia:britannia@server:8550/britannia");
const usersdb = db.get('users');

var router = express.Router();

router.get("/cords", async(req, res) => {
    let result = { players: [] }
    let users = await usersdb.find({});
    for (let i = 0; i < users.length; i++) {
        if (users[i].x) {
            result.players.push({ username: users[i].username, x: users[i].x, y: users[i].y, z: users[i].z })
        }
    }
    console.log(result)
    res.json(result)
});
router.get("/cords/:username", async(req, res) => {
    let {username} = req.params;
    let user = await usersdb.findOne({username:username});
    if(!user){
        res.json({suc:"ERROR"})
        return
    }
    if (user.x) {
        res.json({ username: user.username, x: user.x, y: user.y, z: user.z })
    }
});

module.exports = router;