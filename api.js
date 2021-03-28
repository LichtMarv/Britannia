var express = require('express');
const db = require("monk")("britannia:britannia@server:8550/britannia");
const usersdb = db.get('users');
const itemsdb = db.get('items');

var router = express.Router();

router.get("/user", async(req, res) => {
    try {
        let user = await usersdb.findOne({ token: parseInt(req.cookies.token) });
        if (user.uuid)
            res.json({ username: user.username, id: user._id, playeruuid: user.uuid });
        else {
            fetch("https://api.mojang.com/users/profiles/minecraft/" + user.username)
            .then(response => response.json())
            .then(async function(data) {
                await usersdb.update({ _id: user._id }, { $set: { uuid: data.id } });
                res.json({ username: user.username, id: user._id, playeruuid: data.id })
            });
            

        }
    } catch (error){
        console.error(error)

    }
});

router.get("/items", async(req, res) => {
    let items = await usersdb.find({});
});

router.get("/fix", async(req, res) => {
    try {
        let users = await usersdb.find({});
        console.log(users)
        users.forEach(user => {
            console.log(user.username)
            if(user.username == null) {
                usersdb.remove({_id:user._id})
            }
            if(user.rank == null) {
                usersdb.update({_id:user._id},{ $set: { rank: "user" } })
            }
            if(user.token == null) {
                usersdb.update({_id:user._id},{ $set: { token: 0 } })
            }
            if(user.money == null) {
                usersdb.update({_id:user._id},{ $set: { money: 0 } })
            }
        });
        users = await usersdb.find({});
        console.log(users)
        res.json(users)
    } catch (error){
        console.error(error)

    }
});

router.put("/edit/:id", async(req, res) => {
    try {
        const { id } = req.params;
        const user = await usersdb.findOne({ _id: id });
        if (user) {
            const inserted = await usersdb.update({ _id: id }, { $set: req.body });
            console.log("updated user !")
            res.json(inserted)
        }
    } catch (error){
        console.log(error)
        res.json({ "error": "WRONG ID OR SOMETHING" })

    }
    res.send()
});

router.get("/uuid", async(req, res) => {
    try {
        let user = await usersdb.findOne({ token: parseInt(req.cookies.token) });
        if (user.uuid)
            res.json({ username: user.username, id: user._id, playeruuid: user.uuid });
        else {
            fetch("https://api.mojang.com/users/profiles/minecraft/" + user.username)
            .then(response => response.json())
            .then(async function(data) {
                await usersdb.update({ _id: user._id }, { $set: { uuid: data.id } });
                res.json({ username: user.username, id: user._id, playeruuid: data.id })
            });
            

        }
    } catch (error){
        console.error(error)

    }
});

module.exports = router;