os.loadAPI("json")
local response = http.get("http://purplepenguin.ddns.net:8500/cct/info/18619880070/")
local content = response.readAll()
local ResopnseJSON = json.decode(content)