var HologramNova = require("../index.js");
var nova = new HologramNova({});

nova.sendCommand("AT+CPIN?\r\n", 25, null, null, function(res, err){
  if(err){
    throw(err)
  }
  console.log(res, err);
  nova.sendCommand("AT+CGMI\r\n", 25, null, null, function(res, err){
    if(err){
      throw(err)
    }
    console.log(res, err);
  });
});
