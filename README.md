# hologram-nova

```js
var HologramNova = require("hologram-nova");
var nova = new HologramNova({});

nova.sendCommand("AT+CGMI\r\n", 25, null, null, function(res, err){
  console.log(res, err);
});
```
