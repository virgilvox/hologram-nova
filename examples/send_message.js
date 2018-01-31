var HologramNova = require("../index.js");
var nova = new HologramNova({"key": "@wqV7T&y"});

nova.connect(function(err){
  if(err){
    throw(err)
  }
  nova.sendMessage( "Launch ze missiles!", function(err){
    if(err){
      throw(err)
    }
    console.log("Success");
  });
});
