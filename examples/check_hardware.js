var HologramNova = require("../index.js");
var nova = new HologramNova({});

nova.sendCommand("AT+CPIN?\r\n", 25, null, null, function(res, err){
  if(err){
    throw(err)
  }
  console.log(res, err);
  nova.sendCommand("AT+CMGF=1\r\n", 10, null, null, function(res, err){
    if(err){
      throw(err)
    }
    console.log(res, err);
  });
});
