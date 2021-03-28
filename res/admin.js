let table = document.getElementById("playertable");
let inp = document.getElementById("autocomplete-input");

function clearuser() {
    table.innerHTML = ""
}

function adduser(uname, ux, uy, uz) {
    let wrapper = document.createElement("tr");
    let user = document.createElement("td");
    user.appendChild(document.createTextNode(uname))
    let x = document.createElement("td");
    x.appendChild(document.createTextNode(ux))
    let y = document.createElement("td");
    y.appendChild(document.createTextNode(uy))
    let z = document.createElement("td");
    z.appendChild(document.createTextNode(uz))

    wrapper.appendChild(user);
    wrapper.appendChild(x);
    wrapper.appendChild(y);
    wrapper.appendChild(z);
    table.appendChild(wrapper);
}

function checkuser() {
    if(inp.value) {
        clearuser()
        fetch("admin/cords/"+inp.value)
        .then(response => response.json())
        .then(function(data) {
            if(data.suc)
                return
            adduser(data.username,data.x,data.y,data.z)
        })
    }
    else {
        clearuser()
        fetch("admin/cords")
        .then(response => response.json())
        .then(function(data) {
            data.players.forEach(element => {
                adduser(element.username,element.x,element.y,element.z)
            });
        })
    }
}

document.getElementById("getbutton").addEventListener("click", () => {
    checkuser()
});
checkuser()