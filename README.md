# hologram-nova

WARNING: All that works is sending commands so far. My AT commands aren't working for connect or sendMessage. If anyone wants to help please PR.

```
Args: cmd, wait, success, fail
Success defaults to "OK"
Fail defaults to "ERROR"
```

### Send single command

```js
var HologramNova = require("hologram-nova");
var nova = new HologramNova({});

nova.sendCommand("AT+CGMI\r\n", 25, null, null, function(err, res){
  console.log(res);
});
```

### Send multiple commands

```js
var HologramNova = require("../index.js");
var nova = new HologramNova({});

var commands = [
  ["AT+CIPSHUT\r\n", 65, "SHUT OK", null],
  ["AT+CGATT?\r\n", 10, "OK", null],
  ["AT+CIPMUX=1\r\n", 2, "OK", null],
  ["AT+CSTT=\"hologram\"\r\n", 2, "OK", null],
  ["AT+CIICR\r\n", 85, "OK", null],
  ["AT+CIFSR\r\n", 2, ".", null],
  ["AT+CIPSERVER=1,4010\r\n", 2, "SERVER OK", null]
]

nova.sendCommands( commands, function(err, res){
  if(err){
    throw(err)
  }
  console.log(res);
});
```

### Send MESSAGE

```js
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

```
