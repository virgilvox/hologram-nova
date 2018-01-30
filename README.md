# hologram-nova

### Send single command

```js
var HologramNova = require("hologram-nova");
var nova = new HologramNova({});

nova.sendCommand("AT+CGMI\r\n", 25, null, null, function(res, err){
  console.log(res, err);
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

nova.sendCommands( commands, function(res, err){
  if(err){
    throw(err)
  }
  console.log(res, err);
});
```
