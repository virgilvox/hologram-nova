var HologramNova = require("../index.js");
var nova = new HologramNova({});

nova.sendCommand("AT+CGMI", 25, null, null, function(res, err){
  console.log(res, err);
});
