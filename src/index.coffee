
SerialPort = require 'serialport'

class HologramNova
  constructor: ({device}) ->
    device = device || '/dev/tty.usbmodem1411'
    @nova = SerialPort device, { baudRate: 19200, parser: SerialPort.parsers.raw }, (err) ->
      return Error err if err?

  sendCommand: (cmd, wait, success, fail, callback) =>
    @nova.write cmd, (err) =>
      console.log {cmd, wait, success, fail}
      return callback Error err if err?
      data = @nova.read()
      setTimeout (=>
        data = @nova.read()
        console.log data.toString('utf8')
      ), wait * 100

module.exports = HologramNova
