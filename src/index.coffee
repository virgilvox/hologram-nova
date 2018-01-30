
SerialPort = require 'serialport'
async = require 'async'
_ = require 'lodash'

class HologramNova
  constructor: ({device}) ->
    device = device || '/dev/tty.usbmodem1411'
    @nova = SerialPort device, { baudRate: 19200, parser: SerialPort.parsers.raw }, (err) ->
      throw err if err?

  sendCommand: (cmd, wait, success="OK", fail="ERROR", callback) =>
    @nova.write cmd, (err) =>
      console.log {cmd, wait, success, fail}
      return callback err if err?
      buffer = @nova.read()
      setTimeout (=>
        buffer = @nova.read()
        datas = buffer.toString().trim().split('\r\n')
        return callback new Error datas[1] if datas[1] == fail
        return callback new Error data[3] if datas[3]? && datas[3] == fail
        res = {
          data: datas[1]
          code: datas[3]
        }
        callback null, res if res.code == success
      ), wait * 100

  sendCommands: (commands, callback) =>
    tasks = []
    _.each commands, (command) =>
      cmd     = command[0]
      wait    = command[1]
      success = command[2]
      fail    = command[3]

      tasks.push async.apply(@sendCommand, cmd, wait, success, fail)

    async.series tasks, (err, results) =>
      return callback err if err?
      callback null, results

module.exports = HologramNova
