var express = require('express');
const cookieParser = require('cookie-parser');
const db = require("monk")("britannia:britannia@purplepenguin.ddns.net:8550/britannia");
const usersdb = db.get('users');
var app = express();
var cct = require("./cct");
var admin = require("./admin");
var api = require("./api");
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
        console.log("getting users with token : " + token)
        let user = await usersdb.findOne({ token: parseInt(token) })
        console.log(user)
        if (user) {
            res.sendFile(path.join(__dirname + '/private/index.html'));
        } else {
            res.redirect("/login")
        }

    } catch (error) {
        console.error(error)
    }

    //res.sendFile(path.join(__dirname + '/private / login.html '));
});

app.get('/login', function(req, res) {
    res.sendFile(path.join(__dirname + '/private/login.html'));
});

app.post('/login', async(req, res) => {
    console.log(req.body);
    try {
        var userdata = await usersdb.findOne({ username: req.body.username });
        if (userdata.password == req.body.password) {
            userdata["token"] = Math.round(Math.random() * 89999 + 10000)
            console.log(userdata)
            await usersdb.update({ _id: userdata._id }, { $set: {token:userdata.token} })
            res.cookie("token", userdata["token"], { httpOnly: true/*, domain: "purplepenguin.ddns.net:8600"*/ })
            console.log("user data correct");
            res.redirect("../")
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

app.get('/logout', function(req, res) {
    res.cookie("token", 0, { httpOnly: true/*, domain: "purplepenguin.ddns.net:8600"*/ })
    res.redirect("login")
});

app.use("/cct", cct)
app.use("/admin", admin)
app.use("/account", account)
app.use("/api", api)

app.listen(8600);
