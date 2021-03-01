var express = require('express');
const cookieParser = require('cookie-parser');
const db = require("monk")("britannia:britannia@server:8550/britannia");
const usersdb = db.get('users');
var app = express();
var cct = require("./cct");
var admin = require("./admin");
var account = require("./account");
var path = require('path');
const fetch = require('node-fetch');
const { response } = require('express');


// Parse cookies
app.use(cookieParser());

app.use(express.static('res'));
// viewed at http://localhost:8080

// Parse URL-encoded bodies (as sent by HTML forms)
app.use(express.urlencoded());

// Parse JSON bodies (as sent by API clients)
app.use(express.json());

db.then(() => {
    console.log('Connected correctly to server');
})

app.get('/', async(req, res) => {
    try {
        let token = req.cookies.token;
        let page = req.cookies.page;
        console.log("getting users with token : " + token)
        let user = await usersdb.findOne({ token: parseInt(token) })
        if (!token) {
            res.sendFile(path.join(__dirname + '/private/login.html'));
        }
        if (!user) {
            console.log("no user with token !")
        } else {
            if (page == "main")
                res.sendFile(path.join(__dirname + '/private/index.html'));
            else if (page == "admin" && user.rank == "admin")
                res.sendFile(path.join(__dirname + '/private/admin.html'));
            else if (page == "account")
                res.sendFile(path.join(__dirname + '/private/account.html'));
            else
                res.sendFile(path.join(__dirname + '/private/index.html'));

        }

    } catch (error) {
        console.error(error)
    }

    //res.sendFile(path.join(__dirname + '/private / login.html '));
});

app.get('/page/:pg', async(req, res) => {
    let token = req.cookies.token;
    let user = await usersdb.findOne({ token: parseInt(token) })
    let {pg} = req.params;
    console.log(pg)
    let ck = ""
    if (pg == "main")
        ck = "main"
    else if (pg == "admin" && user.rank == "admin")
        ck = "admin"
    else if (pg == "account")
        ck = "account"

    res.cookie("page", ck, { httpOnly: true })
    res.send()
});

// app.get('/login', function(req, res) {
//     res.sendFile(path.join(__dirname + '/res/login.html'));
// });

app.post('/login', async(req, res) => {
    console.log(req.body);
    try {
        var userdata = await usersdb.findOne({ username: req.body.username });
        if (userdata.password == req.body.password) {
            userdata["token"] = Math.round(Math.random() * 89999 + 10000)
            console.log(userdata)
            await usersdb.update({ _id: userdata._id }, { $set: userdata })
            res.cookie("token", userdata["token"], { httpOnly: true })
            console.log("user data correct");
            res.json({ auth: true, token: userdata["token"] });
            //res.sendFile(path.join(__dirname + '/private/index.html'));
        } else {
            res.json({ auth: false, error: "LOGIN DATA WRONG" });
            //res.status(300)
            //res.sendFile(path.join(__dirname + '/private/login.html'));
        }
    } catch (err) {
        res.json({ auth: false, error: "LOGIN DATA WRONG" });
        console.error(err)
        console.log("ERROR !!");
        //res.sendFile(path.join(__dirname + '/private/index.html'));
    }
    //res.sendFile(path.join(__dirname + '/res/login.html'));
});

app.get("/user", async(req, res) => {
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

app.put("/user/:id", async(req, res) => {
    try {
        const { id } = req.params;
        const user = await usersdb.findOne({ _id: id });
        if (user) {
            const inserted = await usersdb.update({ _id: id }, { $set: req.body });
            res.json(inserted)
        }
    } catch {
        res.json({ "error": "WRON ID OR SOMETHING" })

    }
    res.send()
});

app.use("/cct", cct)
app.use("/admin", admin)
app.use("/account", account)

app.listen(8500);