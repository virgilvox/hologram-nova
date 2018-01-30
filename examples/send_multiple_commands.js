var HologramNova = require("../index.js");
var nova = new HologramNova({});

var commands = [
  ["AT+CPIN?\r\n", 25, "OK", null],
  ["AT+CGMI\r\n", 25, "OK", null],
]

nova.sendCommands( commands, function(err, res){
  if(err){
    throw(err)
  }
  console.log(res);
});
